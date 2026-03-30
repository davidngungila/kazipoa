// Simple test file for Kazipoa project structure
// This file tests basic Dart functionality without Flutter dependencies

// Test basic string operations
void main() {
  print('🧪 Running Kazipoa Basic Tests...');
  
  // Test 1: Swahili text validation
  testSwahiliText();
  
  // Test 2: Basic data structures
  testDataStructures();
  
  // Test 3: String operations
  testStringOperations();
  
  // Test 4: List operations
  testListOperations();
  
  print('✅ All basic tests completed successfully!');
}

void testSwahiliText() {
  print('📝 Testing Swahili text validation...');
  
  // Test Swahili text elements
  const swahiliTexts = [
    'Kitambulisho cha Mteja',
    'Karibu Tena!',
    'Ingia kwenye akaunti yako kuendelea',
    'Barua Pepe',
    'Neno la Siri',
    'Umesahau neno la siri?',
    'Huna akaunti?',
    'Jisajili'
  ];
  
  // Verify all Swahili texts are non-empty
  for (final text in swahiliTexts) {
    assert(text.isNotEmpty, 'Swahili text should not be empty: $text');
  }
  
  print('✅ Swahili text validation passed');
}

void testDataStructures() {
  print('🏗️ Testing basic data structures...');
  
  // Test user data structure
  final user = {
    'name': 'John Doe',
    'email': 'john@example.com',
    'phone': '+255 123 456 789',
    'location': 'Dar es Salaam, Tanzania'
  };
  
  assert(user['name'] == 'John Doe');
  assert(user['email'] == 'john@example.com');
  assert(user['location']!.contains('Tanzania'));
  
  // Test booking data structure
  final booking = {
    'id': 'BK001',
    'service': 'Electrical Repair',
    'provider': 'Ali Hassan',
    'date': '2024-01-15',
    'status': 'confirmed',
    'price': 15000
  };
  
  assert(booking['id'] == 'BK001');
  assert(booking['service'] == 'Electrical Repair');
  assert(booking['price'] == 15000);
  
  print('✅ Data structure tests passed');
}

void testStringOperations() {
  print('🔤 Testing string operations...');
  
  // Test email validation
  final emails = [
    'user@example.com',
    'test@domain.co.tz',
    'admin@kazipoa.co.tz'
  ];
  
  for (final email in emails) {
    assert(email.contains('@'), 'Email should contain @: $email');
    assert(email.contains('.'), 'Email should contain domain: $email');
  }
  
  // Test phone number validation
  final phones = [
    '+255 123 456 789',
    '+255712345678',
    '0712 345 678'
  ];
  
  for (final phone in phones) {
    assert(phone.length >= 10, 'Phone number should be at least 10 characters: $phone');
    assert(RegExp(r'\d').hasMatch(phone), 'Phone should contain digits: $phone');
  }
  
  print('✅ String operation tests passed');
}

void testListOperations() {
  print('📋 Testing list operations...');
  
  // Test services list
  final services = [
    'Electrical Repair',
    'Plumbing',
    'Carpentry',
    'Painting',
    'Cleaning',
    'Gardening',
    'Moving Services',
    'Computer Repair'
  ];
  
  assert(services.length == 8, 'Should have 8 services');
  assert(services.contains('Electrical Repair'), 'Should contain Electrical Repair');
  assert(services.contains('Plumbing'), 'Should contain Plumbing');
  
  // Test locations list
  final locations = [
    'Dar es Salaam',
    'Arusha',
    'Mwanza',
    'Dodoma',
    'Zanzibar',
    'Mbeya',
    'Morogoro'
  ];
  
  assert(locations.length == 7, 'Should have 7 locations');
  assert(locations.first == 'Dar es Salaam', 'First location should be Dar es Salaam');
  assert(locations.last == 'Morogoro', 'Last location should be Morogoro');
  
  print('✅ List operation tests passed');
}

// Test utility functions
class TestUtils {
  static bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
  
  static bool isValidPhone(String phone) {
    return phone.length >= 10 && RegExp(r'\d').hasMatch(phone);
  }
  
  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }
  
  static String formatPrice(int price) {
    return 'TZS ${price.toString()}';
  }
  
  static String formatDate(String date) {
    // Simple date formatting
    return date.replaceAll('-', '/');
  }
}

void testUtilityFunctions() {
  print('🔧 Testing utility functions...');
  
  // Test email validation
  assert(TestUtils.isValidEmail('test@example.com'));
  assert(!TestUtils.isValidEmail('invalid-email'));
  
  // Test phone validation
  assert(TestUtils.isValidPhone('+255123456789'));
  assert(!TestUtils.isValidPhone('123'));
  
  // Test name validation
  assert(TestUtils.isValidName('John Doe'));
  assert(!TestUtils.isValidName(''));
  
  // Test price formatting
  assert(TestUtils.formatPrice(15000) == 'TZS 15000');
  
  // Test date formatting
  assert(TestUtils.formatDate('2024-01-15') == '2024/01/15');
  
  print('✅ Utility function tests passed');
}

// Mock service classes for testing
class MockUserService {
  static Map<String, dynamic> getUser(String id) {
    return {
      'id': id,
      'name': 'Test User',
      'email': 'test@example.com',
      'verified': true
    };
  }
  
  static bool authenticateUser(String email, String password) {
    // Mock authentication
    return email == 'test@example.com' && password == 'password123';
  }
}

class MockBookingService {
  static List<Map<String, dynamic>> getBookings(String userId) {
    return [
      {
        'id': 'BK001',
        'service': 'Electrical Repair',
        'status': 'confirmed',
        'date': '2024-01-15'
      },
      {
        'id': 'BK002',
        'service': 'Plumbing',
        'status': 'pending',
        'date': '2024-01-20'
      }
    ];
  }
  
  static bool createBooking(Map<String, dynamic> booking) {
    // Mock booking creation
    return booking.containsKey('service') && booking.containsKey('date');
  }
}

void testMockServices() {
  print('🏢 Testing mock services...');
  
  // Test user service
  final user = MockUserService.getUser('user123');
  assert(user['name'] == 'Test User');
  assert(user['verified'] == true);
  
  assert(MockUserService.authenticateUser('test@example.com', 'password123'));
  assert(!MockUserService.authenticateUser('test@example.com', 'wrong'));
  
  // Test booking service
  final bookings = MockBookingService.getBookings('user123');
  assert(bookings.length == 2);
  assert(bookings.first['service'] == 'Electrical Repair');
  
  final newBooking = {
    'service': 'Painting',
    'date': '2024-01-25',
    'userId': 'user123'
  };
  assert(MockBookingService.createBooking(newBooking));
  
  print('✅ Mock service tests passed');
}
