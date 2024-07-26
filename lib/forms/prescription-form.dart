import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

class PrescriptionForm {
  final Document _document = Document();
  final String clinicName;
  final String clinicAddress;
  final String doctorName;
  final List<String> prescriptions;
  final String patientName;
  final String patientAge;
  final String patientSex;
  final DateTime datePrescribed;

  late final int totalPages;

  PrescriptionForm({
    required this.clinicName,
    required this.clinicAddress,
    required this.doctorName,
    required this.prescriptions,
    required this.patientName,
    required this.patientAge,
    required this.patientSex,
    required this.datePrescribed,
  }) {
    _generate();
    totalPages = 1;
  }

  void _generate({PdfPageFormat format = PdfPageFormat.a5}) async {
    final header = await _header();
    _document.addPage(
      MultiPage(
        orientation: PageOrientation.portrait,
        margin: const EdgeInsets.all(24),
        pageFormat: format,
        header: (context) => Column(children: [
          header,
          Divider(height: 1.2),
          SizedBox(height: 8),
        ]),
        footer: (context) => Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.8)),
                ),
                child: Text(
                  doctorName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text('Physician\'s Signature over Printed Name'),
            ],
          ),
        ),
        build: (context) {
          return [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text('Patient\'s Information'),
            ),
            _dataEntry(label: 'Name', value: patientName),
            SizedBox(height: 8),
            Wrap(
              spacing: 18,
              children: [
                _dataEntry(label: 'Age', value: patientAge),
                _dataEntry(label: 'Sex', value: patientSex),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8, bottom: 14),
              alignment: Alignment.center,
              child: Text('Drug Prescription'),
            ),
            ListView.builder(
              spacing: 10,
              padding: const EdgeInsets.only(left: 12),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${index + 1}.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        prescriptions[index],
                        style: const TextStyle(fontSize: 11, lineSpacing: 3),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                );
              },
              itemCount: prescriptions.length,
            ),
          ];
        },
      ),
    );
  }

  Future<Widget> _header() async {
    final clinicLogo =
        (await rootBundle.load('assets/images/rx.png')).buffer.asUint8List();
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          MemoryImage(clinicLogo),
          height: 48,
          width: 48,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinicName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                clinicAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text(
                  'Prescribed on ${DateFormat.yMMMMd().format(datePrescribed)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        (totalPages > 1)
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Page 1 of 1',
                  style: const TextStyle(fontSize: 8),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _dataEntry({
    required String label,
    required String value,
    bool isUnderlined = true,
  }) {
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: (isUnderlined)
              ? const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.8)),
                )
              : null,
          padding: EdgeInsets.only(
            right: (isUnderlined) ? 8 : 0,
            left: (isUnderlined) ? 8 : 0,
            bottom: 0.3,
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> save() => _document.save();

  void updateFormat(PdfPageFormat format) async {
    final header = await _header();
    _document.editPage(
      0,
      MultiPage(
        margin: const EdgeInsets.all(24),
        pageFormat: format,
        orientation: PageOrientation.landscape,
        build: (context) => [
          Column(
            children: [
              header,
              Divider(),
              Text(
                'Prescribed on June 15, 2023',
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
