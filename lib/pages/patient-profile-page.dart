import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:rxpro_app/patient.dart';
import 'package:rxpro_app/style.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({
    super.key,
    this.existingPatient,
  });

  final Patient? existingPatient;

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final TextEditingController _birthDateFieldController =
      TextEditingController();
  final FocusNode _birthDateFieldFocusNode = FocusNode();

  String _firstName = '';
  String _middleName = '';
  String _lastName = '';
  String _contact = '';
  String _address = '';
  int? _sex;
  DateTime? _birthDate;

  final TextEditingController _erAddressFieldController =
      TextEditingController();
  String _erName = '';
  String _erRelation = '';
  String _erContact = '';

  bool _livesTogether = false;

  Future<void> _selectBirthDate() async {
    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      keyboardType: const TextInputType.numberWithOptions(),
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
      _middleName = patient.middleName ?? '';
      _lastName = patient.lastName;
      _address = patient.address;
      _contact = patient.contact ?? '';
      _sex = patient.sex;
      _birthDate = patient.birthDate;
      _birthDateFieldController.text =
          DateFormat('MM/dd/yyyy').format(_birthDate!);

      _erName = patient.erName ?? '';
      _erRelation = patient.erRelation ?? '';
      _erAddressFieldController.text = patient.erAddress ?? '';
      _erContact = patient.erContact ?? '';

      _livesTogether = patient.address == patient.erAddress;
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
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              style: primaryButtonStyle,
              onPressed: () {
                String? errorMessage;

                if (_firstName.isEmpty || _lastName.isEmpty) {
                  errorMessage =
                      'Patient\'s name is incomplete. Please fill fields.';
                } else if (_birthDate == null) {
                  errorMessage = 'Please provide your date of birth.';
                } else if (_sex == null) {
                  errorMessage = 'Please choose your sex assigned at birth.';
                } else if (_address.isEmpty) {
                  errorMessage = 'Please provide the patient\'s home address.';
                }

                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(errorMessage),
                    duration: const Duration(seconds: 1, milliseconds: 300),
                  ));
                  return;
                }

                Navigator.pop(
                  context,
                  Patient(
                    -1,
                    firstName: _firstName,
                    middleName: _middleName.isEmpty ? null : _middleName,
                    lastName: _lastName,
                    sex: _sex ?? 1,
                    birthDate: _birthDate ?? DateTime.now(),
                    contact: _contact.isEmpty ? null : _contact,
                    address: _address,
                    erName: _erName.isEmpty ? null : _erName,
                    erRelation: _erRelation.isEmpty ? null : _erRelation,
                    erAddress: _erAddressFieldController.text.isEmpty
                        ? null
                        : _erAddressFieldController.value.text,
                    erContact: _erContact.isEmpty ? null : _erContact,
                  ),
                );
              },
              child: const Text(
                '     Save     ',
                style: TextStyle(fontSize: 16, color: LIGHT),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 32, bottom: 54,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _firstName,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _firstName = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: JUAN',
                labelText: 'FIRST NAME',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: _middleName,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _middleName = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: CRISOSTOMO',
                labelText: 'MIDDLE NAME',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: _lastName,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _lastName = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: DELA CRUZ',
                labelText: 'LAST NAME',
              ),
            ),
            const SizedBox(height: 18),
            InputDecorator(
              decoration: lightTextFieldStyle.copyWith(
                labelText: (_sex != null) ? 'SEX ASSIGNED AT BIRTH' : null,
                // focusColor: Colors.deepPurple,
                focusedBorder: roundedBorder(Colors.deepPurple),
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
            TextFormField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                LengthLimitingTextInputFormatter(
                    10), // To match MM/DD/YYYY format
              ],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'MM/DD/YYYY',
                labelText: 'DATE OF BIRTH',
              ),
              readOnly: true,
              focusNode: _birthDateFieldFocusNode,
              controller: _birthDateFieldController,
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: _address,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                _address = value;
                if (_livesTogether) {
                  setState(() {
                    _erAddressFieldController.text = _address;
                  });
                }
              },
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: 1234 Somewhere St., Place City',
                labelText: 'Home address',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: _contact,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _address = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              keyboardType: TextInputType.phone,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'Telephone / Mobile',
                labelText: 'Contact no.',
              ),
            ),
            // const SizedBox(height: 36),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: BLUE,
                    endIndent: 12,
                    height: 64,
                  ),
                ),
                Text(
                  'Emergency Contact',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: BLUE,
                    // fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: BLUE,
                    indent: 12,
                    height: 64,
                  ),
                ),
              ],
            ),
            TextFormField(
              initialValue: _erName,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _erName = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: JUAN C. DELA CRUZ',
                labelText: 'NAME',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: _erRelation,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _erRelation = value,
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: wife',
                labelText: 'Relation to patient',
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              readOnly: _livesTogether,
              enabled: !_livesTogether,
              textInputAction: TextInputAction.next,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'ex: 1234 Somewhere St., Place City',
                labelText: 'Home address',
              ),
              controller: _erAddressFieldController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _livesTogether,
                  onChanged: (value) => setState(() {
                    _livesTogether = value ?? false;
                    if (value == true) {
                      _erAddressFieldController.text = _address;
                    }
                  }),
                ),
                const Text('Lives with patient'),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _erContact,
              style: const TextStyle(
                fontSize: 14,
                color: BLUE,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => _erContact = value,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              keyboardType: TextInputType.phone,
              decoration: lightTextFieldStyle.copyWith(
                hintText: 'Telephone / Mobile',
                labelText: 'Contact no.',
              ),
            ),
            Visibility(
              visible: widget.existingPatient != null,
              child: Container(
                width: double.infinity,
                decoration: lightContainerDecoration,
                // margin: const EdgeInsets.only(top: 36),
                child: Column(
                  children: [
                    const Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: DANGER,
                            endIndent: 12,
                            height: 64,
                          ),
                        ),
                        Text(
                          'Danger Zone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DANGER,
                            // fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: DANGER,
                            indent: 12,
                            height: 64,
                          ),
                        ),
                      ],
                    ),
                    Text('Delete diagnosis history'),
                    Text('Delete laboratory history'),
                    Text('Delete all of ppatient\'s records.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
