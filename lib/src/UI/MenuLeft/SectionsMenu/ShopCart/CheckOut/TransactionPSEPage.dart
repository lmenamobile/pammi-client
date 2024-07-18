import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'OrderConfirmationPage.dart';

// Import for iOS features.



class TransactionPSEPage extends StatefulWidget {
  @override
  _TransactionPSEPageState createState() => _TransactionPSEPageState();
}

class _TransactionPSEPageState extends State<TransactionPSEPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final prefs = SharePreference();

  ProviderCheckOut? providerCheckOut;
  late ProviderSettings providerSettings;
  final GlobalKey webViewKey = GlobalKey();


  InAppWebViewController? webViewController;



  @override
  void initState() {

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: AppColors.redTour,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              headerView( Strings.confirmationOrder,  () => Navigator.pop(context)),
              Expanded(
                child: providerSettings.hasConnection ?  InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                  URLRequest(url: WebUri(providerCheckOut?.paymentPSE?.urlbanco ?? '')),
                  // initialUrlRequest:
                  // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),

                  // contextMenu: contextMenu,
                 // pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                    print(await controller.getUrl());
                  },
                  onLoadStart: (controller, url) async {
                    setState(() {
                      //this.url = url.toString();
                      //urlController.text = this.url;
                    });
                  },
                  /*onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },*/
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {

                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    if (uri.toString().contains(Constants.finishTransaction)) {
                      Navigator.pushReplacement(context,
                          customPageTransition(OrderConfirmationPage(),PageTransitionType.rightToLeftWithFade));
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    //pullToRefreshController?.endRefreshing();
                    setState(() {
                      //this.url = url.toString();
                      //urlController.text = this.url;
                    });
                  },
                  /*onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                  },*/
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      //pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      //this.progress = progress / 100;
                     // urlController.text = this.url;
                    });
                  },

                  onUpdateVisitedHistory: (controller, url, isReload) {
                    setState(() {
                      //this.url = url.toString();
                      //urlController.text = this.url;
                    });
                  },

                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ):notConnectionInternet(),
              )
                ],
              ),
        ),
              )
    );
  }
}
