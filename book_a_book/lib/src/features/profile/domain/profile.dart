/// Mirrors the `profiles` table.
///
/// Note `location` is deliberately absent. It is a PostGIS `geography` column,
/// and PostgREST hands it back as WKB hex (or `SRID=4326;POINT(...)` text),
/// neither of which is useful in Dart. Read [locationText] for display, and add
/// a `books_nearby(lat, lng, radius_m)` SQL function for proximity queries —
/// distance maths belongs in Postgres, which has the spatial index.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.emailAddress,
    this.avatarUrl,
    this.locationText,
  });

  final int id;
  final String name;
  final String? phoneNumber;
  final String? emailAddress;
  final String? avatarUrl;

  /// Human-readable place, e.g. "Shoreditch, London, UK".
  final String? locationText;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
        id: map['id'] as int,
        name: map['name'] as String? ?? 'Unknown',
        phoneNumber: map['phone_number'] as String?,
        emailAddress: map['email_address'] as String?,
        avatarUrl: map['avatar_url'] as String?,
        locationText: map['location_text'] as String?,
      );

  Map<String, dynamic> toUpdate() => {
        'name': name,
        'phone_number': phoneNumber,
        'avatar_url': avatarUrl,
        'location_text': locationText,
      };
}
