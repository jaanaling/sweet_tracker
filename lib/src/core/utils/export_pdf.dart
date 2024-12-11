import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

// Общий метод экспорта
Future<Uint8List> exportToPDF({
  required String title,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
