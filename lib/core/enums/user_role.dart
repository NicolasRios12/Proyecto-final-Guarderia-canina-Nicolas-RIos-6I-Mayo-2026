/// Roles de usuario en Dog Club.
enum UserRole {
  cliente,
  cuidador,
  admin;

  /// Convierte un string a UserRole. Si no coincide, devuelve [UserRole.cliente].
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.cliente,
    );
  }

  /// Devuelve el nombre como string para Firestore.
  String get toValue => name;
}
