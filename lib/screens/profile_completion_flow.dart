import 'package:flutter/material.dart';
import '../models/profile_completion_models.dart';
import '../main.dart';

class ProfileCompletionFlow extends StatefulWidget {
  const ProfileCompletionFlow({super.key});

  @override
  State<ProfileCompletionFlow> createState() => _ProfileCompletionFlowState();
}

class _ProfileCompletionFlowState extends State<ProfileCompletionFlow> {
  final PageController _pageController = PageController();
  ProfileCompletionData _data = ProfileCompletionData();
  int _currentPageIndex = 0;
  final int _totalPages = 8;

  void _nextPage() {
    if (_currentPageIndex < _totalPages - 1) {
      setState(() {
        _currentPageIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeProfile();
    }
  }

  void _completeProfile() async {
    try {
      // Save profile completion data to database
      // TODO: Wire up backend to store profile questions data
      // await SupabaseService.saveProfileCompletion(_data.toJson());

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(_totalPages, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentPageIndex
                    ? appTheme
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GenderQuestionPage(
                    selectedGender: _data.gender,
                    onGenderSelected: (gender) {
                      setState(() {
                        _data = _data.copyWith(gender: gender);
                      });
                      _nextPage();
                    },
                  ),
                  DatingIntentionQuestionPage(
                    selectedIntention: _data.datingIntention,
                    onIntentionSelected: (intention) {
                      setState(() {
                        _data = _data.copyWith(datingIntention: intention);
                      });
                      _nextPage();
                    },
                  ),
                  HeightQuestionPage(
                    selectedHeight: _data.height,
                    onHeightSelected: (height) {
                      setState(() {
                        _data = _data.copyWith(height: height);
                      });
                      _nextPage();
                    },
                  ),
                  EthnicityQuestionPage(
                    selectedEthnicity: _data.ethnicity,
                    onEthnicitySelected: (ethnicity) {
                      setState(() {
                        _data = _data.copyWith(ethnicity: ethnicity);
                      });
                      _nextPage();
                    },
                  ),
                  ChildrenQuestionPage(
                    selectedChildrenCount: _data.childrenCount,
                    onChildrenCountSelected: (count) {
                      setState(() {
                        _data = _data.copyWith(childrenCount: count);
                      });
                      _nextPage();
                    },
                  ),
                  ReligionQuestionPage(
                    selectedReligion: _data.religion,
                    onReligionSelected: (religion) {
                      setState(() {
                        _data = _data.copyWith(religion: religion);
                      });
                      _nextPage();
                    },
                  ),
                  DrinkingQuestionPage(
                    selectedDrinking: _data.drinkingHabit,
                    onDrinkingSelected: (drinking) {
                      setState(() {
                        _data = _data.copyWith(drinkingHabit: drinking);
                      });
                      _nextPage();
                    },
                  ),
                  SmokingQuestionPage(
                    selectedSmoking: _data.smokingHabit,
                    onSmokingSelected: (smoking) {
                      setState(() {
                        _data = _data.copyWith(smokingHabit: smoking);
                      });
                      _nextPage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BaseQuestionPage extends StatelessWidget {
  final String question;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;

  const BaseQuestionPage({
    super.key,
    required this.question,
    required this.subtitle,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
          const SizedBox(height: 20),
          Text(
            question,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SelectionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? appTheme.withOpacity(0.1)
                : Colors.grey.shade100,
            border: Border.all(
              color: isSelected ? appTheme : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? appTheme : Colors.black,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: appTheme, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderQuestionPage extends StatelessWidget {
  final Gender? selectedGender;
  final Function(Gender) onGenderSelected;

  const GenderQuestionPage({
    super.key,
    this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'Which gender best describes you?',
      subtitle:
          'We match daters using three broad gender groups. You can add more about your gender after.',
      child: Column(
        children: [
          ...Gender.values.map(
            (gender) => SelectionTile(
              title: gender.displayName,
              isSelected: selectedGender == gender,
              onTap: () => onGenderSelected(gender),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.check, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DatingIntentionQuestionPage extends StatelessWidget {
  final DatingIntention? selectedIntention;
  final Function(DatingIntention) onIntentionSelected;

  const DatingIntentionQuestionPage({
    super.key,
    this.selectedIntention,
    required this.onIntentionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'What is your dating intention?',
      subtitle:
          'Help us match you with people who share similar relationship goals.',
      child: Column(
        children: [
          ...DatingIntention.values.map(
            (intention) => SelectionTile(
              title: intention.displayName,
              isSelected: selectedIntention == intention,
              onTap: () => onIntentionSelected(intention),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeightQuestionPage extends StatelessWidget {
  final int? selectedHeight;
  final Function(int) onHeightSelected;

  const HeightQuestionPage({
    super.key,
    this.selectedHeight,
    required this.onHeightSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<int> heights = [
      160,
      161,
      162,
      163,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175,
      176,
      177,
      178,
      179,
      180,
      181,
      182,
      183,
      184,
      185,
    ];

    return BaseQuestionPage(
      question: 'How tall are you?',
      subtitle: 'This helps us find better matches for you.',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: heights
                  .map(
                    (height) => SelectionTile(
                      title: '$height cm',
                      isSelected: selectedHeight == height,
                      onTap: () => onHeightSelected(height),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'CM',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EthnicityQuestionPage extends StatelessWidget {
  final Ethnicity? selectedEthnicity;
  final Function(Ethnicity) onEthnicitySelected;

  const EthnicityQuestionPage({
    super.key,
    this.selectedEthnicity,
    required this.onEthnicitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'What is your ethnicity?',
      subtitle: 'This information helps us understand our community better.',
      child: Column(
        children: [
          ...Ethnicity.values.map(
            (ethnicity) => SelectionTile(
              title: ethnicity.displayName,
              isSelected: selectedEthnicity == ethnicity,
              onTap: () => onEthnicitySelected(ethnicity),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChildrenQuestionPage extends StatelessWidget {
  final ChildrenCount? selectedChildrenCount;
  final Function(ChildrenCount) onChildrenCountSelected;

  const ChildrenQuestionPage({
    super.key,
    this.selectedChildrenCount,
    required this.onChildrenCountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'How many children do you have?',
      subtitle: 'This helps us find compatible matches for you.',
      child: Column(
        children: [
          ...ChildrenCount.values.map(
            (count) => SelectionTile(
              title: count.displayName,
              isSelected: selectedChildrenCount == count,
              onTap: () => onChildrenCountSelected(count),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReligionQuestionPage extends StatelessWidget {
  final Religion? selectedReligion;
  final Function(Religion) onReligionSelected;

  const ReligionQuestionPage({
    super.key,
    this.selectedReligion,
    required this.onReligionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'What are your religious beliefs?',
      subtitle: 'This information helps us find compatible matches.',
      child: ListView(
        children: [
          ...Religion.values.map(
            (religion) => SelectionTile(
              title: religion.displayName,
              isSelected: selectedReligion == religion,
              onTap: () => onReligionSelected(religion),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrinkingQuestionPage extends StatelessWidget {
  final DrinkingHabit? selectedDrinking;
  final Function(DrinkingHabit) onDrinkingSelected;

  const DrinkingQuestionPage({
    super.key,
    this.selectedDrinking,
    required this.onDrinkingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'Do you drink?',
      subtitle: 'This helps us find compatible matches for you.',
      child: Column(
        children: [
          ...DrinkingHabit.values.map(
            (habit) => SelectionTile(
              title: habit.displayName,
              isSelected: selectedDrinking == habit,
              onTap: () => onDrinkingSelected(habit),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SmokingQuestionPage extends StatelessWidget {
  final SmokingHabit? selectedSmoking;
  final Function(SmokingHabit) onSmokingSelected;

  const SmokingQuestionPage({
    super.key,
    this.selectedSmoking,
    required this.onSmokingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseQuestionPage(
      question: 'Do you smoke tobacco?',
      subtitle: 'This helps us find compatible matches for you.',
      child: Column(
        children: [
          ...SmokingHabit.values.map(
            (habit) => SelectionTile(
              title: habit.displayName,
              isSelected: selectedSmoking == habit,
              onTap: () => onSmokingSelected(habit),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.visibility, color: appTheme, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Always visible on profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
