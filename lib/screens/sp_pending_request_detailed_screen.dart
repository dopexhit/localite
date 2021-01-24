import 'package:flutter/material.dart';
import 'package:localite/widgets/toast.dart';

class SPPendingRequestDetail extends StatefulWidget {
  final String spUID;
  final String userUID;
  final String requestID;

  SPPendingRequestDetail({this.requestID, this.spUID, this.userUID});

  @override
  _SPPendingRequestDetailState createState() => _SPPendingRequestDetailState();
}

class _SPPendingRequestDetailState extends State<SPPendingRequestDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
