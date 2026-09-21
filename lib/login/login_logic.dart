import 'package:flutter/material.dart';
import '../database/local_database.dart';
import '../global/utility/utils.dart';

class LoginLogic extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;
  bool isRegisterMode = false;

  void toggleMode() {
    isRegisterMode = !isRegisterMode;
    phoneController.clear();
    pinController.clear();
    nameController.clear();
    notifyListeners();
  }

  Future<bool> handleAuth(BuildContext context) async {
    final phone = phoneController.text.trim();
    final pin = pinController.text.trim();
    final name = nameController.text.trim();

    if (phone.isEmpty || pin.isEmpty || (isRegisterMode && name.isEmpty)) {
      AppUtils.showTopToast(context, 'အချက်အလက်များကို အပြည့်အစုံ ဖြည့်သွင်းပါ', isSuccess: false);
      return false;
    }

    if (!AppUtils.isValidPhoneNumber(phone)) {
      AppUtils.showTopToast(context, 'ဖုန်းနံပါတ် ပုံစံ မမှန်ကန်ပါ (ဥပမာ - 09XXXXXXXXX)', isSuccess: false);
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      if (isRegisterMode) {
        // Register New User
        final existingUser = await LocalDatabase.instance.getUserByPhone(phone);
        if (existingUser != null) {
          AppUtils.showTopToast(context, 'ဤဖုန်းနံပါတ်ဖြင့် အကောင့်ရှိနှင့်ပြီးသား ဖြစ်ပါသည်', isSuccess: false);
          isLoading = false;
          notifyListeners();
          return false;
        }

        final userMap = {
          'phone': phone,
          'name': name,
          'pin': pin,
          'is_premium': 0,
          'expiry_date': null,
          'updated_at': AppUtils.getCurrentTimestamp(),
        };

        await LocalDatabase.instance.upsertUser(userMap);
        AppUtils.showTopToast(context, 'အကောင့်ဖွင့်ခြင်း အောင်မြင်ပါသည်', isSuccess: true);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Login User
        final user = await LocalDatabase.instance.getUserByPhone(phone);
        if (user == null) {
          AppUtils.showTopToast(context, 'ဤဖုန်းနံပါတ်ဖြင့် အကောင့်မရှိသေးပါ', isSuccess: false);
          isLoading = false;
          notifyListeners();
          return false;
        }

        if (user['pin'] != pin) {
          AppUtils.showTopToast(context, 'လော့ဂ်အင်နံပါတ် (PIN) မှားယွင်းနေပါသည်', isSuccess: false);
          isLoading = false;
          notifyListeners();
          return false;
        }

        AppUtils.showTopToast(context, 'အကောင့်ဝင်ရောက်ခြင်း အောင်မြင်ပါသည်', isSuccess: true);
        isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      AppUtils.showTopToast(context, 'မှားယွင်းမှု တစ်စုံတစ်ရာ ရှိနေပါသည်', isSuccess: false);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
