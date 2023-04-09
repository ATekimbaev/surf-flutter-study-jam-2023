import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfDetailsPage extends StatelessWidget {
  const PdfDetailsPage({super.key, required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PDFView(
          filePath: filePath,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          swipeHorizontal: true,
        ),
      ),
    );
  }
}
