import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  Future<bool> login({required String phone, required String password}) async {
    _isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _isLoading = false;
    notifyListeners();
    return phone.isNotEmpty && password.isNotEmpty;
  }
}
