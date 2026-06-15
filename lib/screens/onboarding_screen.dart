import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/program_generator.dart';
import '../services/database_service.dart';
import 'program_preview_screen.dart';

class BodyTypeIllustration extends StatelessWidget {
  final String bodyType;
  final bool isSelected;

  const BodyTypeIllustration({required this.bodyType, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 100),
      painter: BodyTypePainter(bodyType: bodyType, isSelected: isSelected),
    );
  }
}

class BodyTypePainter extends CustomPainter {
  final String bodyType;
  final bool isSelected;

  BodyTypePainter({required this.bodyType, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isSelected ? Colors.white : const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    const double headRadius = 10;

    // Head
    canvas.drawCircle(Offset(centerX, 15), headRadius, paint);

    // Body based on type
    final Path path = Path();
    if (bodyType == 'Ectomorph') {
      // Slim build
      path.moveTo(centerX - 8, 30);
      path.lineTo(centerX + 8, 30);
      path.lineTo(centerX + 6, 70);
      path.lineTo(centerX - 6, 70);
      path.close();
    } else if (bodyType == 'Mesomorph') {
      // Broad shoulders, V-taper
      path.moveTo(centerX - 15, 30);
      path.lineTo(centerX + 15, 30);
      path.lineTo(centerX + 8, 70);
      path.lineTo(centerX - 8, 70);
      path.close();
    } else if (bodyType == 'Endomorph') {
      // Wider build
      path.moveTo(centerX - 12, 30);
      path.lineTo(centerX + 12, 30);
      path.quadraticBezierTo(centerX + 18, 50, centerX + 12, 70);
      path.lineTo(centerX - 12, 70);
      path.quadraticBezierTo(centerX - 18, 50, centerX - 12, 30);
      path.close();
    } else {
      // Average
      path.moveTo(centerX - 10, 30);
      path.lineTo(centerX + 10, 30);
      path.lineTo(centerX + 9, 70);
      path.lineTo(centerX - 10, 70);
      path.close();
    }
    canvas.drawPath(path, paint);

    // Arms
    canvas.drawRect(Rect.fromLTWH(centerX - 18, 30, 4, 30), paint);
    canvas.drawRect(Rect.fromLTWH(centerX + 14, 30, 4, 30), paint);

    // Legs
    canvas.drawRect(Rect.fromLTWH(centerX - 7, 70, 6, 30), paint);
    canvas.drawRect(Rect.fromLTWH(centerX + 1, 70, 6, 30), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6;
  bool _isLoading = false;

  final TextEditingController _heightController = TextEditingController(text: '170');
  final TextEditingController _weightController = TextEditingController(text: '70');
  String _selectedLanguage = 'English';
  String _bodyType = 'Average';
  String _goal = 'Muscle Gain';
  int _sessions = 3;

  final Map<String, Map<String, String>> _translations = {
    'English': {
      'welcome': 'Welcome to this app',
      'choose_language': 'Please choose your language',
      'intro_text': 'Answer these questions to get your personalized plan',
      'intro_subtext': 'We will use your answers to tailor the exercises, intensity, and schedule specifically for you.',
      'height': 'Height',
      'weight': 'Weight',
      'body_type': 'Body Type',
      'body_type_sub': 'Select the body type that best describes you',
      'goal': 'Fitness Goal',
      'goal_sub': 'What\'s your primary fitness objective?',
      'sessions': 'Weekly Sessions',
      'sessions_sub': 'How many days per week can you work out?',
      'sessions_unit': 'sessions per week',
      'sessions_tip': 'For best results, we recommend 3-5 sessions per week with proper rest days.',
      'continue': 'Continue',
      'back': 'Back',
      'generate': 'Generate Program',
      'loading': 'Generating your personalized plan...',
      'ectomorph': 'Ectomorph',
      'mesomorph': 'Mesomorph',
      'endomorph': 'Endomorph',
      'average': 'Average',
      'muscle_gain': 'Muscle Gain',
      'fat_loss': 'Fat Loss',
      'strength': 'Strength',
      'endurance': 'Endurance',
    },
    'Arabic': {
      'welcome': 'مرحباً بك في هذا التطبيق',
      'choose_language': 'الرجاء اختيار لغتك',
      'intro_text': 'أجب على هذه الأسئلة للحصول على خطتك المخصصة',
      'intro_subtext': 'سنستخدم إجاباتك لتفصيل التمارين والكثافة والجدول الزمني خصيصاً لك.',
      'height': 'الطول',
      'weight': 'الوزن',
      'body_type': 'نوع الجسم',
      'body_type_sub': 'اختر نوع الجسم الذي يصفك بشكل أفضل',
      'goal': 'هدف اللياقة',
      'goal_sub': 'ما هو هدفك الأساسي من اللياقة البدنية؟',
      'sessions': 'الجلسات الأسبوعية',
      'sessions_sub': 'كم يوماً في الأسبوع يمكنك التمرين؟',
      'sessions_unit': 'جلسات في الأسبوع',
      'sessions_tip': 'للحصول على أفضل النتائج، نوصي بـ 3-5 جلسات أسبوعياً مع أيام راحة مناسبة.',
      'continue': 'متابعة',
      'back': 'رجوع',
      'generate': 'إنشاء البرنامج',
      'loading': 'جاري إنشاء خطتك المخصصة...',
      'ectomorph': 'إكتومورف',
      'mesomorph': 'ميزومورف',
      'endomorph': 'إندومورف',
      'average': 'عادي',
      'muscle_gain': 'زيادة العضلات',
      'fat_loss': 'خسارة الدهون',
      'strength': 'القوة',
      'endurance': 'التحمل',
    },
    'French': {
      'welcome': 'Bienvenue sur cette application',
      'choose_language': 'Veuillez choisir votre langue',
      'intro_text': 'Répondez à ces questions pour obtenir votre plan personnalisé',
      'intro_subtext': 'Nous utiliserons vos réponses pour adapter les exercices, l\'intensité et le calendrier spécifiquement pour vous.',
      'height': 'Taille',
      'weight': 'Poids',
      'body_type': 'Type de corps',
      'body_type_sub': 'Sélectionnez le type de corps qui vous décrit le mieux',
      'goal': 'Objectif de fitness',
      'goal_sub': 'Quel est votre principal objectif de fitness ?',
      'sessions': 'Sessions hebdomadaires',
      'sessions_sub': 'Combien de jours par semaine pouvez-vous vous entraîner ?',
      'sessions_unit': 'sessions par semaine',
      'sessions_tip': 'Pour de meilleurs résultats, nous recommandons 3 à 5 sessions par semaine avec des jours de repos appropriés.',
      'continue': 'Continuer',
      'back': 'Retour',
      'generate': 'Générer le programme',
      'loading': 'Génération de votre plan personnalisé...',
      'ectomorph': 'Ectomorphe',
      'mesomorph': 'Mésomorphe',
      'endomorph': 'Endomorphe',
      'average': 'Moyen',
      'muscle_gain': 'Prise de muscle',
      'fat_loss': 'Perte de gras',
      'strength': 'Force',
      'endurance': 'Endurance',
    },
  };

  String _t(String key) => _translations[_selectedLanguage]?[key] ?? key;

  TextDirection get _textDirection => _selectedLanguage == 'Arabic' ? TextDirection.rtl : TextDirection.ltr;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Traininy'),
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildWelcomePage(),
                      _buildIntroPage(),
                      _buildHeightWeightPage(),
                      _buildBodyTypePage(),
                      _buildGoalPage(),
                      _buildSessionsPage(),
                    ],
                  ),
                ),
                _buildBottomNavigation(),
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _t('loading'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center,
            size: 100,
            color: Color(0xFF1565C0),
          ),
          const SizedBox(height: 32),
          Text(
            _t('welcome'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _t('choose_language'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageCard('English', 'English'),
              _buildLanguageCard('Arabic', 'العربية'),
              _buildLanguageCard('French', 'Français'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(String language, String label) {
    bool isSelected = _selectedLanguage == language;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF1565C0).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1565C0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIntroPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_ind,
              size: 100,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            _t('intro_text'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _t('intro_subtext'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('height') + ' & ' + _t('weight'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 32),
            _buildCardField(
              label: _t('height') + ' (cm)',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.height, color: Color(0xFF1565C0)),
                      const SizedBox(width: 12),
                      Text(
                        '${double.tryParse(_heightController.text)?.toInt() ?? 170} cm',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: double.tryParse(_heightController.text) ?? 170,
                    min: 120,
                    max: 220,
                    divisions: 100,
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (val) {
                      setState(() {
                        _heightController.text = val.toInt().toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCardField(
              label: _t('weight') + ' (kg)',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monitor_weight, color: Color(0xFF1565C0)),
                      const SizedBox(width: 12),
                      Text(
                        '${double.tryParse(_weightController.text)?.toInt() ?? 70} kg',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: double.tryParse(_weightController.text) ?? 70,
                    min: 40,
                    max: 150,
                    divisions: 110,
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (val) {
                      setState(() {
                        _weightController.text = val.toInt().toString();
                      });
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

  Widget _buildBodyTypePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('body_type'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _t('body_type_sub'),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildSelectionCard(
                  title: 'Ectomorph',
                  label: _t('ectomorph'),
                  illustration: 'Ectomorph',
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Ectomorph'),
                ),
                _buildSelectionCard(
                  title: 'Mesomorph',
                  label: _t('mesomorph'),
                  illustration: 'Mesomorph',
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Mesomorph'),
                ),
                _buildSelectionCard(
                  title: 'Endomorph',
                  label: _t('endomorph'),
                  illustration: 'Endomorph',
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Endomorph'),
                ),
                _buildSelectionCard(
                  title: 'Average',
                  label: _t('average'),
                  illustration: 'Average',
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Average'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('goal'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _t('goal_sub'),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildSelectionCard(
                  title: 'Muscle Gain',
                  label: _t('muscle_gain'),
                  icon: Icons.fitness_center,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Muscle Gain'),
                ),
                _buildSelectionCard(
                  title: 'Fat Loss',
                  label: _t('fat_loss'),
                  icon: Icons.trending_down,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Fat Loss'),
                ),
                _buildSelectionCard(
                  title: 'Strength',
                  label: _t('strength'),
                  icon: Icons.bolt,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Strength'),
                ),
                _buildSelectionCard(
                  title: 'Endurance',
                  label: _t('endurance'),
                  icon: Icons.timer,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Endurance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('sessions'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _t('sessions_sub'),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$_sessions ' + _t('sessions_unit'),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: _sessions.toDouble(),
                  min: 1,
                  max: 7,
                  activeColor: const Color(0xFF1565C0),
                  inactiveColor: Colors.grey[300],
                  divisions: 6,
                  label: '$_sessions sessions',
                  onChanged: (val) {
                    setState(() {
                      _sessions = val.toInt();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1', style: TextStyle(color: Colors.grey[600])),
                    Text('3', style: TextStyle(color: Colors.grey[600])),
                    Text('5', style: TextStyle(color: Colors.grey[600])),
                    Text('7', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _t('sessions_tip'),
                    style: const TextStyle(fontSize: 14, color: Color(0xFFE65100)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    String? label,
    IconData? icon,
    String? illustration,
    required String currentValue,
    required VoidCallback onTap,
  }) {
    bool isSelected = currentValue == title;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? const Color(0xFF1565C0) : Colors.white,
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (illustration != null)
              BodyTypeIllustration(bodyType: illustration, isSelected: isSelected)
            else if (icon != null)
              Icon(
                icon,
                size: 48,
                color: isSelected ? Colors.white : const Color(0xFF1565C0),
              ),
            const SizedBox(height: 12),
            Text(
              label ?? title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardField({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFF1565C0)),
                ),
                child: Text(
                  _t('back'),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF1565C0)),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage == _totalPages - 1 ? _t('generate') : _t('continue'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage == 2) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 5));

    double height = double.tryParse(_heightController.text) ?? 170;
    double weight = double.tryParse(_weightController.text) ?? 70;

    User user = User(
      height: height,
      weight: weight,
      bodyType: _bodyType,
      goal: _goal,
      sessionsPerWeek: _sessions,
    );

    try {
      await DatabaseService().saveUser(user);
      List<WorkoutDay> program = ProgramGenerator.generateProgram(user);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProgramPreviewScreen(program: program),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating program: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
