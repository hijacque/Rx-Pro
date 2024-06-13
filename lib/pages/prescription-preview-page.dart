import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/prescription-form.dart';

class _MobileBody extends StatefulWidget {
  const _MobileBody({super.key});

  @override
  State<_MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<_MobileBody> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Text('Mobile'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Prescription'),
      ),
      body: PdfPreview(
        pdfFileName: 'prescription',
        initialPageFormat: PdfPageFormat.a5,
        previewPageMargin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        enableScrollToPage: true,
        // scrollViewDecoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.all(Radius.circular(12)),
        // ),
        allowSharing: false,
        canDebug: false,
        build: (format) => widget.prescriptionForm.save(),
      ),
    );
  }
}

class PrescriptionPreviewPage extends StatelessWidget {
  final List<String> prescriptions;
  late final PrescriptionForm prescriptionForm;

  PrescriptionPreviewPage({super.key, required this.prescriptions}) {
    prescriptionForm = PrescriptionForm(
      clinicName: 'ABCD Clinic',
      clinicAddress: '1234 Somewhere Street, Fiction City',
      doctorName: 'Juan C. Dela Cruz',
      prescriptions: prescriptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayout(layouts: [
        Layout(
          body: _MobileBody(),
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
