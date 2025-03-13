import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shop/src/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final VoidCallback? onPaymentSuccess;

  const PaymentWebViewScreen(
      {super.key, required this.checkoutUrl, this.onPaymentSuccess});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController? _controller;
  bool _isLoading = true;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            _controller?.runJavaScript(
                "document.querySelectorAll('[data-elementor-type=\"footer\"], [data-elementor-type=\"header\"]').forEach(el => el.remove());");

            setState(() {
              _showOverlay = false;
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              headerBackgroundColor: sandDuneColor,
              barrierDismissible: true, // Make the alert closable
              confirmBtnColor: primaryColor,
              autoCloseDuration: Duration(seconds: 3),
              onConfirmBtnTap: () {
                Navigator.of(context).pop(); // Close the alert
                Navigator.of(context).pop(); // Close the page
              },
              text: "An error occurred. Please try again.",
            );
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains("/thank-you/")) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                headerBackgroundColor: sandDuneColor,
                barrierDismissible: true, // Make the alert closable
                confirmBtnColor: primaryColor,
                onConfirmBtnTap: () {
                  widget.onPaymentSuccess?.call();
                  Navigator.of(context).pop(); // Close the alert
                  Navigator.of(context).pop(); // Close the page
                },
                text: "We've received your payment. Thank you!",
              );

              // Handle successful payment (redirect user)
            } else if (request.url.contains("/checkout/?cancel") ||
                request.url.contains("/my-account/")) {
              // Handle payment cancellation
              Navigator.pop(context, "cancel");
              return NavigationDecision.prevent;
            } else if (request.url.contains("whatsapp.com")) {
              // Open WhatsApp links in external app
              if (await canLaunchUrlString(request.url)) {
                await launchUrlString(request.url,
                    mode: LaunchMode.externalNonBrowserApplication);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  void dispose() {
    _controller?.clearCache();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller!,
          ),
          if (_showOverlay)
            Container(
              color: Colors.white,
              child: Center(
                  child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.white,
                rightDotColor: sandDuneColor,
                size: 30,
              )),
            ),
          if (_isLoading)
            Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.white,
                rightDotColor: sandDuneColor,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}
