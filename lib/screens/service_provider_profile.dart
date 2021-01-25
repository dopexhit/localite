import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class SPProfile extends StatefulWidget {
  @override
  _SPProfileState createState() => _SPProfileState();
}

class _SPProfileState extends State<SPProfile> {
  @override
  Widget build(BuildContext context) {
    ServiceProviderData data = Provider.of<SPDetails>(context).getSPDetails;

    return Container(
      child: Row(
        children: [
          Text('sp profile'),
        ],
      ),
    );
  }
}
