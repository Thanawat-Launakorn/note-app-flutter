import 'package:flutter/material.dart';
import 'package:app/common_widget/button.dart';

class AlertErrorDialog extends StatelessWidget {
  const AlertErrorDialog({
    required this.payload,
    required this.context,
    super.key,
  });
  final BuildContext context;
  final dynamic payload;

  static show(BuildContext context, dynamic payload) =>
      showDialog(
        context: context,
        builder:
            (context) => AlertErrorDialog(
              context: context,
              payload: payload,
            ),
      );

  @override
  Widget build(BuildContext context) {
    String manageTitle(String responseStatus) {
      switch (responseStatus) {
        case '400':
          return 'Invalid data. Please try again.';
        case '403':
          return 'Forbidden. Please check your permissions.';
        case '500':
          return 'Server error. Please try again later.';
        case '503':
          return 'Service unavailable. Please try again later.';
        default:
          return 'An unknown error occurred. Please try again.';
      }
    }

    void onClose() {
      Navigator.pop(context);
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    manageTitle(payload['status'] ?? '404'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(payload['message_en'] ?? 'not found'),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Button(
                    title: 'Close',
                    onTap: onClose,
                    type: ButtonType.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
