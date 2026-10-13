import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/order_status_args.dart'; // [BARU] import model args
import '../data/item_repository.dart';
import '../models/umkm.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_checkout_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/catatan_form_screen.dart';
import '../screens/detail_menu_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/merchant_directory_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/order_status_screen.dart';
import '../screens/support_screen.dart';
import '../screens/umkm_detail_screen.dart';
import '../screens/umkm_list_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String detailMenu = '/detail-menu';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String merchants = '/merchants';
  static const String orderStatus = '/order-status';
  static const String support = '/support';
  static const String catatanForm = '/catatan-form';
  static const String umkmList = '/umkm-list';
  static const String umkmDetail = '/umkm-detail';

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
      case cart:
        return MaterialPageRoute<void>(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
      case checkout:
        Item? item;
        final args = settings.arguments;
        if (args is Item) {
          item = args;
        } else if (CartProvider.instance.isNotEmpty) {
          item = CartProvider.instance.items.first.item;
        } else {
          item = ItemRepository.findById('1');
        }
        if (item != null) {
          return MaterialPageRoute<void>(
            builder: (_) => CartCheckoutScreen(item: item!),
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
        // [BARU] Periksa tipe argument, teruskan ke OrderStatusScreen
        final args = settings.arguments;
        if (args is OrderStatusArgs) {
          return MaterialPageRoute<void>(
            builder: (_) => OrderStatusScreen(args: args),
            settings: settings,
          );
        }
        return null; // argument salah/kosong -> halaman 404
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
      case umkmList:
        return MaterialPageRoute<void>(
          builder: (_) => const UmkmListScreen(),
          settings: settings,
        );
      case umkmDetail:
        // Argument WAJIB berupa Umkm, cek tipenya dulu
        final args = settings.arguments;
        if (args is Umkm) {
          return MaterialPageRoute<void>(
            builder: (_) => UmkmDetailScreen(umkm: args),
            settings: settings,
          );
        }
        return null;
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
