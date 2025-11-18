// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Tutor';

  @override
  String get welcome => 'Welcome';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get onboardingWelcomeTitle => 'Welcome to AI Tutor!';

  @override
  String get onboardingWelcomeSubtitle =>
      'Your personalized learning companion';

  @override
  String get onboardingWelcomeDescription =>
      'Learn through your interests with AI-powered tutoring';

  @override
  String get yourInterests => 'Your Interests';

  @override
  String get selectInterestsPrompt => 'What are you interested in?';

  @override
  String get selectInterestsDescription =>
      'We\'ll use these to make learning fun and relatable!\nSelect 1-5 interests.';

  @override
  String interestsSelected(int count, int max) {
    return '$count/$max selected';
  }

  @override
  String get addYourOwnInterest => 'Add Your Own Interest';

  @override
  String get selectAtLeastOneInterest => 'Please select at least 1 interest';

  @override
  String maxInterestsReached(int max) {
    return 'You can select up to $max interests';
  }

  @override
  String get addCustomInterestTitle => 'Add Your Own Interest';

  @override
  String get chooseEmoji => 'Choose an emoji';

  @override
  String get interestName => 'Interest name';

  @override
  String get interestNameHint => 'e.g., LEGO, Dinosaurs, Dancing';

  @override
  String get keywordsForAI => 'Keywords (for AI personalization)';

  @override
  String get keywordsSeparator => 'Separate with commas or spaces';

  @override
  String get keywordsHint => 'e.g., blocks, build, bricks, pieces';

  @override
  String get keywordsInfo =>
      'AI will use these keywords to create personalized examples in all lessons!';

  @override
  String get enterInterestName => 'Please enter a name for your interest';

  @override
  String get enterKeywords => 'Please enter at least one keyword';

  @override
  String get enterValidKeywords => 'Please enter valid keywords';

  @override
  String get addInterest => 'Add Interest';

  @override
  String get culturalTheme => 'Cultural Theme';

  @override
  String get chooseCulturalTheme => 'Choose Your Style';

  @override
  String get culturalThemeDescription => 'Pick a theme that resonates with you';

  @override
  String get learningStyle => 'Learning Style';

  @override
  String get chooseLearningStyle => 'How do you learn best?';

  @override
  String get learningStyleDescription =>
      'Choose your preferred teaching approach';

  @override
  String get levelAssessment => 'Level Assessment';

  @override
  String get setYourLevel => 'Set your grade level for each subject';

  @override
  String gradeLevel(int level) {
    return 'Grade $level';
  }

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get practice => 'Practice';

  @override
  String get progress => 'Progress';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get todaysChallenge => 'Today\'s Challenge';

  @override
  String get completedChallenges => 'Completed';

  @override
  String get activeGoals => 'Active Goals';

  @override
  String get viewAll => 'View All';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get startPractice => 'Practice';

  @override
  String get challenges => 'Challenges';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get aiTutor => 'AI Tutor';

  @override
  String get askQuestion => 'Ask a question...';

  @override
  String get typeMessage => 'Type your message...';

  @override
  String get send => 'Send';

  @override
  String get practiceMode => 'Practice Mode';

  @override
  String get selectDifficulty => 'Select Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get generateProblems => 'Generate Problems';

  @override
  String get checkAnswer => 'Check Answer';

  @override
  String get nextProblem => 'Next Problem';

  @override
  String get showHint => 'Show Hint';

  @override
  String get showSolution => 'Show Solution';

  @override
  String get correct => 'Correct';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get totalProblems => 'Total Problems';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get studyTime => 'Study Time';

  @override
  String get achievements => 'Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get locked => 'Locked';

  @override
  String get challengesAndGoals => 'Challenges & Goals';

  @override
  String get createNewGoal => 'Create New Goal';

  @override
  String get goalType => 'Goal Type';

  @override
  String get targetValue => 'Target Value';

  @override
  String get deadline => 'Deadline';

  @override
  String get problemsSolved => 'Problems Solved';

  @override
  String get accuracyTarget => 'Accuracy Target';

  @override
  String get streakGoal => 'Streak Goal';

  @override
  String get studyTimeGoal => 'Study Time';

  @override
  String get topicMastery => 'Topic Mastery';

  @override
  String get weeklyReportTitle => 'Weekly Report';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get problemsPerDay => 'Problems per Day';

  @override
  String get averageAccuracy => 'Average Accuracy';

  @override
  String get totalStudyTime => 'Total Study Time';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String hours(int count) {
    return '$count hrs';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editInterests => 'Edit Interests';

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get changeLearningStyle => 'Change Learning Style';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get dailyReminders => 'Daily Reminders';

  @override
  String get streakReminders => 'Streak Reminders';

  @override
  String get achievementAlerts => 'Achievement Alerts';

  @override
  String get progressAndGoals => 'Progress & Goals';

  @override
  String get viewGoals => 'View Goals';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get resetProgressWarning =>
      'This will delete all your progress. Are you sure?';

  @override
  String get data => 'Data';

  @override
  String get shareProgress => 'Share Progress';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataComingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get feedback => 'Send Feedback';

  @override
  String get rateApp => 'Rate App';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get subjects => 'Subjects';

  @override
  String get mathematics => 'Mathematics';

  @override
  String get physics => 'Physics';

  @override
  String get chemistry => 'Chemistry';

  @override
  String get programming => 'Programming';

  @override
  String get biology => 'Biology';

  @override
  String get englishSubject => 'English';

  @override
  String get interests => 'Interests';

  @override
  String get gaming => 'Gaming';

  @override
  String get sports => 'Sports';

  @override
  String get spaceAstronomy => 'Space & Astronomy';

  @override
  String get animalsNature => 'Animals & Nature';

  @override
  String get music => 'Music';

  @override
  String get artDrawing => 'Art & Drawing';

  @override
  String get coding => 'Programming';

  @override
  String get moviesTV => 'Movies & TV';

  @override
  String get booksReading => 'Books & Reading';

  @override
  String get cookingFood => 'Cooking & Food';

  @override
  String get themes => 'Themes';

  @override
  String get classic => 'Classic';

  @override
  String get japanese => 'Japanese';

  @override
  String get eastern => 'Eastern';

  @override
  String get cyberpunk => 'Cyberpunk';

  @override
  String get scandinavian => 'Scandinavian';

  @override
  String get vibrant => 'Vibrant';

  @override
  String get african => 'African';

  @override
  String get latinAmerican => 'Latin American';

  @override
  String get learningStyles => 'Learning Styles';

  @override
  String get visual => 'Visual (Charts & Diagrams)';

  @override
  String get practical => 'Practical (Examples & Practice)';

  @override
  String get theoretical => 'Theoretical (Detailed Explanations)';

  @override
  String get balanced => 'Balanced (Mix of Everything)';

  @override
  String get quick => 'Quick (Fast & Concise)';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get achievementMathWizard => 'Math Wizard';

  @override
  String get achievementScholar => 'Scholar';

  @override
  String get achievementEinstein => 'Einstein';

  @override
  String get achievementOnFire => 'On Fire';

  @override
  String get achievementUnstoppable => 'Unstoppable';

  @override
  String get achievementDiamondStreak => 'Diamond Streak';

  @override
  String get achievementPerfectionist => 'Perfectionist';

  @override
  String get achievementAceStudent => 'Ace Student';

  @override
  String get achievementSpeedDemon => 'Speed Demon';

  @override
  String get achievementBookworm => 'Bookworm';

  @override
  String get achievementRisingStar => 'Rising Star';

  @override
  String get achievementMasterLearner => 'Master Learner';

  @override
  String shareProgressText(int problems, int accuracy, int streak) {
    return '🎓 My AI Tutor Progress\n📊 Problems Solved: $problems\n✅ Accuracy: $accuracy%\n🔥 Streak: $streak days';
  }

  @override
  String get brainTraining => 'Brain Training';

  @override
  String get stroopTest => 'Stroop Test';

  @override
  String get memoryCards => 'Memory Cards';

  @override
  String get speedReading => 'Speed Reading';

  @override
  String get shapeCounter => 'Shape Counter';

  @override
  String get numberSequences => 'Number Sequences';

  @override
  String get nBackTest => 'N-Back Test';

  @override
  String get quickMath => 'Quick Math';

  @override
  String get spotTheDifference => 'Spot the Difference';

  @override
  String get overallStats => 'Overall Stats';

  @override
  String get exercises => 'Exercises';

  @override
  String get played => 'Played';

  @override
  String get best => 'Best';

  @override
  String get newExercise => 'New!';

  @override
  String get efficiency => 'Efficiency';

  @override
  String get moves => 'Moves';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get friends => 'Friends';

  @override
  String get analytics => 'Analytics';

  @override
  String get premium => 'Premium';

  @override
  String get transformProblem => 'Make it Fun ✨';

  @override
  String get transforming => 'Transforming...';

  @override
  String transformed(String interest) {
    return 'Transformed: $interest';
  }

  @override
  String get original => 'Original';

  @override
  String get errorTransforming => 'Error transforming problem';
}
