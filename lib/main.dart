import 'dart:convert';
// ignore: unused_import
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //disappear debug sign
      debugShowCheckedModeBanner: false,
      title: 'flutter get_json',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'flutter get_json'),
    );
  }
}

Future<List<Map<String, dynamic>>> loadJsonFromAssets(
    String LocalFilePath) async {
  String jsonString = await rootBundle.loadString(LocalFilePath);
  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.cast<Map<String, dynamic>>();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  bool _isCheckMen = false;
  bool _isCheckWomen = false;
  String jsonPath = 'assets/jsonFile/user.json';
  String UserName = '';
  bool? UserGender;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> origindata = [];
  List<Map<String, dynamic>> searchedData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    data = await loadJsonFromAssets(jsonPath);
    origindata = await loadJsonFromAssets(jsonPath);
    setState(() {});
  }

  List<Map<String, dynamic>> resultSearch() {
    List<Map<String, dynamic>> filteredData = List.from(origindata);

    //search name
    if (UserName.isNotEmpty) {
      filteredData
          .retainWhere((item) => item['name'].toString().contains(UserName));
    }
    //print(filteredData);

    //search gender
    if (UserGender != null) {
      filteredData.retainWhere(
          (item) => item['Gender'] == (UserGender! ? 'Male' : 'Female'));
    }
    //print(filteredData);
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              width: 300,
              height: 50,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 8.0),
              child: Container(
                child: Row(
                  children: [
                    SizedBox( width: MediaQuery.of(context).size.width*0.08 ,),
                    Text("NAME  :  "),
                    SizedBox( width: MediaQuery.of(context).size.width*0.10 ,),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Row(
                  children: [
                    SizedBox( width: MediaQuery.of(context).size.width*0.07 ,),
                    Text("Gender  :  "),
                    SizedBox( width: MediaQuery.of(context).size.width*0.10 ,),
                    Text("Male"),
                    SizedBox( width: MediaQuery.of(context).size.width*0.12 ,),
                    
                    Checkbox(
                      activeColor: Colors.blue,
                      value: _isCheckMen,
                      onChanged: (value) {
                        setState(() {
                          _isCheckMen = value!;
                          _isCheckWomen = false;
                        });
                      },
                    ),
                    SizedBox( width: MediaQuery.of(context).size.width*0.1 ,),
                    Text("Female"),
                    SizedBox( width: MediaQuery.of(context).size.width*0.12 ,),
                    Checkbox(
                      activeColor: Colors.red,
                      value: _isCheckWomen,
                      onChanged: (value) {
                        setState(() {
                          _isCheckWomen = value!;
                          _isCheckMen = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 70,
                  child: Row(
                    children: [
                      Text('search'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            UserName = myController.text;
                            UserGender = _isCheckMen
                                ? true
                                : _isCheckWomen
                                    ? false
                                    : null;
                            searchedData = resultSearch();
                            print(searchedData);
                            data = searchedData;
                          });
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white12,
                ),
                child: data.isEmpty
                    //on loading circul
                    ? Center(
                        child: Text(
                        'there is no data',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ))
                    : DataTable(
                        columns: const [
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('Gender')),
                          DataColumn(label: Text('Details')),
                        ],
                        rows: data.map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['name'])),
                              DataCell(Text(item['Gender'])),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => detailData(
                                            title: 'Details', data: item),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
