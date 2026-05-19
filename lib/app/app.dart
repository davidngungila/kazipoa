import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/auth_manager.dart';
import '../core/theme/app_theme.dart';

// Entry Points
import '../features/auth/presentation/pages/index_enhanced.dart';

// Declaration Gateway
import '../features/auth/presentation/pages/client_id_registration_enhanced.dart';
import '../features/auth/presentation/pages/pro_account_registration_enhanced.dart';
import '../features/auth/presentation/pages/pro_account_login_enhanced.dart';

// Authentication Flow
import '../features/auth/presentation/pages/client_id_login_enhanced.dart';
import '../features/auth/presentation/pages/otp_client_enhanced.dart';
import '../features/auth/presentation/pages/email_client_enhanced.dart';
import '../features/auth/presentation/pages/email_verification_enhanced.dart';
import '../features/auth/presentation/pages/otp_verification_enhanced.dart';

// Main Navigation Pages
import '../features/landing/presentation/pages/landing_page_enhanced.dart';
import '../features/booking/presentation/pages/my_bookings_enhanced.dart';
import '../features/booking/presentation/pages/my_client_booking_enhanced.dart';
import '../features/live/presentation/pages/kazi_live_client_hub_enhanced.dart';
import '../features/live/presentation/pages/kazi_live_hub_pro_enhanced.dart';
import '../features/chat/presentation/pages/clients_chats_overview_enhanced.dart';
import '../features/chat/presentation/pages/clients_chat_enhanced.dart';
import '../features/chat/presentation/pages/pro_chats_overview_enhanced.dart';
import '../features/dashboard/presentation/pages/dashboard_enhanced.dart';
import '../features/office/presentation/pages/my_office_enhanced.dart';
import '../features/profile/presentation/pages/pro_account_profile_enhanced.dart';
import '../features/profile/presentation/pages/profile_settings_enhanced.dart';
import '../features/services/presentation/pages/service_listings_enhanced.dart';

// Additional Features
import '../features/analytics/presentation/pages/analytics_enhanced.dart';

// Services & Booking
import '../features/booking/presentation/pages/booking_setup_enhanced.dart';
import '../features/booking/presentation/pages/booking_success_enhanced.dart';

// Additional
import '../features/auth/presentation/pages/profile_setup_enhanced.dart';

class KazipoaApp extends StatelessWidget {
  const KazipoaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kazipoa - Kazi Poa Tanzania',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: _router,
    );
  }

  static final _router = GoRouter(
    initialLocation: '/index',
    redirect: (context, state) {
      final authManager = AuthManager();
      final loggedIn = authManager.isAuthenticated;
      final role = authManager.currentRole;
      final isGuest = authManager.isGuest;
      
      final isLoggingIn = state.matchedLocation == '/index' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/pro_login' ||
          state.matchedLocation == '/pro_registration';

      if (!loggedIn && !isGuest) {
        // Not logged in and not guest: only allow access to auth paths and guest entry
        if (!isLoggingIn && state.matchedLocation != '/guest' && !state.matchedLocation.startsWith('/register')) {
          return '/index';
        }
        return null;
      }

      if (loggedIn) {
        // User is logged in. If they try to go to landing/auth pages, redirect to dashboard/home
        if (isLoggingIn) {
          if (role == 'pro') {
            return '/wasifu/pro_dashboard';
          } else {
            return '/home';
          }
        }
      }

      return null;
    },
    routes: [
      // ========== ENTRY FLOW ==========

      // Index Page - Declaration Gateway Entry Point
      GoRoute(
        path: '/index',
        builder: (context, state) => const KazipoaHome(),
      ),

      // ========== CLIENT AUTH FLOW ==========
      // Client Registration Flow
      GoRoute(
        path: '/register',
        builder: (context, state) => const ClientIdRegistrationEnhanced(),
        routes: [
          // Phone verification route
          GoRoute(
            path: '/phone',
            builder: (context, state) => const OtpClientEnhanced(),
          ),
          // Email verification route  
          GoRoute(
            path: '/email',
            builder: (context, state) => const EmailClientEnhanced(),
          ),
        ],
      ),
      
      // Client Login Flow
      GoRoute(
        path: '/login',
        builder: (context, state) => const ClientIdLoginEnhanced(),
      ),
      
      // ========== PRO AUTH FLOW ==========
      // Pro Registration Flow
      GoRoute(
        path: '/pro_registration',
        builder: (context, state) => const ProAccountRegistrationEnhanced(),
        routes: [
          // Phone verification for pros
          GoRoute(
            path: '/phone',
            builder: (context, state) => const OtpVerificationPage(),
          ),
          // Email verification for pros
          GoRoute(
            path: '/email',
            builder: (context, state) => const EmailVerificationEnhanced(),
          ),
          // Profile setup after verification
          GoRoute(
            path: '/setup',
            builder: (context, state) => const ProfileSetupEnhanced(),
          ),
        ],
      ),
      
      // Pro Login Flow
      GoRoute(
        path: '/pro_login',
        builder: (context, state) => const ProAccountLoginEnhanced(),
      ),
      
      // ========== VERIFICATION ROUTES ==========
      // Standalone verification routes (for direct access)
      GoRoute(
        path: '/otp_verification',
        builder: (context, state) => const OtpClientEnhanced(),
      ),
      
      GoRoute(
        path: '/otp_verification_pro',
        builder: (context, state) => const OtpVerificationPage(),
      ),
      
      GoRoute(
        path: '/email_client',
        builder: (context, state) => const EmailClientEnhanced(),
      ),
      
      GoRoute(
        path: '/email_verification',
        builder: (context, state) => const EmailVerificationEnhanced(),
      ),
      
      GoRoute(
        path: '/profile_setup',
        builder: (context, state) => const ProfileSetupEnhanced(),
      ),
      
      // ========== MAIN APP ROUTES ==========
          // Home - Browse pros, categories, featured pros
          GoRoute(
            path: '/home',
            builder: (context, state) => const LandingPageEnhanced(),
            routes: [
              // Service Listings - View all services
              GoRoute(
                path: '/services',
                builder: (context, state) => const ServiceListingsEnhanced(
                  categoryId: 'all',
                  category: null,
                ),
              ),
              
              // Service Listings by Category
              GoRoute(
                path: '/services/category/:categoryId',
                builder: (context, state) {
                  final categoryId = state.pathParameters['categoryId'];
                  if (categoryId == null) return const SizedBox.shrink();
                  return const ServiceListingsEnhanced(
                    categoryId: 'all',
                    category: null,
                  );
                },
              ),
              
              // Pro Account Profile - View pro details
              GoRoute(
                path: '/pro_profile/:proId',
                builder: (context, state) {
                  final proId = state.pathParameters['proId'];
                  if (proId == null) return const SizedBox.shrink();
                  return ProProfileScreen(proId: proId);
                },
              ),
            ],
          ),
          
          // Miadi (Bookings) - Client booking management
          GoRoute(
            path: '/miadi',
            builder: (context, state) {
              final authManager = AuthManager();
              if (authManager.currentRole == 'pro') {
                return const OfisiYanguScreen();
              } else {
                return const MyBookingsEnhanced();
              }
            },
            routes: [
              // Booking Setup - Create new booking
              GoRoute(
                path: '/setup',
                builder: (context, state) {
                  final proId = state.uri.queryParameters['proId'];
                  return BookingSetupEnhanced(proId: proId);
                },
              ),
              
              // Booking Success - Confirmation page
              GoRoute(
                path: '/success',
                builder: (context, state) => const BookingSuccessEnhanced(),
              ),
            ],
          ),
          
          // Kazilive - Live session hub
          GoRoute(
            path: '/kazilive',
            builder: (context, state) {
              // Route based on user role
              final authManager = AuthManager();
              if (authManager.currentRole == 'pro') {
                return const KaziLiveHubProEnhanced();
              } else {
                return const KaziLiveClientHubEnhanced();
              }
            },
            routes: [
              // Live Session - Individual session page
              GoRoute(
                path: '/session',
                builder: (context, state) => const KaziLiveClientHubEnhanced(),
              ),
              
              // Live Session - During active sessions
              GoRoute(
                path: '/session/:sessionId',
                builder: (context, state) {
                  final sessionId = state.pathParameters['sessionId'];
                  if (sessionId == null) return const SizedBox.shrink();
                  
                  final authManager = AuthManager();
                  if (authManager.currentRole == 'pro') {
                    return const KaziLiveHubProEnhanced();
                  } else {
                    return const KaziLiveClientHubEnhanced();
                  }
                },
              ),
            ],
          ),
          
          // Kazi Live Hub Route
          GoRoute(
            path: '/kazi_live_hub',
            builder: (context, state) => const KaziLiveClientHubEnhanced(),
          ),
          
          // Standalone Live Session Route (for direct access)
          GoRoute(
            path: '/kazilive_session',
            builder: (context, state) {
              final authManager = AuthManager();
              final sessionId = state.uri.queryParameters['sessionId'];
              
              if (sessionId == null) return const SizedBox.shrink();
              
              if (authManager.currentRole == 'pro') {
                return const KaziLiveHubProEnhanced();
              } else {
                return const KaziLiveClientHubEnhanced();
              }
            },
          ),
          
          // Chat - Messaging system
          GoRoute(
            path: '/chat',
            builder: (context, state) {
              final authManager = AuthManager();
              if (authManager.currentRole == 'pro') {
                return const ProChatsOverviewEnhanced();
              } else {
                return const ClientsChatsOverviewEnhanced();
              }
            },
            routes: [
              // Individual Chat
              GoRoute(
                path: '/detail/:chatId',
                builder: (context, state) {
                  final chatId = state.pathParameters['chatId'];
                  if (chatId == null) return const SizedBox.shrink();
                  
                  return ClientsChatEnhanced(chatId: chatId);
                },
              ),
            ],
          ),
          
          // Wasifu (Profile) - User profile and settings
          GoRoute(
            path: '/wasifu',
            builder: (context, state) {
              final authManager = AuthManager();
              if (authManager.currentRole == 'pro') {
                return const ProProfileScreen();
              } else {
                return const ProAccountLoginEnhanced();
              }
            },
            routes: [
              // Pro Dashboard - For pro users
              GoRoute(
                path: '/pro_dashboard',
                builder: (context, state) => const DashboardEnhanced(),
              ),
              
              // My Office - Pro office management
              GoRoute(
                path: '/my_office',
                builder: (context, state) => const MyOfficeEnhanced(),
              ),
              
              // Analytics - Pro analytics
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsEnhanced(),
              ),
              
              // My Bookings - Pro booking management
              GoRoute(
                path: '/my_bookings',
                builder: (context, state) {
                  final authManager = AuthManager();
                  if (authManager.currentRole == 'pro') {
                    return const OfisiYanguScreen();
                  } else {
                    return const MyBookingsEnhanced();
                  }
                },
              ),
              
              // Pro Profile - Professional profile
              GoRoute(
                path: '/pro_profile',
                builder: (context, state) => const ProProfileScreen(),
              ),
            ],
          ),
      
      // ========== GUEST MODE ROUTES ==========
      // Guest access to landing page
      GoRoute(
        path: '/guest',
        builder: (context, state) => const LandingPageEnhanced(isGuest: true),
      ),
      
      // Profile Settings Route
      GoRoute(
        path: '/wasifu',
        builder: (context, state) => const ProfileSettingsEnhanced(),
        routes: [
          // My Office - Pro office management
          GoRoute(
            path: '/my_office',
            builder: (context, state) => const MyOfficeEnhanced(),
          ),
          
          // Analytics - Pro analytics
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsEnhanced(),
          ),
          
          // My Bookings - Pro booking management
          GoRoute(
            path: '/my_bookings',
            builder: (context, state) => const MyBookingsEnhanced(),
          ),
        ],
      ),
      
      // ========== CLIENT AUTH COMPLETION ==========
      // Landing Page - After successful client auth
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingPageEnhanced(),
      ),
      
      // ========== REDIRECT ROUTES ==========
      // Legacy route redirects
      GoRoute(
        path: '/pro_dashboard',
        redirect: (context, state) => '/wasifu/pro_dashboard',
      ),
      
      GoRoute(
        path: '/my_office',
        redirect: (context, state) => '/wasifu/my_office',
      ),
      
      GoRoute(
        path: '/analytics',
        redirect: (context, state) => '/wasifu/analytics',
      ),
      
      GoRoute(
        path: '/booking_setup',
        redirect: (context, state) => '/miadi/setup',
      ),
      
      GoRoute(
        path: '/booking_success',
        redirect: (context, state) => '/miadi/success',
      ),
      
      GoRoute(
        path: '/client_login',
        redirect: (context, state) => '/login',
      ),
      
      GoRoute(
        path: '/client_registration',
        redirect: (context, state) => '/register',
      ),
      
      GoRoute(
        path: '/landing',
        redirect: (context, state) => '/home',
      ),
    ],
  );
}
