import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

// Custom dialog widget to pick mail app
class CustomMailAppPickerDialog extends StatelessWidget {
  final List<MailApp> mailApps;

  CustomMailAppPickerDialog({required this.mailApps});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Mail App"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...mailApps.map((mailApp) {
            return ListTile(
              leading: SizedBox.shrink(),
              // title: Text(mailApp.name),
              onTap: () {
                OpenMailApp.openSpecificMailApp(mailApp);
                Navigator.of(context).pop(); // Close the dialog
              },
            );
          }).toList(),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
