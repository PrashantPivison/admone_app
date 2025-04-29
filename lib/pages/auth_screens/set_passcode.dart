import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../config/Animation/righttoleft_animation.dart';
import '../../main.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({Key? key}) : super(key: key);

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _error;

  Future<void> _onSave() async {
    final p1 = _passCtrl.text.trim();
    final p2 = _confirmCtrl.text.trim();

    if (p1.length != 4 || p1 != p2) {
      setState(() => _error = 'Passcode must be 4 digits and match');
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.setNewPasscode(p1);

    // Mark biometric setup done if passcode is set
    await appState.markBiometricSetupDone();

    Navigator.of(context).pushAndRemoveUntil(
      createRightToLeftRoute(const BottomNavScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Passcode')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration:
                  const InputDecoration(labelText: 'Enter 4‑digit passcode'),
            ),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'Confirm passcode'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text('Save Passcode'),
            ),
          ],
        ),
      ),
    );
  }
}
