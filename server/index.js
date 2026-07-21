const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { randomUUID } = require('crypto');
const { BIBLE_BOOKS, TOTAL_CHAPTERS, findBook } = require('./bible');

const app = express();
const PORT = 3000;
const DB_PATH = path.join(__dirname, 'db.json');

app.use(cors());
app.use(express.json());

function readDb() {
  const raw = fs.readFileSync(DB_PATH, 'utf-8');
  return JSON.parse(raw);
}

function writeDb(data) {
  fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
}

function todayDateString() {
  return new Date().toISOString().slice(0, 10);
}

function parseTargetDate(targetParam) {
  if (targetParam) {
    const parsed = new Date(`${targetParam}T00:00:00`);
    if (!Number.isNaN(parsed.getTime())) {
      return parsed;
    }
  }

  const year = new Date().getFullYear();
  return new Date(`${year}-12-31T00:00:00`);
}

function daysBetween(startDate, endDate) {
  const start = new Date(startDate);
  const end = new Date(endDate);
  start.setHours(0, 0, 0, 0);
  end.setHours(0, 0, 0, 0);
  const diffMs = end.getTime() - start.getTime();
  return Math.max(0, Math.ceil(diffMs / (1000 * 60 * 60 * 24)));
}

function buildPanorama(targetParam) {
  const db = readDb();
  const uniqueReads = new Set(db.reads.map((read) => `${read.book}:${read.chapter}`));
  const readCount = uniqueReads.size;
  const remaining = TOTAL_CHAPTERS - readCount;
  const percentComplete = TOTAL_CHAPTERS === 0
    ? 0
    : Math.round((readCount / TOTAL_CHAPTERS) * 1000) / 10;

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const target = parseTargetDate(targetParam);
  const daysRemaining = daysBetween(today, target);
  const chaptersPerDay = daysRemaining === 0
    ? remaining
    : Math.round((remaining / daysRemaining) * 10) / 10;

  return {
    totalChapters: TOTAL_CHAPTERS,
    readChapters: readCount,
    remainingChapters: remaining,
    percentComplete,
    targetDate: target.toISOString().slice(0, 10),
    daysRemaining,
    chaptersPerDay,
  };
}

app.get('/api/bible', (_req, res) => {
  res.json({
    books: BIBLE_BOOKS,
    totalChapters: TOTAL_CHAPTERS,
  });
});

app.get('/api/reads', (_req, res) => {
  const db = readDb();
  res.json(db.reads);
});

app.get('/api/reads/today', (_req, res) => {
  const db = readDb();
  const today = todayDateString();
  const todayReads = db.reads.filter((read) => read.date === today);
  res.json(todayReads);
});

app.post('/api/reads', (req, res) => {
  const { book, chapter } = req.body;

  if (!book || chapter === undefined || chapter === null) {
    return res.status(400).json({ error: 'Campos "book" e "chapter" são obrigatórios.' });
  }

  const bookInfo = findBook(book);
  if (!bookInfo) {
    return res.status(400).json({ error: 'Livro inválido.' });
  }

  const chapterNumber = Number(chapter);
  if (!Number.isInteger(chapterNumber) || chapterNumber < 1 || chapterNumber > bookInfo.chapters) {
    return res.status(400).json({ error: 'Capítulo inválido para este livro.' });
  }

  const db = readDb();
  const existing = db.reads.find(
    (read) => read.book === book && read.chapter === chapterNumber,
  );

  if (existing) {
    return res.status(200).json(existing);
  }

  const newRead = {
    id: randomUUID(),
    book,
    chapter: chapterNumber,
    date: todayDateString(),
  };

  db.reads.push(newRead);
  writeDb(db);

  res.status(201).json(newRead);
});

app.delete('/api/reads/:id', (req, res) => {
  const db = readDb();
  const index = db.reads.findIndex((read) => read.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ error: 'Leitura não encontrada.' });
  }

  const [removed] = db.reads.splice(index, 1);
  writeDb(db);

  res.json(removed);
});

app.get('/api/panorama', (req, res) => {
  res.json(buildPanorama(req.query.target));
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
