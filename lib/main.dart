import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

void main() async {
  Map _data = await getQuakes();
  List _features = _data['features'];
//  print(_features.length);
//  for (int i = 0; i < _features.length; i++) {
//    print(dateString(_features[i]['properties']['time']));
//  }

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Earthquakes"),
        centerTitle: true,
      ),
      body: new Center(
        child: new ListView.separated(
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int postion) {
            return new ListTile(
              onTap: () {
                 _showOnTapMessage(context, "${_features[postion]['properties']['title']}");
              },
              leading: new CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: new Text("${_features[postion]['properties']['mag']}"),
              ),
              title: new Text(
                "${dateString(_features[postion]['properties']['time'])}",
                style: new TextStyle(
                    color: Colors.orangeAccent, fontWeight: FontWeight.w500),
              ),
              subtitle:
                  new Text("${_features[postion]['properties']['place']}"),
            );
          },
          separatorBuilder: (BuildContext context, int position) {
            return new Divider(
              height: 20.0,
              color: Colors.blueAccent,
            );
          },
          itemCount: _features.length,
        ),
      ),
    ),
  ));
}

Future<Map> getQuakes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

String dateString(int dms) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(dms);
  var format = new DateFormat.yMMMMd("en_US").add_jm();
  var dateString = format.format(date);
  return dateString;
}

void _showOnTapMessage(BuildContext context, String message){
  var alert = new AlertDialog(
    title: new Text("Title"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: () {Navigator.pop(context);}, child: new Text("Ok"))
    ],
  );
  showDialog(context: context, child: alert);
}
