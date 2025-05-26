import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/backend/api_requests/auth_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_app/backend/api_requests/fcm_token_api.dart';

class AppState extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  bool biometricPassed = false;
  bool passcodeChecked = false;
  bool passcodePassed = false;
  bool passcodeSet = false;
  bool biometricSetupDone = false;
  String errorMessage = '';
  int _unreadNotificationCount = 0;
  int get unreadNotificationCount => _unreadNotificationCount;
  bool _useDeviceAuth = false;
  bool get useDeviceAuth => _useDeviceAuth;
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> get clients => _clients;
  Map<String, dynamic>? userData;
  String? token;

  // ================ App startup ================
  Future<void> initializeAuth(String? existingToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (existingToken?.isNotEmpty == true) {
      token = existingToken;
      isLoggedIn = true;

      final saved = prefs.getString('user_data');
      if (saved != null) {
        try {
          userData = jsonDecode(saved) as Map<String, dynamic>;
        } catch (_) {
          userData = null;
        }
      }

      biometricSetupDone = prefs.getBool('biometric_setup_done') ?? false;
      passcodeSet = prefs.containsKey('user_passcode');

      // 🛑 Important: Clear previous auth state
      biometricPassed = false;
      passcodePassed = false;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> markBiometricSetupDone() async {
    biometricSetupDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_setup_done', true);
    notifyListeners();
  }

  // ================ Email/password login ================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await AuthApi.login(email: email, password: password);
      final user = response['user'];
      final authToken =
          response['token'] ?? user?['token']?['access']?['token'];

      if (user != null && authToken != null) {
        userData = user as Map<String, dynamic>;
        token = authToken as String;
        isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        // save token
        await prefs.setString('auth_token', token!);
        // ⚡️ persist full userData
        await prefs.setString('user_data', jsonEncode(userData));

        // reset auth flows
        biometricPassed = false;
        passcodeChecked = false;
        passcodePassed = false;
      } else {
        errorMessage = 'Invalid login response';
        isLoggedIn = false;
      }
    } catch (e) {
      final raw = e.toString();
      errorMessage = raw.startsWith('Exception: ')
          ? raw.substring('Exception: '.length)
          : raw;
      isLoggedIn = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await AuthApi.login(email: email, password: password);
      final user = response['user'];
      final authToken =
          response['token'] ?? user?['token']?['access']?['token'];

      if (user != null && authToken != null) {
        userData = user as Map<String, dynamic>;
        token = authToken as String;
        isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token!);
        await prefs.setString('user_data', jsonEncode(userData));

        // ✅ Save user_id separately
        // final userId = userData?['id'];
        final userId =
            (userData?['user'] as Map<String, dynamic>?)?['id'] as int?;
        print("userID->>> $userId");
        if (userId != null) {
          await prefs.setInt('user_id', userId);
        }

        ✅ Upload FCM token
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (userId != null && fcmToken != null) {
          await FcmTokenApi.saveFcmToken(userId: userId, fcmToken: fcmToken);
          print("✅ FCM token sent to backend");
        }

        // Reset auth states
        biometricPassed = false;
        passcodeChecked = false;
        passcodePassed = false;
      } else {
        errorMessage = 'Invalid login response';
        isLoggedIn = false;
      }
    } catch (e) {
      final raw = e.toString();
      errorMessage = raw.startsWith('Exception: ')
          ? raw.substring('Exception: '.length)
          : raw;
      isLoggedIn = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================ Send OTP ================
  Future<void> sendOtp({required String email}) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await AuthApi.sendOtp(email: email);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================ Verify OTP & login ================
  Future<void> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await AuthApi.verifyOtp(userId: userId, otp: otp);
      final user = response['user'];
      String? accessToken;

      // extract token string
      if (response['token'] != null) {
        final t = response['token'];
        if (t is Map<String, dynamic>) {
          accessToken = t['access']?['token'] as String?;
        } else if (t is String) {
          accessToken = t;
        }
      } else if (user?['token'] != null) {
        accessToken = (user['token'] as Map<String, dynamic>)['access']
            ?['token'] as String?;
      }

      if (user != null && accessToken != null) {
        userData = response as Map<String, dynamic>;
        token = accessToken;
        isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', accessToken);
        // ⚡️ persist full userData
        await prefs.setString('user_data', jsonEncode(userData));

        biometricPassed = false;
        passcodeChecked = false;
        passcodePassed = false;
      } else {
        errorMessage = response['message'] ?? 'OTP verification failed';
        isLoggedIn = false;
      }
    } catch (e) {
      errorMessage = e.toString();
      isLoggedIn = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================ Logout ================
  Future<void> logout() async {
    userData = null;
    token = null;
    isLoggedIn = false;
    biometricPassed = false;
    passcodeChecked = false;
    passcodePassed = false;
    biometricSetupDone = false;
    passcodeSet = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    await prefs.remove('user_passcode');
    await prefs.remove('biometric_setup_done');

    notifyListeners();
  }

  // ================ Biometric & Passcode flags ================
  void setBiometricPassed(bool v) {
    biometricPassed = v;
    notifyListeners();
  }

  void setPasscodeChecked(bool v) {
    passcodeChecked = v;
    notifyListeners();
  }

  void setPasscodePassed(bool v) {
    passcodePassed = v;
    notifyListeners();
  }

  // ================ Local Passcode ================
  Future<void> setNewPasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_passcode', passcode);
    passcodeSet = true;

    biometricPassed =
        false; // 🛑 important: disable biometric if passcode is selected
    passcodePassed = true;
    await markBiometricSetupDone();
    notifyListeners();
  }

  Future<bool> verifyPasscode(String attempt) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user_passcode') ?? '';
    return stored == attempt;
  }

  AppState() {
    _loadUseDeviceAuth(); // Load saved value at startup
  }

  Future<void> _loadUseDeviceAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _useDeviceAuth = prefs.getBool('use_device_auth') ?? false;
    notifyListeners(); // Optional if UI depends on it
  }

  Future<void> setUseDeviceAuth(bool enable) async {
    _useDeviceAuth = enable;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_device_auth', enable);
    notifyListeners();
  }

  Future<void> uploadFcmToken(int userId) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FcmTokenApi.saveFcmToken(userId: userId, fcmToken: fcmToken);
      print('✅ FCM token saved successfully');
    } else {
      print('⚠️ FCM token is null');
    }
  }

  void setClients(List<Map<String, dynamic>> newClients) {
    _clients = newClients;
    notifyListeners();
  }

  // ================ Final Auth Check ================
  bool get isFullyAuthenticated =>
      isLoggedIn && (biometricPassed || passcodePassed);
}
