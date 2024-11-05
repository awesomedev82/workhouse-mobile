import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    log('Initializing WebView...');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          log('WebView is loading (progress: $progress%)');
          progressNotifier.value = progress;
        },
        // other delegate methods...
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(automaticallyImplyLeading: false),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: ValueListenableBuilder<int>(
            valueListenable: progressNotifier,
            builder: (context, progress, child) {
              return progress < 100
                  ? LinearProgressIndicator(
                      value: progress / 100,
                      color: Colors.black,
                      backgroundColor: Colors.black,
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
