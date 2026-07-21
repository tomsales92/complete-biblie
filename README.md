# Leitura Bíblica

App de controle de leitura bíblica com Angular + Firebase (Auth + Firestore).

## Estrutura

```
bible-reading-tracker/
├── frontend/        # Angular (deploy na Vercel)
├── firebase.json    # Configuração Firebase
├── firestore.rules  # Regras de segurança
└── server/          # Legado (Express local — não usado em produção)
```

## Configurar Firebase

1. Crie um projeto em [Firebase Console](https://console.firebase.google.com)
2. Ative **Authentication** → método **E-mail/Senha**
3. Crie um banco **Cloud Firestore**
4. Em **Configurações do projeto** → **Seus apps**, adicione um app Web e copie as credenciais
5. Cole as credenciais em `frontend/src/environments/environment.ts` e `environment.prod.ts`

```typescript
firebase: {
  apiKey: '...',
  authDomain: '...',
  projectId: '...',
  storageBucket: '...',
  messagingSenderId: '...',
  appId: '...',
}
```

6. Instale a CLI e publique as regras do Firestore:

```bash
npm install -g firebase-tools
firebase login
firebase use SEU_PROJETO
firebase deploy --only firestore:rules
```

## Como rodar localmente

```bash
cd frontend
npm install
ng serve
```

Abra `http://localhost:4200`, crie uma conta e comece a marcar capítulos.

## Deploy na Vercel

1. Conecte o repositório na Vercel
2. **Root Directory:** `frontend`
3. **Build Command:** `ng build`
4. **Output Directory:** `dist/frontend/browser`
5. Atualize `environment.prod.ts` com as credenciais do Firebase de produção

## Dados no Firestore

Cada usuário tem suas leituras em:

```
users/{userId}/reads/{livro__capitulo}
  ├── book: "Gênesis"
  ├── chapter: 1
  └── date: "2026-07-12"
```

As regras garantem que cada usuário só acessa seus próprios dados.
