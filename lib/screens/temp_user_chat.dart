import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class TempUserChat extends StatefulWidget {
  @override
  _TempUserChatState createState() => _TempUserChatState();
}

class _TempUserChatState extends State<TempUserChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('UserChats'),
    );
  }
}
