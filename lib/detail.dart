import 'package:flutter/material.dart';

class detailData extends StatefulWidget {
  const detailData({super.key, required this.title, required this.data});

  final String title;
  final Map<String, dynamic> data;

  @override
  State<detailData> createState() => _detailDataState();
}

class _detailDataState extends State<detailData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            child: Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.8),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.2),
                  height: 70,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.07),
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          Container(
            child: Row(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.1),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'NAME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.1),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Gender',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('age')),
                DataColumn(label: Text('food')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(widget.data['name'])),
                  DataCell(Text(widget.data['Gender'])),
                  DataCell(Text(widget.data['age'])),
                  DataCell(Text(widget.data['food'])),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
