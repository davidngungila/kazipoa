import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      // Navigate to dashboard (replace with actual navigation)
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Liquid Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0A0A14),
                          const Color(0xFF1A1A2E),
                        ]
                      : [
                          const Color(0xFFF6F5F8),
                          const Color(0xFFE0E7FF),
                        ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Moving blob 1
                      Positioned(
                        top: -100,
                        left: -100,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 20),
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.primaryColor.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: KazipoaTheme.primaryColor.withOpacity(0.2),
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Moving blob 2
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.6,
                        right: -100,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 25),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.secondaryColor.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: KazipoaTheme.secondaryColor.withOpacity(0.2),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Safe Area Content
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Top Navigation
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back),
                                style: IconButton.styleFrom(
                                  backgroundColor: isDark 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.7),
                                  foregroundColor: isDark 
                                      ? Colors.white
                                      : KazipoaTheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Kitambulisho cha Mteja',
                                style: KazipoaTheme.headlineSmall.copyWith(
                                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Hero Section / Branding
                          Center(
                            child: LiquidGlassCard(
                              width: double.infinity,
                              height: 200,
                              borderRadius: BorderRadius.circular(24),
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: KazipoaTheme.primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.work_outline,
                                      size: 48,
                                      color: KazipoaTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Kazipoa',
                                    style: KazipoaTheme.headlineMedium.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Tafuta Kazi Tanzania',
                                    style: KazipoaTheme.bodyMedium.copyWith(
                                      color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Login Form
                          LiquidGlassCard(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Karibu Tena!',
                                    style: KazipoaTheme.headlineSmall.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ingia kwenye akaunti yako kuendelea',
                                    style: KazipoaTheme.bodyMedium.copyWith(
                                      color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Email Field
                                  Text(
                                    'Barua Pepe',
                                    style: KazipoaTheme.labelLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'name@example.com',
                                      prefixIcon: const Icon(Icons.email_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Tafadhali ingiza barua pepe';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Tafadhali ingiza barua pepe sahihi';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Password Field
                                  Text(
                                    'Neno la Siri',
                                    style: KazipoaTheme.labelLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() => _obscurePassword = !_obscurePassword);
                                        },
                                        icon: Icon(
                                          _obscurePassword 
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Tafadhali ingiza neno la siri';
                                      }
                                      if (value.length < 6) {
                                        return 'Neno la siri liwe na angalau herufi 6';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // Navigate to forgot password
                                      },
                                      child: Text(
                                        'Umesahau neno la siri?',
                                        style: KazipoaTheme.labelMedium.copyWith(
                                          color: KazipoaTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: LiquidButton.elevated(
                                      text: 'Ingia',
                                      isLoading: _isLoading,
                                      onPressed: _handleLogin,
                                      height: 56,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: isDark 
                                              ? Colors.white.withOpacity(0.2)
                                              : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'AU',
                                          style: KazipoaTheme.labelSmall.copyWith(
                                            color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: isDark 
                                              ? Colors.white.withOpacity(0.2)
                                              : KazipoaTheme.onSurfaceVariant.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Social Login Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LiquidButton.outlined(
                                          text: 'Google',
                                          onPressed: () {
                                            // Handle Google login
                                          },
                                          height: 48,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: LiquidButton.outlined(
                                          text: 'Facebook',
                                          onPressed: () {
                                            // Handle Facebook login
                                          },
                                          height: 48,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Sign Up Link
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: KazipoaTheme.bodyMedium.copyWith(
                                          color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Huna akaunti? '),
                                          WidgetSpan(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed('/register');
                                              },
                                              child: Text(
                                                'Jisajili',
                                                style: KazipoaTheme.bodyMedium.copyWith(
                                                  color: KazipoaTheme.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
