import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/supabase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_completion_flow.dart';
import 'screens/interests_management_page.dart';
import 'models/profile_completion_models.dart';

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
  // Profile completion fields
  final DatingIntention? datingIntention;
  final int? height;
  final Ethnicity? ethnicity;
  final ChildrenCount? childrenCount;
  final Religion? religion;
  final DrinkingHabit? drinkingHabit;
  final SmokingHabit? smokingHabit;

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
    this.datingIntention,
    this.height,
    this.ethnicity,
    this.childrenCount,
    this.religion,
    this.drinkingHabit,
    this.smokingHabit,
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
        id: 'sarah_id',
        fullName: 'Sarah',
        age: 68,
        location: 'New York, NY',
        bio:
            'Love gardening, reading, and spending time with my grandchildren.',
        interests: [
          Interest(id: '1', name: 'Gardening', icon: '🌱', createdAt: now),
          Interest(id: '2', name: 'Reading', icon: '📚', createdAt: now),
        ],
        profileImageUrl: 'assets/images/pp1.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        lastActive: now.subtract(const Duration(minutes: 5)),
        datingIntention: DatingIntention.longTerm,
        height: 165,
        ethnicity: Ethnicity.chinese,
        childrenCount: ChildrenCount.twoToThree,
        religion: Religion.christian,
        drinkingHabit: DrinkingHabit.sometimes,
        smokingHabit: SmokingHabit.no,
      ),
      UserModel(
        id: 'alex_id',
        fullName: 'Alex',
        age: 72,
        location: 'Los Angeles, CA',
        bio: 'Retired teacher who loves coffee and good conversation.',
        interests: [
          Interest(id: '3', name: 'Coffee', icon: '☕', createdAt: now),
          Interest(id: '4', name: 'Reading', icon: '📚', createdAt: now),
        ],
        profileImageUrl: 'assets/images/mpp1.jpg',
        status: 'offline',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 2)),
        lastActive: now.subtract(const Duration(hours: 3)),
        datingIntention: DatingIntention.dontKnow,
        height: 175,
        ethnicity: Ethnicity.eurasian,
        childrenCount: ChildrenCount.zeroToOne,
        religion: Religion.atheist,
        drinkingHabit: DrinkingHabit.yes,
        smokingHabit: SmokingHabit.no,
      ),
      UserModel(
        id: 'emma_id',
        fullName: 'Emma',
        age: 65,
        location: 'Chicago, IL',
        bio: 'Art enthusiast and volunteer at the local shelter.',
        interests: [
          Interest(id: '9', name: 'Art', icon: '�', createdAt: now),
          Interest(id: '10', name: 'Volunteering', icon: '🤝', createdAt: now),
        ],
        profileImageUrl: 'assets/images/pp2.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        lastActive: now.subtract(const Duration(minutes: 15)),
        datingIntention: DatingIntention.shortTerm,
        height: 160,
        ethnicity: Ethnicity.african,
        childrenCount: ChildrenCount.fourToFive,
        religion: Religion.buddhist,
        drinkingHabit: DrinkingHabit.no,
        smokingHabit: SmokingHabit.no,
      ),
      UserModel(
        id: 'jessica_id',
        fullName: 'Jessica',
        age: 70,
        location: 'Miami, FL',
        bio: 'Enjoying retirement and looking for new adventures.',
        interests: [
          Interest(id: '13', name: 'Travel', icon: '✈️', createdAt: now),
          Interest(id: '14', name: 'Dancing', icon: '💃', createdAt: now),
        ],
        profileImageUrl: 'assets/images/pp3.jpg',
        status: 'offline',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 3)),
        lastActive: now.subtract(const Duration(days: 1)),
        datingIntention: DatingIntention.longTerm,
        height: 162,
        ethnicity: Ethnicity.indian,
        childrenCount: ChildrenCount.sixPlus,
        religion: Religion.hindu,
        drinkingHabit: DrinkingHabit.sometimes,
        smokingHabit: SmokingHabit.sometimes,
      ),
      UserModel(
        id: 'michael_id',
        fullName: 'Michael',
        age: 67,
        location: 'Denver, CO',
        bio: 'Outdoor enthusiast who loves hiking and photography.',
        interests: [
          Interest(id: '15', name: 'Hiking', icon: '🥾', createdAt: now),
          Interest(id: '16', name: 'Photography', icon: '📷', createdAt: now),
        ],
        profileImageUrl: 'assets/images/mpp2.jpg',
        status: 'online',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        lastActive: now.subtract(const Duration(hours: 1)),
        datingIntention: DatingIntention.longTerm,
        height: 178,
        ethnicity: Ethnicity.malay,
        childrenCount: ChildrenCount.twoToThree,
        religion: Religion.muslim,
        drinkingHabit: DrinkingHabit.no,
        smokingHabit: SmokingHabit.no,
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
        senderId: 'sarah_id',
        receiverId: 'current_user',
        content: 'Hey! How was your day?',
        createdAt: now.subtract(const Duration(minutes: 2)),
        updatedAt: now.subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
      ChatMessage(
        id: '2',
        conversationId: 'conv_2',
        senderId: 'alex_id',
        receiverId: 'current_user',
        content: 'That coffee place was amazing! ☕',
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        conversationId: 'conv_3',
        senderId: 'emma_id',
        receiverId: 'current_user',
        content: 'Would love to check out that art gallery!',
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      ChatMessage(
        id: '4',
        conversationId: 'conv_4',
        senderId: 'jessica_id',
        receiverId: 'current_user',
        content: 'Thanks for the great evening! 😊',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: '5',
        conversationId: 'conv_5',
        senderId: 'michael_id',
        receiverId: 'current_user',
        content: 'Looking forward to our hiking trip!',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
        isRead: true,
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

  // Sample data for people who liked the current user
  static List<UserModel> getSampleUsersWhoLikedMe() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'liker_1',
        fullName: 'Jessica',
        age: 24,
        location: '1 mile away',
        bio: 'Love hiking, reading, and good coffee.',
        profileImageUrl: 'assets/images/pp3.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        lastActive: now.subtract(const Duration(hours: 1)),
        interests: [
          Interest(id: '1', name: 'Hiking', icon: '🥾', createdAt: now),
          Interest(id: '2', name: 'Reading', icon: '📚', createdAt: now),
        ],
      ),
      UserModel(
        id: 'liker_2',
        fullName: 'Michael',
        age: 29,
        location: '4 miles away',
        bio: 'Software engineer who loves cooking and traveling.',
        profileImageUrl: 'assets/images/mpp3.jpg',
        status: 'online',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        lastActive: now.subtract(const Duration(hours: 2)),
        interests: [
          Interest(id: '3', name: 'Cooking', icon: '👨‍🍳', createdAt: now),
          Interest(id: '4', name: 'Travel', icon: '✈️', createdAt: now),
        ],
      ),
      UserModel(
        id: 'liker_3',
        fullName: 'Lisa',
        age: 27,
        location: '2 miles away',
        bio: 'Artist and dog lover. Looking for genuine connections.',
        profileImageUrl: 'assets/images/pp4.jpg',
        status: 'offline',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        lastActive: now.subtract(const Duration(hours: 8)),
        interests: [
          Interest(id: '5', name: 'Art', icon: '🎨', createdAt: now),
          Interest(id: '6', name: 'Dogs', icon: '🐕', createdAt: now),
        ],
      ),
      UserModel(
        id: 'liker_4',
        fullName: 'David',
        age: 31,
        location: '3 miles away',
        bio: 'Photographer and music enthusiast.',
        profileImageUrl: 'assets/images/mpp4.jpg',
        status: 'online',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        lastActive: now.subtract(const Duration(minutes: 30)),
        interests: [
          Interest(id: '7', name: 'Photography', icon: '📷', createdAt: now),
          Interest(id: '8', name: 'Music', icon: '🎵', createdAt: now),
        ],
      ),
    ];
  }

  // Sample data for people the current user has liked
  static List<UserModel> getSampleUsersILiked() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'liked_1',
        fullName: 'Emily',
        age: 26,
        location: '2 miles away',
        bio: 'Nature lover and yoga instructor.',
        profileImageUrl: 'assets/images/pp5.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        lastActive: now.subtract(const Duration(minutes: 45)),
        interests: [
          Interest(id: '9', name: 'Yoga', icon: '🧘‍♀️', createdAt: now),
          Interest(id: '10', name: 'Nature', icon: '🌿', createdAt: now),
        ],
      ),
      UserModel(
        id: 'liked_2',
        fullName: 'James',
        age: 32,
        location: '5 miles away',
        bio: 'Chef and wine enthusiast.',
        profileImageUrl: 'assets/images/mpp5.jpg',
        status: 'offline',
        gender: 'male',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 8)),
        lastActive: now.subtract(const Duration(hours: 6)),
        interests: [
          Interest(id: '11', name: 'Cooking', icon: '👨‍🍳', createdAt: now),
          Interest(id: '12', name: 'Wine', icon: '🍷', createdAt: now),
        ],
      ),
      UserModel(
        id: 'liked_3',
        fullName: 'Sarah',
        age: 28,
        location: '1 mile away',
        bio: 'Writer and bookworm.',
        profileImageUrl: 'assets/images/pp6.jpg',
        status: 'online',
        gender: 'female',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        lastActive: now.subtract(const Duration(minutes: 10)),
        interests: [
          Interest(id: '13', name: 'Writing', icon: '✍️', createdAt: now),
          Interest(id: '14', name: 'Reading', icon: '📚', createdAt: now),
        ],
      ),
    ];
  }

  static Future<List<UserModel>> getUsersWhoLikedMe() async {
    try {
      // In a real app, you would fetch from Supabase here
      return getSampleUsersWhoLikedMe();
    } catch (e) {
      print('Error fetching users who liked me: $e');
      return getSampleUsersWhoLikedMe();
    }
  }

  static Future<List<UserModel>> getUsersILiked() async {
    try {
      // In a real app, you would fetch from Supabase here
      return getSampleUsersILiked();
    } catch (e) {
      print('Error fetching users I liked: $e');
      return getSampleUsersILiked();
    }
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
  List<UserModel> filteredUsers = [];
  int currentIndex = 0;
  bool isLoading = true;
  String selectedAgeRange = 'All';
  String selectedRegion = 'All';

  final List<String> ageRanges = ['All', '50-60', '50-70', '60-80', '70+'];
  final List<String> regions = [
    'All',
    'Central',
    'North',
    'South',
    'East',
    'West',
  ];

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
        _filterUsers();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        users = DataService.getSampleUsers();
        _filterUsers();
        isLoading = false;
      });
    }
  }

  void _filterUsers() {
    filteredUsers = users.where((user) {
      // Age filter
      bool ageMatch = true;
      if (selectedAgeRange != 'All') {
        switch (selectedAgeRange) {
          case '50-60':
            ageMatch = user.age >= 50 && user.age <= 60;
            break;
          case '50-70':
            ageMatch = user.age >= 50 && user.age <= 70;
            break;
          case '60-80':
            ageMatch = user.age >= 60 && user.age <= 80;
            break;
          case '70+':
            ageMatch = user.age >= 70;
            break;
        }
      }

      // Region filter (simplified - just check if location contains region)
      // bool regionMatch = true;
      // if (selectedRegion != 'All') {
      //   regionMatch = user.location.toLowerCase().contains(
      //     selectedRegion.toLowerCase(),
      //   );
      // }

      return ageMatch;
    }).toList();

    // Reset current index if filtered list is smaller
    if (currentIndex >= filteredUsers.length && filteredUsers.isNotEmpty) {
      currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredUsers.isEmpty
            ? const Center(child: Text('No profiles match your filters'))
            : Stack(
                children: [
                  Column(
                    children: [
                      // Header with app name
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'ELDERIZZ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: appTheme,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Filters section
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Age filter
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'AGE',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectedAgeRange,
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey.shade600,
                                            ),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  selectedAgeRange = newValue;
                                                  _filterUsers();
                                                  currentIndex = 0;
                                                });
                                              }
                                            },
                                            items: ageRanges
                                                .map<DropdownMenuItem<String>>((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .grey
                                                            .shade800,
                                                      ),
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Region filter
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'REGION',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectedRegion,
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey.shade600,
                                            ),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  selectedRegion = newValue;
                                                  _filterUsers();
                                                  currentIndex = 0;
                                                });
                                              }
                                            },
                                            items: regions
                                                .map<DropdownMenuItem<String>>((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .grey
                                                            .shade800,
                                                      ),
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Profile card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  // elevation-like effect
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          // Background image
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child:
                                                  filteredUsers[currentIndex]
                                                              .profileImageUrl !=
                                                          null &&
                                                      filteredUsers[currentIndex]
                                                          .profileImageUrl!
                                                          .startsWith('http')
                                                  ? Image.network(
                                                      filteredUsers[currentIndex]
                                                          .profileImageUrl!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      filteredUsers[currentIndex]
                                                              .profileImageUrl ??
                                                          'assets/images/no_image.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),

                                          // Gradient overlay
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.black.withOpacity(
                                                      0.7,
                                                    ),
                                                  ],
                                                  stops: const [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Profile info at bottom
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(24),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${filteredUsers[currentIndex].fullName}, ${filteredUsers[currentIndex].age}',
                                                    style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_on,
                                                        color: Colors.white70,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          filteredUsers[currentIndex]
                                                              .location,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white70,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                          horizontal: 16,
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 12),
                                            Text(
                                              filteredUsers[currentIndex].bio ??
                                                  'No bio available',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 16),
                                            // Interest tags
                                            if (filteredUsers[currentIndex]
                                                .interests
                                                .isNotEmpty)
                                              Row(
                                                children: [
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    children: filteredUsers[currentIndex]
                                                        .interests
                                                        .take(
                                                          4,
                                                        ) // Show max 4 interests
                                                        .map((interest) {
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: appTheme
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              interest.name,
                                                              style: const TextStyle(
                                                                color: appTheme,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Profile completion info
                                      if (filteredUsers[currentIndex]
                                                  .datingIntention !=
                                              null ||
                                          filteredUsers[currentIndex].height !=
                                              null ||
                                          filteredUsers[currentIndex]
                                                  .ethnicity !=
                                              null)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10,
                                            0,
                                            10,
                                            16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 16),
                                              _buildProfileCompletionSection(
                                                filteredUsers[currentIndex],
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 110),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Action buttons
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Pass button
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _nextProfile();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),

                          // Like button
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _likeProfile();
                              },
                              icon: const Icon(
                                Icons.favorite_outline,
                                color: Colors.white,
                                size: 30,
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

  void _nextProfile() {
    setState(() {
      if (currentIndex < filteredUsers.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Loop back to start
      }
    });
  }

  void _likeProfile() async {
    final currentUser = filteredUsers[currentIndex];

    try {
      // Like the user in the database
      await SupabaseService.likeUser(currentUser.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You liked ${currentUser.fullName}!'),
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

  Widget _buildProfileCompletionSection(UserModel user) {
    final profileInfo = <Map<String, String>>[];

    if (user.datingIntention != null) {
      profileInfo.add({
        'icon': '💕',
        'label': 'Looking for',
        'value': user.datingIntention!.displayName,
      });
    }

    if (user.height != null) {
      profileInfo.add({
        'icon': '📏',
        'label': 'Height',
        'value': '${user.height} cm',
      });
    }

    if (user.ethnicity != null) {
      profileInfo.add({
        'icon': '🌍',
        'label': 'Ethnicity',
        'value': user.ethnicity!.displayName,
      });
    }

    if (user.childrenCount != null) {
      profileInfo.add({
        'icon': '👶',
        'label': 'Children',
        'value': user.childrenCount!.displayName,
      });
    }

    if (user.religion != null) {
      profileInfo.add({
        'icon': '🙏',
        'label': 'Religion',
        'value': user.religion!.displayName,
      });
    }

    if (user.drinkingHabit != null) {
      profileInfo.add({
        'icon': '🍷',
        'label': 'Drinks',
        'value': user.drinkingHabit!.displayName,
      });
    }

    if (user.smokingHabit != null) {
      profileInfo.add({
        'icon': '🚭',
        'label': 'Smokes',
        'value': user.smokingHabit!.displayName,
      });
    }

    if (profileInfo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...profileInfo
              .take(4)
              .map(
                (info) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(info['icon']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        '${info['label']}: ',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          info['value']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black87),
            onPressed: () {
              // Add menu functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Messages list
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final sender = users.firstWhere(
                        (user) => user.id == message.senderId,
                        orElse: () => users.first,
                      );

                      return _buildMessageItem(sender, message);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LikesPage()),
          );
        },
        backgroundColor: appTheme,
        child: const Icon(Icons.favorite, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageItem(UserModel sender, ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: Stack(
          children: [
            ProfileImageWidget(
              imageUrl: sender.profileImageUrl,
              size: 50,
              isCircular: true,
            ),
            // Online indicator
            if (sender.status == 'online')
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          sender.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            message.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatMessageTime(message.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            // Unread indicator
            if (!message.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: appTheme,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(user: sender),
            ),
          );
        },
      ),
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return '1d ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}

// Likes Page
class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  bool showWhoLikedMe = true; // true = who liked me, false = who I liked
  List<UserModel> usersWhoLikedMe = [];
  List<UserModel> usersILiked = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final likedMe = await DataService.getUsersWhoLikedMe();
      final iLiked = await DataService.getUsersILiked();
      setState(() {
        usersWhoLikedMe = likedMe;
        usersILiked = iLiked;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading likes data: $e');
      setState(() {
        usersWhoLikedMe = DataService.getSampleUsersWhoLikedMe();
        usersILiked = DataService.getSampleUsersILiked();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = showWhoLikedMe ? usersWhoLikedMe : usersILiked;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const BackButton(),
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
                  const SizedBox(height: 16),
                  Text(
                    showWhoLikedMe
                        ? 'People who liked you'
                        : 'People you liked',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${currentList.length} ${showWhoLikedMe ? 'potential matches' : 'profiles liked'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Toggle switch
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showWhoLikedMe = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: showWhoLikedMe
                                ? appTheme
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Liked You',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: showWhoLikedMe
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showWhoLikedMe = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !showWhoLikedMe
                                ? appTheme
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'You Liked',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !showWhoLikedMe
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List of users
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : currentList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            showWhoLikedMe
                                ? 'No one has liked you yet\nKeep exploring to get matches!'
                                : 'You haven\'t liked anyone yet\nStart exploring to find people you like!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final user = currentList[index];
                        return _buildUserCard(user);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    // Calculate mutual friends (mock data for demo)
    final mutualFriends = (user.age % 3) + 1; // Simple mock calculation

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Profile image with heart icon
            Stack(
              children: [
                ProfileImageWidget(
                  imageUrl: user.profileImageUrl,
                  size: 60,
                  isCircular: true,
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: appTheme,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.location,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mutualFriends mutual friend${mutualFriends > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                // View Profile button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfilePage(user: user),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: appTheme),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'View Profile',
                    style: TextStyle(
                      color: appTheme,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Message button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(user: user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.message, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
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
                                  style: const TextStyle(color: Colors.grey),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProfileCompletionFlow(),
                              ),
                            ).then(
                              (_) => _loadCurrentProfile(),
                            ); // Reload profile after completion
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Complete Your Profile',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
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

  Widget _buildInterestsSection() {
    final currentProfile = widget.currentProfile;
    final userInterests = currentProfile?.interests ?? [];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Interests',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InterestsManagementPage(),
                    ),
                  );
                  // Optionally refresh profile data if interests were updated
                  if (result != null) {
                    // You could call a refresh method here if needed
                  }
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(foregroundColor: appTheme),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (userInterests.isEmpty)
            Text(
              'No interests selected. Add some interests to help others find you!',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userInterests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getMaterialColor(appTheme).shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: getMaterialColor(appTheme).shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (interest.icon != null) ...[
                        Text(interest.icon!),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        interest.name,
                        style: TextStyle(
                          color: appTheme,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
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
            const SizedBox(height: 20),
            _buildInterestsSection(),
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
