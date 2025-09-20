import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/supabase_service.dart';
import 'screens/auth_screen.dart';

const appTheme = Color.fromRGBO(102, 51, 152, 1);
MaterialColor getMaterialColor(Color color) {
  final int red = 102;
  final int green = 51;
  final int blue = 152;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://npemdwlhzelkqdyupuzu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5wZW1kd2xoemVsa3FkeXVwdXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyODg3NzgsImV4cCI6MjA3Mzg2NDc3OH0.htNqcHH_IdaJIPvI2kIN3v1zbdEectRPuAQ8OQMW6O0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderizz',
      theme: ThemeData(
        primarySwatch: getMaterialColor(appTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: StreamBuilder<AuthState>(
        stream: SupabaseService.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return const ElderlyDatingApp();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}

class ElderlyDatingApp extends StatelessWidget {
  const ElderlyDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderizz',
      theme: ThemeData(
        primarySwatch: getMaterialColor(appTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ExplorePage(),
    const EventsPage(),
    const ChatPage(),
    const ProfilePage(),
  ];
  // jsbdbvid sv
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: appTheme,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Event model for the events page
class EventModel {
  final String id;
  final String title;
  final String location;
  final DateTime dateTime;
  final String category;
  final String? imageUrl;
  final String description;
  final int participantCount;
  final int maxParticipants;
  final String organizerId;
  final bool isJoined;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.category,
    this.imageUrl,
    required this.description,
    required this.participantCount,
    required this.maxParticipants,
    required this.organizerId,
    this.isJoined = false,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      dateTime: DateTime.parse(json['date_time']),
      category: json['category'] as String,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String,
      participantCount: json['participant_count'] as int,
      maxParticipants: json['max_participants'] as int,
      organizerId: json['organizer_id'] as String,
      isJoined: json['is_joined'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date_time': dateTime.toIso8601String(),
      'category': category,
      'image_url': imageUrl,
      'description': description,
      'participant_count': participantCount,
      'max_participants': maxParticipants,
      'organizer_id': organizerId,
      'is_joined': isJoined,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (eventDate == today) {
      return 'Today';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      final days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return days[dateTime.weekday - 1];
    }
  }
}

// User model matching database schema
class UserModel {
  final String id;
  final String? email;
  final String fullName;
  final int age;
  final String location;
  final String? bio;
  final String? profileImageUrl;
  final String status;
  final bool isVerified;
  final bool isActive;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String> lookingFor;
  final int maxDistanceKm;
  final int ageRangeMin;
  final int ageRangeMax;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastActive;
  final List<Interest> interests;

  UserModel({
    required this.id,
    this.email,
    required this.fullName,
    required this.age,
    required this.location,
    this.bio,
    this.profileImageUrl,
    this.status = 'offline',
    this.isVerified = false,
    this.isActive = true,
    this.dateOfBirth,
    this.gender,
    this.lookingFor = const [],
    this.maxDistanceKm = 50,
    this.ageRangeMin = 18,
    this.ageRangeMax = 100,
    required this.createdAt,
    required this.updatedAt,
    required this.lastActive,
    this.interests = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      interests:
          (json['user_interests'] as List<dynamic>?)
              ?.map((i) => Interest.fromJson(i['interests']))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'age': age,
      'location': location,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'status': status,
      'is_verified': isVerified,
      'is_active': isActive,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'gender': gender,
      'looking_for': lookingFor,
      'max_distance_km': maxDistanceKm,
      'age_range_min': ageRangeMin,
      'age_range_max': ageRangeMax,
      'last_active': lastActive.toIso8601String(),
    };
  }

  // Helper getter for backwards compatibility
  String get name => fullName;
  String get profileImage => profileImageUrl ?? 'assets/images/no_image.jpg';
}

// Interest model
class Interest {
  final String id;
  final String name;
  final String? category;
  final String? icon;
  final bool isActive;
  final DateTime createdAt;

  Interest({
    required this.id,
    required this.name,
    this.category,
    this.icon,
    this.isActive = true,
    required this.createdAt,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'icon': icon,
      'is_active': isActive,
    };
  }
}

// Chat message model matching database schema
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.messageType = 'text',
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'message_type': messageType,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
    };
  }

  // Helper getter for backwards compatibility
  String get message => content;
  DateTime get timestamp => createdAt;
}

// Helper widget for displaying profile images
class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isCircular;

  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    this.size = 120,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        // Network image
        imageWidget = Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      } else {
        // Asset image
        imageWidget = Image.asset(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      }
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (isCircular) {
      return ClipOval(child: imageWidget);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        color: Colors.grey.shade300,
      ),
      child: Icon(Icons.person, size: size * 0.5, color: Colors.grey.shade600),
    );
  }
}

// Data service - now uses Supabase for real data
class DataService {
  // Keep sample data for development/fallback
  static List<UserModel> getSampleUsers() {
    final now = DateTime.now();
    return [
      UserModel(
        id: '1',
        fullName: 'Margaret Johnson',
        age: 68,
        location: 'New York, NY',
        bio:
            'Love gardening, reading, and spending time with my grandchildren. Looking for someone to share life\'s adventures with.',
        interests: [
          Interest(id: '1', name: 'Gardening', icon: '🌱', createdAt: now),
          Interest(id: '2', name: 'Reading', icon: '📚', createdAt: now),
          Interest(id: '3', name: 'Cooking', icon: '👨‍🍳', createdAt: now),
          Interest(id: '4', name: 'Travel', icon: '✈️', createdAt: now),
        ],
        profileImageUrl: 'assets/images/pp1.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 1)),
        lastActive: now.subtract(const Duration(minutes: 5)),
      ),
      UserModel(
        id: '2',
        fullName: 'Robert Smith',
        age: 72,
        location: 'Los Angeles, CA',
        bio:
            'Retired teacher who enjoys hiking, photography, and good conversation. Seeking a kind companion for this chapter of life.',
        interests: [
          Interest(id: '5', name: 'Photography', icon: '📷', createdAt: now),
          Interest(id: '6', name: 'Hiking', icon: '🥾', createdAt: now),
          Interest(id: '7', name: 'Movies', icon: '🎬', createdAt: now),
          Interest(id: '8', name: 'Music', icon: '🎵', createdAt: now),
        ],
        profileImageUrl: 'assets/images/mpp1.jpg',
        status: 'offline',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 2)),
        lastActive: now.subtract(const Duration(hours: 3)),
      ),
      UserModel(
        id: '3',
        fullName: 'Dorothy Williams',
        age: 65,
        location: 'Chicago, IL',
        bio:
            'Recently widowed, ready to find joy again. Love painting, bridge, and volunteer work at the local shelter.',
        interests: [
          Interest(id: '9', name: 'Painting', icon: '🎨', createdAt: now),
          Interest(id: '10', name: 'Bridge', icon: '🃏', createdAt: now),
          Interest(id: '11', name: 'Volunteering', icon: '🤝', createdAt: now),
          Interest(id: '12', name: 'Dancing', icon: '💃', createdAt: now),
        ],
        profileImageUrl: 'assets/images/pp2.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        lastActive: now.subtract(const Duration(minutes: 15)),
      ),
      UserModel(
        id: '4',
        fullName: 'Frank Miller',
        age: 70,
        location: 'Miami, FL',
        bio:
            'Widower looking for companionship. Enjoy fishing, golf, and cooking for someone special.',
        interests: [
          Interest(id: '13', name: 'Fishing', icon: '🎣', createdAt: now),
          Interest(id: '14', name: 'Golf', icon: '⛳', createdAt: now),
          Interest(id: '3', name: 'Cooking', icon: '👨‍🍳', createdAt: now),
          Interest(id: '4', name: 'Travel', icon: '✈️', createdAt: now),
        ],
        profileImageUrl: 'assets/images/mpp2.jpg',
        status: 'online',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 3)),
        lastActive: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  static Future<List<UserModel>> getUsers() async {
    try {
      // Try to get users from Supabase
      final users = await SupabaseService.getDiscoverableUsers();
      if (users.isNotEmpty) {
        // TODO: Make sample users so dont need sample
        // return users.cast<UserModel>();
        return [...getSampleUsers(), ...users.cast<UserModel>()];
      }
    } catch (e) {
      print('Error fetching users from Supabase: $e');
    }

    // Fallback to sample data
    return getSampleUsers();
  }

  /*
Making Traditional Ang Ku Kueh!
Photography Walk: Fall Colors, 
Art & Craft Workshop, 
Jazz & Wine Evening
*/
  static List<EventModel> getSampleEvents() {
    final now = DateTime.now();
    final a = [
      EventModel(
        id: '1',
        title: 'Weekend Hiking at Blue Ridge',
        location: 'Blue Ridge Mountains',
        dateTime: now.add(const Duration(days: 2)),
        category: 'Outdoor',
        imageUrl: 'assets/images/hiking.jpg',
        description:
            'Join us for a scenic hike through the beautiful Blue Ridge Mountains. Moderate difficulty level suitable for active seniors.',
        participantCount: 12,
        maxParticipants: 20,
        organizerId: 'org_1',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      EventModel(
        id: '2',
        title: 'Mahjong Tournament',
        location: 'Community Center',
        dateTime: now.add(const Duration(days: 1)),
        category: 'Mahjong',
        imageUrl: 'assets/images/mahjong.jpg',
        description:
            'Weekly mahjong tournament for players of all skill levels. Prizes for winners and tea service provided.',
        participantCount: 16,
        maxParticipants: 20,
        organizerId: 'org_2',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      EventModel(
        id: '3',
        title: 'Garden Club Planting Session',
        location: 'Sunset Gardens',
        dateTime: now.add(const Duration(days: 3)),
        category: 'Gardening',
        imageUrl: 'assets/images/gardening.jpg',
        description:
            'Come and help us plant the spring vegetable garden. Learn new techniques and make new friends!',
        participantCount: 8,
        maxParticipants: 15,
        organizerId: 'org_3',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      EventModel(
        id: '4',
        title: 'Morning Tai Chi in the Park',
        location: 'Central Park',
        dateTime: now.add(const Duration(hours: 18)),
        category: 'Tai Chi',
        imageUrl: 'assets/images/taichi.jpg',
        description:
            'Gentle morning Tai Chi practice suitable for all levels. Improve balance, flexibility and meet fellow practitioners.',
        participantCount: 24,
        maxParticipants: 30,
        organizerId: 'org_4',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      EventModel(
        id: '5',
        title: 'Classic Literature Book Club',
        location: 'Public Library',
        dateTime: now.add(const Duration(days: 5)),
        category: 'Book Club',
        imageUrl: 'assets/images/bookclub.jpg',
        description:
            'This month we\'re discussing "To Kill a Mockingbird". New members welcome! Light refreshments provided.',
        participantCount: 10,
        maxParticipants: 12,
        organizerId: 'org_5',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      EventModel(
        id: '6',
        title: 'Cooking Class: Traditional Recipes',
        location: 'Culinary Arts Center',
        dateTime: now.add(const Duration(days: 4)),
        category: 'Cooking',
        imageUrl: 'assets/images/cooking.jpg',
        description:
            'Learn to make traditional family recipes passed down through generations. All ingredients provided.',
        participantCount: 6,
        maxParticipants: 12,
        organizerId: 'org_6',
        createdAt: now.subtract(const Duration(days: 6)),
      ),
      EventModel(
        id: '7',
        title: 'Photography Walk: Fall Colors',
        location: 'Botanical Gardens',
        dateTime: now.add(const Duration(days: 7)),
        category: 'Photography',
        imageUrl: 'assets/images/photography.jpg',
        description:
            'Capture the beautiful fall foliage with fellow photography enthusiasts. All skill levels welcome.',
        participantCount: 14,
        maxParticipants: 20,
        organizerId: 'org_8',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
      EventModel(
        id: '8',
        title: 'Art & Craft Workshop',
        location: 'Community Art Center',
        dateTime: now.add(const Duration(days: 9)),
        category: 'Arts & Crafts',
        imageUrl: 'assets/images/arts.jpg',
        description:
            'Create beautiful handmade crafts and artwork. All materials provided. Take home your creations!',
        participantCount: 9,
        maxParticipants: 15,
        organizerId: 'org_9',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      EventModel(
        id: '9',
        title: 'Jazz & Wine Evening',
        location: 'Harbor Lounge',
        dateTime: now.add(const Duration(days: 8)),
        category: 'Music & Entertainment',
        imageUrl: 'assets/images/jazz.jpg',
        description:
            'Enjoy live jazz music with wine tasting. A sophisticated evening for music lovers.',
        participantCount: 22,
        maxParticipants: 50,
        organizerId: 'org_10',
        createdAt: now.subtract(const Duration(days: 12)),
      ),
    ];
    print(a.map((e) => e.title).toList());
    return a;
  }

  static Future<List<EventModel>> getEvents({String? category}) async {
    try {
      // In a real app, you would fetch from Supabase here
      final events = getSampleEvents();

      if (category != null && category != 'All') {
        return events.where((event) => event.category == category).toList();
      }

      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return getSampleEvents();
    }
  }

  static List<ChatMessage> getSampleMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '1',
        conversationId: 'conv_1',
        senderId: '1',
        receiverId: 'current_user',
        content:
            'Hello! I saw your profile and thought we might have a lot in common.',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: '2',
        conversationId: 'conv_2',
        senderId: '2',
        receiverId: 'current_user',
        content: 'Would you like to grab coffee sometime?',
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  static Future<List<ChatMessage>> getMessages() async {
    try {
      return getSampleMessages();
      // Try to get conversations from Supabase
      final conversations = await SupabaseService.getConversations();
      if (conversations.isNotEmpty) {
        // Get the most recent message from each conversation
        List<ChatMessage> recentMessages = [];
        for (final conversation in conversations) {
          final messages = await SupabaseService.getMessages(conversation.id);
          if (messages.isNotEmpty) {
            recentMessages.add(messages.last);
          }
        }
        return recentMessages;
      }
    } catch (e) {
      print('Error fetching messages from Supabase: $e');
    }

    // Fallback to sample data
    return getSampleMessages();
  }
}

// Explore Page
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<UserModel> users = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final loadedUsers = await DataService.getUsers();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        users = DataService.getSampleUsers();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : users.isEmpty
            ? const Center(child: Text('No profiles to show'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Row(
                      children: [
                        const Text(
                          'ELDERIZZ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: appTheme,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  getMaterialColor(appTheme).shade50,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child:
                                      users[currentIndex].profileImage
                                          .startsWith('http')
                                      ? Image.network(
                                          users[currentIndex].profileImage,
                                          height: 300,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          users[currentIndex].profileImage,
                                          height: 300,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(height: 20),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: ListView(
                                      children: [
                                        Text(
                                          '${users[currentIndex].name}, ${users[currentIndex].age}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              users[currentIndex].location,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          users[currentIndex].bio ??
                                              'No bio available',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Interests:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          children: users[currentIndex]
                                              .interests
                                              .map((interest) {
                                                return Chip(
                                                  label: Text(interest.name),
                                                  backgroundColor:
                                                      getMaterialColor(
                                                        appTheme,
                                                      ).shade100,
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: FloatingActionButton(
                            shape: CircleBorder(),
                            onPressed: () {
                              _nextProfile();
                            },
                            backgroundColor: Colors.red,
                            heroTag: "pass",
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: FloatingActionButton(
                            shape: CircleBorder(),
                            onPressed: () {
                              _likeProfile();
                            },
                            backgroundColor: Colors.green,
                            heroTag: "like",
                            child: const Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _nextProfile() {
    setState(() {
      if (currentIndex < users.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Loop back to start
      }
    });
  }

  void _likeProfile() async {
    final currentUser = users[currentIndex];

    try {
      // Like the user in the database
      await SupabaseService.likeUser(currentUser.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You liked ${currentUser.name}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Log the activity
      await SupabaseService.logActivity('like', {
        'liked_user_id': currentUser.id,
      });
    } catch (e) {
      debugPrint('Error liking profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error liking profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    _nextProfile();
  }
}

// Events Page
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];
  bool isLoading = true;
  String selectedCategory = 'All';

  final Map<String, String> eventCategories = {
    'All': '🌟',
    'Outdoor': '🏞️',
    'Mahjong': '🀄',
    'Gardening': '🌱',
    'Tai Chi': '🧘‍♀️',
    'Book Club': '📚',
    'Cooking': '👨‍🍳',
    'Bridge': '🃏',
    'Photography': '📷',
    'Arts & Crafts': '🎨',
    'Music & Entertainment': '🎵',
  };

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final loadedEvents = await DataService.getEvents();
      setState(() {
        events = loadedEvents;
        filteredEvents = loadedEvents;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading events: $e');
      setState(() {
        events = DataService.getSampleEvents();
        filteredEvents = DataService.getSampleEvents();
        isLoading = false;
      });
    }
  }

  void _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      final filteredEventsFromDb = await DataService.getEvents(
        category: selectedCategory == 'All' ? null : selectedCategory,
      );

      setState(() {
        filteredEvents = filteredEventsFromDb;
        isLoading = false;
      });
    } catch (e) {
      print('Error applying filters: $e');
      // Fallback to local filtering
      filteredEvents = selectedCategory == 'All'
          ? events
          : events
                .where((event) => event.category == selectedCategory)
                .toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ELDERIZZ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: appTheme,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: eventCategories.entries.map((entry) {
                        final isSelected = selectedCategory == entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = entry.key;
                              });
                              _applyFilters();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? appTheme : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? appTheme
                                      : Colors.grey.shade300,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    entry.value,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Popular Activities section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Popular Activities Near You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Events list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return _buildEventCard(event);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(
                  event.imageUrl ?? 'assets/images/no_image.jpg',
                ),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {},
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Participant info and date
                Row(
                  children: [
                    // Participants
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${event.participantCount}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Date
                    Text(
                      event.formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // View participants and Join button
                Row(
                  children: [
                    // View participants button
                    TextButton(
                      onPressed: () {
                        _showParticipantsDialog(event);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: 16, color: appTheme),
                          const SizedBox(width: 4),
                          Text(
                            'View participants',
                            style: TextStyle(
                              color: appTheme,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: appTheme,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Join button
                    ElevatedButton(
                      onPressed: () => _joinEvent(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        event.isJoined ? 'Joined' : 'Join',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showParticipantsDialog(EventModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${event.title} Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${event.participantCount} people have joined this event'),
              const SizedBox(height: 16),
              Text('Max participants: ${event.maxParticipants}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _joinEvent(EventModel event) async {
    try {
      // In a real app, you would call a service to join the event
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            event.isJoined
                ? 'You have left ${event.title}'
                : 'Successfully joined ${event.title}!',
          ),
          backgroundColor: appTheme,
        ),
      );

      // Update local state (in real app, this would be handled by the backend)
      setState(() {
        final index = filteredEvents.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          filteredEvents[index] = EventModel(
            id: event.id,
            title: event.title,
            location: event.location,
            dateTime: event.dateTime,
            category: event.category,
            imageUrl: event.imageUrl,
            description: event.description,
            participantCount: event.isJoined
                ? event.participantCount - 1
                : event.participantCount + 1,
            maxParticipants: event.maxParticipants,
            organizerId: event.organizerId,
            isJoined: !event.isJoined,
            createdAt: event.createdAt,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error joining event. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Chat Page
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];
  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedMessages = await DataService.getMessages();
      final loadedUsers = await DataService.getUsers();
      setState(() {
        messages = loadedMessages;
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading chat data: $e');
      setState(() {
        messages = DataService.getSampleMessages();
        users = DataService.getSampleUsers();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Text(
                    'ELDERIZZ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appTheme,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet\nStart exploring to connect with people!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final sender = users.firstWhere(
                          (user) => user.id == message.senderId,
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: ProfileImageWidget(
                              imageUrl: sender.profileImageUrl,
                              size: 40,
                            ),
                            title: Text(sender.name),
                            subtitle: Text(
                              message.message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              _formatTime(message.timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatDetailPage(user: sender),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

// Chat Detail Page
class ChatDetailPage extends StatefulWidget {
  final UserModel user;

  const ChatDetailPage({super.key, required this.user});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String? conversationId;
  RealtimeChannel? _messagesSubscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupRealtimeSubscription();
  }

  @override
  void dispose() {
    _messagesSubscription?.unsubscribe();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      // In a real app, you would get the conversation ID from the widget or find it
      // For now, we'll create a simple conversation ID based on user IDs
      final currentUserId = SupabaseService.currentUserId;
      if (currentUserId != null) {
        // Try to find existing conversation or messages
        final conversations = await SupabaseService.getConversations();
        final conversation = conversations.firstWhere(
          (conv) =>
              (conv.user1Id == currentUserId &&
                  conv.user2Id == widget.user.id) ||
              (conv.user1Id == widget.user.id && conv.user2Id == currentUserId),
          orElse: () => throw Exception('No conversation found'),
        );

        conversationId = conversation.id;
        final messages = await SupabaseService.getMessages(conversationId!);

        setState(() {
          _messages = messages
              .map(
                (msg) => {
                  'message': msg.content,
                  'isMe': msg.senderId == currentUserId,
                  'timestamp': msg.createdAt,
                },
              )
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading messages: $e');
      // Fallback to sample data
      setState(() {
        _messages.addAll([
          {
            'message':
                'Hello! I saw your profile and thought we might have a lot in common.',
            'isMe': false,
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          },
          {
            'message':
                'Hi! Thank you for reaching out. I\'d love to get to know you better.',
            'isMe': true,
            'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          },
        ]);
        isLoading = false;
      });
    }
  }

  void _setupRealtimeSubscription() {
    if (conversationId != null) {
      _messagesSubscription = SupabaseService.subscribeToMessages(
        conversationId!,
        (message) {
          if (mounted) {
            setState(() {
              _messages.add({
                'message': message.content,
                'isMe': message.senderId == SupabaseService.currentUserId,
                'timestamp': message.createdAt,
              });
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ProfileImageWidget(imageUrl: widget.user.profileImageUrl, size: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name, style: const TextStyle(fontSize: 16)),
                Text(
                  widget.user.status,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(
                        message['message'],
                        message['isMe'],
                        message['timestamp'],
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  backgroundColor: appTheme,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMe, DateTime timestamp) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? appTheme : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(timestamp),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    // Add message to UI immediately
    setState(() {
      _messages.add({
        'message': messageText,
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });

    try {
      if (conversationId != null) {
        await SupabaseService.sendMessage(
          conversationId: conversationId!,
          receiverId: widget.user.id,
          content: messageText,
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? currentUserProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    try {
      final profile = await SupabaseService.getCurrentProfile();
      setState(() {
        currentUserProfile = profile as UserModel?;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await SupabaseService.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('My Profile'),
        //   backgroundColor: appTheme,
        //   foregroundColor: Colors.white,
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.edit),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) =>
        //                 EditProfilePage(currentProfile: currentUserProfile),
        //           ),
        //         ).then(
        //           (_) => _loadCurrentProfile(),
        //         ); // Reload profile after editing
        //       },
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: Row(
                children: [
                  const Text(
                    'ELDERIZZ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appTheme,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : currentUserProfile == null
                  ? const Center(child: Text('No profile data available'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                ProfileImageWidget(
                                  imageUrl: currentUserProfile!.profileImageUrl,
                                  size: 120,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${currentUserProfile!.fullName}, ${currentUserProfile!.age}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentUserProfile!.location,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentUserProfile!.bio ??
                                'No bio available yet. Add one by editing your profile!',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'My Interests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          currentUserProfile!.interests.isEmpty
                              ? const Text(
                                  'No interests added yet. Add some by editing your profile!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              : Wrap(
                                  spacing: 8,
                                  children: currentUserProfile!.interests.map((
                                    interest,
                                  ) {
                                    return Chip(
                                      label: Text(interest.name),
                                      backgroundColor: getMaterialColor(
                                        appTheme,
                                      ).shade100,
                                    );
                                  }).toList(),
                                ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      currentProfile: currentUserProfile,
                                    ),
                                  ),
                                ).then(
                                  (_) => _loadCurrentProfile(),
                                ); // Reload profile after editing
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appTheme,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                _showSettingsDialog(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: appTheme),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Settings',
                                style: TextStyle(fontSize: 16, color: appTheme),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement notifications settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement privacy settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement help & support
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _signOut();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final UserModel? currentProfile;

  const EditProfilePage({super.key, this.currentProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _locationController;
  late final TextEditingController _bioController;
  bool isLoading = false;
  String? _profileImageUrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = widget.currentProfile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _locationController = TextEditingController(text: profile?.location ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _profileImageUrl = profile?.profileImageUrl;
  }

  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Picture',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeProfilePicture() async {
    if (_profileImageUrl != null) {
      try {
        await SupabaseService.deleteProfileImage(_profileImageUrl!);
        setState(() {
          _profileImageUrl = null;
          _selectedImage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture removed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing picture: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildProfileImage() {
    const double imageSize = 120;

    if (_selectedImage != null) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      );
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          _profileImageUrl!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: imageSize,
              height: imageSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            );
          },
        ),
      );
    } else {
      return Container(
        width: imageSize,
        height: imageSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: const Icon(Icons.person, size: 60, color: Colors.white),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final age = int.tryParse(_ageController.text);
    if (age == null || age < 18 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age (18-120)')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Upload image if a new one was selected
      String? imageUrl = _profileImageUrl;
      if (_selectedImage != null) {
        imageUrl = await SupabaseService.uploadProfileImage(
          _selectedImage!.path,
        );
      }

      // Update profile with all data
      await SupabaseService.updateProfile({
        'full_name': _nameController.text.trim(),
        'age': age,
        'location': _locationController.text.trim(),
        'bio': _bioController.text.trim(),
        if (imageUrl != null) 'profile_image_url': imageUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e, stackTrace) {
      debugPrint("Error updating profile: ${e.toString()}");
      debugPrint("Error updating profile: ${stackTrace.toString()}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileImage(),
            TextButton(
              onPressed: _showImagePickerDialog,
              child: const Text('Change Photo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'About Me',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Other User Profile Page
class OtherProfilePage extends StatelessWidget {
  final UserModel user;

  const OtherProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ProfileImageWidget(imageUrl: user.profileImageUrl, size: 120),
                  const SizedBox(height: 10),
                  Text(
                    '${user.name}, ${user.age}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: user.status == 'online'
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        user.status == 'online' ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: user.status == 'online'
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              user.bio ?? 'No bio available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Interests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: user.interests.map((interest) {
                return Chip(
                  label: Text(interest.name),
                  backgroundColor: getMaterialColor(appTheme).shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You liked ${user.name}!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    label: const Text(
                      'Like',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(user: user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message, color: Colors.white),
                    label: const Text(
                      'Message',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showReportDialog(context, user.name);
                },
                icon: const Icon(Icons.report, color: Colors.red),
                label: const Text(
                  'Report User',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report $userName'),
          content: const Text(
            'Are you sure you want to report this user? This action will be reviewed by our moderation team.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'User reported. Thank you for keeping our community safe.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Report', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
