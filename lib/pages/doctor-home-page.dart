import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rxpro_app/carousel.dart';
import 'package:rxpro_app/pages/patient-page.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'package:rxpro_app/pages/new-prescription-page.dart';
import 'package:rxpro_app/style.dart';
import 'package:rxpro_app/pages/patient-profile-page.dart';
import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/database.dart';
import 'package:rxpro_app/patient.dart';
import 'package:rxpro_app/doctor.dart';
import 'package:rxpro_app/clinic.dart';

class FloatingActionSpeedDial extends StatefulWidget {
  const FloatingActionSpeedDial({
    super.key,
    required this.mainIcon,
    required this.subActions,
  });

  final IconData mainIcon;
  final Map<IconData, Function()> subActions;

  @override
  State<FloatingActionSpeedDial> createState() =>
      _FloatingActionSpeedDialState();
}

class _FloatingActionSpeedDialState extends State<FloatingActionSpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _viewSubActionsController;
  late final List<IconData> _icons;
  late final List<Function()> _subActionFunctions;

  @override
  void initState() {
    super.initState();
    _icons = widget.subActions.keys.toList();
    _subActionFunctions = widget.subActions.values.toList();

    _viewSubActionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          _icons.length,
          (index) => Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _viewSubActionsController,
                curve: Interval(
                  0.0,
                  1.0 - index / _icons.length / 2.0,
                  curve: Curves.easeOut,
                ),
              ),
              child: FloatingActionButton(
                heroTag: null,
                // backgroundColor: backgroundColor,
                mini: true,
                onPressed: _subActionFunctions[index],
                child: Icon(_icons[index]),
              ),
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            if (_viewSubActionsController.isDismissed) {
              _viewSubActionsController.forward();
            } else {
              _viewSubActionsController.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _viewSubActionsController,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                transform: Matrix4.rotationZ(
                    _viewSubActionsController.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(
                  _viewSubActionsController.isDismissed
                      ? widget.mainIcon
                      : Icons.close,
                  size: _viewSubActionsController.isDismissed ? 32 : 28,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _mobileBody(
  BuildContext buildContext, {
  required GlobalKey<ScaffoldState> scaffoldKey, // mobile only
  required List<Map<String, dynamic>> clinics,
  required List<Map<String, dynamic>> patients,
  required void Function({int? newIndex}) openPatientPage,
  required void Function() openDoctorInfoDialog,
  required void Function({Clinic? existingClinic}) openClinicInfoDialog,
  required void Function(int index) onSelectPatient,
  required void Function(int index) onSelectClinic,
  required int selectedClinicIndex,
  Doctor? doctor,
}) {
  return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      backgroundColor: Theme.of(buildContext).primaryColor.withAlpha(120),
      title: const Text(' Rx Pro '),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            style: lightButtonStyle,
            onPressed: () {
              if (doctor != null &&
                  clinics.isNotEmpty &&
                  selectedClinicIndex >= 0) {
                Navigator.push(
                    buildContext,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionPage(
                        doctor: doctor,
                        clinic: Clinic(
                          clinics[selectedClinicIndex]['id'],
                          name: clinics[selectedClinicIndex]['clinic_name'],
                          address: clinics[selectedClinicIndex]['clinic_addr'],
                        ),
                      ),
                    ));
              } else {
                ScaffoldMessenger.of(buildContext).showSnackBar(const SnackBar(
                  content: Text('Missing doctor and clinic information.'),
                  duration: Duration(seconds: 1, milliseconds: 300),
                ));
              }
            },
            child: const Text('   New Prescription   '),
          ),
        ),
      ],
    ),
    drawer: Drawer(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0.5, blurRadius: 4)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: (doctor != null) ? 20 : 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: PURPLE.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all((doctor != null) ? 8 : 16),
                  child: Text(
                    (doctor != null)
                        ? '${doctor.firstName[0].toUpperCase()}${doctor.lastName[0].toUpperCase()}'
                        : '?',
                    style:
                        Theme.of(buildContext).textTheme.titleLarge!.copyWith(
                              color: INDIGO,
                            ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    (doctor != null)
                        ? '${doctor.firstName}${doctor.middleName != null ? ' ${doctor.middleName![0]}.' : ''} ${doctor.lastName}, ${doctor.title}'
                        : 'No name',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              (doctor != null)
                  ? 'License no.: ${doctor.licenseID}'
                  : 'Unidentified doctor user',
              maxLines: 1,
              style: (doctor != null)
                  ? const TextStyle(fontWeight: FontWeight.w600)
                  : const TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              (doctor != null && doctor.contact != null)
                  ? 'Contact no.: ${doctor.contact}'
                  : 'No contact information',
              maxLines: 1,
              style: (doctor != null && doctor.contact != null)
                  ? null
                  : const TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              (doctor != null && doctor.email != null)
                  ? 'E-mail: ${doctor.email}'
                  : 'No e-mail address',
              maxLines: 1,
              style: (doctor != null && doctor.email != null)
                  ? null
                  : const TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            TextButton(
              style: lightButtonStyle,
              onPressed: openDoctorInfoDialog,
              child: const Text('  Edit profile  '),
            ),
            const Divider(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Clinics',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () => openClinicInfoDialog(),
                  icon: const Icon(
                    Icons.add,
                    color: BLUE,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: clinics.length,
                itemBuilder: (context, index) => Container(
                  decoration: lightContainerDecoration,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.zero,
                  child: GestureDetector(
                    onTap: () => onSelectClinic(index),
                    onDoubleTap: () => openClinicInfoDialog(
                      existingClinic: Clinic(
                        clinics[index]['id'],
                        name: clinics[index]['clinic_name'],
                        address: clinics[index]['clinic_addr'],
                      ),
                    ),
                    child: ListTile(
                      selected: selectedClinicIndex == index,
                      title: Text(
                        clinics[index]['clinic_name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        clinics[index]['clinic_addr'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    body: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Patients List',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () => openPatientPage(newIndex: -1),
                style: primaryButtonStyle,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: PatientsDataTable(
            patients: patients,
            onSelected: onSelectPatient,
          ),
        ),
      ],
    ),
  );
}

Widget _desktopBody(
  BuildContext buildContext, {
  required List<Map<String, dynamic>> clinics,
  required List<Map<String, dynamic>> patients,
  required void Function({int? newIndex}) openPatientPage,
  required void Function() openDoctorInfoDialog,
  required void Function({Clinic? existingClinic}) openClinicInfoDialog,
  required void Function(int index) onSelectPatient,
  required void Function(int index) onSelectClinic,
  required int selectedClinicIndex,
  Doctor? doctor,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(buildContext).primaryColor.withAlpha(120),
      title: const Text(' Rx Pro '),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            style: lightButtonStyle,
            onPressed: () {
              if (doctor != null &&
                  clinics.isNotEmpty &&
                  selectedClinicIndex >= 0) {
                Navigator.push(
                    buildContext,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionPage(
                        doctor: doctor,
                        clinic: Clinic(
                          clinics[selectedClinicIndex]['id'],
                          name: clinics[selectedClinicIndex]['clinic_name'],
                          address: clinics[selectedClinicIndex]['clinic_addr'],
                        ),
                      ),
                    ));
              } else {
                ScaffoldMessenger.of(buildContext).showSnackBar(const SnackBar(
                  content: Text('Missing doctor and clinic information.'),
                  duration: Duration(seconds: 1, milliseconds: 300),
                ));
              }
            },
            child: const Text('   New Prescription   '),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: buildContext,
          builder: (context) => ImageCarousel(
            [AssetImage('assets/images/rx.png')],
            ['prescription logo'],
          ),
        );
      },
    ),
    body: Row(
      children: [
        Drawer(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, spreadRadius: 0.5, blurRadius: 4)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: (doctor != null) ? 20 : 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: PURPLE.withAlpha(120),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all((doctor != null) ? 8 : 16),
                      child: Text(
                        (doctor != null)
                            ? '${doctor.firstName[0].toUpperCase()}${doctor.lastName[0].toUpperCase()}'
                            : '?',
                        style: Theme.of(buildContext)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                              color: INDIGO,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        (doctor != null)
                            ? '${doctor.firstName}${doctor.middleName != null ? ' ${doctor.middleName![0]}.' : ''} ${doctor.lastName}, ${doctor.title}'
                            : 'No name',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (doctor != null)
                      ? 'License no.: ${doctor.licenseID}'
                      : 'Unidentified doctor user',
                  maxLines: 1,
                  style: (doctor != null)
                      ? const TextStyle(fontWeight: FontWeight.w600)
                      : const TextStyle(fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  (doctor != null && doctor.contact != null)
                      ? 'Contact no.: ${doctor.contact}'
                      : 'No contact information',
                  maxLines: 1,
                  style: (doctor != null && doctor.contact != null)
                      ? null
                      : const TextStyle(fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  (doctor != null && doctor.email != null)
                      ? 'E-mail: ${doctor.email}'
                      : 'No e-mail address',
                  maxLines: 1,
                  style: (doctor != null && doctor.email != null)
                      ? null
                      : const TextStyle(fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                TextButton(
                  style: lightButtonStyle,
                  onPressed: openDoctorInfoDialog,
                  child: const Text('  Edit profile  '),
                ),
                const Divider(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Clinics',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => openClinicInfoDialog(),
                      icon: const Icon(
                        Icons.add,
                        color: BLUE,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: clinics.length,
                    itemBuilder: (context, index) => Container(
                      decoration: lightContainerDecoration,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () => onSelectClinic(index),
                        onDoubleTap: () => openClinicInfoDialog(
                          existingClinic: Clinic(
                            clinics[index]['id'],
                            name: clinics[index]['clinic_name'],
                            address: clinics[index]['clinic_addr'],
                          ),
                        ),
                        child: ListTile(
                          selected: selectedClinicIndex == index,
                          title: Text(
                            clinics[index]['clinic_name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            clinics[index]['clinic_addr'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Patients List',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () => openPatientPage(newIndex: -1),
                      style: primaryButtonStyle,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PatientsDataTable(
                  patients: patients,
                  onSelected: onSelectPatient,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  sqlite3.Database? _database;
  late final RxProDbHelper _dbHelper;
  List<Map<String, dynamic>> _patients = [];
  Doctor? _doctor;
  int _selectedClinicIndex = -1;
  List<Map<String, dynamic>> _clinics = [];
  int? _selectedPatientIndex;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeDatabase().then(
      (value) => setState(() {}),
    );
  }

  Future<void> _initializeDatabase() async {
    _dbHelper = RxProDbHelper.instance;
    _database = await _dbHelper.database;

    _patients = await _dbHelper.getItems(tableName: 'patient');

    _clinics = await _dbHelper.getItems(tableName: 'clinic');
    if (_clinics.isNotEmpty) {
      _selectedClinicIndex = 0;
    }

    var doctors = await _dbHelper.getItems(tableName: 'doctor');
    if (doctors.isNotEmpty) {
      Map<String, dynamic> doctor = doctors[0];
      _doctor = Doctor(
        doctor['license_id'],
        firstName: doctor['first_name'],
        middleName: doctor['middle_name'],
        lastName: doctor['last_name'],
        title: doctor['title'] ?? 'MD',
        contact: doctor['contact'],
        email: doctor['email'],
      );
    } else {
      await _openDoctorInfoDialog();
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  Future<void> _refreshPatientsList() async {
    _patients = await _dbHelper.getItems(tableName: 'patient');
  }

  Future<void> _refreshClinicsList() async {
    _clinics = await _dbHelper.getItems(tableName: 'clinic');
  }

  void _openPatientPage({int? newIndex}) async {
    if (newIndex != null) {
      _selectedPatientIndex = (newIndex < 0) ? null : newIndex;
    }

    if (_selectedPatientIndex == null) {
      Patient? newPatient = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PatientProfilePage(),
        ),
      );

      if (newPatient != null) {
        await _dbHelper.addPatient(newPatient);
        int? nextID = await _dbHelper.getNextIncrement('patient');
        await _refreshPatientsList();
        setState(() {
          _openPatientPage(
            newIndex: _patients.indexWhere(
              (patient) => patient['id'] == nextID,
            ),
          );
        });
      }
    } else {
      Map<String, dynamic> selectedPatient = _patients[_selectedPatientIndex!];
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientPage(
            doctor: _doctor,
            clinic: _clinics.isEmpty
                ? null
                : Clinic(
                    _clinics[_selectedClinicIndex]['id'],
                    name: _clinics[_selectedClinicIndex]['clinic_name'],
                    address: _clinics[_selectedClinicIndex]['clinic_addr'],
                  ),
            patient: Patient(
              selectedPatient['id'],
              firstName: selectedPatient['first_name'],
              middleName: selectedPatient['middle_name'],
              lastName: selectedPatient['last_name'],
              sex: selectedPatient['sex'],
              contact: selectedPatient['contact'],
              birthDate: DateTime.parse(selectedPatient['birthdate']),
              address: selectedPatient['addr'],
              erName: selectedPatient['er_name'],
              erRelation: selectedPatient['er_rel'],
              erAddress: selectedPatient['er_addr'],
              erContact: selectedPatient['er_contact'],
            ),
          ),
        ),
      );

      _selectedPatientIndex = null;
      setState(() {
        _refreshPatientsList();
      });
    }
  }

  Future<void> _openClinicInfoDialog({Clinic? existingClinic}) async {
    var newClinic = await showDialog(
      context: context,
      builder: (context) => ClinicInfoDialog(existingClinic: existingClinic),
    );

    if (existingClinic != null && newClinic.runtimeType == bool && !newClinic) {
      // remove clinic from list
      _database!.execute(
        'DELETE FROM clinic WHERE id = ?',
        [_clinics[_selectedClinicIndex]['id']],
      );

      setState(() {
        _refreshClinicsList();
        if (_clinics.isNotEmpty) {
          // select the first clinic in the list
          _selectedClinicIndex = 0;
        } else {
          // unset selected clinic
          _selectedClinicIndex = -1;
        }
      });
    } else if (existingClinic != null && newClinic.runtimeType == Clinic) {
      // update existing clinic's information
      _database!.execute(
        'UPDATE clinic SET clinic_name = ?, clinic_addr = ?, contact = ?, email = ? WHERE id = ?',
        [
          newClinic.name,
          newClinic.address,
          newClinic.contact,
          newClinic.contact,
          existingClinic.id,
        ],
      );

      setState(() {
        _refreshClinicsList();
      });
    } else if (newClinic.runtimeType == Clinic) {
      // adding new clinc to the list
      _database!.execute(
        'INSERT INTO clinic (clinic_name, clinic_addr, contact, email) VALUES (?, ?, ?, ?)',
        [
          newClinic.name,
          newClinic.address,
          newClinic.contact,
          newClinic.contact,
        ],
      );
      setState(() {
        _refreshClinicsList();
        _selectedClinicIndex = 0;
      });
    }
  }

  Future<void> _openDoctorInfoDialog() async {
    Doctor? doctor = await showDialog(
      context: context,
      builder: (context) => DoctorInfoDialog(existingDoctor: _doctor),
    );

    if (_doctor != null && doctor != null) {
      _database!.execute(
        '''
        UPDATE doctor SET license_id = ?, first_name = ?, middle_name = ?, last_name = ?, 
        title = ?, contact = ?, email = ? WHERE id = ?
        ''',
        [
          doctor.licenseID,
          doctor.firstName,
          doctor.middleName,
          doctor.lastName,
          doctor.title,
          doctor.contact,
          doctor.email,
          _doctor!.licenseID,
        ],
      );
      setState(() {
        _doctor = doctor;
      });
    } else if (doctor != null) {
      _database!.execute(
        '''
        INSERT INTO doctor (license_id, first_name, middle_name, last_name, title, contact, email) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          doctor.licenseID,
          doctor.firstName,
          doctor.middleName,
          doctor.lastName,
          doctor.title,
          doctor.contact,
          doctor.email,
        ],
      );
      setState(() {
        _doctor = doctor;
      });
    }
  }

  void _onSelectPatient(int index) {
    _selectedPatientIndex = index;
    _openPatientPage();
  }

  void _onSelectClinic(int index) {
    setState(() {
      _selectedClinicIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayout(layouts: [
        Layout(
          body: _mobileBody(
            context,
            scaffoldKey: _scaffoldKey,
            clinics: _clinics,
            patients: _patients,
            doctor: _doctor,
            openPatientPage: _openPatientPage,
            openDoctorInfoDialog: _openDoctorInfoDialog,
            openClinicInfoDialog: _openClinicInfoDialog,
            onSelectPatient: _onSelectPatient,
            onSelectClinic: _onSelectClinic,
            selectedClinicIndex: _selectedClinicIndex,
          ),
          // less than 760px width is considered mobile
          breakpoint: 760,
        ),
        Layout(
          body: _desktopBody(
            context,
            clinics: _clinics,
            patients: _patients,
            doctor: _doctor,
            openPatientPage: _openPatientPage,
            openDoctorInfoDialog: _openDoctorInfoDialog,
            openClinicInfoDialog: _openClinicInfoDialog,
            onSelectPatient: _onSelectPatient,
            onSelectClinic: _onSelectClinic,
            selectedClinicIndex: _selectedClinicIndex,
          ),
          // default screen if width does not fall in other screen categories
          breakpoint: double.infinity,
        ),
      ]),
    );
  }
}
