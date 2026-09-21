import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // ==================== 1. CURRENCY FORMAT (KS) ====================
  static String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '${formatter.format(amount)} ks';
  }

  // Text ထဲက input တွေကို calculation အတွက် Double ပြောင်းရန်
  static double parseCurrency(String value) {
    if (value.isEmpty) return 0.0;
    String cleanValue = value.replaceAll(',', '').replaceAll('ks', '').trim();
    return double.tryParse(cleanValue) ?? 0.0;
  }

  // ==================== 2. DATE FORMAT ====================
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static String getCurrentTimestamp() {
    return DateTime.now().toIso8601String();
  }

  // ==================== 3. TOP DROPDOWN TOAST ====================
  static void showTopToast(
    BuildContext context, 
    String message, {
    bool isSuccess = true,
  }) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * -50),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  // ==================== 4. COMPACT PREMIUM DIALOG ====================
  static Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('မလုပ်တော့ပါ', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E3A8A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(confirmText, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ==================== 5. VALIDATIONS ====================
  static bool isValidPhoneNumber(String phone) {
    // မြန်မာဖုန်းနံပါတ် ဖော်မတ်စစ်ဆေးရန် (ဥပမာ - 09XXXXXXXXX)
    final regExp = RegExp(r'^(09|\+959)\d{7,9}$');
    return regExp.hasMatch(phone);
  }
}
