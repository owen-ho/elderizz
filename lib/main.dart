import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    const DiscoverPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
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
        //return users.cast<UserModel>();
        return [...getSampleUsers(), ...users.cast<UserModel>()];
      }
    } catch (e) {
      print('Error fetching users from Supabase: $e');
    }

    // Fallback to sample data
    return getSampleUsers();
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
                                  child: Image.asset(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            _nextProfile();
                          },
                          backgroundColor: Colors.red,
                          heroTag: "pass",
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            _likeProfile();
                          },
                          backgroundColor: Colors.green,
                          heroTag: "like",
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
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

// Discover Page
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;
  String selectedAgeRange = 'All Ages';
  String selectedLocation = 'All Locations';
  String selectedInterest = 'All Interests';

  final List<String> ageRanges = ['All Ages', '60-65', '66-70', '71-75', '76+'];
  final List<String> locations = [
    'All Locations',
    'New York, NY',
    'Los Angeles, CA',
    'Chicago, IL',
    'Miami, FL',
  ];
  final List<String> interests = [
    'All Interests',
    'Gardening',
    'Reading',
    'Photography',
    'Cooking',
    'Travel',
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
        filteredUsers = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        users = DataService.getSampleUsers();
        filteredUsers = DataService.getSampleUsers();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filters by interest in the form of pill buttons which can be active/inactive, updating the listview accordingly
                // Interest filter pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: interests.map((interest) {
                      final isSelected = selectedInterest == interest;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(interest),
                          selected: isSelected,
                          selectedColor: appTheme,
                          backgroundColor: getMaterialColor(appTheme).shade50,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : appTheme,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedInterest = interest;
                            });
                            _applyFilters();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            foregroundImage: AssetImage(user.profileImage),
                          ),
                          title: Text('${user.name}, ${user.age}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(user.location),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.bio ?? 'No bio available',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
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
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtherProfilePage(user: user),
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
    );
  }

  void _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Determine age range
      int? minAge, maxAge;
      switch (selectedAgeRange) {
        case '60-65':
          minAge = 60;
          maxAge = 65;
          break;
        case '66-70':
          minAge = 66;
          maxAge = 70;
          break;
        case '71-75':
          minAge = 71;
          maxAge = 75;
          break;
        case '76+':
          minAge = 76;
          break;
      }

      // Determine location filter
      String? locationFilter = selectedLocation == 'All Locations'
          ? null
          : selectedLocation;

      // Get filtered users from Supabase
      final filteredUsersFromDb = await SupabaseService.getDiscoverableUsers(
        minAge: minAge,
        maxAge: maxAge,
        location: locationFilter,
      );

      // Apply interest filter locally (since it's more complex)
      List<UserModel> finalFilteredUsers = filteredUsersFromDb
          .cast<UserModel>();
      if (selectedInterest != 'All Interests') {
        finalFilteredUsers = filteredUsersFromDb
            .where(
              (user) => user.interests.any(
                (interest) => interest.name == selectedInterest,
              ),
            )
            .cast<UserModel>()
            .toList();
      }

      setState(() {
        filteredUsers = finalFilteredUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error applying filters: $e');
      // Fallback to local filtering
      filteredUsers = users.where((user) {
        bool ageMatch =
            selectedAgeRange == 'All Ages' ||
            _isAgeInRange(user.age, selectedAgeRange);
        bool locationMatch =
            selectedLocation == 'All Locations' ||
            user.location == selectedLocation;
        bool interestMatch =
            selectedInterest == 'All Interests' ||
            user.interests.any((interest) => interest.name == selectedInterest);

        return ageMatch && locationMatch && interestMatch;
      }).toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isAgeInRange(int age, String range) {
    switch (range) {
      case '60-65':
        return age >= 60 && age <= 65;
      case '66-70':
        return age >= 66 && age <= 70;
      case '71-75':
        return age >= 71 && age <= 75;
      case '76+':
        return age >= 76;
      default:
        return true;
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
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
      ),
      body: isLoading
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
                    leading: CircleAvatar(
                      foregroundImage: AssetImage(sender.profileImage),
                    ),
                    title: Text(sender.name),
                    subtitle: Text(
                      message.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTime(message.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
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
              },
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
            CircleAvatar(foregroundImage: AssetImage(widget.user.profileImage)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: appTheme,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfilePage(currentProfile: currentUserProfile),
                ),
              ).then(
                (_) => _loadCurrentProfile(),
              ); // Reload profile after editing
            },
          ),
        ],
      ),
      body: isLoading
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
                        Image.asset(currentUserProfile!.profileImage),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  currentUserProfile!.interests.isEmpty
                      ? const Text(
                          'No interests added yet. Add some by editing your profile!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
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
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
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

  @override
  void initState() {
    super.initState();
    final profile = widget.currentProfile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _locationController = TextEditingController(text: profile?.location ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
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
      await SupabaseService.updateProfile({
        'full_name': _nameController.text.trim(),
        'age': age,
        'location': _locationController.text.trim(),
        'bio': _bioController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
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
            const Text('👤', style: TextStyle(fontSize: 80)),
            TextButton(
              onPressed: () {
                // Handle profile picture change
              },
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
                onPressed: () {
                  // Save profile changes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
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
                  Image.asset(user.profileImage),
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
