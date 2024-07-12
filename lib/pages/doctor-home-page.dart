import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'package:rxpro_app/pages/new-prescription-page.dart';
import 'package:rxpro_app/style.dart';
import 'package:rxpro_app/pages/patient-info-page.dart';
import 'package:rxpro_app/responsive-layout.dart';
import 'package:rxpro_app/database.dart';
import 'package:rxpro_app/patient.dart';
import 'package:rxpro_app/doctor.dart';
import 'package:rxpro_app/clinic.dart';

Widget _mobileBody(
  BuildContext buildContext, {
  required GlobalKey<ScaffoldState> scaffoldKey, // mobile only
  required List<Map<String, dynamic>> clinics,
  required List<Map<String, dynamic>> patients,
  required void Function({int? newIndex}) moveToPatientPage,
  required void Function() openDoctorInfoDialog,
  required void Function() openClinicInfoDialog,
  required void Function(int index) onSelectedPatient,
  Doctor? doctor,
}) {
  return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      backgroundColor: Colors.deepPurple.shade100,
      title: const Text('Rx Pro'),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            style: lightButtonStyle,
            onPressed: () {
              if (doctor != null && clinics.isNotEmpty) {
                Navigator.push(
                    buildContext,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionPage(
                        doctor: doctor,
                        clinic: Clinic(
                          name: clinics[0]['facility_name'],
                          address: clinics[0]['facility_addr'],
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
      shape: const RoundedRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0.5, blurRadius: 4)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: LIGHT_PURPLE, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    (doctor != null)
                        ? '''${doctor.firstName[0].toString().toUpperCase()}${doctor.lastName[0].toString().toUpperCase()}'''
                        : 'DR',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    (doctor != null)
                        ? '${doctor.firstName} ${doctor.middleName[0]}. ${doctor.lastName}, ${doctor.title}'
                        : 'No name',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              doctor?.specialty ?? 'No specialty',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              doctor?.contact ?? 'No contact information',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
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
                  onPressed: openClinicInfoDialog,
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
                  child: ListTile(
                    onTap: openClinicInfoDialog,
                    title: Text(
                      clinics[index]['facility_name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(clinics[index]['facility_addr']),
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
                onPressed: () => moveToPatientPage(newIndex: -1),
                style: primaryButtonStyle,
                color: LIGHT,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: PatientsDataTable(
            patients: patients,
            onSelected: onSelectedPatient,
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
  required void Function({int? newIndex}) moveToPatientPage,
  required void Function() openDoctorInfoDialog,
  required void Function() openClinicInfoDialog,
  required void Function(int index) onSelectedPatient,
  Doctor? doctor,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple.shade100,
      title: const Text(' Rx Pro '),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            style: lightButtonStyle,
            onPressed: () {
              if (doctor != null && clinics.isNotEmpty) {
                Navigator.push(
                    buildContext,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionPage(
                        doctor: doctor,
                        clinic: Clinic(
                          name: clinics[0]['facility_name'],
                          address: clinics[0]['facility_addr'],
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: LIGHT_PURPLE, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        (doctor != null)
                            ? '''${doctor.firstName[0].toString().toUpperCase()}${doctor.lastName[0].toString().toUpperCase()}'''
                            : 'DR',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        (doctor != null)
                            ? '${doctor.firstName} ${doctor.middleName[0]}. ${doctor.lastName}, ${doctor.title}'
                            : 'No name',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  doctor?.specialty ?? 'No specialty',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  doctor?.contact ?? 'No contact information',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),
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
                      onPressed: openClinicInfoDialog,
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
                      child: ListTile(
                        onTap: openClinicInfoDialog,
                        title: Text(
                          clinics[index]['facility_name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(clinics[index]['facility_addr']),
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
                      onPressed: () => moveToPatientPage(newIndex: -1),
                      style: primaryButtonStyle,
                      color: LIGHT,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PatientsDataTable(
                  patients: patients,
                  onSelected: onSelectedPatient,
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
  List<Map<String, dynamic>> _clinics = [];
  int? _selectedPatientIndex;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeDatabase(onEmptyDoctor: _onEmptyDoctor).then(
      (value) => setState(() {}),
    );
  }

  void _onEmptyDoctor() {
    double width = MediaQuery.sizeOf(context).width;
    if (width < 760) {
      // open drawer if mobile view
      _scaffoldKey.currentState!.openDrawer();
    } else {
      // display SnackBar if desktop view
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please provide missing doctor and/or clinic information.',
        ),
        duration: Duration(milliseconds: 800),
      ));
    }
  }

  Future<void> _initializeDatabase({required Function() onEmptyDoctor}) async {
    _dbHelper = RxProDbHelper.instance;
    _database = await _dbHelper.database;

    _patients = await _dbHelper.getItems(tableName: 'patient');

    var doctors = await _dbHelper.getItems(tableName: 'doctor');
    if (doctors.isNotEmpty) {
      Map<String, dynamic> doctor = doctors[0];
      _doctor = Doctor(
        firstName: doctor['first_name'],
        middleName: doctor['middle_name'],
        lastName: doctor['last_name'],
        title: doctor['title'] ?? 'MD',
        specialty: doctor['specialty'],
      );
    } else {
      onEmptyDoctor();
    }

    _clinics = await _dbHelper.getItems(tableName: 'hc_facility');
  }

  void _refreshPatientsList() async {
    _patients = await _dbHelper.getItems(tableName: 'patient');
  }

  void _refreshClinicsList() async {
    _clinics = await _dbHelper.getItems(tableName: 'hc_facility');
  }

  void _moveToPatientPage({int? newIndex}) async {
    if (newIndex != null) {
      _selectedPatientIndex = (newIndex < 0) ? null : newIndex;
    }

    if (_selectedPatientIndex == null) {
      Patient? newPatient = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientPage(
            doctor: _doctor,
            clinic: _clinics.isEmpty
                ? null
                : Clinic(
                    name: _clinics[0]['facility_name'],
                    address: _clinics[0]['facility_addr'],
                  ),
          ),
        ),
      );

      if (newPatient != null) {
        _dbHelper.addPatient(
          firstName: newPatient.firstName,
          middleName: newPatient.middleName,
          lastName: newPatient.lastName,
          birthDate: newPatient.birthDate,
          sex: newPatient.sex,
          mobile: newPatient.contact,
        );
        setState(() {
          _refreshPatientsList();
        });
      }
    } else {
      Map<String, dynamic> selectedPatient = _patients[_selectedPatientIndex!];

      var updatedPatient = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientPage(
            doctor: _doctor,
            clinic: _clinics.isEmpty
                ? null
                : Clinic(
                    name: _clinics[0]['facility_name'],
                    address: _clinics[0]['facility_addr'],
                  ),
            existingPatient: Patient(
              firstName: selectedPatient['first_name'],
              middleName: selectedPatient['middle_name'],
              lastName: selectedPatient['last_name'],
              sex: selectedPatient['sex'],
              contact: selectedPatient['mobile'],
              birthDate: DateTime.parse(selectedPatient['birthdate']),
            ),
          ),
        ),
      );

      if (updatedPatient.runtimeType == bool && !updatedPatient) {
        // the patient's information was deleted
        _database!.execute(
          'DELETE FROM patient WHERE id = ?',
          [selectedPatient['id']],
        );
      } else if (updatedPatient.runtimeType == Patient) {
        _database!.execute(
          '''
          UPDATE patient SET first_name = ?, middle_name = ?, last_name = ?, sex = ?, birthdate = ?, mobile = ?
          WHERE id = ?
          ''',
          [
            updatedPatient!.firstName,
            updatedPatient!.middleName,
            updatedPatient!.lastName,
            updatedPatient!.sex,
            updatedPatient!.birthDate.toString(),
            updatedPatient.contact,
            selectedPatient['id'],
          ],
        );

        _selectedPatientIndex = null;
        setState(() {
          _refreshPatientsList();
        });
      }
    }
  }

  Future<void> _openClinicInfoDialog() async {
    Clinic? newClinic = await showDialog(
      context: context,
      builder: (context) => const ClinicInfoDialog(),
    );

    if (newClinic != null) {
      _database!.execute(
        'INSERT INTO hc_facility (facility_name, facility_addr) VALUES (?, ?)',
        [newClinic.name, newClinic.address],
      );
      setState(() {
        _refreshClinicsList();
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
        'UPDATE doctor SET first_name = ?, middle_name = ?, last_name = ?, specialty = ?, contact = ? WHERE id = ?',
        [
          doctor.firstName,
          doctor.middleName,
          doctor.lastName,
          doctor.specialty,
          doctor.contact,
          1
        ],
      );
      setState(() {
        _doctor = doctor;
      });
    } else if (doctor != null) {
      _database!.execute(
        '''
        INSERT INTO doctor (first_name, middle_name, last_name, title, specialty, contact) 
        VALUES (?, ?, ?, ?, ?, ?)
        ''',
        [
          doctor.firstName,
          doctor.middleName,
          doctor.lastName,
          doctor.title,
          doctor.specialty,
          doctor.contact
        ],
      );
      setState(() {
        _doctor = doctor;
      });
    }
  }

  void _onSelectedPatient(int index) {
    _selectedPatientIndex = index;
    _moveToPatientPage();
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
            moveToPatientPage: _moveToPatientPage,
            openDoctorInfoDialog: _openDoctorInfoDialog,
            openClinicInfoDialog: _openClinicInfoDialog,
            onSelectedPatient: _onSelectedPatient,
          ),
          // less than 480px width is considered mobile
          breakpoint: 760,
        ),
        Layout(
          body: _desktopBody(
            context,
            clinics: _clinics,
            patients: _patients,
            doctor: _doctor,
            moveToPatientPage: _moveToPatientPage,
            openDoctorInfoDialog: _openDoctorInfoDialog,
            openClinicInfoDialog: _openClinicInfoDialog,
            onSelectedPatient: _onSelectedPatient,
          ),
          // default screen if width does not fall in other screen categories
          breakpoint: double.infinity,
        ),
      ]),
    );
  }
}
