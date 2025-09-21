# Elderizz 💕

**Elderizz** is a modern dating application specifically designed for mature adults (50+) looking for meaningful connections. The app combines the convenience of modern dating technology with features tailored to the preferences and needs of older adults.

## 🌟 Features

### Core Dating Features
- **Smart Matching System**: Advanced filtering by age range, location, and interests
- **Profile Completion Flow**: Comprehensive 8-question onboarding covering:
  - Gender and dating intentions
  - Physical attributes (height)
  - Cultural background (ethnicity)
  - Lifestyle choices (children, religion, drinking, smoking habits)
- **Swipe-to-Like Interface**: Intuitive card-based user discovery
- **Real-time Messaging**: Chat with matched users instantly
- **Interest-based Matching**: Rich interest system with 20+ categories

### Social Features
- **Community Events**: Discover and join local activities including:
  - Outdoor activities (hiking, gardening, photography walks)
  - Cultural events (cooking classes, art workshops)
  - Social gatherings (book clubs, wine tasting, jazz evenings)
  - Games and hobbies (mahjong, bridge, tai chi)
- **Event Management**: Join events, view participants, track attendance

### User Experience
- **Accessible Design**: Large fonts, clear navigation, senior-friendly interface
- **Profile Customization**: Rich profiles with photos, interests, and detailed information
- **Privacy Controls**: Comprehensive blocking and reporting features
- **Multiple Authentication Options**: Email/password and Singpass integration

## 🛠️ Technology Stack

### Frontend
- **Flutter 3.x**: Cross-platform mobile app framework
- **Dart**: Primary programming language
- **Material Design**: UI component library

### Backend & Database
- **Supabase**: Backend-as-a-Service platform providing:
  - PostgreSQL database
  - Real-time subscriptions
  - Authentication system
  - File storage for profile images
  - Row Level Security (RLS) policies

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  supabase_flutter: ^2.6.0
  image_picker: ^1.1.2
  
dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0
```

## 📱 App Architecture

### Database Schema
- **Profiles**: User information and preferences
- **Interests**: Categorized hobby/activity system
- **User Interests**: Many-to-many relationship for user hobbies
- **Likes & Matches**: Dating interaction system
- **Messages & Conversations**: Real-time chat functionality
- **Events**: Community activity management
- **Reports & Blocks**: Safety and moderation features

### Key Models
- `UserModel`: Complete user profile with demographics and preferences
- `EventModel`: Community events with location and participant tracking
- `ChatMessage`: Real-time messaging system
- `Interest`: Categorized interests with icons and descriptions
- `ProfileCompletionData`: Onboarding questionnaire responses

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/owen-ho/elderizz.git
   cd elderizz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Update the Supabase URL and anon key in `lib/main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```
   - Run the database schema from `schema.sql` in your Supabase SQL editor

4. **Run the application**
   ```bash
   flutter run
   ```

### Demo Credentials
For testing purposes, you can use the Singpass demo login:
- **Email**: `hoshangluen@gmail.com`
- **Password**: `password1!`

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point and main screens
├── models/
│   └── profile_completion_models.dart # Data models for profile completion
├── screens/
│   ├── auth_screen.dart              # Authentication UI
│   ├── profile_completion_flow.dart   # 8-question onboarding flow
│   └── interests_management_page.dart # Interest selection interface
└── services/
    └── supabase_service.dart         # Backend API integration

assets/
├── images/                           # Sample profile and event images
└── icon/                            # App icon assets
```

## 🎯 Target Audience

Elderizz is specifically designed for:
- **Mature adults aged 50+** seeking romantic relationships
- **Users preferring thoughtful, detailed profiles** over superficial interactions
- **Community-minded individuals** interested in local events and activities
- **Tech-comfortable seniors** who appreciate modern app conveniences with accessibility considerations

## 🔐 Privacy & Safety

- **Row Level Security**: Database-level access controls
- **User Reporting System**: Report inappropriate behavior
- **Blocking Features**: Block unwanted users
- **Profile Verification**: Optional verification badges
- **Data Privacy**: Secure handling of personal information

## 📊 Key Metrics Tracked

- User activity and engagement
- Match success rates
- Event participation
- Profile completion rates
- Message response times

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

**Elderizz** - Where mature connections begin. 💕
