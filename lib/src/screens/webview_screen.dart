import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;
  final String allowedUrl; // Used for filtering navigation

  const WebViewScreen({
    Key? key,
    required this.title,
    required this.url,
    required this.allowedUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url != allowedUrl) {
              try {
                await launchUrlString(
                  request.url,
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                toast(
                  'Failed to open link: ${request.url}',
                  print: true,
                );
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WebViewWidget(controller: controller),
    );
  }
}
