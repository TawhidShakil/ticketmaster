import 'package:flutter/material.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadEvent> {
  List<String> eventcategory = [
    "Seminar",
    "Workshop",
    "Conference",
    "Festival",
  ];

  String? selectedEventType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0, left: 20, right: 20, bottom: 40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined),
                ),
                // SizedBox(width: MediaQuery.of(context).size.width / 5.5),
                Expanded(
                  child: Center(
                    child: Text(
                      "Upload Event",
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Builder(
                builder: (context) {
                  return Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(Icons.camera_alt_outlined),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Event Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Event Name",
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 30.0),
            Text(
              "Ticket Price",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Price",
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "Select Category",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                items: eventcategory
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEventType = value;
                  });
                },
                dropdownColor: Colors.white,
                hint: Text("Select Category"),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                value: selectedEventType,
                underline: Container(),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Event Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What will be on the event .....",
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child:  Container(
              decoration: BoxDecoration(
                color: Color(0xff6351ec),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 200,
              height: 50,
              child: Center(
                child: Text(
                  "Upload",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ),
            )
          ],
        ),
      ),
    );
  }
}
