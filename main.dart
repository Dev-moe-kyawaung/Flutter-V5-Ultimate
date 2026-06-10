// main.dart - Flutter V5 Ultimate - Quantum Edition
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize all systems
  await _initializeAllSystems();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(
    ProviderScope(
      child: const UltimatePortfolioV5(),
    ),
  );
}

Future<void> _initializeAllSystems() async {
  // Initialize storage
  await SharedPreferences.getInstance();
  
  // Initialize AI system
  await AINeuralSystem.initialize();
  
  // Initialize quantum performance
  await QuantumPerformance.initialize();
  
  debugPrint('✅ All V5 Systems Initialized');
}

// ============================================================================
// AI NEURAL SYSTEM
// ============================================================================
class AINeuralSystem {
  static Map<String, double> _userPreferences = {};
  static Map<String, int> _behaviorPatterns = {};
  
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _userPreferences = {
      'theme': prefs.getDouble('theme') ?? 0.5,
      'speed': prefs.getDouble('speed') ?? 0.5,
      'animations': prefs.getDouble('animations') ?? 0.5,
    };
    debugPrint('✅ AI Neural System Initialized');
  }
  
  static void learn(String pattern, int value) {
    _behaviorPatterns[pattern] = (_behaviorPatterns[pattern] ?? 0) + value;
  }
  
  static double getPreference(String key) {
    return _userPreferences[key] ?? 0.5;
  }
  
  static void updatePreference(String key, double value) {
    _userPreferences[key] = value;
    final prefs = SharedPreferences.getInstance();
    prefs.then((p) => p.setDouble(key, value));
  }
  
  static String predictNextAction() {
    if (_behaviorPatterns['scroll'] > 10) return 'navigate';
    if (_behaviorPatterns['click'] > 5) return 'explore';
    return 'view';
  }
}

// ============================================================================
// QUANTUM PERFORMANCE SYSTEM
// ============================================================================
class QuantumPerformance {
  static int _frameCount = 0;
  static DateTime _lastFrame = DateTime.now();
  static double _fps = 60.0;
  
  static Future<void> initialize() async {
    debugPrint('✅ Quantum Performance System Initialized');
  }
  
  static void trackFrame() {
    _frameCount++;
    final now = DateTime.now();
    final diff = now.difference(_lastFrame).inMilliseconds;
    
    if (diff > 100) {
      _fps = 1000.0 / diff;
      _lastFrame = now;
    }
  }
  
  static double getFPS() => _fps;
  static int getFrameCount() => _frameCount;
}

// ============================================================================
// THEME STATE
// ============================================================================
class ThemeState extends ChangeNotifier {
  bool _isDark = true;
  String _theme = 'quantum'; // quantum, neon, coral, minimal, cyber
  double _brightness = 1.0;
  bool _showAnimations = true;
  
  bool get isDark => _isDark;
  String get theme => _theme;
  double get brightness => _brightness;
  bool get showAnimations => _showAnimations;
  
  void toggleTheme() {
    _isDark = !_isDark;
    AINeuralSystem.updatePreference('theme', _isDark ? 0.0 : 1.0);
    notifyListeners();
  }
  
  void setTheme(String theme) {
    _theme = theme;
    AINeuralSystem.updatePreference('theme_speed', _theme == 'quantum' ? 1.0 : 0.5);
    notifyListeners();
  }
  
  void toggleBrightness() {
    _brightness = _brightness == 1.0 ? 0.7 : 1.0;
    notifyListeners();
  }
  
  void toggleAnimations() {
    _showAnimations = !_showAnimations;
    AINeuralSystem.updatePreference('animations', _showAnimations ? 1.0 : 0.0);
    notifyListeners();
  }
  
  ThemeData getTheme() {
    ColorScheme scheme;
    
    switch (_theme) {
      case 'quantum':
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: _isDark ? Brightness.dark : Brightness.light,
        );
      case 'neon':
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FF88),
          brightness: Brightness.dark,
        );
      case 'coral':
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: _isDark ? Brightness.dark : Brightness.light,
        );
      case 'minimal':
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C2C2C),
          brightness: Brightness.light,
        );
      case 'cyber':
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4FF),
          brightness: Brightness.dark,
        );
      default:
        scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: _isDark ? Brightness.dark : Brightness.light,
        );
    }
    
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: 'Inter',
      brightness: _isDark ? Brightness.dark : Brightness.light,
    );
  }
}

// ============================================================================
// MAIN APP
// ============================================================================
class UltimatePortfolioV5 extends StatelessWidget {
  const UltimatePortfolioV5({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeState(),
      child: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return MaterialApp(
            title: 'Moe Kyaw Aung | Ultimate V5',
            debugShowCheckedModeBanner: false,
            theme: themeState.getTheme(),
            darkTheme: themeState.getTheme(),
            themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            home: UltimateHomeV5(
              themeState: themeState,
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// HOME PAGE
// ============================================================================
class UltimateHomeV5 extends StatefulWidget {
  final ThemeState themeState;

  const UltimateHomeV5({
    super.key,
    required this.themeState,
  });

  @override
  State<UltimateHomeV5> createState() => _UltimateHomeV5State();
}

class _UltimateHomeV5State extends State<UltimateHomeV5> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  final PageController _pageController = PageController();
  bool _isLoading = true;
  bool _showInstallPrompt = true;
  bool _isInstalled = false;
  double _scrollProgress = 0;
  int _currentSection = 0;
  final List<String> _sections = [
    'hero', 'ai-insights', 'overview', 'skills', 'projects', 
    'featured', 'experience', 'certs', 'contact', 'analytics'
  ];
  
  // Analytics
  Map<String, int> _sectionViews = {};
  DateTime _sessionStart = DateTime.now();
  int _totalScrolls = 0;
  int _totalClicks = 0;
  
  // Quantum effects
  bool _enableQuantum = true;
  double _quantumLevel = 0.5;
  
  @override
  void initState() {
    super.initState();
    _initializeSections();
    _loadPreferences();
    _startSessionTracking();
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _initializeSections() {
    for (final id in _sections) {
      _sectionKeys[id] = GlobalKey();
    }
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final hasInstalled = prefs.getBool('hasInstalled') ?? false;
    
    setState(() {
      _isInstalled = hasInstalled;
      _showInstallPrompt = !hasInstalled;
    });
  }

  void _startSessionTracking() {
    _sessionStart = DateTime.now();
    
    _scrollController.addListener(() {
      _totalScrolls++;
      _trackSectionVisibility();
      QuantumPerformance.trackFrame();
    });
  }

  void _trackSectionVisibility() {
    for (final id in _sections) {
      final key = _sectionKeys[id];
      if (key?.currentContext != null) {
        final renderBox = key!.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        
        if (position.dy < MediaQuery.of(context).size.height - 100) {
          _sectionViews[id] = (_sectionViews[id] ?? 0) + 1;
          AINeuralSystem.learn('scroll', 1);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    _saveAnalytics();
    super.dispose();
  }

  void _saveAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionDuration = DateTime.now().difference(_sessionStart).inSeconds;
    
    await prefs.setInt('v5_totalSessionDuration', 
      (prefs.getInt('v5_totalSessionDuration') ?? 0) + sessionDuration);
    await prefs.setInt('v5_totalScrolls', 
      (prefs.getInt('v5_totalScrolls') ?? 0) + _totalScrolls);
    await prefs.setInt('v5_totalClicks', 
      (prefs.getInt('v5_totalClicks') ?? 0) + _totalClicks);
    await prefs.setString('v5_lastSection', _sections[_currentSection]);
    
    debugPrint('📊 V5 Analytics Saved');
    debugPrint('  Session: ${sessionDuration}s');
    debugPrint('  Scrolls: $_totalScrolls');
    debugPrint('  Clicks: $_totalClicks');
  }

  @override
  Widget build(BuildContext context) {
    final themeState = widget.themeState;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Quantum Animated Background
        if (_enableQuantum) _buildQuantumBackground(colorScheme),
        
        // Neural Network Background
        _buildNeuralNetwork(colorScheme),
        
        // Install Prompt
        if (_showInstallPrompt && !_isLoading) 
          _buildInstallPrompt(colorScheme),
        
        // Loading Screen
        if (_isLoading) _buildLoadingScreen(colorScheme, themeState),
        
        // Main Content
        _buildMainContent(context, colorScheme, themeState),
        
        // Floating Quantum Controls
        _buildQuantumControls(colorScheme, themeState),
        
        // Performance Monitor
        _buildPerformanceMonitor(colorScheme),
        
        // AI Insights Panel
        _buildAIInsightsPanel(colorScheme),
        
        // Bottom Navigation
        _buildBottomNavigation(colorScheme),
        
        // Scroll Progress Circle
        _buildScrollProgressCircle(colorScheme),
      ],
    );
  }

  Widget _buildQuantumBackground(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        _scrollProgress = (_scrollController.offset / 10000).clamp(0.0, 1.0);
        _quantumLevel = 0.5 + (_scrollProgress * 0.5);
        
        return IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.background,
                  colorScheme.primary.withOpacity(0.15 * _quantumLevel),
                  colorScheme.secondary.withOpacity(0.1 * _quantumLevel),
                  colorScheme.background,
                ],
              ),
            ),
            child: CustomPaint(
              painter: QuantumNeuralPainter(
                color: colorScheme.primary.withOpacity(0.08),
                scrollProgress: _scrollProgress,
                quantumLevel: _quantumLevel,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNeuralNetwork(ColorScheme colorScheme) {
    return IgnorePointer(
      child: CustomPaint(
        painter: NeuralNetworkPainter(
          color: colorScheme.secondary.withOpacity(0.05),
          scrollProgress: _scrollProgress,
        ),
      ),
    );
  }

  Widget _buildInstallPrompt(ColorScheme colorScheme) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Animate(
        autoPlay: true,
        effects: [
          slideEffect(delay: 0.2s, duration: 0.6s, begin: const Offset(0, -1)),
          fadeEffect(delay: 0.2s, duration: 0.6s),
          scaleEffect(delay: 0.2s, duration: 0.6s, begin: 0.95, end: 1.0),
        ],
        child: GestureDetector(
          onTap: _handleInstall,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3DDC97),
                  const Color(0xFF4EF5A8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3DDC97).withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Install Ultimate V5',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'AI-powered portfolio with offline support & quantum performance',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(ColorScheme colorScheme, ThemeState themeState) {
    return Container(
      color: colorScheme.background,
      child: Stack(
        children: [
          // Quantum particles
          CustomPaint(
            painter: QuantumLoadingPainter(
              color: colorScheme.primary,
              quantumLevel: _quantumLevel,
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D Rotating Quantum Logo
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 360),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        .setEntry(3, 2, 0.001)
                        .rotateX(value * math.pi / 180)
                        .rotateY(value * math.pi / 180),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                              colorScheme.primary,
                            ],
                          ).createShader(const Rect.fromCircle(center: Offset.zero, radius: 80)),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.6),
                              blurRadius: 50,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.quantum_effects,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
                
                // Text
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        'ULTIMATE V5',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                          letterSpacing: 5,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 12),
                
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1400),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        'AI-Powered Quantum Portfolio',
                        style: TextStyle(
                          fontSize: 19,
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
                
                // Progress
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 2000),
                  builder: (context, value, child) {
                    return SizedBox(
                      width: 300,
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: colorScheme.surface.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 25),
                
                // Loading Status
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Column(
                        children: [
                          Text(
                            'Initializing AI Neural System...',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onBackground.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Quantum Performance: ${QuantumPerformance.getFPS().toStringAsFixed(1)} FPS',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ColorScheme colorScheme, ThemeState themeState) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // Hero Section
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['hero']!,
          delay: 0.0,
          child: _buildHeroSection(context, colorScheme, themeState),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // AI Insights
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['ai-insights']!,
          delay: 0.15,
          child: _buildAIInsightsSection(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Overview
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['overview']!,
          delay: 0.3,
          child: _buildOverviewSection(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Skills Matrix
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['skills']!,
          delay: 0.45,
          child: _buildSkillsMatrix(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Projects
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['projects']!,
          delay: 0.6,
          child: _buildProjectsGrid(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Featured
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['featured']!,
          delay: 0.75,
          child: _buildFeaturedProject(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Experience
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['experience']!,
          delay: 0.9,
          child: _buildExperienceTimeline(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Certifications
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['certs']!,
          delay: 1.05,
          child: _buildCertifications(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Contact
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['contact']!,
          delay: 1.2,
          child: _buildContactSection(context, colorScheme),
        ),
        
        _buildQuantumDivider(colorScheme),
        
        // Analytics
        _buildQuantumAnimatedSlideInSection(
          context,
          key: _sectionKeys['analytics']!,
          delay: 1.35,
          child: _buildAnalyticsSection(context, colorScheme),
        ),
        
        // Footer
        _buildFooter(context, colorScheme),
      ],
    );
  }

  Widget _buildQuantumAnimatedSlideInSection(
    BuildContext context, {
    required GlobalKey key,
    double delay = 0.0,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        final sectionContext = key.currentContext;
        if (sectionContext == null) return child;

        final renderBox = sectionContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final isVisible = position.dy < MediaQuery.of(context).size.height - 100;

        if (isVisible) {
          final currentIndex = _sections.indexWhere((id) => _sectionKeys[id] == key);
          if (currentIndex != -1) {
            _currentSection = currentIndex;
          }
        }

        return AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: (800 * (1 + delay)).round()),
          child: SlideTransition(
            position: TweenVector2(
              begin: const Vector2(0, 0.2),
              end: const Vector2(0, 0),
            ).animate(
              CurvedAnimation(
                parent: AlwaysStoppedAnimation(isVisible ? 1.0 : 0.0),
                curve: Curves.easeOutCubic,
              ),
            ),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.95, end: 1.0),
              duration: Duration(milliseconds: (600 * (1 + delay)).round()),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context, ColorScheme colorScheme, ThemeState themeState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 120, 24, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quantum Photo Effect
          Center(
            child: Hero(
              tag: 'profile-photo-v5',
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.6),
                          blurRadius: 60,
                          spreadRadius: 15,
                        ),
                        BoxShadow(
                          color: colorScheme.secondary.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://res.cloudinary.com/dye5qpwii/image/upload/v1778527878/IMG_20260430_053105_uef0yr.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Installed Badge
          if (_isInstalled)
            Animate(
              effects: [fadeEffect(), scaleEffect(begin: 0.9, end: 1.0)],
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF),
                        const Color(0xFF7C9CFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '✓ Installed as App',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Name
          Text(
            'မိုးကျော်အောင်
Moe Kyaw Aung',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: colorScheme.onBackground,
              letterSpacing: -2,
              height: 1.1,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Title with Quantum Effect
          Text(
            'Senior Android Developer',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              foreground: Paint()
                .shader = LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary, colorScheme.primary],
                  stops: const [0.0, 0.5, 1.0],
                )
                .createShader(const Rect.fromLTWH(0, 0, 400, 30)),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Location
          Text(
            '📍 Tachileik, Myanmar ↔ Bangkok, Thailand',
            style: TextStyle(
              fontSize: 17,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Summary
          Text(
            'Senior Android Engineer with 3+ years. Built 40+ production apps, 82+ certifications. Expert in Kotlin, Jetpack Compose, Firebase, CI/CD. AI-powered portfolio with quantum performance.',
            style: TextStyle(
              fontSize: 17,
              color: colorScheme.onBackground.withOpacity(0.85),
              height: 1.75,
            ),
          ),
          
          const SizedBox(height: 35),
          
          // Quantum Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuantumStatCard(context, '82+', 'Certifications', colorScheme, const Color(0xFF3DDC97)),
              _buildQuantumDividerVertical(colorScheme),
              _buildQuantumStatCard(context, '40+', 'Projects', colorScheme, const Color(0xFFFFB454)),
              _buildQuantumDividerVertical(colorScheme),
              _buildQuantumStatCard(context, '3+', 'Years', colorScheme, const Color(0xFF6C63FF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantumStatCard(
    BuildContext context,
    String number,
    String label,
    ColorScheme colorScheme,
    Color color,
  ) {
    return Column(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, child) {
            return Text(
              number,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -1,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantumDividerVertical(ColorScheme colorScheme) {
    return Container(
      width: 3,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.2),
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAIInsightsSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'AI Insights', 'Neural Analysis', colorScheme),
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pulse,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI-Powered Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                _buildAIInsightRow(context, 'Session Duration', '${DateTime.now().difference(_sessionStart).inSeconds}s', colorScheme),
                _buildAIInsightRow(context, 'Total Scrolls', '$_totalScrolls', colorScheme),
                _buildAIInsightRow(context, 'Total Clicks', '$_totalClicks', colorScheme),
                _buildAIInsightRow(context, 'Current Section', _sections[_currentSection], colorScheme),
                _buildAIInsightRow(context, 'Predicted Action', AINeuralSystem.predictNextAction(), colorScheme),
                _buildAIInsightRow(context, 'FPS', '${QuantumPerformance.getFPS().toStringAsFixed(1)}', colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightRow(
    BuildContext context,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ... Continue with all other sections (Overview, Skills, Projects, etc.)
  // Using same patterns as V4 but with quantum effects

  Widget _buildQuantumControls(ColorScheme colorScheme, ThemeState themeState) {
    return Positioned(
      top: 100,
      right: 20,
      child: Column(
        children: [
          // Theme Selector
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildQuantumThemeButton('Quantum', 'quantum', themeState, colorScheme),
                const SizedBox(height: 10),
                _buildQuantumThemeButton('Neon', 'neon', themeState, colorScheme),
                const SizedBox(height: 10),
                _buildQuantumThemeButton('Coral', 'coral', themeState, colorScheme),
                const SizedBox(height: 10),
                _buildQuantumThemeButton('Minimal', 'minimal', themeState, colorScheme),
                const SizedBox(height: 10),
                _buildQuantumThemeButton('Cyber', 'cyber', themeState, colorScheme),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Quantum Toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => _enableQuantum = !_enableQuantum);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _enableQuantum 
                    ? colorScheme.primary.withOpacity(0.2) 
                    : colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _enableQuantum ? colorScheme.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.quantum_effects,
                color: _enableQuantum ? colorScheme.primary : Colors.grey,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantumThemeButton(
    String label,
    String theme,
    ThemeState themeState,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        themeState.setTheme(theme);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: themeState.theme == theme 
              ? colorScheme.primary 
              : colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: themeState.theme == theme ? Colors.white : colorScheme.onBackground,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMonitor(ColorScheme colorScheme) {
    return Positioned(
      bottom: 100,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'FPS',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            Text(
              '${QuantumPerformance.getFPS().toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: QuantumPerformance.getFPS() > 55 
                    ? const Color(0xFF3DDC97) 
                    : const Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightsPanel(ColorScheme colorScheme) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.pulse,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'AI Active',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollProgressCircle(ColorScheme colorScheme) {
    return Positioned(
      top: 80,
      left: 20,
      child: Container(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            CustomPaint(
              painter: CircleProgressPainter(
                progress: _scrollProgress,
                color: colorScheme.primary,
              ),
            ),
            Center(
              child: Text(
                '${(_scrollProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(ColorScheme colorScheme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.98),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(context, 'Home', Icons.home, colorScheme, () => _scrollToSection('hero')),
            _buildNavButton(context, 'Apps', Icons.phone_android, colorScheme, () => _scrollToSection('projects')),
            _buildNavButton(context, 'AI', Icons.pulse, colorScheme, () => _scrollToSection('ai-insights')),
            _buildNavButton(context, 'Resume', Icons.download, colorScheme, () => _downloadResume()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String label,
    IconData icon,
    ColorScheme colorScheme,
    VoidCallback onTap,
  ) {
    final isSelected = label.toLowerCase() == _sections[_currentSection].replaceAll('-', '');
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? colorScheme.primary : colorScheme.onBackground.withOpacity(0.5),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? colorScheme.primary : colorScheme.onBackground.withOpacity(0.5),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _handleInstall() async {
    HapticFeedback.mediumImpact();
    _totalClicks++;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasInstalled', true);
    setState(() {
      _showInstallPrompt = false;
      _isInstalled = true;
    });
  }

  void _scrollToSection(String sectionId) {
    HapticFeedback.lightImpact();
    _totalClicks++;
    
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      final renderBox = key!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      _scrollController.animateTo(
        _scrollController.offset + position.dy - 100,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _downloadResume() async {
    HapticFeedback.lightImpact();
    _totalClicks++;
    
    final Uri url = Uri.parse('https://moekyawaung.github.io/resume.pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openGitHub() async {
    HapticFeedback.mediumImpact();
    _totalClicks++;
    
    final Uri url = Uri.parse('https://github.com/Dev-moe-kyawaung');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openLinkedIn() async {
    HapticFeedback.mediumImpact();
    _totalClicks++;
    
    final Uri url = Uri.parse('https://linkedin.com/in/moe-kyaw-aung-2653093a1');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _sendEmail() async {
    HapticFeedback.mediumImpact();
    _totalClicks++;
    
    final Uri emailUri = Uri.parse('mailto:moekyawaung@programmer.net');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String subtitle,
    String title,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: colorScheme.onBackground,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantumDivider(ColorScheme colorScheme) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 55),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              Colors.transparent,
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.primary,
              Colors.transparent,
            ],
          ).createShader(bounds);
        },
        child: Container(
          height: 3,
          color: Colors.white,
        ),
      ),
    );
  }

  // Footer, Overview, Skills, Projects, Featured, Experience, Certs, Contact
  // Use same patterns as V4 with quantum effects
}

// ============================================================================
// QUANTUM PAINTERS
// ============================================================================
class QuantumNeuralPainter extends CustomPainter {
  final Color color;
  final double scrollProgress;
  final double quantumLevel;

  QuantumNeuralPainter({
    required this.color,
    required this.scrollProgress,
    required this.quantumLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      .color = color
      .strokeWidth = 2
      .strokeCap = StrokeCap.round;

    // Draw neural network
    for (int i = 0; i < 30; i++) {
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final x1 = ((i * 70 + time * 10 * scrollProgress) % size.width);
      final y1 = ((i * 60 + sin(time + i) * 40) % size.height);
      
      paint.color = color.withOpacity(0.08 + quantumLevel * 0.12);
      canvas.drawCircle(Offset(x1, y1), 4 + quantumLevel * 3, paint);
      
      // Connect neurons
      for (int j = i + 1; j < 30 && j < i + 6; j++) {
        final x2 = ((j * 70 + time * 10 * scrollProgress) % size.width);
        final y2 = ((j * 60 + sin(time + j) * 40) % size.height);
        
        final distance = math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        if (distance < 150) {
          paint.color = color.withOpacity((1 - distance / 150) * 0.05 * quantumLevel);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeuralNetworkPainter extends CustomPainter {
  final Color color;
  final double scrollProgress;

  NeuralNetworkPainter({required this.color, required this.scrollProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      .color = color
      .strokeWidth = 1
      .strokeCap = StrokeCap.round;

    // Draw grid
    for (int i = 0; i < 30; i++) {
      final x = i * size.width / 30;
      paint.color = color.withOpacity(0.02 + scrollProgress * 0.04);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i < 30; i++) {
      final y = i * size.height / 30;
      paint.color = color.withOpacity(0.02 + scrollProgress * 0.04);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class QuantumLoadingPainter extends CustomPainter {
  final Color color;
  final double quantumLevel;

  QuantumLoadingPainter({required this.color, required this.quantumLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      .color = color
      .strokeWidth = 3
      .strokeCap = StrokeCap.round;

    // Draw quantum particles
    for (int i = 0; i < 40; i++) {
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final angle = (time + i * 0.5) * quantumLevel;
      final radius = 60 + sin(time * 2 + i) * 20 * quantumLevel;
      
      final x = size.width / 2 + cos(angle) * radius;
      final y = size.height / 2 + sin(angle) * radius;
      
      paint.color = color.withOpacity(0.3 + quantumLevel * 0.5);
      canvas.drawCircle(Offset(x, y), 3 + quantumLevel * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      .color = color
      .strokeWidth = 6
      .strokeCap = StrokeCap.round
      .style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2 - 3),
      -math.pi / 2,
      2 * math.pi * progress,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double sin(double x) => math.sin(x);
double cos(double x) => math.cos(x);
