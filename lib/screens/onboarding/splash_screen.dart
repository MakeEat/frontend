import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/signup_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFFAF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            // Centered Logo and Text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(14),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1A4D2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Hero(
                      tag: 'app_logo',
                      child: Image.asset('assets/images/makeeat_logo.png'),
                    ),
                  )
                  .animate(
                    autoPlay: true,
                    onComplete: (controller) {
                      controller.forward(from: 0);
                    },
                  )
                  .custom(
                    duration: 1800.ms,
                    builder: (context, value, child) => ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment(-1.0 + (2.0 * value), 0.0),
                        end: Alignment(-0.2 + (2.0 * value), 0.0),
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds),
                      blendMode: BlendMode.srcATop,
                      child: child,
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  const Text(
                    'MakeEat',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 28,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Get Started Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => 
                        const SignupScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48600),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Login Text
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already a member? ',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 