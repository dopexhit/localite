import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  @override
  _ServiceProviderHomeScreenState createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  bool pendingVisibility = true;
  bool completedVisibility = true;
  int flexPending = 1;
  int flexCompleted = 1;
  bool pendingIconDown = true;
  bool completedIconDown = true;
  IconData pendingIcon = Icons.keyboard_arrow_down_rounded;
  IconData completedIcon = Icons.keyboard_arrow_down_rounded;

  @override
  Widget build(BuildContext context) {
    GlobalContext.context = context;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Text('Service provider screen'),
            RaisedButton(
              onPressed: () async {
                SharedPrefs.preferences.remove('isServiceProvider');
                await AuthService().signOut().whenComplete(
                  () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectionScreen()));
                  },
                );
              },
              child: Text('SignOut'),
            ),
            Expanded(
                flex: flexPending,
                child: Visibility(
                    visible: pendingVisibility,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 10),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Pending requests',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 8),
                              Expanded(child: ListView()),
                              SizedBox(
                                height: 30,
                                child: RawMaterialButton(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      flexCompleted = (flexCompleted + 1) % 2;
                                      completedVisibility =
                                          !completedVisibility;
                                      if (pendingIconDown == true) {}
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))),
            Expanded(
                flex: flexCompleted,
                child: Visibility(
                    visible: completedVisibility,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        elevation: 5,
                        child: Text('jj'),
                      ),
                    )))
          ],
        )),
      ),
    );
  }
}
