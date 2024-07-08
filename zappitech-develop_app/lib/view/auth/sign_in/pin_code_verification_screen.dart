import 'dart:async';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../components/circleLoading.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../helpers/loadingStates.dart';
import '../../../providers/authProvider.dart';
import 'package:firebase_auth_platform_interface/src/auth_provider.dart' as FirebaseProvider;
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/providers/authProvider.dart' hide AuthProvider;

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  final Function? signin;

  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
    this.signin,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: GestureDetector(
          onTap: () {},
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 660,
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Phone Number Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                    child: RichText(
                      text: TextSpan(
                          text: "Enter the code sent to ",
                          children: [
                            TextSpan(
                                text: "${widget.phoneNumber}",
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 50),
                        child: PinCodeTextField(
                          appContext: context,
                          autoFocus: true,
                          autoDismissKeyboard: true,
                          pastedTextStyle: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: true,
                          obscuringCharacter: '*',
          
                          blinkWhenObscuring: true,
                          animationType: AnimationType.none,
                          validator: (v) {
                            if (v!.length < 6) {
                              return "${v.length}/6";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            errorBorderColor: Colors.red,
                            disabledColor: Colors.grey,
                            activeColor:
                                FlutterFlowTheme.of(context).primaryColor,
                            inactiveColor: Colors.black54,
                            selectedColor: Colors.green,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 0),
          
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          // boxShadows: const [
                          //   BoxShadow(
                          //     offset: Offset(0, 1),
                          //     color: Colors.black12,
                          //     blurRadius: 10,
                          //   )
                          // ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "*Please fill up all the cells properly" : "",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code? ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () => snackBar("OTP resend!!"),
                        child: Text(
                          "RESEND",
                          style: TextStyle(
                              color: FlutterFlowTheme.of(context)
                                  .primaryColor
                                  !.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 10),
                    child: Consumer<AuthProvider>(
                      builder: (context, authData, child) => authData
                                  .loadingState ==
                              LoadingStates.loading
                          ? circleLoading(context)
                          : FFButtonWidget(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  print("validated");
                                  // authData
                                  //     .signIn(
                                  //         emailAddress: emailController.text.trim(),
                                  //         password: passwordController.text.trim())
                                  //     .then((value) {
                                  //   if (authData.loadingState ==
                                  //       LoadingStates.success) {
                                  //     Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => Entry(),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     ScaffoldMessenger.of(context)
                                  //         .showSnackBar(SnackBar(
                                  //             content:
                                  //                 Text(authData.message)));
                                  //   }
                                  // });}
                                  //  Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => PinCodeVerificationScreen(),
                                  //       ),
                                  //     );
                                  // authData.signInOtp();
                                  authData.setSmsCode(textEditingController.text);
                                  widget.signin!();
          
                                  // Sign the user in (or link) with the credential
                                }
                              },
                              text: 'VERIFY',
                              options: FFButtonOptions(
                                width: 130,
                                height: 40,
                                color: FlutterFlowTheme.of(context).primaryColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: 12,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
