import 'package:flutter/material.dart';

import '../models/item.dart';
import '../screens/cart_checkout_screen.dart';
import '../screens/catatan_form_screen.dart';
import '../screens/detail_menu_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/merchant_directory_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/order_status_screen.dart';
import '../screens/support_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String detailMenu = '/detail-menu';
  static const String checkout = '/checkout';
  static const String merchants = '/merchants';
  static const String orderStatus = '/order-status';
  static const String support = '/support';
  static const String catatanForm = '/catatan-form';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case detail:
        final args = settings.arguments;
        if (args is Item) {
          return MaterialPageRoute<void>(
            builder: (_) => DetailScreen(item: args),
            settings: settings,
          );
        }
        return null; // data salah/kosong -> halaman 404
      case detailMenu:
        final args = settings.arguments;
        if (args is Item) {
          return MaterialPageRoute<void>(
            builder: (_) => DetailMenuScreen(item: args),
            settings: settings,
          );
        }
        return null;
      case checkout:
        final args = settings.arguments;
        if (args is Item) {
          return MaterialPageRoute<void>(
            builder: (_) => CartCheckoutScreen(item: args),
            settings: settings,
          );
        }
        return null;
      case merchants:
        return MaterialPageRoute<void>(
          builder: (_) => const MerchantDirectoryScreen(),
          settings: settings,
        );
      case orderStatus:
        return MaterialPageRoute<void>(
          builder: (_) => const OrderStatusScreen(),
          settings: settings,
        );
      case support:
        return MaterialPageRoute<void>(
          builder: (_) => const SupportScreen(),
          settings: settings,
        );
      case catatanForm:
        // <String> karena layar ini mengembalikan teks saat ditutup
        return MaterialPageRoute<String>(
          builder: (_) => const CatatanFormScreen(),
          settings: settings,
        );
      default:
        return null; // route tidak terdaftar -> halaman 404
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => NotFoundScreen(routeName: settings.name),
      settings: settings,
    );
  }
}
