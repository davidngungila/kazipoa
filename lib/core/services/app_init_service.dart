class AppInitService {
  static Future<String> getInitialRoute() async {
    // Based on app flow logic: splash -> index_enhanced
    // Users choose role (Client/Pro/Guest) at index_enhanced
    return '/index';
  }
}
