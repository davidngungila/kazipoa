class AppSettings {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final bool showProfile;
  final bool allowMessages;
  final bool twoFactorEnabled;
  final String currency;
  final String timezone;

  const AppSettings({
    this.isDarkMode = false,
    this.language = 'en',
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.pushNotifications = true,
    this.showProfile = true,
    this.allowMessages = true,
    this.twoFactorEnabled = false,
    this.currency = 'TZS',
    this.timezone = 'Africa/Dar_es_Salaam',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? false,
      language: json['language'] ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      showProfile: json['showProfile'] ?? true,
      allowMessages: json['allowMessages'] ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      currency: json['currency'] ?? 'TZS',
      timezone: json['timezone'] ?? 'Africa/Dar_es_Salaam',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'pushNotifications': pushNotifications,
      'showProfile': showProfile,
      'allowMessages': allowMessages,
      'twoFactorEnabled': twoFactorEnabled,
      'currency': currency,
      'timezone': timezone,
    };
  }

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
    bool? showProfile,
    bool? allowMessages,
    bool? twoFactorEnabled,
    String? currency,
    String? timezone,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      showProfile: showProfile ?? this.showProfile,
      allowMessages: allowMessages ?? this.allowMessages,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
    );
  }
}
