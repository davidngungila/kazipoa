import 'package:intl/intl.dart';

/// Date Utility - Equivalent to JavaScript DateUtil
/// Provides date formatting, manipulation, and utility methods
class DateUtil {
  // Format dates in various formats
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateSwahili(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Leo';
    } else if (dateToCheck == today.add(const Duration(days: 1))) {
      return 'Kesho';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return 'Jana';
    } else {
      return DateFormat('d MMM, yyyy', 'sw').format(date);
    }
  }

  static String formatTime(DateTime time, {bool use24Hour = false}) {
    if (use24Hour) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('h:mm a').format(time);
    }
  }

  static String formatDateTimeSwahili(DateTime dateTime) {
    return '${formatDateSwahili(dateTime)} saa ${formatTime(dateTime)}';
  }

  // Parse dates from strings
  static DateTime? parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Date manipulation
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static DateTime addHours(DateTime date, int hours) {
    return date.add(Duration(hours: hours));
  }

  static DateTime addMinutes(DateTime date, int minutes) {
    return date.add(Duration(minutes: minutes));
  }

  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  static DateTime subtractHours(DateTime date, int hours) {
    return date.subtract(Duration(hours: hours));
  }

  static DateTime subtractMinutes(DateTime date, int minutes) {
    return date.subtract(Duration(minutes: minutes));
  }

  // Date comparison
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isTomorrow(DateTime date) {
    return isSameDay(date, DateTime.now().add(const Duration(days: 1)));
  }

  static bool isYesterday(DateTime date) {
    return isSameDay(date, DateTime.now().subtract(const Duration(days: 1)));
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
           date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  // Date differences
  static int daysBetween(DateTime date1, DateTime date2) {
    return date2.difference(date1).inDays;
  }

  static int hoursBetween(DateTime date1, DateTime date2) {
    return date2.difference(date1).inHours;
  }

  static int minutesBetween(DateTime date1, DateTime date2) {
    return date2.difference(date1).inMinutes;
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Hivi karibuni';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakiki iliyopita';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} masaa iliyopita';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} siku iliyopita';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks wiki iliyopita';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months miezi iliyopita';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years miaka iliyopita';
    }
  }

  // Working with time slots
  static List<String> generateTimeSlots({
    DateTime? startDate,
    DateTime? endDate,
    int intervalMinutes = 30,
    String startTime = '09:00',
    String endTime = '18:00',
  }) {
    final slots = <String>[];
    final start = DateFormat('HH:mm').parse(startTime);
    final end = DateFormat('HH:mm').parse(endTime);

    DateTime current = start;
    while (current.isBefore(end)) {
      slots.add(DateFormat('h:mm a').format(current));
      current = current.add(Duration(minutes: intervalMinutes));
    }

    return slots;
  }

  static DateTime combineDateAndTime(DateTime date, String timeString) {
    final time = DateFormat('h:mm a').parse(timeString);
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  // Business hours and availability
  static bool isBusinessHours(DateTime dateTime) {
    final hour = dateTime.hour;
    final weekday = dateTime.weekday;
    
    // Monday to Friday, 9 AM to 6 PM
    return weekday >= 1 && weekday <= 5 && hour >= 9 && hour < 18;
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  // Date validation
  static bool isValidDate(DateTime date) {
    try {
      // Check if the date is within a reasonable range
      final now = DateTime.now();
      final minDate = DateTime(1900);
      final maxDate = now.add(const Duration(days: 365 * 100)); // 100 years from now
      
      return date.isAfter(minDate) && date.isBefore(maxDate);
    } catch (e) {
      return false;
    }
  }

  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Booking specific utilities
  static List<DateTime> getAvailableDates({
    int daysAhead = 30,
    List<DateTime>? excludedDates,
    bool includeWeekends = true,
  }) {
    final dates = <DateTime>[];
    final now = DateTime.now();
    
    for (int i = 0; i < daysAhead; i++) {
      final date = now.add(Duration(days: i));
      
      // Skip weekends if not included
      if (!includeWeekends && isWeekend(date)) continue;
      
      // Skip excluded dates
      if (excludedDates != null && excludedDates.any((excluded) => isSameDay(excluded, date))) continue;
      
      dates.add(date);
    }
    
    return dates;
  }

  static Map<String, dynamic> getBookingInfo(DateTime bookingDate, String bookingTime) {
    final now = DateTime.now();
    final bookingDateTime = combineDateAndTime(bookingDate, bookingTime);
    final isUpcoming = bookingDateTime.isAfter(now);
    final daysUntil = isUpcoming ? daysBetween(now, bookingDate) : -daysBetween(bookingDate, now);
    
    return {
      'bookingDateTime': bookingDateTime,
      'isUpcoming': isUpcoming,
      'daysUntil': daysUntil,
      'formattedDate': formatDateSwahili(bookingDate),
      'formattedTime': bookingTime,
      'formattedDateTime': formatDateTimeSwahili(bookingDateTime),
      'relativeTime': getRelativeTime(bookingDateTime),
    };
  }

  // Time zone utilities
  static DateTime convertToTimeZone(DateTime dateTime, String timeZone) {
    // This is a simplified version - in production, you'd use a proper time zone library
    return dateTime; // Placeholder
  }

  static String getCurrentTimeZone() {
    return DateTime.now().timeZoneName;
  }

  // Calendar utilities
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static int getDaysInMonth(DateTime date) {
    return getLastDayOfMonth(date).day;
  }

  static List<DateTime> getCalendarWeek(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    final week = <DateTime>[];
    
    for (int i = 0; i < 7; i++) {
      week.add(weekStart.add(Duration(days: i)));
    }
    
    return week;
  }
}
