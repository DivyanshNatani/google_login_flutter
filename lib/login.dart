import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'myHomePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Login"),
        ),
        body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User? user;

  @override
  void initState() {
    super.initState();
    Authentication.initializeFirebase();
    Authentication.signOutWithGoogle();
  }

  void click() {
    Authentication.signInWithGoogle().then((user) {
      print(user);
      if (user != null)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      user: user,
                    )));
    });
  }

  Widget googleLoginButton() {
    return OutlinedButton(
      onPressed: this.click,
      style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
          primary: Colors.grey,
          side: BorderSide(color: Colors.grey)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage('assets/google_logo.png'),
              height: 35,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}
