import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  static SupabaseClient get client => _client;

  // Authentication
  static SupabaseUser? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => _client.auth.currentUser?.id;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String location,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      // Create profile after successful signup
      await createProfile(
        userId: response.user!.id,
        email: email,
        fullName: fullName,
        age: age,
        location: location,
      );
    }

    return response;
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Profile Management
  static Future<void> createProfile({
    required String userId,
    required String email,
    required String fullName,
    required int age,
    required String location,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    await _client.from('profiles').insert({
      'id': userId,
      'email': email,
      'full_name': fullName,
      'age': age,
      'location': location,
      'bio': bio,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
    });
  }

  static Future<UserProfile?> getCurrentProfile() async {
    if (currentUserId == null) return null;

    final response = await _client.from('profiles').select('''
          *,
          user_interests (
            interests (*)
          )
        ''').eq('id', currentUserId!).maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  static Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return;

    await _client.from('profiles').update(updates).eq('id', currentUserId!);
  }

  static Future<List<UserProfile>> getDiscoverableUsers({
    int? minAge,
    int? maxAge,
    String? location,
    String? interestId,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client
        .from('profiles')
        .select('''
          *,
          user_interests (
            interests (*)
          )
        ''')
        .eq('is_active', true)
        .neq('id', currentUserId ?? '')
        .limit(limit)
        .range(offset, offset + limit - 1);

    if (minAge != null) {
      query = query.gte('age', minAge);
    }
    if (maxAge != null) {
      query = query.lte('age', maxAge);
    }
    if (location != null && location.isNotEmpty) {
      query = query.ilike('location', '%$location%');
    }

    final response = await query;
    return response.map((json) => UserProfile.fromJson(json)).toList();
  }

  // Interests Management
  static Future<List<Interest>> getAllInterests() async {
    final response = await _client
        .from('interests')
        .select()
        .eq('is_active', true)
        .order('name');

    return response.map((json) => Interest.fromJson(json)).toList();
  }

  static Future<void> updateUserInterests(List<String> interestIds) async {
    if (currentUserId == null) return;

    // First, delete existing interests
    await _client.from('user_interests').delete().eq('user_id', currentUserId!);

    // Then insert new interests
    if (interestIds.isNotEmpty) {
      final inserts = interestIds
          .map((interestId) => {
                'user_id': currentUserId!,
                'interest_id': interestId,
              })
          .toList();

      await _client.from('user_interests').insert(inserts);
    }
  }

  // Likes and Matches
  static Future<void> likeUser(String likedUserId) async {
    if (currentUserId == null) return;

    await _client.from('likes').insert({
      'liker_id': currentUserId!,
      'liked_id': likedUserId,
    });
  }

  static Future<bool> hasLikedUser(String userId) async {
    if (currentUserId == null) return false;

    final response = await _client
        .from('likes')
        .select()
        .eq('liker_id', currentUserId!)
        .eq('liked_id', userId)
        .maybeSingle();

    return response != null;
  }

  static Future<List<Match>> getMatches() async {
    if (currentUserId == null) return [];

    final response = await _client
        .from('matches')
        .select('''
          *,
          user1:profiles!matches_user1_id_fkey (*),
          user2:profiles!matches_user2_id_fkey (*)
        ''')
        .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((json) => Match.fromJson(json)).toList();
  }

  // Conversations and Messages
  static Future<List<Conversation>> getConversations() async {
    if (currentUserId == null) return [];

    final response = await _client
        .from('conversations')
        .select('''
          *,
          user1:profiles!conversations_user1_id_fkey (*),
          user2:profiles!conversations_user2_id_fkey (*)
        ''')
        .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
        .eq('is_active', true)
        .order('last_message_at', ascending: false);

    return response.map((json) => Conversation.fromJson(json)).toList();
  }

  static Future<List<ChatMessage>> getMessages(String conversationId) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return response.map((json) => ChatMessage.fromJson(json)).toList();
  }

  static Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String content,
    String messageType = 'text',
  }) async {
    if (currentUserId == null) return;

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': currentUserId!,
      'receiver_id': receiverId,
      'content': content,
      'message_type': messageType,
    });
  }

  static Future<void> markMessageAsRead(String messageId) async {
    await _client.from('messages').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', messageId);
  }

  // Real-time subscriptions
  static RealtimeChannel subscribeToMessages(
    String conversationId,
    void Function(ChatMessage) onMessage,
  ) {
    return _client
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final message = ChatMessage.fromJson(payload.newRecord);
            onMessage(message);
          },
        )
        .subscribe();
  }

  static RealtimeChannel subscribeToMatches(
    void Function(Match) onMatch,
  ) {
    return _client
        .channel('matches:$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'matches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.or,
            column: 'user1_id,user2_id',
            value: '$currentUserId,$currentUserId',
          ),
          callback: (payload) {
            // You'll need to fetch the full match data with user profiles
            _fetchMatchWithProfiles(payload.newRecord['id']).then(onMatch);
          },
        )
        .subscribe();
  }

  static Future<Match> _fetchMatchWithProfiles(String matchId) async {
    final response = await _client.from('matches').select('''
          *,
          user1:profiles!matches_user1_id_fkey (*),
          user2:profiles!matches_user2_id_fkey (*)
        ''').eq('id', matchId).single();

    return Match.fromJson(response);
  }

  // Blocking and Reporting
  static Future<void> blockUser(String blockedUserId, String? reason) async {
    if (currentUserId == null) return;

    await _client.from('blocks').insert({
      'blocker_id': currentUserId!,
      'blocked_id': blockedUserId,
      'reason': reason,
    });
  }

  static Future<void> reportUser({
    required String reportedUserId,
    required String reason,
    String? description,
  }) async {
    if (currentUserId == null) return;

    await _client.from('reports').insert({
      'reporter_id': currentUserId!,
      'reported_id': reportedUserId,
      'reason': reason,
      'description': description,
    });
  }

  // User Activity Tracking
  static Future<void> logActivity(String activityType,
      [Map<String, dynamic>? metadata]) async {
    if (currentUserId == null) return;

    await _client.from('user_activity').insert({
      'user_id': currentUserId!,
      'activity_type': activityType,
      'metadata': metadata,
    });
  }

  static Future<void> updateLastActive() async {
    if (currentUserId == null) return;

    await _client
        .from('profiles')
        .update({'last_active': DateTime.now().toIso8601String()}).eq(
            'id', currentUserId!);
  }
}

// Additional model classes for the service
class UserProfile extends User {
  UserProfile({
    required super.id,
    super.email,
    required super.fullName,
    required super.age,
    required super.location,
    super.bio,
    super.profileImageUrl,
    super.status,
    super.isVerified,
    super.isActive,
    super.dateOfBirth,
    super.gender,
    super.lookingFor,
    super.maxDistanceKm,
    super.ageRangeMin,
    super.ageRangeMax,
    required super.createdAt,
    required super.updatedAt,
    required super.lastActive,
    super.interests,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String,
      age: json['age'] as int,
      location: json['location'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      status: json['status'] as String? ?? 'offline',
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'] as String?,
      lookingFor: (json['looking_for'] as List<dynamic>?)?.cast<String>() ?? [],
      maxDistanceKm: json['max_distance_km'] as int? ?? 50,
      ageRangeMin: json['age_range_min'] as int? ?? 18,
      ageRangeMax: json['age_range_max'] as int? ?? 100,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastActive: DateTime.parse(json['last_active']),
      interests: (json['user_interests'] as List<dynamic>?)
              ?.map((i) => Interest.fromJson(i['interests']))
              .toList() ??
          [],
    );
  }
}

class Match {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final bool isActive;
  final UserProfile? user1;
  final UserProfile? user2;

  Match({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.isActive = true,
    this.user1,
    this.user2,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'] as bool? ?? true,
      user1: json['user1'] != null ? UserProfile.fromJson(json['user1']) : null,
      user2: json['user2'] != null ? UserProfile.fromJson(json['user2']) : null,
    );
  }

  // Get the other user in the match
  UserProfile? getOtherUser(String currentUserId) {
    if (user1?.id == currentUserId) return user2;
    if (user2?.id == currentUserId) return user1;
    return null;
  }
}

class Conversation {
  final String id;
  final String? matchId;
  final String user1Id;
  final String user2Id;
  final DateTime lastMessageAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile? user1;
  final UserProfile? user2;

  Conversation({
    required this.id,
    this.matchId,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessageAt,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.user1,
    this.user2,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      matchId: json['match_id'] as String?,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      lastMessageAt: DateTime.parse(json['last_message_at']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user1: json['user1'] != null ? UserProfile.fromJson(json['user1']) : null,
      user2: json['user2'] != null ? UserProfile.fromJson(json['user2']) : null,
    );
  }

  // Get the other user in the conversation
  UserProfile? getOtherUser(String currentUserId) {
    if (user1?.id == currentUserId) return user2;
    if (user2?.id == currentUserId) return user1;
    return null;
  }
}
