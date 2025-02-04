import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../Utils/Strings.dart';

class DataProtectionPolicyPdfView extends StatefulWidget {
  final String pdfPath;

  DataProtectionPolicyPdfView({required this.pdfPath});

  @override
  _DataProtectionPolicyPdfViewState createState() => _DataProtectionPolicyPdfViewState();
}

class _DataProtectionPolicyPdfViewState extends State<DataProtectionPolicyPdfView> {
  late PDFViewController pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.policiesPamiiTitle),
      ),
      body: PDF().cachedFromUrl(
        widget.pdfPath,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
