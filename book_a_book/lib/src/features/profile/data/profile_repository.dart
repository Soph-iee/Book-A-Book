import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/supabase/tables.dart';
import '../domain/profile.dart';

class ProfileRepository {
  const ProfileRepository(this._db);

  final SupabaseAdapter _db;

  /// Looks up the signed-in user's profile row.
  ///
  /// **This assumes a `user_id uuid` column on `profiles` linking to
  /// `auth.users(id)`.** Your seed data keys `profiles` by an integer `id`,
  /// which cannot be compared to `auth.uid()` — so either add that column, or
  /// change this one filter to whatever links the two.
  Future<Profile?> fetchCurrent() {
    final userId = _db.currentUserId;
    if (userId == null) return Future.value();

    return _db.run(() async {
      final row = await _db
          .from(Tables.profiles)
          .select()
          .eq('user_id', userId)
          .maybeSingle(); // returns null instead of throwing when absent

      return row == null ? null : Profile.fromMap(row);
    });
  }

  Future<Profile> fetchById(int id) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.profiles)
          .select()
          .eq('id', id)
          .single();

      return Profile.fromMap(row);
    });
  }

  Future<Profile> update(int id, Map<String, dynamic> changes) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.profiles)
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
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseAdapterProvider));
});

final currentProfileProvider = FutureProvider<Profile?>((ref) {
  // Re-runs on sign-in and sign-out because it watches the auth stream.
  ref.watch(currentSessionProvider);
  return ref.watch(profileRepositoryProvider).fetchCurrent();
});
