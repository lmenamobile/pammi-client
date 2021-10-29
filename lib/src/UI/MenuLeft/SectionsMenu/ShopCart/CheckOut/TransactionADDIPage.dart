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

class TransactionADDIPage extends StatefulWidget {
  @override
  _TransactionADDIPageState createState() => _TransactionADDIPageState();
}

class _TransactionADDIPageState extends State<TransactionADDIPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final prefs = SharePreference();
  ProviderCheckOut? providerCheckOut;
  late ProviderSettings providerSettings;

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
                child: providerSettings.hasConnection?WebView(
                  initialUrl: providerCheckOut?.paymentADDI?.urlRedirectLocation ?? '',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  navigationDelegate: (NavigationRequest request) {
                    print(".............url ADDI"+request.url);
                    if (request.url.contains(Constants.finishTransaction)) {
                      Navigator.pushReplacement(context,
                          customPageTransition(OrderConfirmationPage()));
                    }
                    return NavigationDecision.navigate;
                  },
                ):notConnectionInternet(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
