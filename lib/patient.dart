import 'package:flutter/material.dart';

import 'package:rxpro_app/style.dart';
import 'package:rxpro_app/utils.dart';

const Map<int, String> _sex = {1: 'MALE', 2: 'FEMALE', 3: 'INTERSEX'};

class Patient {
  final int id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String address;
  final int sex;
  final DateTime birthDate;
  final String? contact;

  final String? erName;
  final String? erAddress;
  final String? erRelation;
  final String? erContact;

  const Patient(
    this.id, {
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.sex,
    required this.birthDate,
    required this.address,
    this.contact,
    this.erName,
    this.erRelation,
    this.erContact,
    this.erAddress,
  });

  String get sexText => _sex[sex] ?? 'N/A';
}

class PatientsDataTable extends StatelessWidget {
  const PatientsDataTable({
    super.key,
    required this.patients,
    required this.onSelected,
  });
  final void Function(int index) onSelected;
  final List<Map<String, dynamic>> patients;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: (patients.isEmpty)
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 18)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(
        left: 18,
        bottom: 18,
        right: 18,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 0.5,
            blurRadius: 4,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: (patients.isNotEmpty)
          ? DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Age')),
                DataColumn(label: Text('Sex')),
              ],
              columnSpacing: 24,
              rows: List.generate(
                patients.length,
                (index) {
                  var patient = patients[index];
                  DateTime birthDate = DateTime.parse(patient['birthdate']);
                  int age = getAge(birthDate);

                  return DataRow(
                    selected: patient['selected'] ?? false,
                    cells: [
                      DataCell(
                        Text(
                          '${patient["last_name"]}, ${patient["first_name"]}${patient["middle_name"] != null ? ' ${patient["middle_name"][0]}.' : ''}',
                        ),
                        onTap: () => onSelected(index),
                      ),
                      DataCell(
                        Text(age.toString()),
                        onTap: () => onSelected(index),
                      ),
                      DataCell(
                        Text(
                          (patient['sex'] == 1)
                              ? 'M'
                              : (patient['sex'] == 2)
                                  ? 'F'
                                  : (patient['sex'] == 3)
                                      ? 'I'
                                      : 'N/A',
                        ),
                        onTap: () => onSelected(index),
                      ),
                    ],
                  );
                },
              ),
            )
          : const Text(
              'No patients recorded.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
    );
  }
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
