import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eagle_esports/models/profile.dart';

class ProfileRepository {
  final SupabaseClient client;

  ProfileRepository(this.client);

  /// Updates the current user's profile fields.
  /// Only fullName, avatarUrl, phone are sent — role/isBanned
  /// are ignored by the DB trigger anyway.
  Future<Profile> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
    required String avatarUrl,
  }) async {
    final data = await client
        .from('profiles')
        .update({
          'full_name': fullName,
          'phone': phone,
          'avatar_url': avatarUrl,
        })
        .eq('id', userId)
        .select()
        .single();
    return Profile.fromMap(data);
  }

  /// Fetches the total number of tournament wins (1st place ranks)
  /// for a given user across all teams they belong to.
  Future<int> fetchUserWins(String userId) async {
    final teamMemberRows = await client
        .from('team_members')
        .select('team_id')
        .eq('user_id', userId);

    final teamIds = teamMemberRows
        .map((row) => row['team_id'] as String)
        .toSet()
        .toList();

    if (teamIds.isEmpty) {
      return 0;
    }

    final winRows = await client
        .from('leaderboard')
        .select('id')
        .inFilter('team_id', teamIds)
        .eq('rank', 1);

    return winRows.length;
  }
}
