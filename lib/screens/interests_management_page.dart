import 'package:flutter/material.dart';
import '../main.dart';
import '../services/supabase_service.dart';

class InterestsManagementPage extends StatefulWidget {
  const InterestsManagementPage({super.key});

  @override
  State<InterestsManagementPage> createState() =>
      _InterestsManagementPageState();
}

class _InterestsManagementPageState extends State<InterestsManagementPage> {
  List<Interest> allInterests = [];
  List<String> selectedInterestIds = [];
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    try {
      final interests = await SupabaseService.getAllInterests();
      final currentProfile = await SupabaseService.getCurrentProfile();

      setState(() {
        allInterests = interests;
        // Cast to User to access interests
        final userProfile = currentProfile as UserModel?;
        selectedInterestIds =
            userProfile?.interests.map((i) => i.id).toList() ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading interests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveInterests() async {
    setState(() {
      isSaving = true;
    });

    try {
      await SupabaseService.updateUserInterests(selectedInterestIds);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interests updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating interests: ${e.toString()}')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Interests'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (!isLoading)
            TextButton(
              onPressed: isSaving ? null : _saveInterests,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allInterests.isEmpty
              ? const Center(child: Text('No interests available'))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.shade100,
                      child: Text(
                        'Select your interests to help others find you and to improve your matches.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            'Selected: ${selectedInterestIds.length} interests',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInterestGrid(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInterestGrid() {
    // Group interests by category
    Map<String, List<Interest>> categorizedInterests = {};
    for (final interest in allInterests) {
      final category = interest.category ?? 'Other';
      categorizedInterests.putIfAbsent(category, () => []).add(interest);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categorizedInterests.entries.map((entry) {
        final category = entry.key;
        final interests = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                final isSelected = selectedInterestIds.contains(interest.id);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (interest.icon != null) ...[
                        Text(interest.icon!),
                        const SizedBox(width: 4),
                      ],
                      Text(interest.name),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterestIds.add(interest.id);
                      } else {
                        selectedInterestIds.remove(interest.id);
                      }
                    });
                  },
                  selectedColor: Colors.teal.shade100,
                  backgroundColor: Colors.grey.shade200,
                  checkmarkColor: Colors.teal,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
