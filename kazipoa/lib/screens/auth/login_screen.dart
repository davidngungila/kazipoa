import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isRegistering = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Logo and Title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kazi Poa',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      widget.isProLogin ? 'Pro Portal' : 'Client Portal',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // User Type Toggle
              if (widget.onToggleUserType != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Client',
                        isOutlined: !widget.isProLogin,
                        onPressed: () => widget.onToggleUserType!(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Professional',
                        isOutlined: widget.isProLogin,
                        onPressed: () => widget.onToggleUserType!(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_isRegistering && !widget.isProLogin) ...[
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    if (_isRegistering) ...[
                      CustomTextField(
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    CustomTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
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
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock,
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
                    CustomButton(
                      text: _isRegistering ? 'Register' : 'Login',
                      isLoading: _isLoading,
                      onPressed: _handleSubmit,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Toggle Register/Login
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(
                        _isRegistering
                            ? 'Already have an account? Login'
                            : 'Don\'t have an account? Register',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

      if (_isRegistering) {
        if (widget.isProLogin) {
          success = await authService.registerPro(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            businessName: _nameController.text.trim(),
            specialization: 'General Services', // Default for demo
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
      } else {
        if (widget.isProLogin) {
          success = await authService.loginPro(
            _emailController.text.trim(),
            _passwordController.text,
          );
        } else {
          success = await authService.loginClient(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
            _phoneController.text.trim(),
          );
        }
      }

      if (success && mounted) {
        // Navigate to appropriate home screen
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login/Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
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
