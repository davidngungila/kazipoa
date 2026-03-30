import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final bool isProRegistration;
  final VoidCallback? onBackToLogin;

  const RegisterScreen({
    Key? key,
    this.isProRegistration = false,
    this.onBackToLogin,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _specializationController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryPurple),
          onPressed: widget.onBackToLogin ?? () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
          style: TextStyle(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryPurple,
                            AppTheme.lightPurple,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Join Kazipoa',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isProRegistration 
                          ? 'Start your professional journey'
                          : 'Find your dream job today',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Registration Form
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
                      // User Type Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryPurple.withOpacity(0.1),
                              AppTheme.lightPurple.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.isProRegistration ? Icons.business : Icons.person,
                              color: AppTheme.primaryPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isProRegistration ? 'Professional Account' : 'Client Account',
                              style: TextStyle(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Business Name for Professionals
                      if (widget.isProRegistration) ...[
                        _buildTextField(
                          controller: _businessNameController,
                          label: 'Business Name',
                          hint: 'Enter your business name',
                          icon: Icons.business,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your business name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _specializationController,
                          label: 'Specialization',
                          hint: 'e.g., Plumbing, Electrical, Cleaning',
                          icon: Icons.build,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your specialization';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Full Name for Clients
                      if (!widget.isProRegistration) ...[
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      
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
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Create a strong password',
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
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        icon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.mediumGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppTheme.primaryPurple,
                          ),
                          Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.mediumGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Register Button
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
                          onPressed: _isLoading ? null : _handleRegister,
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
                                  'Create Account',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Already have account
                      GestureDetector(
                        onTap: widget.onBackToLogin ?? () => Navigator.pop(context),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppTheme.mediumGrey,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      bool success;

      if (widget.isProRegistration) {
        success = await authService.registerPro(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          businessName: _businessNameController.text.trim(),
          specialization: _specializationController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      } else {
        success = await authService.registerClient(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        // Navigate back to login or main screen
        if (widget.onBackToLogin != null) {
          widget.onBackToLogin!();
        } else {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
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
