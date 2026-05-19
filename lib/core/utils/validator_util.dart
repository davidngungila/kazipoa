/// Validator Utility - Equivalent to JavaScript ValidatorUtil
/// Provides validation methods for various input types
class ValidatorUtil {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    // Basic email regex pattern
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  static void validateEmail(String email) {
    if (email.isEmpty) {
      throw ArgumentError('Barua pepe inahitajika');
    }
    if (!isValidEmail(email)) {
      throw ArgumentError('Tafadhali weka anwani halali ya barua pepe');
    }
  }

  // Phone validation
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'[\D]'), '');
    
    // Check if it has at least 10 digits
    return digitsOnly.length >= 10;
  }

  static void validatePhone(String phone) {
    if (phone.isEmpty) {
      throw ArgumentError('Namba ya simu inahitajika');
    }
    if (!isValidPhone(phone)) {
      throw ArgumentError('Tafadhali weka namba halali ya simu');
    }
  }

  // Password validation
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    
    // Basic password validation - at least 6 characters
    return password.length >= 6;
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw ArgumentError('Nenosiri inahitajika');
    }
    if (!isValidPassword(password)) {
      throw ArgumentError('Nenosiri lazima liwe na herufi 6 au zaidi');
    }
  }

  // Username validation
  static bool isValidUsername(String username) {
    if (username.isEmpty) return false;
    
    // Username should be at least 3 characters
    return username.length >= 3;
  }

  static void validateUsername(String username) {
    if (username.isEmpty) {
      throw ArgumentError('Jina la mtumiaji linahitajika');
    }
    if (!isValidUsername(username)) {
      throw ArgumentError('Jina la mtumiaji lazima liwe na herufi 3 au zaidi');
    }
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    
    // Name should have at least 2 characters
    return name.trim().length >= 2;
  }

  static void validateName(String name, {String fieldName = 'Jina'}) {
    if (name.isEmpty) {
      throw ArgumentError('$fieldName linahitajika');
    }
    if (!isValidName(name)) {
      throw ArgumentError('$fieldName lazima liwe na herufi 2 au zaidi');
    }
  }

  // Required field validation
  static void validateRequired(String value, {String fieldName = 'Sehemu hii'}) {
    if (value.trim().isEmpty) {
      throw ArgumentError('$fieldName inahitajika');
    }
  }

  // Number validation
  static bool isValidNumber(String number) {
    if (number.isEmpty) return false;
    
    return double.tryParse(number) != null;
  }

  static void validateNumber(String number, {String fieldName = 'Namba'}) {
    if (number.isEmpty) {
      throw ArgumentError('$fieldName inahitajika');
    }
    if (!isValidNumber(number)) {
      throw ArgumentError('Tafadhali weka $fieldName halali');
    }
  }

  // Price validation
  static bool isValidPrice(String price) {
    if (price.isEmpty) return false;
    
    final number = double.tryParse(price);
    return number != null && number > 0;
  }

  static void validatePrice(String price) {
    if (price.isEmpty) {
      throw ArgumentError('Bei inahitajika');
    }
    if (!isValidPrice(price)) {
      throw ArgumentError('Tafadhali weka bei halali');
    }
  }

  // Date validation
  static bool isValidDate(String date) {
    if (date.isEmpty) return false;
    
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  static void validateDate(String date) {
    if (date.isEmpty) {
      throw ArgumentError('Tarehe inahitajika');
    }
    if (!isValidDate(date)) {
      throw ArgumentError('Tafadhali weka tarehe halali');
    }
  }

  // Time validation (HH:MM format)
  static bool isValidTime(String time) {
    if (time.isEmpty) return false;
    
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  static void validateTime(String time) {
    if (time.isEmpty) {
      throw ArgumentError('Saa inahitajika');
    }
    if (!isValidTime(time)) {
      throw ArgumentError('Tafadhali weka saa halali (HH:MM)');
    }
  }

  // URL validation
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  static void validateUrl(String url) {
    if (url.isEmpty) {
      throw ArgumentError('URL inahitajika');
    }
    if (!isValidUrl(url)) {
      throw ArgumentError('Tafadhali weka URL halali');
    }
  }

  // Length validation
  static bool isValidLength(String value, int minLength, {int? maxLength}) {
    if (value.isEmpty) return false;
    
    if (value.length < minLength) return false;
    if (maxLength != null && value.length > maxLength) return false;
    
    return true;
  }

  static void validateLength(String value, int minLength, {int? maxLength, String fieldName = 'Sehemu hii'}) {
    if (value.isEmpty) {
      throw ArgumentError('$fieldName inahitajika');
    }
    
    if (value.length < minLength) {
      throw ArgumentError('$fieldName lazima iwe na herufi $minLength au zaidi');
    }
    
    if (maxLength != null && value.length > maxLength) {
      throw ArgumentError('$fieldName haitowezi kuwa na herufi zaidi ya $maxLength');
    }
  }

  // General validation method that returns validation result
  static Map<String, dynamic> validateField(String value, String fieldType, {String fieldName = 'Sehemu hii'}) {
    try {
      switch (fieldType.toLowerCase()) {
        case 'email':
          validateEmail(value);
          break;
        case 'phone':
          validatePhone(value);
          break;
        case 'password':
          validatePassword(value);
          break;
        case 'username':
          validateUsername(value);
          break;
        case 'name':
          validateName(value, fieldName: fieldName);
          break;
        case 'number':
          validateNumber(value, fieldName: fieldName);
          break;
        case 'price':
          validatePrice(value);
          break;
        case 'date':
          validateDate(value);
          break;
        case 'time':
          validateTime(value);
          break;
        case 'url':
          validateUrl(value);
          break;
        default:
          validateRequired(value, fieldName: fieldName);
      }
      
      return {'valid': true, 'error': null};
    } catch (e) {
      return {'valid': false, 'error': e.toString()};
    }
  }

  // Batch validation for multiple fields
  static Map<String, dynamic> validateFields(Map<String, dynamic> fields) {
    final errors = <String, String>{};
    bool isValid = true;

    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final fieldData = entry.value;
      
      if (fieldData is Map<String, dynamic>) {
        final value = fieldData['value'] as String? ?? '';
        final type = fieldData['type'] as String? ?? 'required';
        
        final result = validateField(value, type, fieldName: fieldName);
        if (!result['valid']) {
          errors[fieldName] = result['error'] as String;
          isValid = false;
        }
      }
    }

    return {
      'valid': isValid,
      'errors': errors,
    };
  }
}
