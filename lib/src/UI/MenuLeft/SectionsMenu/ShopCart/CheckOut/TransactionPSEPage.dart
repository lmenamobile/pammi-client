import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'OrderConfirmationPage.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class TransactionPSEPage extends StatefulWidget {
  @override
  _TransactionPSEPageState createState() => _TransactionPSEPageState();
}

class _TransactionPSEPageState extends State<TransactionPSEPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final prefs = SharePreference();
  WebViewController _controller2 = WebViewController();
  ProviderCheckOut? providerCheckOut;
  late ProviderSettings providerSettings;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      final WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },

            onPageStarted: (String url) {},
            onPageFinished: (String url) {},

            onWebResourceError: (WebResourceError error) {
              print("ocurrio un error ________________ $error");
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains(Constants.finishTransaction)) {
                Navigator.pushReplacement(context,
                    customPageTransition(OrderConfirmationPage()));
              }
              return NavigationDecision.navigate;
            },
          ),
        )..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(providerCheckOut?.paymentPSE?.urlbanco ?? '',));
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
      // #enddocregion platform_features

      _controller2 = controller;

      setState(() {

      });
    });




    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              titleBar(Strings.confirmationOrder, "ic_blue_arrow.png",
                  () => Navigator.pop(context)),
              Expanded(
                child: providerSettings.hasConnection?WebViewWidget(
                 controller: _controller2,
                ):notConnectionInternet(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
