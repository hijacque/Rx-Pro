import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxpro_app/style.dart';

class Clinic {
  final int id;
  final String name;
  final String address;
  final String? contact;
  final String? email;

  const Clinic(
    this.id, {
    required this.name,
    required this.address,
    this.contact,
    this.email,
  });
}

class DeleteClinicDialog extends StatefulWidget {
  const DeleteClinicDialog({super.key});

  @override
  State<DeleteClinicDialog> createState() => _DeleteClinicDialogState();
}

class _DeleteClinicDialogState extends State<DeleteClinicDialog> {
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
              'Do you want to permanently remove the clinic information?'),
          const SizedBox(height: 12),
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

class ClinicInfoDialog extends StatefulWidget {
  const ClinicInfoDialog({super.key, this.existingClinic});
  final Clinic? existingClinic;

  @override
  State<ClinicInfoDialog> createState() => _ClinicInfoDialogState();
}

class _ClinicInfoDialogState extends State<ClinicInfoDialog> {
  Timer? _errorTimer;
  String _name = '';
  String _address = '';
  String _contact = '';
  String _email = '';
  bool _showError = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingClinic != null) {
      Clinic clinic = widget.existingClinic!;
      _name = clinic.name;
      _address = clinic.address;
      _contact = clinic.contact ?? '';
      _email = clinic.email ?? '';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: LIGHT,
      surfaceTintColor: Colors.white,
      title: const Text('About clinic'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: The Medical City Clinic',
                labelText: 'Name',
                errorText:
                    (_showError && _name.isEmpty) ? 'Required field' : null,
              ),
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _address,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: 1234 Somewhere St., Place City',
                labelText: 'Address',
                errorText:
                    (_showError && _name.isEmpty) ? 'Required field' : null,
              ),
              onChanged: (value) => _address = value,
            ),
            const SizedBox(height: 12),
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
                hintText: 'Mobile / Landline',
                labelText: 'Contact no.',
              ),
              onChanged: (value) => _contact = value,
            ),
            const SizedBox(height: 12),
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
                hintText: 'sample@email.com',
                labelText: 'E-mail address',
              ),
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 18,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showError = _name.isEmpty || _address.isEmpty;
                    });

                    if (_showError) {
                      _errorTimer =
                          Timer(const Duration(milliseconds: 900), () {
                        setState(() => _showError = false);
                      });
                    } else {
                      Navigator.pop(
                        context,
                        Clinic(
                          (widget.existingClinic != null)
                              ? widget.existingClinic!.id
                              : -1,
                          name: _name,
                          address: _address,
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
                  child: const Text('Cancel'),
                ),
                Visibility(
                  visible: widget.existingClinic != null,
                  child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const DeleteClinicDialog(),
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
    );
  }
}
