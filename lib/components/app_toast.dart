import 'package:flutter/material.dart';
import 'custom_toast.dart';

void showAppToast(BuildContext context, String message) {
  OverlayState overlayState = Overlay.of(context);
  late OverlayEntry
      overlayEntry; // Use late keyword so it can be referenced within the CustomToast callback

  overlayEntry = OverlayEntry(
    builder: (context) => CustomToast(
      message: message,
      duration: Duration(seconds: 3),
      onDismiss: () {
        overlayEntry.remove(); // Remove the overlay entry directly
      },
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the overlay entry after the duration
  Future.delayed(Duration(seconds: 3) + Duration(milliseconds: 500), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
