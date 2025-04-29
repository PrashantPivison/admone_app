// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../app_state.dart';
// import '../../config/Animation/righttoleft_animation.dart';
// import '../../main.dart';
//
// class SetPasscodeScreen extends StatefulWidget {
//   const SetPasscodeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
// }
//
// class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
//   final _passCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   String? _error;
//
//   Future<void> _onSave() async {
//     final p1 = _passCtrl.text.trim();
//     final p2 = _confirmCtrl.text.trim();
//
//     if (p1.length != 4 || p1 != p2) {
//       setState(() => _error = 'Passcode must be 4 digits and match');
//       return;
//     }
//
//     final appState = Provider.of<AppState>(context, listen: false);
//     await appState.setNewPasscode(p1);
//
//     // Mark biometric setup done if passcode is set
//     await appState.markBiometricSetupDone();
//
//     Navigator.of(context).pushAndRemoveUntil(
//       createRightToLeftRoute(const BottomNavScreen()),
//       (_) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Passcodess')),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _passCtrl,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               maxLength: 4,
//               decoration:
//                   const InputDecoration(labelText: 'Enter 4‑digit passcode'),
//             ),
//             TextField(
//               controller: _confirmCtrl,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               maxLength: 4,
//               decoration: const InputDecoration(labelText: 'Confirm passcode'),
//             ),
//             if (_error != null) ...[
//               const SizedBox(height: 12),
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//             ],
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _onSave,
//               child: const Text('Save Passcode'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../config/theme.dart';
import '../../main.dart' show BottomNavScreen;

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({Key? key}) : super(key: key);

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _error;
  bool _isSaving = false;

  Future<void> _onSave() async {
    final p1 = _passCtrl.text.trim();
    final p2 = _confirmCtrl.text.trim();

    if (p1.length != 4 || p2.length != 4) {
      setState(() => _error = 'Passcode must be 4 digits');
      return;
    }

    if (p1 != p2) {
      setState(() => _error = 'Passcodes do not match');
      return;
    }

    setState(() {
      _error = null;
      _isSaving = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.setNewPasscode(p1);

      // Mark biometric setup done if passcode is set
      await appState.markBiometricSetupDone();

      Navigator.of(context).pushAndRemoveUntil(
        createRightToLeftRoute(const BottomNavScreen()),
            (_) => false,
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // _buildLogo(),
              const SizedBox(height: 24),
              _buildTitle('Create Passcode'),
              const SizedBox(height: 12),
              _buildSubtitle('Set a 4-digit passcode for security'),
              const SizedBox(height: 24),
              _buildPasscodeField('Enter 4-digit passcode', _passCtrl),
              const SizedBox(height: 16),
              _buildPasscodeField('Confirm passcode', _confirmCtrl),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              _buildSaveButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildLogo() {
  //   return Image.asset(
  //     'assets/images/logo.png',
  //     height: 40,
  //     errorBuilder: (_, __, ___) => const Icon(
  //       Icons.broken_image,
  //       size: 60,
  //       color: Colors.grey,
  //     ),
  //   );
  // }

  Widget _buildTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildPasscodeField(String labelText, TextEditingController controller) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        decoration: _buildInputDecoration(
          labelText: labelText,
          prefixIcon: Icons.lock_outline,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: CustomColors.textField),
      counterText: '',
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(prefixIcon, color: CustomColors.textField),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColors.textField),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: CustomColors.textField.withOpacity(0.8),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        child: _isSaving
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text('Save Passcode'),
      ),
    );
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
}