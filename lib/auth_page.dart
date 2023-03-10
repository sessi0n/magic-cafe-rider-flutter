// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
//
//
// class AuthController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   initialize() async {
//     await Firebase.initializeApp();
//   }
//
//   // Future getUser() {
//   //   return _auth.currentUser();
//   // }
//
// }
//
// class AuthPage extends StatelessWidget {
//   AuthPage({Key? key}) : super(key: key);
//
//   AuthController auth = AuthController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       home: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.active) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final user = snapshot.data;
//           if (user != null &&
//               FirebaseAuth.instance.currentUser!.emailVerified == true) {
//             print("user is logged in");
//             print(user);
//             // return HomeScreen();
//             return Container();
//           } else {
//             print("user is not logged in");
//             // return LoginScreen();
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
