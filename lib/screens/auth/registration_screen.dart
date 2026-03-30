import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tafadhali kubali masharti na sheria'),
            backgroundColor: KazipoaTheme.errorColor,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      // Simulate registration process
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
                                'Jisajili',
                                style: KazipoaTheme.headlineSmall.copyWith(
                                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Registration Form
                          LiquidGlassCard(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unda Akaunti Mpya',
                                    style: KazipoaTheme.headlineSmall.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Jiunge na Kazipoa na kupata kazi bora',
                                    style: KazipoaTheme.bodyMedium.copyWith(
                                      color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Name Field
                                  Text(
                                    'Jina Kamili',
                                    style: KazipoaTheme.labelLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Jina lako kamili',
                                      prefixIcon: const Icon(Icons.person_outline),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Tafadhali ingiza jina lako';
                                      }
                                      if (value.length < 3) {
                                        return 'Jina liwe na angalau herufi 3';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
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
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Phone Field
                                  Text(
                                    'Namba ya Simu',
                                    style: KazipoaTheme.labelLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: '+255 712 345 678',
                                      prefixIcon: const Icon(Icons.phone_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Tafadhali ingiza namba ya simu';
                                      }
                                      if (value.length < 10) {
                                        return 'Namba ya simu si sahihi';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
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
                                  
                                  // Confirm Password Field
                                  Text(
                                    'Thibitisha Neno la Siri',
                                    style: KazipoaTheme.labelLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                        },
                                        icon: Icon(
                                          _obscureConfirmPassword 
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Tafadhali thibitisha neno la siri';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Maneno ya siri hayalingani';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Terms and Conditions
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _agreeToTerms,
                                        onChanged: (value) {
                                          setState(() => _agreeToTerms = value ?? false);
                                        },
                                        activeColor: KazipoaTheme.primaryColor,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() => _agreeToTerms = !_agreeToTerms);
                                          },
                                          child: Text(
                                            'Nakubali masharti na sheria za Kazipoa. Soma masharti hapa.',
                                            style: KazipoaTheme.bodySmall.copyWith(
                                              color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Register Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: LiquidButton.elevated(
                                      text: 'Jisajili Sasa',
                                      isLoading: _isLoading,
                                      onPressed: _handleRegistration,
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
                                  
                                  // Social Registration Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LiquidButton.outlined(
                                          text: 'Google',
                                          onPressed: () {
                                            // Handle Google registration
                                          },
                                          height: 48,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: LiquidButton.outlined(
                                          text: 'Facebook',
                                          onPressed: () {
                                            // Handle Facebook registration
                                          },
                                          height: 48,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Login Link
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: KazipoaTheme.bodyMedium.copyWith(
                                          color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Tayari una akaunti? '),
                                          WidgetSpan(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed('/login');
                                              },
                                              child: Text(
                                                'Ingia',
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
