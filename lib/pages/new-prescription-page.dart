import 'package:flutter/material.dart';

import 'package:rxpro_app/pages/prescription-preview-page.dart';
import 'package:rxpro_app/pages/patient-profile-page.dart';
import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/style.dart';
import 'package:rxpro_app/utils.dart';
import 'package:rxpro_app/database.dart';
import 'package:rxpro_app/doctor.dart';
import 'package:rxpro_app/clinic.dart';
import 'package:rxpro_app/patient.dart';

class SearchPatientDialog extends StatefulWidget {
  const SearchPatientDialog({super.key});

  @override
  State<SearchPatientDialog> createState() => _SearchPatientDialogState();
}

class _SearchPatientDialogState extends State<SearchPatientDialog> {
  late final RxProDbHelper _dbHelper;
  List<Map<String, dynamic>> _patients = [];

  Future<void> _initializeDatabase() async {
    _dbHelper = RxProDbHelper.instance;
    _patients = await _dbHelper.getItems(tableName: 'patient');
  }

  void _onSelectedPatient(int index) {
    Map<String, dynamic> selectedPatient = _patients[index];

    Navigator.pop(
      context,
      Patient(
        selectedPatient['id'],
        firstName: selectedPatient['first_name'],
        middleName: selectedPatient['middle_name'],
        lastName: selectedPatient['last_name'],
        sex: selectedPatient['sex'],
        birthDate: DateTime.parse(selectedPatient['birthdate']),
        address: selectedPatient['addr'],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'Patients List',
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 12),
      contentPadding: EdgeInsets.zero,
      content: PatientsDataTable(
        patients: _patients,
        onSelected: _onSelectedPatient,
      ),
    );
  }
}

Widget _mobileBody(
  BuildContext buildContext, {
  required void Function() clearPrescription,
  required bool Function() isPrescriptionValid,
  required void Function() onPrint,
  required void Function(int index) onDeletePrescription,
  required void Function(int index) onSelectPrescription,
  required void Function(String text) addPrescription,
  required void Function(String text) onInputPrescription,
  required void Function() updatePrescription,
  required void Function() newPatientInfo,
  required void Function() existingPatientInfo,
  required TextEditingController prescriptionFieldController,
  required FocusNode prescriptionFieldFocusNode,
  required bool isPrescribing,
  required List<String> prescriptions,
  required int selectedPrescriptionIndex,
  required String currentPrescription,
  required bool isExistingPatient,
  Patient? patient,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text(
        'New Prescription',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: PURPLE.withAlpha(70),
            foregroundColor: LIGHT,
            disabledForegroundColor: LIGHT.withAlpha(90),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: clearPrescription,
          child: const Text('  Reset  '),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: TextButton(
            onPressed: (isPrescriptionValid()) ? onPrint : null,
            style: lightButtonStyle,
            child: const Text('  Print  '),
          ),
        ),
      ],
    ),
    body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Visibility(
            visible: (!isPrescribing),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: (patient == null)
                    ? [
                        const Text(
                          'Patient\'s Information',
                          style: TextStyle(
                            fontSize: 18,
                            height: 3.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: newPatientInfo,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.only(right: 16, left: 12),
                              ),
                              child: const Text('      New patient     '),
                            ),
                            TextButton(
                              onPressed: existingPatientInfo,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.only(right: 16, left: 12),
                              ),
                              child: const Wrap(
                                spacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  Text('Search patient'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                    : [
                        const Text(
                          'Patient\'s Information',
                          style: TextStyle(
                            fontSize: 18,
                            height: 3.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Wrap(
                          spacing: 36,
                          runSpacing: 6,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Name: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${patient.firstName}${patient.middleName == null ? '' : '${patient.middleName![0]}.'} ${patient.lastName}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Age: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getAge(patient.birthDate).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Sex assigned at birth: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: patient.sexText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: newPatientInfo,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.only(right: 16, left: 12),
                              ),
                              child: Text(
                                (isExistingPatient)
                                    ? '      New patient     '
                                    : '   Update patient   ',
                              ),
                            ),
                            TextButton(
                              onPressed: existingPatientInfo,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.only(right: 16, left: 12),
                              ),
                              child: const Wrap(
                                spacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  Text('Search patient'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
              ),
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
          const Divider(indent: 24, endIndent: 24, height: 1),
          Expanded(
            child: (prescriptions.isNotEmpty)
                ? ListView.separated(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color:
                            (selectedPrescriptionIndex == index) ? LIGHT : null,
                        child: ListTile(
                          dense: true,
                          title: Text(
                            prescriptions[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            onPressed: () => onDeletePrescription(index),
                            icon: const Icon(Icons.delete),
                            mouseCursor: SystemMouseCursors.click,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          selected: (selectedPrescriptionIndex == index),
                          shape: const RoundedRectangleBorder(),
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () => onSelectPrescription(index),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
              controller: prescriptionFieldController,
              focusNode: prescriptionFieldFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onSubmitted: (text) {
                if (selectedPrescriptionIndex < 0) {
                  addPrescription(text);
                } else {
                  updatePrescription();
                }
              },
              onChanged: onInputPrescription,
              decoration: lightTextFieldStyle.copyWith(
                contentPadding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 12,
                  bottom: 10,
                ),
                hintText: (selectedPrescriptionIndex < 0)
                    ? 'New prescription'
                    : 'Updated prescription',
                suffix: (selectedPrescriptionIndex < 0)
                    ? TextButton(
                        onPressed: (currentPrescription.isEmpty)
                            ? null
                            : () => addPrescription(currentPrescription),
                        child: const Text('Add'),
                      )
                    : TextButton(
                        onPressed: updatePrescription,
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

Widget _desktopBody(
    BuildContext buildContext, {
      required void Function() clearPrescription,
      required bool Function() isPrescriptionValid,
      required void Function() onPrint,
      required void Function(int index) onDeletePrescription,
      required void Function(int index) onSelectPrescription,
      required void Function(String text) addPrescription,
      required void Function(String text) onInputPrescription,
      required void Function() updatePrescription,
      required void Function() newPatientInfo,
      required void Function() existingPatientInfo,
      required TextEditingController prescriptionFieldController,
      required FocusNode prescriptionFieldFocusNode,
      required List<String> prescriptions,
      required int selectedPrescriptionIndex,
      required String currentPrescription,
      required bool isExistingPatient,
      Patient? patient,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text(
        'New Prescription',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: PURPLE.withAlpha(70),
            foregroundColor: LIGHT,
            disabledForegroundColor: LIGHT.withAlpha(90),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: clearPrescription,
          child: const Text('  Reset  '),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: TextButton(
            onPressed: (isPrescriptionValid()) ? onPrint : null,
            style: lightButtonStyle,
            child: const Text('  Print  '),
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
            padding: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
            color: Colors.deepPurple.shade50,
            child: Column(
              children: (patient == null)
                  ? [
                const Text(
                  'Patient\'s Information',
                  style: TextStyle(
                    fontSize: 18,
                    height: 3.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: newPatientInfo,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.only(right: 16, left: 12),
                      ),
                      child: const Text('      New patient     '),
                    ),
                    TextButton(
                      onPressed: existingPatientInfo,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.only(right: 16, left: 12),
                      ),
                      child: const Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                          ),
                          Text('Search patient'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
                  : [
                const Text(
                  'Patient\'s Information',
                  style: TextStyle(
                    fontSize: 18,
                    height: 3.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Wrap(
                  spacing: 36,
                  runSpacing: 6,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Name: ',
                        children: <TextSpan>[
                          TextSpan(
                            text:
                            '${patient.firstName}${patient.middleName == null ? '' : '${patient.middleName![0]}.'} ${patient.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Age: ',
                        children: <TextSpan>[
                          TextSpan(
                            text: getAge(patient.birthDate).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Sex assigned at birth: ',
                        children: <TextSpan>[
                          TextSpan(
                            text: patient.sexText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: newPatientInfo,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.only(right: 16, left: 12),
                      ),
                      child: Text(
                        (isExistingPatient)
                            ? '      New patient     '
                            : '   Update patient   ',
                      ),
                    ),
                    TextButton(
                      onPressed: existingPatientInfo,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.only(right: 16, left: 12),
                      ),
                      child: const Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                          ),
                          Text('Search patient'),
                        ],
                      ),
                    ),
                  ],
                ),
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
          const Divider(indent: 24, endIndent: 24, height: 1),
          Expanded(
            child: (prescriptions.isNotEmpty)
                ? ListView.separated(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                return Container(
                  color:
                  (selectedPrescriptionIndex == index) ? LIGHT : null,
                  child: ListTile(
                    dense: true,
                    title: Text(
                      prescriptions[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      onPressed: () => onDeletePrescription(index),
                      icon: const Icon(Icons.delete),
                      mouseCursor: SystemMouseCursors.click,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    selected: (selectedPrescriptionIndex == index),
                    shape: const RoundedRectangleBorder(),
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () => onSelectPrescription(index),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
              const Divider(height: 1),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
              controller: prescriptionFieldController,
              focusNode: prescriptionFieldFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onSubmitted: (text) {
                if (selectedPrescriptionIndex < 0) {
                  addPrescription(text);
                } else {
                  updatePrescription();
                }
              },
              onChanged: onInputPrescription,
              decoration: lightTextFieldStyle.copyWith(
                contentPadding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 12,
                  bottom: 10,
                ),
                hintText: (selectedPrescriptionIndex < 0)
                    ? 'New prescription'
                    : 'Updated prescription',
                suffix: (selectedPrescriptionIndex < 0)
                    ? TextButton(
                  onPressed: (currentPrescription.isEmpty)
                      ? null
                      : () => addPrescription(currentPrescription),
                  child: const Text('Add'),
                )
                    : TextButton(
                  onPressed: updatePrescription,
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

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({
    super.key,
    required this.doctor,
    required this.clinic,
    this.existingPatient,
  });

  final Patient? existingPatient;
  final Doctor doctor;
  final Clinic clinic;

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final TextEditingController _prescriptionFieldController =
      TextEditingController();
  final FocusNode _prescriptionFieldFocusNode = FocusNode();
  final List<String> _prescriptions = [];

  int _selectedPrescriptionIndex = -1;
  bool _isPrescribing = false;
  Patient? _patient;
  String _currentPrescription = '';
  bool _isExistingPatient = false;

  @override
  void initState() {
    super.initState();
    _prescriptionFieldFocusNode.addListener(() {
      setState(() {
        _isPrescribing = _prescriptionFieldFocusNode.hasFocus;
      });
    });

    if (widget.existingPatient != null) {
      _patient = widget.existingPatient;
      _isExistingPatient = true;
    }
  }

  void _addPrescription(String prescription) {
    if (prescription.isNotEmpty) {
      setState(() {
        _prescriptions.add(prescription);
        _prescriptionFieldController.clear();
        _prescriptionFieldFocusNode.requestFocus();
      });
    }
  }

  void _onInputPrescription(String text) {
    setState(() {
      _currentPrescription = text;
    });
  }

  void _onSelectPrescription(int index) {
    setState(() {
      if (_selectedPrescriptionIndex == index) {
        _selectedPrescriptionIndex = -1;
        _prescriptionFieldController.clear();
      } else {
        _selectedPrescriptionIndex = index;
        String previousPrescription =
            _prescriptions[_selectedPrescriptionIndex];
        _prescriptionFieldController.text = previousPrescription;
        _currentPrescription = previousPrescription;
        _prescriptionFieldFocusNode.requestFocus();
      }
    });
  }

  void _updatePrescription() {
    String updatedPrescription = _currentPrescription;
    if (updatedPrescription.isNotEmpty) {
      _prescriptions[_selectedPrescriptionIndex] = updatedPrescription;
      _prescriptionFieldController.clear();
      setState(() {
        _selectedPrescriptionIndex = -1;
        _prescriptionFieldFocusNode.requestFocus();
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

  bool _isPrescriptionValid() {
    return _prescriptions.isNotEmpty && _patient != null;
  }

  void _clearPrescription() {
    setState(() {
      _prescriptions.clear();
      _prescriptionFieldController.clear();
      _selectedPrescriptionIndex = -1;
    });
  }

  void _onPrint() {
    setState(() {
      _prescriptionFieldFocusNode.unfocus();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionPreviewPage(
          doctor: widget.doctor,
          clinic: widget.clinic,
          prescriptions: _prescriptions,
          patientName:
          '${_patient!.firstName}${_patient!.middleName == null ? '' : ' ${_patient!.middleName![0]}.'} ${_patient!.lastName}',
          patientAge: getAge(_patient!.birthDate).toString(),
          patientSex: _patient!.sexText,
        ),
      ),
    ).then((isClosed) {
      if (isClosed.runtimeType == bool && isClosed) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  void _onDeletePrescription(int index) {
    setState(() {
      _prescriptions.removeAt(index);
    });
  }

  void _newPatientInfo() async {
    var newPatient = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfilePage(
          existingPatient: (_isExistingPatient) ? null : _patient,
        ),
      ),
    );

    if (newPatient.runtimeType == bool && !newPatient) {
      setState(() {
        _patient = null;
        _isExistingPatient = false;
      });
    } else if (newPatient.runtimeType == Patient) {
      setState(() {
        _patient = newPatient;
        _isExistingPatient = false;
      });
    }
  }

  void _existingPatientInfo() async {
    Patient? existingPatient = await showDialog(
      context: context,
      builder: (context) => const SearchPatientDialog(),
    );

    if (existingPatient != null) {
      setState(() {
        _patient = existingPatient;
        _isExistingPatient = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayout(layouts: [
        Layout(
          body: _mobileBody(
            context,
            currentPrescription: _currentPrescription,
            clearPrescription: _clearPrescription,
            isPrescriptionValid: _isPrescriptionValid,
            onPrint: _onPrint,
            onDeletePrescription: _onDeletePrescription,
            onSelectPrescription: _onSelectPrescription,
            addPrescription: _addPrescription,
            updatePrescription: _updatePrescription,
            onInputPrescription: _onInputPrescription,
            newPatientInfo: _newPatientInfo,
            existingPatientInfo: _existingPatientInfo,
            prescriptionFieldController: _prescriptionFieldController,
            prescriptionFieldFocusNode: _prescriptionFieldFocusNode,
            patient: _patient,
            isExistingPatient: _isExistingPatient,
            isPrescribing: _isPrescribing,
            prescriptions: _prescriptions,
            selectedPrescriptionIndex: _selectedPrescriptionIndex,
          ),
          breakpoint: 760,
        ),
        Layout(
          body: _desktopBody(
            context,
            currentPrescription: _currentPrescription,
            clearPrescription: _clearPrescription,
            isPrescriptionValid: _isPrescriptionValid,
            onPrint: _onPrint,
            onDeletePrescription: _onDeletePrescription,
            onSelectPrescription: _onSelectPrescription,
            addPrescription: _addPrescription,
            updatePrescription: _updatePrescription,
            onInputPrescription: _onInputPrescription,
            newPatientInfo: _newPatientInfo,
            existingPatientInfo: _existingPatientInfo,
            prescriptionFieldController: _prescriptionFieldController,
            prescriptionFieldFocusNode: _prescriptionFieldFocusNode,
            patient: _patient,
            isExistingPatient: _isExistingPatient,
            prescriptions: _prescriptions,
            selectedPrescriptionIndex: _selectedPrescriptionIndex,
          ),
          breakpoint: double.infinity,
        ),
      ]),
    );
  }
}
