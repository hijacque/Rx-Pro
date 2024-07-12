import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:rxpro_app/pages/new-prescription-page.dart';
import 'package:rxpro_app/doctor.dart';
import 'package:rxpro_app/clinic.dart';
import 'package:rxpro_app/style.dart';

class Patient {
  final String firstName;
  final String middleName;
  final String lastName;
  final int sex;
  final DateTime birthDate;
  final String? contact;

  const Patient({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.sex,
    required this.birthDate,
    this.contact,
  });
}

class DeletePatientDialog extends StatefulWidget {
  const DeletePatientDialog({super.key});

  @override
  State<DeletePatientDialog> createState() => _DeletePatientDialogState();
}

class _DeletePatientDialogState extends State<DeletePatientDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: LIGHT,
      surfaceTintColor: Colors.white,
      title: const Text('Are you sure?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Do you want to permanently remove the patient\'s information?'),
          Wrap(
            spacing: 18,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 3,
                  side: const BorderSide(color: LIGHT, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: DANGER, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: INDIGO,
                  shadowColor: Colors.grey,
                  elevation: 3,
                  side: const BorderSide(color: DARK, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: LIGHT, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PatientPage extends StatefulWidget {
  const PatientPage({
    super.key,
    this.doctor,
    this.clinic,
    this.existingPatient,
  });

  final Doctor? doctor;
  final Clinic? clinic;
  final Patient? existingPatient;

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final TextEditingController _firstNameFieldController =
      TextEditingController();
  final TextEditingController _middleNameFieldController =
      TextEditingController();
  final TextEditingController _lastNameFieldController =
      TextEditingController();
  final TextEditingController _birthDateFieldController =
      TextEditingController();
  final FocusNode _birthDateFieldFocusNode = FocusNode();
  final TextEditingController _contactFieldController = TextEditingController();

  String _firstName = '';
  String _middleName = '';
  String _lastName = '';
  String _contact = '';
  int? _sex;
  DateTime? _birthDate;

  Future<void> _selectBirthDate() async {
    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? currentDate,
      firstDate: DateTime(1800),
      lastDate: currentDate,
    );

    if (picked != null && picked != _birthDate) {
      _birthDate = picked;
      _birthDateFieldController.text = DateFormat('MM/dd/yyyy').format(picked);
    }
    setState(() {
      _birthDateFieldFocusNode.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingPatient != null) {
      Patient patient = widget.existingPatient!;
      _firstName = patient.firstName;
      _middleName = patient.middleName;
      _lastName = patient.lastName;
      _contact = patient.contact ?? '';

      _firstNameFieldController.text = _firstName;
      _middleNameFieldController.text = _middleName;
      _lastNameFieldController.text = _lastName;
      _contactFieldController.text = _contact;

      _sex = patient.sex;
      _birthDate = patient.birthDate;
      _birthDateFieldController.text =
          DateFormat('MM/dd/yyyy').format(_birthDate!);
    }

    _birthDateFieldFocusNode.addListener(() {
      if (_birthDateFieldFocusNode.hasFocus) {
        _selectBirthDate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
        elevation: 1,
        centerTitle: (widget.existingPatient == null ||
            widget.doctor == null ||
            widget.clinic == null),
        actions: (widget.existingPatient == null ||
                widget.doctor == null ||
                widget.clinic == null)
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: TextButton(
                    style: lightButtonStyle,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrescriptionPage(
                            doctor: widget.doctor!,
                            clinic: widget.clinic!,
                            existingPatient: widget.existingPatient,
                          ),
                        ),
                      );
                    },
                    child: const Text('   New Prescription   '),
                  ),
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: BLUE,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: lightTextFieldStyle.copyWith(
                  hintText: 'ex: JUAN',
                  label: const Text('FIRST NAME'),
                ),
                controller: _firstNameFieldController,
              ),
              const SizedBox(height: 18),
              TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: BLUE,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _middleName = value;
                  });
                },
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: lightTextFieldStyle.copyWith(
                  hintText: 'ex: CRISOSTOMO',
                  label: const Text('MIDDLE NAME'),
                ),
                controller: _middleNameFieldController,
              ),
              const SizedBox(height: 18),
              TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: BLUE,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: lightTextFieldStyle.copyWith(
                  hintText: 'ex: DELA CRUZ',
                  label: const Text('LAST NAME'),
                ),
                controller: _lastNameFieldController,
              ),
              const SizedBox(height: 18),
              InputDecorator(
                decoration: lightTextFieldStyle.copyWith(
                  label: (_sex != null)
                      ? const Text('SEX ASSIGNED AT BIRTH')
                      : null,
                  contentPadding: const EdgeInsets.only(
                    right: 12,
                    left: 16,
                    top: 3,
                    bottom: 3,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: const TextStyle(
                      fontSize: 14,
                      color: BLUE,
                      fontWeight: FontWeight.w500,
                    ),
                    hint: Text(
                      'SEX ASSIGNED AT BIRTH',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: _sex,
                    items: const [
                      DropdownMenuItem(
                        value: 2,
                        child: Text('FEMALE'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('MALE'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('INTERSEX'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sex = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: BLUE,
                  fontWeight: FontWeight.w500,
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: lightTextFieldStyle.copyWith(
                  hintText: 'MM/DD/YYYY',
                  label: const Text('BIRTH DATE'),
                ),
                readOnly: true,
                controller: _birthDateFieldController,
                focusNode: _birthDateFieldFocusNode,
              ),
              const SizedBox(height: 18),
              TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: BLUE,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _contact = value;
                  });
                },
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: lightTextFieldStyle.copyWith(
                  hintText: 'Telephone / Mobile',
                  label: const Text('CONTACT NO.'),
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 18,
                children: [
                  TextButton(
                    onPressed: () {
                      String? errorMessage;

                      if (_firstName.isEmpty ||
                          _middleName.isEmpty ||
                          _lastName.isEmpty) {
                        errorMessage = 'Incomplete name. Please fill fields.';
                      } else if (_birthDate == null) {
                        errorMessage = 'Please provide missing birthdate.';
                      } else if (_sex == null) {
                        errorMessage =
                            'Please choose your sex assigned at birth accordingly.';
                      }

                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage),
                          duration:
                              const Duration(seconds: 1, milliseconds: 300),
                        ));
                        return;
                      }

                      Navigator.pop(
                        context,
                        Patient(
                          firstName: _firstName,
                          middleName: _middleName,
                          lastName: _lastName,
                          sex: _sex ?? 1,
                          birthDate: _birthDate ?? DateTime.now(),
                          contact: _contact.isEmpty ? null : _contact,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: INDIGO,
                      shadowColor: Colors.grey,
                      elevation: 3,
                      side: const BorderSide(color: DARK, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: LIGHT, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 3,
                      side: const BorderSide(color: LIGHT, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: DARK, fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: widget.existingPatient != null,
                    child: TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => const DeletePatientDialog(),
                        ).then((deleteConfirmed) {
                          if (deleteConfirmed != null && deleteConfirmed) {
                            Navigator.pop(context, false);
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 3,
                        side: const BorderSide(color: LIGHT, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: DANGER, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class PatientPage extends StatelessWidget {
//   const PatientPage({
//     Key? key,
//     // required this.doctor,
//     // required this.clinic,
//     // this.firstName,
//     // this.middleName,
//     // this.lastName,
//     // this.birthDate,
//     // this.sex,
//     // this.contact,
//   }) : super(key: key);
//
//   // final Doctor doctor;
//   // final Clinic clinic;
//   //
//   // final String? firstName;
//   // final String? middleName;
//   // final String? lastName;
//   // final DateTime? birthDate;
//   // final int? sex;
//   // final String? contact;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ResponsiveLayout(layouts: [
//         Layout(
//           body: Scaffold(
//             appBar: AppBar(),
//             backgroundColor: Colors.green,
//             body: Center(
//               child: Text('Mobile View'),
//             ),
//           ),
//           breakpoint: 600,
//         ),
//         Layout(
//           body: Scaffold(
//             appBar: AppBar(),
//             backgroundColor: Colors.blueAccent,
//             body: Center(
//               child: Text('Desktop View'),
//             ),
//           ),
//           breakpoint: double.infinity,
//         ),
//       ]),
//     );
//   }
// }
