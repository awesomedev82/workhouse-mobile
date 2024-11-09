import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          progressNotifier.value = progress;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Link copied to clipboard")),
    );
  }

  Future<void> _openInBrowser() async {
    if (await canLaunchUrl(Uri.parse(widget.url))) {
      await launchUrl(Uri.parse(widget.url),
          mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open link")),
      );
    }
  }

  Future<void> _shareLink() async {
    await Share.share(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              widget.url,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  _copyLink();
                  break;
                case 'open_browser':
                  _openInBrowser();
                  break;
                case 'share':
                  _shareLink();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.link, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Copy Link"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'open_browser',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Open in Browser"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Share"),
                  ],
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: ValueListenableBuilder<int>(
            valueListenable: progressNotifier,
            builder: (context, progress, child) {
              return progress < 100
                  ? LinearProgressIndicator(
                      value: progress / 100,
                      color: Colors.black,
                      backgroundColor: Colors.grey.shade400,
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
