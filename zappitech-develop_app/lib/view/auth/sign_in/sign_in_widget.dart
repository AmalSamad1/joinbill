import 'package:flutter/cupertino.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:provider/provider.dart';
import 'package:ziptech/entry.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/view/auth/sign_in/pin_code_verification_screen.dart';

import '../../../components/circleLoading.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../helpers/loadingStates.dart';
import '../../dashboard/home_widget.dart';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sign_up/sign_up_widget.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  DateTime? datePicked1;
  TextEditingController? phoneController;
  DateTime? datePicked2;

  String countryCode = "+91";
  bool? passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();

    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
        child: Consumer<AuthProvider>(
          builder: (context, authData, child) =>
          authData.loadingState == LoadingStates.loading
              ? circleLoading(context)
              : FFButtonWidget(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
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
                authData.signInOtp(context: context,
                    phone:
                    "$countryCode${phoneController!.text}");
              }
              // authData.signInOtp();
            },
            text: 'SEND OTP',
            options: FFButtonOptions(
              width: 300,
              height: 40,
              color: FlutterFlowTheme.of(context)
                  .primaryColor,
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
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: Container(
                width: 660,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height:50 ,),
                      Container(
                          constraints: const BoxConstraints(
                              maxWidth: 500
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(text: 'We will send you an ', style: TextStyle(color:FlutterFlowTheme.of(context).primaryColor)),
                              TextSpan(
                                  text: 'One Time Password ', style: TextStyle(color: FlutterFlowTheme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'on this mobile number', style: TextStyle(color:FlutterFlowTheme.of(context).primaryColor)),
                            ]),
                          )),
                      SizedBox(height:50 ,),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Container(
                          //   height: 60,
                          //   constraints: const BoxConstraints(
                          //       maxWidth: 500
                          //   ),
                          //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          //   child: CupertinoTextField(prefix: Text( "   $countryCode"),
                          //     padding: const EdgeInsets.symmetric(horizontal: 16),
                          //     decoration: BoxDecoration(
                          //         color: Colors.grey.shade100,
                          //         borderRadius: const BorderRadius.all(Radius.circular(4))
                          //     ),
                          //     controller: phoneController,
                          //     clearButtonMode: OverlayVisibilityMode.editing,
                          //     keyboardType: TextInputType.phone,
                          //     maxLines: 1,
                          //     placeholder: 'Enter your phone number',
                          //     placeholderStyle: TextStyle(fontSize: 14,fontFamily:'Poppins'),
                          //   ),
                          // ),
                          Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 40, 16, 16),
                              child: IntlPhoneField(
                                keyboardType: TextInputType.number,
                                dropdownIconPosition: IconPosition.trailing,
                                controller: phoneController,
                                onCountryChanged: (value) {
                                  print(value.dialCode);
                                },
                                flagsButtonMargin:
                                    EdgeInsets.symmetric(horizontal: 8),
                                decoration: InputDecoration(
                                  labelText: 'Phone number',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xD3101213),
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primaryColor!,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primaryColor!,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  print(phoneController!.text);
                                },
                              )
                              // TextFormField(
                              //   controller: emailController,
                              //   validator: (value) {
                              //     if (value == '' || value == null) {
                              //       return "field cannot be empty";
                              //     } else if (!value.contains('@') ||
                              //         !value.contains('.')) {
                              //       return 'enter a valid email';
                              //     }
                              //     return null;
                              //   },
                              //   onChanged: (_) => EasyDebounce.debounce(
                              //     'emailController',
                              //     Duration(milliseconds: 2000),
                              //     () => setState(() {}),
                              //   ),
                              //   onFieldSubmitted: (_) async {
                              //     await DatePicker.showDatePicker(
                              //       context,
                              //       showTitleActions: true,
                              //       onConfirm: (date) {
                              //         setState(() => datePicked1 = date);
                              //       },
                              //       currentTime: getCurrentTimestamp,
                              //       minTime: getCurrentTimestamp,
                              //     );
                              //   },
                              //   autofocus: true,
                              //   obscureText: false,
                              //   decoration: InputDecoration(
                              //     labelText: 'Username',
                              //     labelStyle:
                              //         FlutterFlowTheme.of(context).bodyText1.override(
                              //               fontFamily: 'Poppins',
                              //               color: Color(0xD3101213),
                              //             ),
                              //     hintText: 'example@mail.com',
                              //     hintStyle:
                              //         FlutterFlowTheme.of(context).bodyText1.override(
                              //               fontFamily: 'Poppins',
                              //               color: Color(0x81101213),
                              //             ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color:
                              //             FlutterFlowTheme.of(context).primaryColor,
                              //         width: 1,
                              //       ),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color:
                              //             FlutterFlowTheme.of(context).primaryColor,
                              //         width: 1,
                              //       ),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //   ),
                              //   style: FlutterFlowTheme.of(context).bodyText1,
                              //   textAlign: TextAlign.start,
                              // ),
                              ),
                        ],
                      ),
                      // Column(
                      //   mainAxisSize: MainAxisSize.max,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      //       child: TextFormField(
                      //         controller: passwordController,
                      //         validator: (value) {
                      //           if (value == '' || value == null) {
                      //             return "field cannot be empty";
                      //           }
                      //           return null;
                      //         },
                      //         onChanged: (_) => EasyDebounce.debounce(
                      //           'passwordController',
                      //           Duration(milliseconds: 2000),
                      //           () => setState(() {}),
                      //         ),
                      //         onFieldSubmitted: (_) async {
                      //           await DatePicker.showDatePicker(
                      //             context,
                      //             showTitleActions: true,
                      //             onConfirm: (date) {
                      //               setState(() => datePicked2 = date);
                      //             },
                      //             currentTime: getCurrentTimestamp,
                      //             minTime: getCurrentTimestamp,
                      //           );
                      //         },
                      //         autofocus: true,
                      //         obscureText: !passwordVisibility,
                      //         decoration: InputDecoration(
                      //           labelText: 'Password',
                      //           labelStyle:
                      //               FlutterFlowTheme.of(context).bodyText1.override(
                      //                     fontFamily: 'Poppins',
                      //                     color: Color(0xCE101213),
                      //                   ),
                      //           hintText: '********',
                      //           hintStyle:
                      //               FlutterFlowTheme.of(context).bodyText1.override(
                      //                     fontFamily: 'Poppins',
                      //                     color: Color(0x83101213),
                      //                   ),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //               color:
                      //                   FlutterFlowTheme.of(context).primaryColor,
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //               color:
                      //                   FlutterFlowTheme.of(context).primaryColor,
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //           suffixIcon: InkWell(
                      //             onTap: () => setState(
                      //               () => passwordVisibility = !passwordVisibility,
                      //             ),
                      //             child: Icon(
                      //               passwordVisibility
                      //                   ? Icons.visibility_outlined
                      //                   : Icons.visibility_off_outlined,
                      //               color: Color(0xFF757575),
                      //               size: 22,
                      //             ),
                      //           ),
                      //         ),
                      //         style: FlutterFlowTheme.of(context).bodyText1,
                      //         textAlign: TextAlign.start,
                      //       ),
                      //     ),
                      //   ],
                      // ),


                      // Text(
                      //   'new user?',
                      //   style: FlutterFlowTheme.of(context).bodyText1.override(
                      //         fontFamily: 'Poppins',
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      //   child: FFButtonWidget(
                      //     onPressed: () async {
                      //       await Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => SignUpWidget(),
                      //         ),
                      //       );
                      //     },
                      //     text: 'Signup',
                      //     options: FFButtonOptions(
                      //       width: 130,
                      //       height: 40,
                      //       color: FlutterFlowTheme.of(context).primaryBackground,
                      //       textStyle: FlutterFlowTheme.of(context)
                      //           .subtitle2
                      //           .override(
                      //             fontFamily: 'Poppins',
                      //             color: FlutterFlowTheme.of(context).primaryColor,
                      //           ),
                      //       borderSide: BorderSide(
                      //         color: FlutterFlowTheme.of(context).primaryColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: 12,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
