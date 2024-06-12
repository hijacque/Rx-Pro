import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io' show Platform;

enum PageFormat { a3, a4, a5, a6 }

class PrescriptionForm {
  final Document _document = Document();
  final String clinicName;
  final String clinicAddress;
  final String doctorName;

  PrescriptionForm({
    required this.clinicName,
    required this.clinicAddress,
    required this.doctorName,
    required List<String> prescriptions,
  }) {
    // TODO: layout the prescription form (header, page number*, and patient's info)
    _document.addPage(Page(build: (Context context) {
      return Center(child: Text('Hello World'));
    }));

    // TODO: adjust form layout if prescription exceeds the page
    // TODO: Add footer for doctor's signature
  }

  Future<Uint8List> save() => _document.save();
}
