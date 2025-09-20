enum Gender {
  male('Male'),
  female('Female'),
  nonBinary('Non-binary');

  const Gender(this.displayName);
  final String displayName;
}

enum DatingIntention {
  longTerm('Long-term'),
  shortTerm('Short-term'),
  dontKnow("Don't know");

  const DatingIntention(this.displayName);
  final String displayName;
}

enum Ethnicity {
  chinese('Chinese'),
  indian('Indian'),
  malay('Malay'),
  eurasian('Eurasian'),
  african('African');

  const Ethnicity(this.displayName);
  final String displayName;
}

enum ChildrenCount {
  zeroToOne('0-1'),
  twoToThree('2-3'),
  fourToFive('4-5'),
  sixPlus('6+');

  const ChildrenCount(this.displayName);
  final String displayName;
}

enum Religion {
  buddhist('Buddhist'),
  christian('Christian'),
  muslim('Muslim'),
  hindu('Hindu'),
  atheist('Atheist'),
  agnostic('Agnostic'),
  jewish('Jewish');

  const Religion(this.displayName);
  final String displayName;
}

enum DrinkingHabit {
  yes('Yes'),
  sometimes('Sometimes'),
  no('No');

  const DrinkingHabit(this.displayName);
  final String displayName;
}

enum SmokingHabit {
  yes('Yes'),
  sometimes('Sometimes'),
  no('No');

  const SmokingHabit(this.displayName);
  final String displayName;
}

class ProfileCompletionData {
  Gender? gender;
  DatingIntention? datingIntention;
  int? height; // in cm
  Ethnicity? ethnicity;
  ChildrenCount? childrenCount;
  Religion? religion;
  DrinkingHabit? drinkingHabit;
  SmokingHabit? smokingHabit;

  ProfileCompletionData({
    this.gender,
    this.datingIntention,
    this.height,
    this.ethnicity,
    this.childrenCount,
    this.religion,
    this.drinkingHabit,
    this.smokingHabit,
  });

  bool get isComplete =>
      gender != null &&
      datingIntention != null &&
      height != null &&
      ethnicity != null &&
      childrenCount != null &&
      religion != null &&
      drinkingHabit != null &&
      smokingHabit != null;

  Map<String, dynamic> toJson() {
    return {
      'gender': gender?.name,
      'dating_intention': datingIntention?.name,
      'height': height,
      'ethnicity': ethnicity?.name,
      'children_count': childrenCount?.name,
      'religion': religion?.name,
      'drinking_habit': drinkingHabit?.name,
      'smoking_habit': smokingHabit?.name,
    };
  }

  factory ProfileCompletionData.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionData(
      gender: json['gender'] != null
          ? Gender.values.firstWhere((e) => e.name == json['gender'])
          : null,
      datingIntention: json['dating_intention'] != null
          ? DatingIntention.values.firstWhere(
              (e) => e.name == json['dating_intention'],
            )
          : null,
      height: json['height'],
      ethnicity: json['ethnicity'] != null
          ? Ethnicity.values.firstWhere((e) => e.name == json['ethnicity'])
          : null,
      childrenCount: json['children_count'] != null
          ? ChildrenCount.values.firstWhere(
              (e) => e.name == json['children_count'],
            )
          : null,
      religion: json['religion'] != null
          ? Religion.values.firstWhere((e) => e.name == json['religion'])
          : null,
      drinkingHabit: json['drinking_habit'] != null
          ? DrinkingHabit.values.firstWhere(
              (e) => e.name == json['drinking_habit'],
            )
          : null,
      smokingHabit: json['smoking_habit'] != null
          ? SmokingHabit.values.firstWhere(
              (e) => e.name == json['smoking_habit'],
            )
          : null,
    );
  }

  ProfileCompletionData copyWith({
    Gender? gender,
    DatingIntention? datingIntention,
    int? height,
    Ethnicity? ethnicity,
    ChildrenCount? childrenCount,
    Religion? religion,
    DrinkingHabit? drinkingHabit,
    SmokingHabit? smokingHabit,
  }) {
    return ProfileCompletionData(
      gender: gender ?? this.gender,
      datingIntention: datingIntention ?? this.datingIntention,
      height: height ?? this.height,
      ethnicity: ethnicity ?? this.ethnicity,
      childrenCount: childrenCount ?? this.childrenCount,
      religion: religion ?? this.religion,
      drinkingHabit: drinkingHabit ?? this.drinkingHabit,
      smokingHabit: smokingHabit ?? this.smokingHabit,
    );
  }
}
