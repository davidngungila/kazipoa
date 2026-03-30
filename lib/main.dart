import 'package:flutter/material.dart';
import 'app_router.dart';
import 'platform_config.dart';

void main() {
  // Configure Flutter for unified platform support
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const KazipoaApp());
}
