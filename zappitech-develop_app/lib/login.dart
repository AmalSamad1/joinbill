// import 'package:email_validator/email_validator.dart';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ziptech/entry.dart';
// import 'package:ziptech/index.dart';
// import 'package:ziptech/providers/authProvider.dart';
//
//
// import '../../../flutter_flow/flutter_flow_theme.dart';
// import '../../../components/circleLoading.dart';
// import '../../../flutter_flow/flutter_flow_icon_button.dart';
// import '../../../flutter_flow/flutter_flow_widgets.dart';
//
// import 'components/circleLoading.dart';
// import 'firbase_auth.dart';
// import 'flutter_flow/flutter_flow_widgets.dart';
// import 'google_sigin.dart';
// import 'helpers/loadingStates.dart';
//
// class Log1 extends StatefulWidget {
//   const Log1({Key key}) : super(key: key);
//
//   @override
//   State<Log1> createState() => _Log1State();
// }
//
// class _Log1State extends State<Log1> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   bool _isProcessing = false;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emaillog = new TextEditingController();
//   final TextEditingController passlog = new TextEditingController();
//   bool _validate = false;
//   bool _obscureText = true;
//   RegExp email_valid= RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   RegExp pass_valid = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,10}$');
//   //A function that validate user entered password
//   bool validatePassword(String pass) {
//     String _password = pass.trim();
//     if (pass_valid.hasMatch(_password)) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//  bool newuser;
//   @override
//   void initState() {
// // TODO: implement initState
//     super.initState();
//
//   }
//
//   @override
//   void dispose() {
// // Clean up the controller when the widget is disposed.
//     emaillog.dispose();
//     passlog.dispose();
//     super.dispose();
//   }
//
//   bool isEmail(String input) => EmailValidator.validate(input);
//   bool isPhone(String input) =>
//       RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
//           .hasMatch(input);
//   @override
//   Widget build(BuildContext context) {
//     bool register = true;
//     Size size = MediaQuery.of(context).size;
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isDarkMode = brightness == Brightness.dark;
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 colors: [
//                   Color.fromARGB(223, 82, 54, 43),
//                   Color.fromARGB(223, 82, 54, 43),
//                   Color.fromARGB(223, 82, 54, 43),
//                 ]
//             )
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 80,),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),),
//                   SizedBox(height: 10,),
//                   Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.all(30),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 60,),
//                         Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Colors.grey,
//                                       blurRadius: 20,
//                                       offset: Offset(0, 10)
//                                   )]
//                             ),
//                             child: Column(
//                                 children: <Widget>[
//                                   SingleChildScrollView(
//                                       child: Form(
//                                         key: _formKey,
//                                         child:Column(
//                                           children: [
//                                             Container(
//                                               padding: EdgeInsets.all(10),
//                                               decoration: BoxDecoration(
//                                                   border: Border(bottom: BorderSide(color: Colors.grey.shade200))
//                                               ),
//                                               child: TextFormField(
//
//                                                 controller: emaillog,
//                                                 validator: (value) {
//                                                   if (value.isEmpty||!email_valid.hasMatch(value)) {
//                                                     return 'Please enter the email address.';
//                                                   }
//                                                   return null;
//                                                 },
//
//                                                 decoration: InputDecoration(
//                                                     hintText: "Email ",
//                                                     hintStyle: TextStyle(color: Colors.grey),
//                                                     border: InputBorder.none
//                                                 ),
//                                               ),
//                                             ),
//                                             Container(
//                                               padding: EdgeInsets.all(10),
//                                               decoration: BoxDecoration(
//                                                   border: Border(bottom: BorderSide(color: Colors.grey.shade200))
//                                               ),
//                                               child: TextFormField(
//                                                 controller: passlog,
//                                                 autocorrect: true,
//                                                 obscureText: _obscureText,
//
//                                                 validator: (value){
//                                                   if(value.isEmpty||value==null){
//                                                     return "Please enter password";
//                                                   }
//                                                   if(!pass_valid.hasMatch(value)){
//                                                     //call function to check password
//                                                     return "Uppercase, lowercase, numbers";
//                                                   }else{
//                                                     return null;
//                                                   }
//                                                 },
//
//                                                 decoration: InputDecoration(suffixIcon: GestureDetector(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       _obscureText = !_obscureText;
//                                                     });
//                                                   },
//                                                   child: Icon(
//                                                     _obscureText ? Icons.visibility : Icons.visibility_off,
//                                                     semanticLabel:
//                                                     _obscureText ? 'show password' : 'hide password',
//                                                   ),
//                                                 ),
//                                                     hintText: "Password",
//                                                     hintStyle: TextStyle(color: Colors.grey),
//                                                     border: InputBorder.none
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ))])),
//                         SizedBox(height: 20,),
//                         Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
//                         SizedBox(height: 20,),
//
//                         FloatingActionButton.extended(
//                           isExtended: true,
//                           backgroundColor:Color.fromARGB(223, 82, 54, 43) ,
//                           onPressed: () async {
//                             // final user = FirebaseAuth.instance.currentUser;
//                             //
//                             // if (_formKey.currentState
//                             //     .validate()) {
//                             //
//                             //   setState(() {
//                             //     _isProcessing = true;
//                             //   });
//                             //   String username = emaillog.text;
//                             //   String password = passlog.text;
//                             //   if (username != '' && password != '') {
//                             //     print('Successfull');
//                             //     Navigator.defaultRouteName;
//                             //   }
//                             //   User user = await FireAuth.signInUsingEmailPassword(
//                             //     email: emaillog.text,
//                             //     password:
//                             //     passlog.text,
//                             //   );
//                             //
//                             //   setState(() {
//                             //     _isProcessing = false;
//                             //   });
//                             //
//                             //   if (user != null) {
//                             //     Navigator.pushNamed(context, "/home");
//                             //
//                             //   }
//                             // }
//
//
//                           },
//                           label: Text('                       Login                            '),
//                         ),
//                         SizedBox(height: 10,),
//                         _divider(),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 10),
//                           child: Consumer<AuthProvider>(
//                             builder: (context, authData, child) => authData
//                                 .loadingState ==
//                                 LoadingStates.loading
//                                 ? circleLoading(context)
//                                 : FFButtonWidget(
//                               onPressed: () async {
//                                 // if (_formKey.currentState.validate()) {
//                                 //   print("validated");
//                                   // authData
//                                   //     .signIn(
//                                   //         emailAddress: emailController.text.trim(),
//                                   //         password: passwordController.text.trim())
//                                   //     .then((value) {
//                                   //   if (authData.loadingState ==
//                                   //       LoadingStates.success) {
//                                   //     Navigator.pushReplacement(
//                                   //       context,
//                                   //       MaterialPageRoute(
//                                   //         builder: (context) => Entry(),
//                                   //       ),
//                                   //     );
//                                   //   } else {
//                                   //     ScaffoldMessenger.of(context)
//                                   //         .showSnackBar(SnackBar(
//                                   //             content:
//                                   //                 Text(authData.message)));
//                                   //   }
//                                   // });}
//                                   //  Navigator.push(
//                                   //       context,
//                                   //       MaterialPageRoute(
//                                   //         builder: (context) => PinCodeVerificationScreen(),
//                                   //       ),
//                                   //     );
//                                   // authData.signInOtp();
//
//                                 // authData.googleSignIn.signIn().then((value) => {
//                                 //
//                                 // });
//                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Entry()));
//                                   // Sign the user in (or link) with the credential
//                                 // signInWithGoogle().then((value) async {
//                                 //   if(value!=null){
//                                 //
//                                 //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Entry()));
//                                 //   }
//                                 // });
//
//                               },
//                               text: 'VERIFY',
//                               options: FFButtonOptions(
//                                 width: 130,
//                                 height: 40,
//                                 color: FlutterFlowTheme.of(context).primaryColor,
//                                 textStyle: FlutterFlowTheme.of(context)
//                                     .subtitle2
//                                     .override(
//                                   fontFamily: 'Poppins',
//                                   color: Colors.white,
//                                 ),
//                                 borderSide: BorderSide(
//                                   color: Colors.transparent,
//                                   width: 1,
//                                 ),
//                                 borderRadius: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                         FloatingActionButton.extended(
//                             backgroundColor: Colors.white70,
//                             isExtended: true,
//
//                             onPressed: (){
//
//                               // String username = emaillog.text;
//                               // String password = passlog.text;
//                               // final user = FirebaseAuth.instance.currentUser;
//
//                               setState(() {
//
//
//                                 // signInWithGoogle().then((value) async {
//                                 //   if(value!=null){
//                                 //
//                                 //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Entry()));
//                                 //   }
//                                 // });
//                               });
//                             },
//                             label: Row(children: [
//                               Image.asset("images/google_logo.png",height: 20),
//                               Text('     Sign in with Google     ',style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.grey,
//                               ),),])
//                         ),
//
//                         SizedBox(height: 10,),
//                         // RichText(
//                         //   textAlign: TextAlign.left,
//                         //   text: TextSpan(
//                         //     children: [
//                         //       TextSpan(
//                         //         onEnter: (event) => SignUp(),
//                         //         text: register
//                         //             ? "Don’t have an account yet? "
//                         //             : " Don’t have an account yet? ",
//                         //         style: TextStyle(
//                         //           color: isDarkMode
//                         //               ? Colors.white
//                         //               : const Color(0xff1D1617),
//                         //           fontSize: size.height * 0.018,
//                         //         ),
//                         //       ),
//                         //       WidgetSpan(
//                         //
//                         //         child: InkWell(
//                         //           onTap: () => setState(() {
//                         //             Navigator.of(context).push(MaterialPageRoute(builder: (c)=>SignUp()));
//                         //           }),
//                         //           child: register
//                         //               ? Text(
//                         //             "SignUp",
//                         //
//                         //             style: TextStyle(
//                         //               foreground: Paint()
//                         //                 ..shader = const LinearGradient(
//                         //                   colors: <Color>[
//                         //                     Color(0xffEEA4CE),
//                         //                     Color(0xffC58BF2),
//                         //                   ],
//                         //                 ).createShader(
//                         //                   const Rect.fromLTWH(
//                         //                     0.0,
//                         //                     0.0,
//                         //                     200.0,
//                         //                     70.0,
//                         //                   ),
//                         //                 ),
//                         //               fontSize: size.height * 0.018,
//                         //             ),
//                         //           )
//                         //               : Text(
//                         //             "Register",
//                         //             style: TextStyle(
//                         //               foreground: Paint()
//                         //                 ..shader = const LinearGradient(
//                         //                   colors: <Color>[
//                         //                     Color(0xffEEA4CE),
//                         //                     Color(0xffC58BF2),
//                         //                   ],
//                         //                 ).createShader(
//                         //                   const Rect.fromLTWH(
//                         //                       0.0, 0.0, 200.0, 70.0),
//                         //                 ),
//                         //               // color: const Color(0xffC58BF2),
//                         //               fontSize: size.height * 0.018,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _divider() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: <Widget>[
//           SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Divider(
//                 thickness: 1,
//               ),
//             ),
//           ),
//           Text('or'),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Divider(
//                 thickness: 1,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // class FadeAnimation extends StatelessWidget {
// //   final double delay;
// //   final Widget child;
// //
// //   FadeAnimation(this.delay, this.child);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final tween = MultiTrackTween([
// //       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
// //       Track("translateY").add(
// //           Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
// //           curve: Curves.easeOut)
// //     ]);
// //
// //     return ControlledAnimation(
// //       delay: Duration(milliseconds: (500 * delay).round()),
// //       duration: tween.duration,
// //       tween: tween,
// //       child: child,
// //       builderWithChild: (context, child, animation) => Opacity(
// //         opacity: animation["opacity"],
// //         child: Transform.translate(
// //             offset: Offset(0, animation["translateY"]),
// //             child: child
// //         ),
// //       ),
// //     );
// //   }
// // }
