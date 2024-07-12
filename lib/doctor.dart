import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:rxpro_app/style.dart';

class Doctor {
  final String firstName;
  final String lastName;
  final String middleName;
  final String title;
  final String? specialty;
  final String? contact;

  const Doctor({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.title,
    this.specialty,
    this.contact,
  });
}

class DoctorInfoDialog extends StatefulWidget {
  const DoctorInfoDialog({super.key, this.existingDoctor});
  final Doctor? existingDoctor;

  @override
  State<DoctorInfoDialog> createState() => _DoctorInfoDialogState();
}

class _DoctorInfoDialogState extends State<DoctorInfoDialog> {
  final TextEditingController _firstNameFieldController =
  TextEditingController();
  final TextEditingController _lastNameFieldController =
  TextEditingController();
  final TextEditingController _middleNameFieldController =
  TextEditingController();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _contactFieldController = TextEditingController();
  final TextEditingController _specialtyFieldController =
  TextEditingController();

  bool? _hasFirstName;
  bool? _hasMiddleName;
  bool? _hasLastName;

  @override
  void initState() {
    super.initState();
    if (widget.existingDoctor != null) {
      _firstNameFieldController.text = widget.existingDoctor!.firstName;
      _lastNameFieldController.text = widget.existingDoctor!.lastName;
      _middleNameFieldController.text = widget.existingDoctor!.middleName;

      _titleFieldController.text = widget.existingDoctor!.title;
      _specialtyFieldController.text = widget.existingDoctor?.specialty ?? '';
      _contactFieldController.text = widget.existingDoctor?.contact ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      scrollable: true,
      backgroundColor: LIGHT,
      surfaceTintColor: Colors.white,
      title: const Text('About doctor'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: JUAN',
                label: const Text('FIRST NAME'),
                error: _hasFirstName == null
                    ? null
                    : !_hasFirstName!
                    ? const Text('Required field')
                    : null,
              ),
              controller: _firstNameFieldController,
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: CRISOSTOMO',
                label: const Text('MIDDLE NAME'),
                error: _hasMiddleName == null
                    ? null
                    : !_hasMiddleName!
                    ? const Text('Required field')
                    : null,
              ),
              controller: _middleNameFieldController,
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: DELA CRUZ',
                label: const Text('LAST NAME'),
                error: _hasLastName == null
                    ? null
                    : !_hasLastName!
                    ? const Text('Required field')
                    : null,
              ),
              controller: _lastNameFieldController,
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: OB/GYN MD',
                label: const Text('TITLE'),
              ),
              controller: _titleFieldController,
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: Nephrology',
                label: const Text('Specialty'),
              ),
              controller: _specialtyFieldController,
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'Telephone / Mobile ',
                label: const Text('Contact no.'),
              ),
              controller: _contactFieldController,
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 18,
              children: [
                TextButton(
                  onPressed: () {
                    String firstName = _firstNameFieldController.value.text;
                    String middleName = _middleNameFieldController.value.text;
                    String lastName = _lastNameFieldController.value.text;

                    setState(() {
                      _hasFirstName = firstName.isNotEmpty;
                      _hasMiddleName = middleName.isNotEmpty;
                      _hasLastName = lastName.isNotEmpty;
                    });

                    Timer errorTimer =
                    Timer(const Duration(milliseconds: 900), () {
                      print('remove error');
                      setState(() {
                        _hasFirstName = null;
                        _hasMiddleName = null;
                        _hasLastName = null;
                      });
                    });

                    if (_hasFirstName! && _hasMiddleName! && _hasLastName!) {
                      errorTimer.cancel();
                      String title = _titleFieldController.value.text;
                      String specialty = _specialtyFieldController.value.text;
                      String contact = _contactFieldController.value.text;

                      Navigator.pop(
                        context,
                        Doctor(
                          firstName: firstName,
                          middleName: middleName,
                          lastName: lastName,
                          title: title.isEmpty ? 'MD' : title,
                          specialty: specialty.isEmpty ? null : specialty,
                          contact: contact.isEmpty ? null : contact,
                        ),
                      );
                    }
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
                    style: TextStyle(color: DANGER, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}