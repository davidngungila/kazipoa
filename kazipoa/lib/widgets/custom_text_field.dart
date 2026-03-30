import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.grey[600]),
                onPressed: onSuffixIconTap,
              )
            : null,
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
    );
  }
}
