import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<void> launchHtmlPage(String relativePath) async {
    final String baseUrl = 'file:///c:/Users/Eutychus/OneDrive/Desktop/Kazi poa app/kazipoa full/Pages';
    final Uri uri = Uri.parse('$baseUrl/$relativePath');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
  
  static Future<void> launchProAccountProfile() async {
    await launchHtmlPage('02.Pro-account-profile.html');
  }
  
  static Future<void> launchBookingSuccess() async {
    await launchHtmlPage('06.Booking-success.html');
  }
  
  static Future<void> launchClientRegistration() async {
    await launchHtmlPage('04.ClientID-registration.html');
  }
  
  static Future<void> launchClientLogin() async {
    await launchHtmlPage('05.ClientID-login.html');
  }
  
  static Future<void> launchMyClientBooking() async {
    await launchHtmlPage('17.MyClient-Booking.html');
  }
  
  static Future<void> launchProAccountLogin() async {
    await launchHtmlPage('08.Pro-account-login.html');
  }
  
  static Future<void> launchProAccountRegistration() async {
    await launchHtmlPage('09.Pro-account-registration.html');
  }
  
  static Future<void> launchEmailVerification() async {
    await launchHtmlPage('10.Email-verification.html');
  }
  
  static Future<void> launchOtpVerification() async {
    await launchHtmlPage('11.OTP-verification.html');
  }
  
  static Future<void> launchProfileSetup() async {
    await launchHtmlPage('12.Profile-setup.html');
  }
}
