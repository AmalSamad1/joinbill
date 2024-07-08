import 'dart:io';

import 'package:provider/provider.dart';
import 'package:ziptech/components/circleLoading.dart';
import 'package:ziptech/entry.dart';
import 'package:ziptech/helpers/loadingStates.dart';
import 'package:ziptech/providers/authProvider.dart';

import '../../../dashboard/dashboard_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../sign_in/sign_in_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CredentialsWidget extends StatefulWidget {
  final String? name;
  final DateTime? dob;
  final String? address;
  final String? phone;
  final String? company;
  final String? gstin;
  final String? ifsc;
  final String? acc;
  final String? upi;
  final String? terms;
  final String? businessType;
  final File? seal;
  final File? sign;
  final File? logo;

  const CredentialsWidget({
    Key? key,
    this.name,
    this.dob,
    this.address,
    this.phone,
    this.company,
    this.gstin,
    this.ifsc,
    this.acc,
    this.upi,
    this.terms,
    this.businessType,
    this.seal,
    this.sign,
    this.logo,
  }) : super(key: key);

  @override
  _CredentialsWidgetState createState() => _CredentialsWidgetState();
}

class _CredentialsWidgetState extends State<CredentialsWidget> {
  TextEditingController? emailController;

  TextEditingController? passwordController;
  bool? passwordVisibility1;

  TextEditingController? confirmController;
  bool? passwordVisibility2;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility1 = false;
    confirmController = TextEditingController();
    passwordVisibility2 = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Signup',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text(
                              'Credentials',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return "field cannot be empty";
                                } else if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'enter a valid email';
                                }
                                return null;
                              },
                              onChanged: (_) => EasyDebounce.debounce(
                                'emailController',
                                Duration(milliseconds: 2000),
                                () => setState(() {}),
                              ),
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'someone@mail.com',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyText1,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return "field cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (_) => EasyDebounce.debounce(
                                'passwordController',
                                Duration(milliseconds: 2000),
                                () => setState(() {}),
                              ),
                              autofocus: true,
                              obscureText: !passwordVisibility1!,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '********',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility1 =
                                        !passwordVisibility1!,
                                  ),
                                  child: Icon(
                                    passwordVisibility1!
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Color(0xFF757575),
                                    size: 22,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                            child: TextFormField(
                              controller: confirmController,
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return "field cannot be empty";
                                } else if (value !=
                                    passwordController!.text.trim()) {
                                  return "Password doesn't match";
                                }
                                return null;
                              },
                              onChanged: (_) => EasyDebounce.debounce(
                                'confirmController',
                                Duration(milliseconds: 2000),
                                () => setState(() {}),
                              ),
                              autofocus: true,
                              obscureText: !passwordVisibility2!,
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
                                hintText: '********',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility2 =
                                        !passwordVisibility2!,
                                  ),
                                  child: Icon(
                                    passwordVisibility2!
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Color(0xFF757575),
                                    size: 22,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: Consumer<AuthProvider>(
                          builder: (context, authData, child) => authData
                                      .loadingState ==
                                  LoadingStates.loading
                              ? circleLoading(context)
                              : FFButtonWidget(
                                  onPressed: () async {
                                    authData.registerWithEmailAndPassword(emailController!.text.trim(),passwordController!.text.trim());
                                    if (_formKey.currentState!.validate()) {
                                      authData
                                          .signUp(
                                              emailAddress:
                                                  emailController!.text.trim(),
                                              password: passwordController!.text
                                                  .trim(),
                                              acc: widget.acc,
                                              address: widget.address,
                                              companyName: widget.company,
                                              dob: widget.dob,
                                              gstin: widget.gstin,
                                              ifsc: widget.ifsc,
                                              name: widget.name,
                                              phone: widget.phone,
                                              businessType: widget.businessType,
                                              seal: widget.seal,
                                              sign: widget.sign,
                                              terms: widget.terms,
                                              upi: widget.upi,
                                              logo: widget.logo)
                                          .then((value) {
                                        if (authData.loadingState ==
                                            LoadingStates.success) {
                                          // Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DashboardWidget()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(authData.message)));
                                        }
                                      });
                                    }
                                  },
                                  text: 'Signup',
                                  options: FFButtonOptions(
                                    width: 130,
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
                      Divider(
                        height: 10,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0x56000000),
                      ),
                      Text(
                        'already a user?',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          text: 'Login',
                          options: FFButtonOptions(
                            width: 130,
                            height: 40,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .subtitle2
                                .override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
                                ),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryColor!,
                              width: 1,
                            ),
                            borderRadius: 12,
                          ),
                        ),
                      ),
                    ],
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
