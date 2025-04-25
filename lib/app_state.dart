// import 'package:flutter/foundation.dart';
// import 'package:my_app/backend/api_requests/auth_api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AppState extends ChangeNotifier {
//   bool isLoading = false;
//   bool isLoggedIn = false;
//   bool biometricPassed = false;
//   bool passcodeChecked = false; // Have we shown passcode screen?
//   bool passcodePassed = false; // Did they enter it OK?
//   bool passcodeSet = false; // Has user ever set a PIN?
//   String errorMessage = '';

//   Map<String, dynamic>? userData;
//   String? token;

//   // ================ App startup ================
//   Future<void> initializeAuth(String? existingToken) async {
//     if (existingToken?.isNotEmpty == true) {
//       token = existingToken;
//       isLoggedIn = true;
//       biometricPassed = false;
//       passcodeChecked = false;
//       passcodePassed = false;
//     } else {
//       isLoggedIn = false;
//     }
//     final prefs = await SharedPreferences.getInstance();
//     passcodeSet = prefs.containsKey('user_passcode');
//     notifyListeners();
//   }

//   // ================ Email/password login ================
//   Future<void> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       final response = await AuthApi.login(email: email, password: password);
//       final user = response['user'];

//       final authToken =
//           response['token'] ?? user?['token']?['access']?['token'];

//       if (user != null && authToken != null) {
//         userData = user;
//         token = authToken as String;
//         isLoggedIn = true;

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token!);

//         biometricPassed = false;
//         passcodeChecked = false;
//         passcodePassed = false;
//       } else {
//         errorMessage = 'Invalid login response';
//         isLoggedIn = false;
//       }
//     } catch (e) {
//       errorMessage = e.toString();
//       isLoggedIn = false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ================ Send OTP ================
//   Future<void> sendOtp({required String email}) async {
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       await AuthApi.sendOtp(email: email);
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ================ Verify OTP & login ================
//   Future<void> verifyOtp({
//     required int userId,
//     required String otp,
//   }) async {
//     isLoading = true;
//     errorMessage = '';
//     notifyListeners();

//     try {
//       final response = await AuthApi.verifyOtp(userId: userId, otp: otp);
//       final user = response['user'];
//       print('user->>>>>> → $response');
//       // Extract only the access token string
//       String? accessToken;
//       if (response['token'] != null) {
//         final tokenObj = response['token'];
//         if (tokenObj is Map<String, dynamic>) {
//           accessToken = tokenObj['access']?['token'] as String?;
//         } else if (tokenObj is String) {
//           // in case your API ever just returns a raw string
//           accessToken = tokenObj;
//         }
//       } else if (user?['token'] != null) {
//         // fallback if your API nests it under `user`
//         final userToken = user['token'] as Map<String, dynamic>;
//         accessToken = userToken['access']?['token'] as String?;
//       }

//       // Debug
//       print('accessToken → $accessToken');

//       if (user != null && accessToken != null) {
//         userData = response;
//         token = accessToken;
//         isLoggedIn = true;

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', accessToken);

//         // reset your flows
//         biometricPassed = false;
//         passcodeChecked = false;
//         passcodePassed = false;
//       } else {
//         errorMessage = response['message'] ?? 'OTP verification failed';
//         isLoggedIn = false;
//       }
//     } catch (e) {
//       errorMessage = e.toString();
//       isLoggedIn = false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ================ Logout ================
//   Future<void> logout() async {
//     userData = null;
//     token = null;
//     isLoggedIn = false;
//     biometricPassed = false;
//     passcodeChecked = false;
//     passcodePassed = false;

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');

//     notifyListeners();
//   }

//   // ================ Biometric & Passcode flags ================
//   void setBiometricPassed(bool v) {
//     biometricPassed = v;
//     notifyListeners();
//   }

//   void setPasscodeChecked(bool v) {
//     passcodeChecked = v;
//     notifyListeners();
//   }

//   void setPasscodePassed(bool v) {
//     passcodePassed = v;
//     notifyListeners();
//   }

//   // ================ Local Passcode ================
//   Future<void> setNewPasscode(String passcode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_passcode', passcode);
//     passcodeSet = true;
//     passcodeChecked = true;
//     passcodePassed = true;
//     notifyListeners();
//   }

//   Future<bool> verifyPasscode(String attempt) async {
//     final prefs = await SharedPreferences.getInstance();
//     final stored = prefs.getString('user_passcode') ?? '';
//     return stored == attempt;
//   }

//   // ================ Final Auth Check ================
//   bool get isFullyAuthenticated =>
//       isLoggedIn && (biometricPassed || passcodePassed);
// }

// lib/app_state.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/backend/api_requests/auth_api.dart';

class AppState extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  bool biometricPassed = false;
  bool passcodeChecked = false; // Have we shown passcode screen?
  bool passcodePassed = false; // Did they enter it OK?
  bool passcodeSet = false; // Has user ever set a PIN?
  String errorMessage = '';

  Map<String, dynamic>? userData;
  String? token;

  // ================ App startup ================
  Future<void> initializeAuth(String? existingToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (existingToken?.isNotEmpty == true) {
      // restore token and logged‑in state
      token = existingToken;
      isLoggedIn = true;

      // restore userData if we saved it previously
      final saved = prefs.getString('user_data');
      if (saved != null) {
        try {
          userData = jsonDecode(saved) as Map<String, dynamic>;
        } catch (_) {
          userData = null;
        }
      }

      // reset any auth flows
      biometricPassed = false;
      passcodeChecked = false;
      passcodePassed = false;
    } else {
      isLoggedIn = false;
    }

    // detect if user has ever set a PIN
    passcodeSet = prefs.containsKey('user_passcode');
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
      errorMessage = e.toString();
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // ⚡️ clear persisted userData
    await prefs.remove('user_data');

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
    passcodeChecked = true;
    passcodePassed = true;
    notifyListeners();
  }

  Future<bool> verifyPasscode(String attempt) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user_passcode') ?? '';
    return stored == attempt;
  }

  // ================ Final Auth Check ================
  bool get isFullyAuthenticated =>
      isLoggedIn && (biometricPassed || passcodePassed);
}
