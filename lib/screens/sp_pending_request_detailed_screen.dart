import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;

class SPPendingRequestDetail extends StatefulWidget {
  final String spUID;
  final String userUID;
  final String requestID;

  SPPendingRequestDetail({this.requestID, this.spUID, this.userUID});

  @override
  _SPPendingRequestDetailState createState() => _SPPendingRequestDetailState();
}

class _SPPendingRequestDetailState extends State<SPPendingRequestDetail> {
  bool asyncCall = true;
  String userName = '';
  String address = '';
  String description = '';
  double latitude = 0;
  double longitude = 0;
  String contact = '';
  String spName = '';
  Timestamp requestTime = Timestamp.now();
  String service = '';

  @override
  void initState() {
    super.initState();
    updateScreen();
  }

  void updateScreen() {
    var docRef = _firestore
        .collection('requests')
        .doc(widget.requestID)
        .collection('pending');

    docRef.get().then((value) {
      if (value.docs.isEmpty) {
        MyToast().getToast('No request found!');
      } else {
        for (var doc in value.docs) {
          setState(() {
            userName = doc.data()['user name'];
            spName = doc.data()['service provider'];
            latitude = doc.data()['latitude'];
            longitude = doc.data()['longitude'];
            address = doc.data()['address'];
            description = doc.data()['description'];
            contact = doc.data()['contact'];
            service = doc.data()['service'];
            requestTime = doc.data()['timestamp'];
            asyncCall = false;
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Text('name: $userName'),
                Text('description: $description'),
                Text('address: $address'),
                Text(requestTime.toDate().toString()),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.call), onPressed: () {}),
                        Text(contact),
                      ],
                    )),
                    Expanded(
                        child: IconButton(
                            icon: Icon(Icons.message), onPressed: () {})),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.location_on), onPressed: () {}),
                    Text('Find on map')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.red),
                            Text('Decline'),
                          ],
                        ),
                        onPressed: () async {
                          // delete pending request
                          var docRef = _firestore
                              .collection('requests')
                              .doc(widget.requestID)
                              .collection('pending');

                          docRef.get().then((value) {
                            if (value.docs.isEmpty) {
                              MyToast().getToast('No request found!');
                            } else {
                              _firestore.runTransaction((transaction) async {
                                transaction.delete(value.docs.first.reference);
                              });
                            }
                          });

                          // make user pending request false
                          _firestore
                              .collection('Users')
                              .doc(widget.userUID)
                              .collection('requests')
                              .doc(widget.spUID)
                              .update({
                            'pending': false,
                          });

                          // make service provider pending request false
                          _firestore
                              .collection('Service Providers')
                              .doc(widget.spUID)
                              .collection('requests')
                              .doc(widget.userUID)
                              .update({
                            'pending': false,
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                        child: RawMaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          Text('Accept'),
                        ],
                      ),
                      onPressed: () {
                        // delete pending request
                        var docRef = _firestore
                            .collection('requests')
                            .doc(widget.requestID)
                            .collection('pending');

                        docRef.get().then((value) {
                          if (value.docs.isEmpty) {
                            MyToast().getToast('No request found!');
                          } else {
                            _firestore.runTransaction((transaction) async {
                              transaction.delete(value.docs.first.reference);
                            });
                          }
                        });

                        // push pending data in completed request list
                        var docRefCompleted = _firestore
                            .collection('requests')
                            .doc(widget.requestID)
                            .collection('completed')
                            .add({
                          'service': service,
                          'description': description,
                          'service provider': spName,
                          'user name': userName,
                          'address': address,
                          'latitude': latitude,
                          'longitude': longitude,
                          'contact': contact,
                          'timestamp': requestTime,
                        });
                        // make user pending request = false and completed = true
                        _firestore
                            .collection('Users')
                            .doc(widget.userUID)
                            .collection('requests')
                            .doc(widget.spUID)
                            .update({'pending': false, 'completed': true});

                        // make service provider pending request = false completed = true
                        _firestore
                            .collection('Service Providers')
                            .doc(widget.spUID)
                            .collection('requests')
                            .doc(widget.userUID)
                            .update({'pending': false, 'completed': true});

                        Navigator.pop(context);
                      },
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
