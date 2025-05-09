// splash_screen_with_particles.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _orangePathAnimation;
  late Animation<double> _bluePathAnimation;
  
  // Generate random particles
  final List<Particle> _particles = List.generate(
    20, 
    (index) => Particle.random(),
  );

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Pulse animation controller (continuous)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
    // Scale animation for the logo
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    // Fade animation for the logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    
    // Fade animation for the text
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
    
    // Pulse animation for the heart
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Animation for drawing the orange path
    _orangePathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
      ),
    );
    
    // Animation for drawing the blue path
    _bluePathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );
    
    // Start the animation
    _mainController.forward();
    
    // Navigate to the next screen after animation completes
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pushReplacementNamed(context, '/onboarding');
        });
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _pulseController, _particleController]),
          builder: (context, child) {
            return Stack(
              children: [
                // Particles
                if (_fadeAnimation.value > 0.5)
                  ...List.generate(_particles.length, (index) {
                    final particle = _particles[index];
                    final progress = (_particleController.value + particle.offset) % 1.0;
                    
                    // Calculate position based on progress
                    final x = MediaQuery.of(context).size.width / 2 + 
                              math.cos(particle.angle) * 150 * progress;
                    final y = MediaQuery.of(context).size.height / 2 + 
                              math.sin(particle.angle) * 150 * progress;
                    
                    return Positioned(
                      left: x - particle.size / 2,
                      top: y - particle.size / 2,
                      child: Opacity(
                        opacity: (1 - progress) * 0.7,
                        child: Container(
                          width: particle.size,
                          height: particle.size,
                          decoration: BoxDecoration(
                            color: particle.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                
                // Logo and Text
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value * _pulseAnimation.value,
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CustomPaint(
                              painter: AnimatedHeartLogoPainter(
                                orangeProgress: _orangePathAnimation.value,
                                blueProgress: _bluePathAnimation.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animated Text with sliding effect
                      Transform.translate(
                        offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: const Text(
                            "Teman Tumbuh",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Particle class for the floating particles
class Particle {
  final double size;
  final Color color;
  final double angle;
  final double offset;
  
  Particle({
    required this.size,
    required this.color,
    required this.angle,
    required this.offset,
  });
  
  factory Particle.random() {
    final random = math.Random();
    
    // Randomly choose between orange and blue colors
    final color = random.nextBool() 
      ? Colors.orange.withOpacity(0.8)
      : Colors.blue.withOpacity(0.8);
    
    return Particle(
      size: random.nextDouble() * 6 + 2, // Size between 2-8
      color: color,
      angle: random.nextDouble() * 2 * math.pi, // Random angle
      offset: random.nextDouble(), // Random offset for animation
    );
  }
}

// Custom painter for the animated heart logo
class AnimatedHeartLogoPainter extends CustomPainter {
  final double orangeProgress;
  final double blueProgress;
  
  AnimatedHeartLogoPainter({
    required this.orangeProgress,
    required this.blueProgress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final orangePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
      
    final bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw the orange part of the heart (top-right curve)
    if (orangeProgress > 0) {
      final orangePath = Path();
      orangePath.moveTo(center.dx, center.dy - radius * 0.2);
      
      // Calculate the end point based on progress
      final endPoint = Offset(
        center.dx + radius * 0.5 * orangeProgress,
        center.dy - radius * 0.2 + radius * 0.7 * orangeProgress,
      );
      
      // Calculate the control point based on progress
      final controlPoint = Offset(
        center.dx + radius * 1.0 * orangeProgress,
        center.dy - radius * 1.2 * orangeProgress,
      );
      
      orangePath.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy,
      );
      
      canvas.drawPath(orangePath, orangePaint);
    }
    
    // Draw the blue part of the heart (bottom-left curve)
    if (blueProgress > 0) {
      final bluePath = Path();
      bluePath.moveTo(center.dx, center.dy - radius * 0.2);
      
      // Calculate the end point based on progress
      final endPoint = Offset(
        center.dx - radius * 0.5 * blueProgress,
        center.dy - radius * 0.2 + radius * 0.7 * blueProgress,
      );
      
      // Calculate the control point based on progress
      final controlPoint = Offset(
        center.dx - radius * 1.0 * blueProgress,
        center.dy - radius * 1.2 * blueProgress,
      );
      
      bluePath.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy,
      );
      
      canvas.drawPath(bluePath, bluePaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedHeartLogoPainter oldDelegate) {
    return oldDelegate.orangeProgress != orangeProgress || 
           oldDelegate.blueProgress != blueProgress;
  }
}