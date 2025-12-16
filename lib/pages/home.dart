import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                Text("Balucor, Sylhet", style:TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w500)),
              ],
            ),
              SizedBox(height: 10.0),
              Text("Hello, Fardeen", style:TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Text("There are 20 events \naround your location", style:TextStyle(color: Color(0xff6351ec), fontSize: 25.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search_outlined
                  ), border: InputBorder.none, hintText: "Search a Location"
                ),
              ),
            )
        ],),
      ),
    );
  }
}
