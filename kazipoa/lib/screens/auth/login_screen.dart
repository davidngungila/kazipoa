import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import 'register_screen.dart';
import '../landing_page.dart';

class LoginScreen extends StatefulWidget {
  final bool isProLogin;
  final VoidCallback? onToggleUserType;

  const LoginScreen({
    Key? key,
    this.isProLogin = false,
    this.onToggleUserType,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Logo and Title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryPurple,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kazipoa',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pata Kazi ya Ndoto Yako',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.mediumGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              
              // User Type Toggle
              if (widget.onToggleUserType != null) ...[
                Container(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onToggleUserType!(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: !widget.isProLogin ? AppTheme.primaryPurple : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Client',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !widget.isProLogin ? Colors.white : AppTheme.mediumGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onToggleUserType!(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: widget.isProLogin ? AppTheme.primaryPurple : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Professional',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.isProLogin ? Colors.white : AppTheme.mediumGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
              
              // Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your journey',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.mediumGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.mediumGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Submit Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryPurple,
                              AppTheme.lightPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : Text(
                                  'Sign In',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Toggle Register/Login
                      GestureDetector(
                        onTap: _isLoading ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                                isProRegistration: widget.isProLogin,
                                onBackToLogin: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: AppTheme.mediumGrey,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.w600,
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
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.mediumGrey),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppTheme.lavenderBackground.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            hintStyle: TextStyle(
              color: AppTheme.lightGrey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      bool success;

      if (widget.isProLogin) {
        success = await authService.loginPro(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await authService.loginClient(
          _emailController.text.trim(),
          _passwordController.text,
          '', // name - not needed for login
          '', // phone - not needed for login
        );
      }

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LandingPage()),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
