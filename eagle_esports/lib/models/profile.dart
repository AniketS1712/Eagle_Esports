/// Mirrors the `profiles` table.
/// Extends auth.users — `id` is shared with Supabase Auth's user id.
enum UserRole { user, organiser }

UserRole userRoleFromString(String value) {
  final normalizedValue = value.trim().toLowerCase();

  if (normalizedValue == 'organizer') {
    return UserRole.organiser;
  }

  return UserRole.values.firstWhere(
    (e) => e.name == normalizedValue,
    orElse: () => UserRole.user,
  );
}

class Profile {
  final String id;
  final String fullName;
  final String avatarUrl;
  final String phone;
  final UserRole role;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.fullName,
    required this.avatarUrl,
    required this.phone,
    required this.role,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      avatarUrl: map['avatar_url'] as String,
      phone: map['phone'] as String,
      role: userRoleFromString(map['role'] as String),
      isBanned: map['is_banned'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Use for UPDATE calls (e.g. editing full_name/avatar_url).
  /// Do NOT include role/is_banned — the DB trigger silently reverts
  /// these for non-service_role callers anyway, so there's no point
  /// sending them from Flutter.
  Map<String, dynamic> toMap() {
    return {'full_name': fullName, 'avatar_url': avatarUrl, 'phone': phone};
  }

  Profile copyWith({
    String? fullName,
    String? avatarUrl,
    String? phone,
    UserRole? role,
    bool? isBanned,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isBanned: isBanned ?? this.isBanned,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
