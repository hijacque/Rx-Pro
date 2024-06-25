import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rxpro_app/responsive-layout.dart';

class _MobileBody extends StatefulWidget {
  const _MobileBody({super.key});

  @override
  State<_MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<_MobileBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _patientListScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100,
        title: Text('Rx Pro'),
      ),
      floatingActionButton: IconButton(
        onPressed: () {},
        style: IconButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade900
        ),
        color: Colors.white,
        icon: Icon(Icons.add),
      ),
      drawer: Drawer(
        width: 220,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 0.5,
                  blurRadius: 4
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          margin: EdgeInsets.all(18),
          padding: EdgeInsets.all(12),
          child: Text('Sidebar'),
        ),
      ),
      body: Row(
        children: [
          Drawer(
            width: 220,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(),
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.5,
                    blurRadius: 4
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(12),
              child: Text('Sidebar'),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 18, bottom: 18, right: 18),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0.5,
                          blurRadius: 4
                      )
                    ],
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text('Doctor\'s Information'),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 18, right: 18),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 0.5,
                            blurRadius: 4
                        )
                      ],
                      color:Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ListView.builder(
                      controller: _patientListScrollController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selected: (index == 2),
                          selectedTileColor: Colors.deepPurple.shade50,
                          style: ListTileStyle.drawer,
                          title: Text('Patient #$index'),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

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
