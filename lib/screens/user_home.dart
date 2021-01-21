import 'package:flutter/material.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/offered_services.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String location;
  String searchValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  location = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                decoration:
                    kLoginDecoration.copyWith(hintText: 'Enter your location'),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  searchValue = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'search',
                  icon: Icon(
                    Icons.person_search_sharp,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: getCards(),
                  ),
                ),
              )
            ],
          ),
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

List<CustomCard> getCards() {
  List<CustomCard> myCards = [];

  for (var service in servicesList) {
    myCards.add(CustomCard(title: service));
  }
  return myCards;
}

class CustomCard extends StatelessWidget {
  final String title;
  CustomCard({this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
