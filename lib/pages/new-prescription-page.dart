import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/style.dart';

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
  const _DesktopBody({super.key});

  @override
  State<_DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<_DesktopBody> {
  final TextEditingController _prescriptionFieldController =
      TextEditingController();
  final FocusNode _prescriptionFieldFocusNode = FocusNode();
  final List<String> _prescriptions = [];

  int _selectedPrescriptionIndex = -1;
  String? _patientsSex;

  void _addPrescription(String prescription) {
    setState(() {
      _prescriptions.add(prescription);
      _prescriptionFieldController.clear();
      _prescriptionFieldFocusNode.requestFocus();
    });
  }

  void _onSelectPrescription() {
    String previousPrescription = _prescriptions[_selectedPrescriptionIndex];
    _prescriptionFieldController.text = previousPrescription;
    _prescriptionFieldFocusNode.requestFocus();
  }

  void _updatePrescription() {
    String updatedPrescription = _prescriptionFieldController.value.text;
    if (updatedPrescription.isNotEmpty) {
      _prescriptions[_selectedPrescriptionIndex] = updatedPrescription;
      _prescriptionFieldController.clear();
      _selectedPrescriptionIndex = -1;
      setState(() {
        _prescriptionFieldFocusNode.unfocus();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'No prescription entered. Retyping previous prescription...',
        ),
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        _prescriptionFieldController.text =
            _prescriptions[_selectedPrescriptionIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'New Prescription',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: TextButton(
              onPressed: () {
                if (_prescriptions.isEmpty) {
                  // TODO: snack bar message - no prescription entered
                }
              },
              style: lightButtonStyle,
              child: const Text('Done'),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 36, left: 36, bottom: 20),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  const Text(
                    'Patient\'s Information',
                    style: TextStyle(
                      fontSize: 16,
                      height: 3.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      TextField(
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        decoration: lightTextFieldStyle.copyWith(
                          hintText: 'ex: JUAN C. DELA CRUZ JR.',
                          label: const Text(
                            'NAME',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: lightTextFieldStyle.copyWith(
                            label: const Text(
                              'AGE',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: InputDecorator(
                          decoration: lightTextFieldStyle.copyWith(
                            label: (_patientsSex != null)
                                ? const Text(
                                    'SEX',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : null,
                            contentPadding: const EdgeInsets.only(
                                right: 12, left: 16, top: 4, bottom: 4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(
                                'SEX ASSIGNED AT BIRTH',
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                              value: _patientsSex,
                              items: const [
                                DropdownMenuItem(
                                  value: 'F',
                                  child: Text(
                                    'FEMALE',
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'M',
                                  child: Text(
                                    'MALE',
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'I',
                                  child: Text(
                                    'INTERSEX',
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _patientsSex = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Text(
              'Drug Prescriptions',
              style: TextStyle(
                fontSize: 18,
                height: 3.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(indent: 32, endIndent: 32, height: 1),
            Expanded(
              child: (_prescriptions.isNotEmpty)
                  ? ListView.separated(
                      itemCount: _prescriptions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: (_selectedPrescriptionIndex == index)
                              ? LIGHT
                              : null,
                          child: ListTile(
                            dense: true,
                            title: Text(_prescriptions[index]),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _prescriptions.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete),
                              mouseCursor: SystemMouseCursors.click,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            selected: (_selectedPrescriptionIndex == index),
                            shape: const RoundedRectangleBorder(),
                            mouseCursor: SystemMouseCursors.click,
                            onTap: () {
                              setState(() {
                                if (_selectedPrescriptionIndex == index) {
                                  _selectedPrescriptionIndex = -1;
                                  _prescriptionFieldController.clear();
                                } else {
                                  _selectedPrescriptionIndex = index;
                                  _onSelectPrescription();
                                }
                              });
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    )
                  : const Text(
                      'No prescription in list.',
                      style: TextStyle(
                        color: LIGHT_GREY,
                        height: 3,
                      ),
                    ),
            ),
            Container(
              color: Colors.deepPurple.shade50,
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _prescriptionFieldController,
                focusNode: _prescriptionFieldFocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onSubmitted: (text) {
                  if (_selectedPrescriptionIndex < 0) {
                    _addPrescription(text);
                  } else {
                    _updatePrescription();
                  }
                },
                decoration: lightTextFieldStyle.copyWith(
                  hintText: (_selectedPrescriptionIndex < 0)
                      ? 'New prescription'
                      : 'Updated prescription',
                  suffix: (_selectedPrescriptionIndex < 0)
                      ? TextButton(
                          onPressed: () => _addPrescription(
                              _prescriptionFieldController.value.text),
                          child: const Text('Add'),
                        )
                      : TextButton(
                          onPressed: _updatePrescription,
                          child: const Text('Edit'),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: ResponsiveLayout(layouts: [
        Layout(
          body: _MobileBody(),
          breakpoint: 600,
        ),
        Layout(
          body: _DesktopBody(),
          breakpoint: double.infinity,
        ),
      ]),
    );
  }
}
