import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/theme.dart';
import 'login_screen.dart';
import '../onboarding/splash_screen.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import 'package:provider/provider.dart';
import '../onboarding/welcome_slides.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Back Arrow with Circle Background
              Positioned(
                top: 80,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                          const SplashScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeOutQuint;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          
                          // Fade transition combined with slide
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 700),
                        reverseTransitionDuration: const Duration(milliseconds: 700),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF1A4D2E),
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Main Content
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16, 
                  MediaQuery.of(context).size.height * 0.12,
                  16,
                  16
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 54),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 28,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.60,
                        ),
                      ),

                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputField(
                              'Full Name',
                              _nameController,
                              error: _nameError,
                            ),
                            const SizedBox(height: 14),
                            _buildInputField(
                              'Email Address',
                              _emailController,
                              error: _emailError,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
                            _buildInputField(
                              'Password',
                              _passwordController,
                              error: _passwordError,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onTogglePassword: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 14),
                            // Terms and Conditions
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _agreedToTerms = !_agreedToTerms;
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _agreedToTerms ? AppColors.primary : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _agreedToTerms ? AppColors.primary : const Color(0xFFCCCCCC),
                                      ),
                                    ),
                                    child: _agreedToTerms
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I agree to MakeEat\'s ',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 16,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: Color(0xFF191919),
                                            fontSize: 16,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            _buildButton(
                              'Create an Account',
                              onPressed: _handleSignup,
                              isEnabled: _agreedToTerms,
                            ),

                            const SizedBox(height: 20),
                            _buildDivider(),

                            const SizedBox(height: 20),
                            _buildSocialButton(
                              'Sign Up with Google',
                              'assets/images/google_logo.png',
                              onPressed: _handleGoogleSignUp,
                              backgroundColor: Colors.white,
                              textColor: const Color(0xFF191919),
                            ),

                            const SizedBox(height: 14),
                            _buildSocialButton(
                              'Sign Up with Facebook',
                              'assets/icons/logos_facebook.svg',
                              onPressed: () {},
                              backgroundColor: const Color(0xFF1877F2),
                              textColor: Colors.white,
                            ),

                            const SizedBox(height: 32),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
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
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? error,
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 16,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: error != null
                    ? const Color(0xFFE55A47)
                    : const Color(0xFFCCCCCC),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !(isPasswordVisible ?? false),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible ?? false
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF666666),
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE55A47),
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE6E6E6),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE6E6E6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text, {
    VoidCallback? onPressed,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: 57,
        decoration: ShapeDecoration(
          color: isEnabled ? const Color(0xFFF48600) : const Color(0xFFE6E6E6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? const Color(0xFF191919) : const Color(0xFF999999),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    String iconPath, {
    VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: backgroundColor == Colors.white
                ? const BorderSide(color: Color(0xFFCCCCCC))
                : BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath.endsWith('.svg'))
              SvgPicture.asset(iconPath, width: 24, height: 24)
            else
              Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final (success, message) = await authService.signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;

        if (success) {
          // Generate FCM token after successful signup
          final notificationService = NotificationService();
          await notificationService.getFCMToken();
          
          if (!mounted) return;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeSlides(),
              settings: const RouteSettings(name: '/welcome'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    final authService = context.read<AuthService>();
    final (success, message) = await authService.signInWithGoogle();

    if (mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 