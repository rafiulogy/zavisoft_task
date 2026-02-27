import 'package:get/get.dart';

import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String homeScreen = "/homeScreen";
  static String profileScreen = "/profileScreen";

  static String getLoginScreen() => loginScreen;
  static String getHomeScreen() => homeScreen;
  static String getProfileScreen() => profileScreen;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
  ];
}
