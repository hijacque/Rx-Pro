import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:rxpro_app/style.dart';

class Doctor {
  final String licenseID;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String title;
  final String? specialty;
  final String? contact;
  final String? email;

  const Doctor(
    this.licenseID, {
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.title,
    this.specialty,
    this.contact,
    this.email,
  });
}

class DoctorInfoDialog extends StatefulWidget {
  const DoctorInfoDialog({super.key, this.existingDoctor});
  final Doctor? existingDoctor;

  @override
  State<DoctorInfoDialog> createState() => _DoctorInfoDialogState();
}

class _DoctorInfoDialogState extends State<DoctorInfoDialog> {
  Timer? _errorTimer;

  String _licenseID = '';
  String _firstName = '';
  String _middleName = '';
  String _lastName = '';
  String _title = '';
  String _specialty = '';
  String _contact = '';
  String _email = '';
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingDoctor != null) {
      _licenseID = widget.existingDoctor!.licenseID.toString();
      _firstName = widget.existingDoctor!.firstName;
      _lastName = widget.existingDoctor!.lastName;
      _middleName = widget.existingDoctor?.middleName ?? '';

      _title = widget.existingDoctor!.title;
      _specialty = widget.existingDoctor!.specialty ?? '';
      _contact = widget.existingDoctor!.contact ?? '';
      _email = widget.existingDoctor!.email ?? '';
    }
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
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
            TextFormField(
              initialValue: _licenseID,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: lightTextFieldStyle.copyWith(
                labelText: (_licenseID.isEmpty) ? null : 'License no.',
                hintText: 'License no.',
                errorText:
                    _showError && _licenseID.isEmpty ? 'Required field' : null,
              ),
              onChanged: (value) => setState(() {
                _licenseID = value;
              }),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _firstName,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: JUAN',
                labelText: 'FIRST NAME',
                errorText:
                    _showError && _firstName.isEmpty ? 'Required field' : null,
              ),
              onChanged: (value) => _firstName = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _middleName,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: CRISOSTOMO',
                labelText: 'MIDDLE NAME',
              ),
              onChanged: (value) => _middleName = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _lastName,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: DELA CRUZ',
                labelText: 'LAST NAME',
                errorText:
                    _showError && _lastName.isEmpty ? 'Required field' : null,
              ),
              onChanged: (value) => _lastName = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _title,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: OB/GYN MD',
                labelText: 'TITLE',
              ),
              onChanged: (value) => _title = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _specialty,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: Nephrology',
                labelText: 'Specialty',
              ),
              onChanged: (value) => _firstName = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _contact,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'Telephone / Mobile ',
                label: const Text('Contact no.'),
              ),
              onChanged: (value) => _contact = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _email,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'example@email.com',
                labelText: 'E-mail Address',
              ),
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 18,
              runSpacing: 12,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showError = _licenseID.isEmpty ||
                          _firstName.isEmpty ||
                          _lastName.isEmpty;
                    });

                    if (_showError) {
                      _errorTimer =
                          Timer(const Duration(milliseconds: 900), () {
                        setState(() => _showError = false);
                      });
                    } else {
                      Navigator.pop(
                        context,
                        Doctor(
                          _licenseID,
                          firstName: _firstName,
                          middleName: _middleName.isEmpty ? null : _middleName,
                          lastName: _lastName,
                          title: _title.isEmpty ? 'MD' : _title,
                          contact: _contact.isEmpty ? null : _contact,
                          email: _email.isEmpty ? null : _email,
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
                  child: const Text(' Cancel '),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
