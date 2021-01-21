import 'package:flutter/material.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  @override
  _ServiceProviderHomeScreenState createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('service provider screen'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(child: Icon(Icons.chat)),
            Expanded(child: Icon(Icons.home_filled)),
            Expanded(child: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
