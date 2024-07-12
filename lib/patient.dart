import 'package:flutter/material.dart';

import 'package:rxpro_app/utils.dart';

class PatientsDataTable extends StatelessWidget {
  const PatientsDataTable({super.key, required this.patients, required this.onSelected,});
  final void Function(int index) onSelected;
  final List<Map<String, dynamic>> patients;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            DateTime birthDate =
            DateTime.parse(patient['birthdate']);
            int age = getAge(birthDate);

            return DataRow(
              selected: patient['selected'] ?? false,
              cells: [
                DataCell(
                  Text(
                    '${patient["last_name"]}, ${patient["first_name"]} ${patient["middle_name"].toString()[0]}.',
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
        'Empty list.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
