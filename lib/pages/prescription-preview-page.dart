import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:rxpro_app/prescription-form.dart';
import 'package:rxpro_app/doctor.dart';
import 'package:rxpro_app/clinic.dart';
import 'package:rxpro_app/style.dart';

class PrescriptionPreviewPage extends StatefulWidget {
  const PrescriptionPreviewPage({
    super.key,
    required this.doctor,
    required this.clinic,
    required this.prescriptions,
    required this.patientName,
    required this.patientAge,
    required this.patientSex,
  });

  final List<String> prescriptions;
  final Doctor doctor;
  final Clinic clinic;
  final String patientName;
  final String patientAge;
  final String patientSex;

  @override
  State<PrescriptionPreviewPage> createState() =>
      _PrescriptionPreviewPageState();
}

class _PrescriptionPreviewPageState extends State<PrescriptionPreviewPage> {
  late final PrescriptionForm _prescriptionForm;
  bool? _savePrescription;

  @override
  void initState() {
    super.initState();
    Clinic clinic = widget.clinic;
    Doctor doctor = widget.doctor;

    _prescriptionForm = PrescriptionForm(
      clinicName: clinic.name,
      clinicAddress: clinic.address,
      doctorName:
          '${doctor.firstName} ${doctor.middleName[0]}. ${doctor.lastName}, ${doctor.title}',
      prescriptions: widget.prescriptions,
      patientName: widget.patientName,
      patientAge: widget.patientAge,
      patientSex: widget.patientSex,
    );
  }

  Future<bool?> _closePrescriptionDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: const Center(
            child: Text(
              'Close prescription?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Closing will clear this prescription form and create a new blank form.',
                textAlign: TextAlign.start,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Save patient\'s info',
                      style: TextStyle(fontSize: 16),
                    ),
                    value: _savePrescription,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _savePrescription = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: lightButtonStyle,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        );
      },
    );
  }

  void _onClosePrescription() {
    _closePrescriptionDialog().then((bool? reply) {
      if (reply != null && reply) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Print Prescription'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                style: lightButtonStyle,
                onPressed: _onClosePrescription,
                child: const Text('Close'),
              ),
            ),
          ],
        ),
        body: PdfPreview(
          pdfFileName: 'prescription',
          initialPageFormat: PdfPageFormat.a5,
          previewPageMargin: const EdgeInsets.all(12),
          enableScrollToPage: true,
          onPageFormatChanged: _prescriptionForm.updateFormat,
          dynamicLayout: true,
          useActions: true,
          shouldRepaint: true,
          allowSharing: false,
          canDebug: false,
          canChangePageFormat: false,
          build: (format) => _prescriptionForm.save(),
        ),
      ),
    );
  }
}
