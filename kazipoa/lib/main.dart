import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize auth service
  final authService = AuthService();
  await authService.init();
  
  runApp(
    ChangeNotifierProvider<AuthService>(
      create: (_) => authService,
      child: const KaziPoaApp(),
    ),
  );
}

class KaziPoaApp extends StatelessWidget {
  const KaziPoaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kazi Poa Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
      routes: {
        '/main': (context) => const MainNavigation(),
      },
    );
  }
}
