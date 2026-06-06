import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main/main_navigation_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/medical/medical_dashboard_screen.dart';
import 'screens/officer/officer_dashboard_screen.dart';
import 'screens/pharmacy/pharmacy_dashboard_screen.dart';
import 'screens/head/head_dashboard_screen.dart';
import 'screens/articles/articles_screen.dart';
import 'screens/feedback/feedback_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for Indonesian locale (id_ID)
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puskesmas Silangit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Named routes definition
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/medical': (context) => const MedicalDashboardScreen(),
        '/officer': (context) => const OfficerDashboardScreen(),
        '/pharmacy': (context) => const PharmacyDashboardScreen(),
        '/head': (context) => const HeadDashboardScreen(),
        '/articles': (context) => const ArticlesScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },

      // OnGenerateRoute to handle dynamic route arguments (like initialIndex for main navigation)
      onGenerateRoute: (settings) {
        if (settings.name == '/main') {
          final int initialIndex = settings.arguments as int? ?? 0;
          return MaterialPageRoute(
            builder: (context) => MainNavigationScreen(initialIndex: initialIndex),
          );
        }
        return null;
      },
    );
  }
}
