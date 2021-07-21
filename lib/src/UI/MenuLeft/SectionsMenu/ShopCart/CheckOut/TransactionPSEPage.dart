import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'OrderConfirmationPage.dart';

class TransactionPSEPage extends StatefulWidget {
  @override
  _TransactionPSEPageState createState() => _TransactionPSEPageState();
}

class _TransactionPSEPageState extends State<TransactionPSEPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final prefs = SharePreference();
  ProviderCheckOut providerCheckOut;

  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
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
                child: WebView(
                  initialUrl: providerCheckOut?.paymentPSE?.urlbanco ?? '',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  navigationDelegate: (NavigationRequest request) {
                    print(request.url);
                    if (request.url == Constants.finishTransaction) {
                      Navigator.pushReplacement(context,
                          customPageTransition(OrderConfirmationPage()));
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
