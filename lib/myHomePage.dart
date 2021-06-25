import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage({required this.user});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? userID;

  String? userName;

  bool localStorageAccess=false;

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.containsKey("email"));
    if (prefs.getString("email") != null &&
        prefs.getString("name") != null) {
      // print("inside if");
      this.userID = prefs.getString("email");
      this.userName = prefs.getString("name");
      setState((){
        // print("Set State called");
        localStorageAccess=true;
      });

    }
  }
  /*
  * API Call: https://api3.moodi.org/ccp_temp
  * Response if successfully creating temp-account= "Success"
  * Response if account already exists= {"status":"Already Exists","referral_code":"CC00000"}
  * Response if bad call = "fuck"
  *
  * */
  send_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("into send data");
    if(prefs.getString("email")!=null && prefs.getString("name")!=null && prefs.getString("gid")!=null && prefs.getString("pic_url")!=null) {

      String name =prefs.getString("name") ?? "";
      String email =prefs.getString("email") ?? "";
      String gid =prefs.getString("gid") ?? "";
      String pic_url =prefs.getString("pic_url") ?? "";


      // String email=prefs.getString("email");
      // print("into if statement before response");
      // String email ="dummyemail@gmail.com";
      // String name ="dummyname";
      // print("obj $email $name $gid $pic_url");
      // print("JSon Encode");
      // print(jsonEncode(<String, String>{
      //   'email': email,
      //   "name": name,
      //   "gid": gid.substring(0,25),
      //   "profile_url": pic_url
      // }));


      final response = await http.post(
        Uri.parse('https://api3.moodi.org/ccp_temp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          "name": name,
          "gid": gid.substring(0,25),
          "profile_url": pic_url
        }),
      );
      // print("after response");
      print(response.body);
      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.
        // print("Printing data from api3");
        // print(jsonDecode(response.body));
        // print((response.body));

        /*
        * Logic for showing the regis form, (if response=="Success")
        * else load all regis detail and show home page
        *
        * */

      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        // print(response);
        throw Exception('Failed to get.');
      }
    }
    else{
      print("Error in Local Storage");
    }
  }



  Widget getLocalDataWidget(bool storage){
    // bool cond= setData();
    if (storage) {
    // if (localStorageAccess) {
      return Column(
        children: [

          Text("Got data from local storage",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
          Text("Name: $userID"),
          Text("Name: $userName"),
        ],
      );
    }
    else{
      return Text("Didn't find local storage data",
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    send_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Email:" + (widget.user.email).toString()),
          Text("Name:" + (widget.user.displayName).toString()),
          getLocalDataWidget(localStorageAccess),
        ],
      ),
    );
  }
}
