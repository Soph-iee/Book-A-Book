import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/supabase/tables.dart';
import '../domain/profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final SupabaseAdapter _db;

  /// Looks up the signed-in user's profile row.
  ///
  /// Matches on the `uuid` column, which references `auth.users(id)`. A
  /// Postgres trigger (`handle_new_user`) creates this row automatically when
  /// a new user signs up, so by the time this runs the row should exist.
  Future<Profile?> fetchCurrent() {
    final userId = _db.currentUserId;
    if (userId == null) return Future.value();

    return _db.run(() async {
      final row = await _db
          .from(Tables.profile)
          .select()
          .eq('uuid', userId)
          .maybeSingle();

      return row == null ? null : Profile.fromMap(row);
    });
  }

  /// Ensures the signed-in user's profile row exists and is complete.
  ///
  /// The `handle_new_user` trigger creates the row but does not copy
  /// `auth.users.email` into `email_address`, which is why email went missing.
  /// Rather than maintain that trigger, this guarantees the row using the
  /// *authoritative* values from the authenticated user — Supabase sets
  /// `email` and `user_metadata`, so neither can be spoofed from the client.
  ///
  /// A healthy row (already has an email) is returned untouched after a single
  /// read, so this performs no write on normal launches.
  Future<Profile?> ensureCurrent() {
    final user = _db.auth.currentUser;
    if (user == null) return Future.value();

    return _db.run(() async {
      final existing = await _db
          .from(Tables.profile)
          .select()
          .eq('uuid', user.id)
          .maybeSingle();

      final hasEmail =
          (existing?['email_address'] as String?)?.isNotEmpty ?? false;
      if (existing != null && hasEmail) return Profile.fromMap(existing);

      final name =
          (user.userMetadata?['name'] as String?) ??
          (existing?['name'] as String? ?? '');
      final email = user.email ?? '';

      final row = await _db
          .from(Tables.profile)
          .upsert({
            'uuid': user.id,
            'name': name,
            'email_address': email,
          }, onConflict: 'uuid')
          .select()
          .single();

      return Profile.fromMap(row);
    });
  }

  Future<Profile> fetchById(int id) {
    return _db.run(() async {
      final row = await _db.from(Tables.profile).select().eq('id', id).single();

      return Profile.fromMap(row);
    });
  }

  /// Updates the signed-in user's location.
  ///
  /// [lat] and [lng] are converted to a PostGIS geography point. [label] is the
  /// human-readable text shown on the book card.
  ///
  /// When the user enters a location manually (no coordinates), [lat] and [lng]
  /// are null and only [label] is stored — the geography column stays null.
  Future<Profile> updateLocation({
    required int profileId,
    double? lat,
    double? lng,
    required String label,
  }) {
    return _db.run(() async {
      // PostGIS expects WKT with longitude first: POINT(lng lat)
      final locationValue = (lat != null && lng != null)
          ? "POINT($lng $lat)"
          : null;

      final row = await _db
          .from(Tables.profile)
          .update({'location_text': label, 'location': locationValue})
          .eq('id', profileId)
          .select()
          .single();

      return Profile.fromMap(row);
    });
  }

  Future<Profile> update(int id, Map<String, dynamic> changes) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.profile)
          .update(changes)
          .eq('id', id)
          .select()
          .single();

      return Profile.fromMap(row);
    });
  }

  /// Uploads an avatar and returns its public URL.
  ///
  /// `upsert: true` makes re-uploading to the same path overwrite rather than
  /// fail, which is what you want for a single avatar per user.
  Future<String> uploadAvatar({
    required int profileId,
    required Uint8List bytes,
    required String fileExtension,
  }) {
    return _db.run(() async {
      final path = '$profileId/avatar.$fileExtension';

      await _db.storage
          .from(Buckets.avatars)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      return _db.storage.from(Buckets.avatars).getPublicUrl(path);
    });
  }

  final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
    return ProfileRepository(ref.watch(supabaseAdapterProvider));
  });

  late final currentProfileProvider = FutureProvider<Profile?>((ref) {
    // Re-runs on sign-in and sign-out because it watches the auth stream.
    ref.watch(currentSessionProvider);
    return ref.watch(profileRepositoryProvider).ensureCurrent();
  });
}
