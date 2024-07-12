import 'package:flutter/material.dart';

import 'package:rxpro_app/style.dart';

class Clinic {
  final String name;
  final String address;

  const Clinic({required this.name, required this.address});
}

class ClinicInfoDialog extends StatefulWidget {
  const ClinicInfoDialog({super.key, this.existingClinic});
  final Clinic? existingClinic;

  @override
  State<ClinicInfoDialog> createState() => _ClinicInfoDialogState();
}

class _ClinicInfoDialogState extends State<ClinicInfoDialog> {
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _addressFieldController = TextEditingController();

  bool? _hasName;
  bool? _hasAddress;

  @override
  void initState() {
    super.initState();

    if (widget.existingClinic != null) {
      _nameFieldController.text = widget.existingClinic!.name;
      _addressFieldController.text = widget.existingClinic!.address;
    }
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
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: The Medical City Clinic',
                label: const Text('Name'),
                error: _hasName == null
                    ? null
                    : !_hasName!
                    ? const Text('Required field')
                    : null,
              ),
              controller: _nameFieldController,
            ),
            const SizedBox(height: 12),
            TextField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: 1234 Somewhere St., Place City',
                label: const Text('Address'),
                error: _hasAddress == null
                    ? null
                    : !_hasAddress!
                    ? const Text('Required field')
                    : null,
              ),
              controller: _addressFieldController,
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 18,
              children: [
                TextButton(
                  onPressed: () {
                    String name = _nameFieldController.value.text;
                    String address = _addressFieldController.value.text;

                    if (name.isNotEmpty && address.isNotEmpty) {
                      Navigator.pop(
                        context,
                        Clinic(
                          name: name,
                          address: address,
                        ),
                      );
                    } else {
                      setState(() {
                        _hasName = name.isNotEmpty;
                        _hasAddress = address.isNotEmpty;
                      });
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