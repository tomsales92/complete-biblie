class UserProfile {
  const UserProfile({
    required this.name,
    required this.state,
    required this.birthDate,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    name: map['name'] as String? ?? '',
    state: map['state'] as String? ?? '',
    birthDate: map['birthDate'] as String? ?? '',
  );

  final String name;
  final String state;
  final String birthDate;

  Map<String, dynamic> toMap() => {
    'name': name,
    'state': state,
    'birthDate': birthDate,
  };
}
