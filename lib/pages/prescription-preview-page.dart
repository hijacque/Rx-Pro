import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/prescription-form.dart';
import 'package:rxpro_app/style.dart';

class _MobileBody extends StatefulWidget {
  final PrescriptionForm prescriptionForm;
  const _MobileBody({super.key, required this.prescriptionForm});

  @override
  State<_MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<_MobileBody> {
  bool? _savePrescription = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Prescription'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              style: lightButtonStyle,
              onPressed: () async {
                final bool? reply = await _closePrescriptionDialog();
                if (reply != null) {
                  Navigator.pop(context, reply);
                }
              },
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
        onPageFormatChanged: widget.prescriptionForm.updateFormat,
        dynamicLayout: true,
        useActions: true,
        shouldRepaint: true,
        allowSharing: false,
        canDebug: false,
        canChangePageFormat: false,
        build: (format) => widget.prescriptionForm.save(),
      ),
    );
  }
}

class _DesktopBody extends StatefulWidget {
  final PrescriptionForm prescriptionForm;
  const _DesktopBody({super.key, required this.prescriptionForm});

  @override
  State<_DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<_DesktopBody> {
  bool? _savePrescription = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Prescription'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              style: lightButtonStyle,
              onPressed: () async {
                final bool? reply = await _closePrescriptionDialog();
                if (reply != null) {
                  Navigator.pop(context, reply);
                }
              },
              child: const Text('Close'),
            ),
          ),
        ],
      ),
      body: PdfPreview(
        pdfFileName: 'prescription',
        initialPageFormat: PdfPageFormat.a5,
        previewPageMargin:
            const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        enableScrollToPage: true,
        onPageFormatChanged: widget.prescriptionForm.updateFormat,
        dynamicLayout: true,
        useActions: true,
        shouldRepaint: true,
        allowSharing: false,
        canDebug: false,
        canChangePageFormat: false,
        build: (format) => widget.prescriptionForm.save(),
      ),
    );
  }
}

class PrescriptionPreviewPage extends StatelessWidget {
  final List<String> prescriptions;
  final String patientName;
  final String patientAge;
  final String patientSex;

  late final PrescriptionForm prescriptionForm;

  PrescriptionPreviewPage({
    super.key,
    required this.prescriptions,
    required this.patientName,
    required this.patientAge,
    required this.patientSex,
  }) {
    prescriptionForm = PrescriptionForm(
      clinicName: 'The Medical City Clinic - Trinoma',
      clinicAddress: 'LM1 Trinoma, North Ave., Quezon City',
      doctorName: 'Janice Kristine D. Refe-Friolo, MD FPCP DPSN',
      prescriptions: prescriptions,
      patientName: patientName,
      patientAge: patientAge,
      patientSex: patientSex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayout(layouts: [
        Layout(
          body: _MobileBody(prescriptionForm: prescriptionForm),
          breakpoint: 600,
        ),
        Layout(
          body: _DesktopBody(prescriptionForm: prescriptionForm),
          breakpoint: double.infinity,
        ),
      ]),
    );
  }
}
