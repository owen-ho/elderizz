import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://npemdwlhzelkqdyupuzu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5wZW1kd2xoemVsa3FkeXVwdXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyODg3NzgsImV4cCI6MjA3Mzg2NDc3OH0.htNqcHH_IdaJIPvI2kIN3v1zbdEectRPuAQ8OQMW6O0',
  );
  runApp(ElderlyDatingApp());
}

class ElderlyDatingApp extends StatelessWidget {
  const ElderlyDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golden Connections',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
        selectedItemColor: Colors.teal,
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

// User model
class User {
  final String id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final String profileImage;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.profileImage,
    required this.status,
  });
}

// Chat message model
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}

// Sample data
class DataService {
  static List<User> getUsers() {
    return [
      User(
        id: '1',
        name: 'Margaret Johnson',
        age: 68,
        location: 'New York, NY',
        bio:
            'Love gardening, reading, and spending time with my grandchildren. Looking for someone to share life\'s adventures with.',
        interests: ['Gardening', 'Reading', 'Cooking', 'Travel'],
        profileImage: '👩‍🦳',
        status: 'online',
      ),
      User(
        id: '2',
        name: 'Robert Smith',
        age: 72,
        location: 'Los Angeles, CA',
        bio:
            'Retired teacher who enjoys hiking, photography, and good conversation. Seeking a kind companion for this chapter of life.',
        interests: ['Photography', 'Hiking', 'Movies', 'Music'],
        profileImage: '👨‍🦳',
        status: 'offline',
      ),
      User(
        id: '3',
        name: 'Dorothy Williams',
        age: 65,
        location: 'Chicago, IL',
        bio:
            'Recently widowed, ready to find joy again. Love painting, bridge, and volunteer work at the local shelter.',
        interests: ['Painting', 'Bridge', 'Volunteering', 'Dancing'],
        profileImage: '👵',
        status: 'online',
      ),
      User(
        id: '4',
        name: 'Frank Miller',
        age: 70,
        location: 'Miami, FL',
        bio:
            'Widower looking for companionship. Enjoy fishing, golf, and cooking for someone special.',
        interests: ['Fishing', 'Golf', 'Cooking', 'Travel'],
        profileImage: '👴',
        status: 'online',
      ),
    ];
  }

  static List<ChatMessage> getMessages() {
    return [
      ChatMessage(
        id: '1',
        senderId: '1',
        receiverId: 'current_user',
        message:
            'Hello! I saw your profile and thought we might have a lot in common.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: '2',
        senderId: '2',
        receiverId: 'current_user',
        message: 'Would you like to grab coffee sometime?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}

// Explore Page
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<User> users = DataService.getUsers();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Profiles'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: users.isEmpty
          ? const Center(child: Text('No more profiles to show'))
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
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.teal.shade50, Colors.white],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                users[currentIndex].profileImage,
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                              users[currentIndex].bio,
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
                              children: users[currentIndex].interests.map((
                                interest,
                              ) {
                                return Chip(
                                  label: Text(interest),
                                  backgroundColor: Colors.teal.shade100,
                                );
                              }).toList(),
                            ),
                          ],
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
                        child: const Icon(Icons.favorite, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
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

  void _likeProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You liked ${users[currentIndex].name}!'),
        backgroundColor: Colors.green,
      ),
    );
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
  List<User> users = DataService.getUsers();
  List<User> filteredUsers = [];
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
    filteredUsers = users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Age Range',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedAgeRange,
                        items: ageRanges.map((String age) {
                          return DropdownMenuItem<String>(
                            value: age,
                            child: Text(age),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAgeRange = newValue!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedLocation,
                        items: locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Interest',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedInterest,
                  items: interests.map((String interest) {
                    return DropdownMenuItem<String>(
                      value: interest,
                      child: Text(interest),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInterest = newValue!;
                      _applyFilters();
                    });
                  },
                ),
              ],
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
                      child: Text(
                        user.profileImage,
                        style: const TextStyle(fontSize: 30),
                      ),
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
                          user.bio,
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
                          builder: (context) => OtherProfilePage(user: user),
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

  void _applyFilters() {
    filteredUsers = users.where((user) {
      bool ageMatch = selectedAgeRange == 'All Ages' ||
          _isAgeInRange(user.age, selectedAgeRange);
      bool locationMatch = selectedLocation == 'All Locations' ||
          user.location == selectedLocation;
      bool interestMatch = selectedInterest == 'All Interests' ||
          user.interests.contains(selectedInterest);

      return ageMatch && locationMatch && interestMatch;
    }).toList();
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
  final List<ChatMessage> messages = DataService.getMessages();
  final List<User> users = DataService.getUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: messages.isEmpty
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
                      child: Text(
                        sender.profileImage,
                        style: const TextStyle(fontSize: 20),
                      ),
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
  final User user;

  const ChatDetailPage({super.key, required this.user});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Text(
                widget.user.profileImage,
                style: const TextStyle(fontSize: 16),
              ),
            ),
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
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                  backgroundColor: Colors.teal,
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
          color: isMe ? Colors.teal : Colors.grey.shade200,
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

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'message': _messageController.text.trim(),
          'isMe': true,
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('👤', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe, 65',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.location_on, color: Colors.grey, size: 18),
                      SizedBox(width: 4),
                      Text('Boston, MA', style: TextStyle(color: Colors.grey)),
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
            const Text(
              'Retired engineer who loves to stay active. Enjoy hiking, reading mystery novels, and cooking for friends and family. Looking for someone special to share new adventures with.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'My Interests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Hiking', 'Reading', 'Cooking', 'Travel', 'Movies']
                  .map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: Colors.teal.shade100,
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
                  backgroundColor: Colors.teal,
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
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
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
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {},
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
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _ageController = TextEditingController(text: '65');
  final _locationController = TextEditingController(text: 'Boston, MA');
  final _bioController = TextEditingController(
    text:
        'Retired engineer who loves to stay active. Enjoy hiking, reading mystery novels, and cooking for friends and family. Looking for someone special to share new adventures with.',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
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
                  backgroundColor: Colors.teal,
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
  final User user;

  const OtherProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.teal,
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
                  Text(user.profileImage, style: const TextStyle(fontSize: 80)),
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
            Text(user.bio, style: const TextStyle(fontSize: 16)),
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
                  label: Text(interest),
                  backgroundColor: Colors.teal.shade100,
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
                      backgroundColor: Colors.teal,
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
