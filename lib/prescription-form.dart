import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io' show Platform;

class PrescriptionForm {
  final Document _document = Document();
  final String clinicName;
  final String clinicAddress;
  final String doctorName;
  final List<String> prescriptions;

  PrescriptionForm({
    required this.clinicName,
    required this.clinicAddress,
    required this.doctorName,
    required this.prescriptions,
  }) {
    _generate();
  }

  void _generate() async {
    // TODO: layout the prescription form (header, page number*, and patient's info)
    // TODO: adjust form layout if prescription exceeds the page
    // TODO: Add footer for doctor's signature
    final header = await _header();
    _document.addPage(
      Page(
        margin: const EdgeInsets.all(24),
        build: (context) => Column(
          children: [
            header,
            Divider(),
            Text(
              'Prescribed on June 15, 2023',
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _header() async {
    final clinicLogo =
        (await rootBundle.load('assets/images/rx.png')).buffer.asUint8List();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          MemoryImage(clinicLogo),
          height: 48,
          width: 48,
        ),
        Expanded(
            child: Column(children: [
          Text(
            clinicName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Text(clinicAddress),
        ])),
        Text(
          'Page 1 of 1',
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _patientInfo() {
    return Column(children: [Text('Name:')]);
  }

  Future<Uint8List> save() => _document.save();
}
