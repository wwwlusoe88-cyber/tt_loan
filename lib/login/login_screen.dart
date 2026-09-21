import 'package:flutter/material.dart';
import 'logic_logic.dart';
import '../global/utility/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginLogic _logic = LoginLogic();

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedBuilder(
              animation: _logic,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Icon / Logo
                      const Center(
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 56,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _logic.isRegisterMode ? 'အကောင့်အသစ်ဖွင့်ရန်' : 'tt_loan သို့ ဝင်ရောက်ရန်',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _logic.isRegisterMode 
                          ? 'ကျေးဇူးပြု၍ အချက်အလက်များ ဖြည့်သွင်းပါ' 
                          : 'သင့်ဖုန်းနံပါတ်နှင့် PIN ဖြင့် ဝင်ရောက်ပါ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Name Field (Register Mode Only)
                      if (_logic.isRegisterMode) ...[
                        TextField(
                          controller: _logic.nameController,
                          decoration: InputDecoration(
                            labelText: 'နာမည် (သို့) လုပ်ငန်းအမည်',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Phone Number Field
                      TextField(
                        controller: _logic.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'ဖုန်းနံပါတ် (ဥပမာ - 09XXXXXXXXX)',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PIN Field
                      TextField(
                        controller: _logic.pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'လော့ဂ်အင်နံပါတ် (PIN)',
                          prefixIcon: const Icon(Icons.lock_outline),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _logic.isLoading 
                          ? null 
                          : () async {
                              bool success = await _logic.handleAuth(context);
                              if (success && !_logic.isRegisterMode) {
                                // TODO: Navigate to Home Screen / Dashboard
                              } else if (success && _logic.isRegisterMode) {
                                _logic.toggleMode(); // Switch back to login after successful register
                              }
                            },
                        child: _logic.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          : Text(
                              _logic.isRegisterMode ? 'အကောင့်ဖွင့်မည်' : 'လော့ဂ်အင်ဝင်မည်',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Toggle Register / Login Mode
                      TextButton(
                        onPressed: _logic.toggleMode,
                        child: Text(
                          _logic.isRegisterMode 
                            ? 'အကောင့်ရှိပြီးသားလား? လော့ဂ်အင်ဝင်ရန်' 
                            : 'အကောင့်မရှိသေးဘူးလား? ဖုန်းနံပါတ်ဖြင့် အကောင့်ဖွင့်ရန်',
                          style: const TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
