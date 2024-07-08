import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'credentials_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../sign_in/sign_in_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyDetailsWidget extends StatefulWidget {
  final String name;
  final DateTime? dob;
  final String address;
  final String phone;
  const CompanyDetailsWidget({
    Key? key,
    required this.name,
    this.dob,
    required this.address,
    required this.phone,
  }) : super(key: key);

  @override
  _CompanyDetailsWidgetState createState() => _CompanyDetailsWidgetState();
}

class _CompanyDetailsWidgetState extends State<CompanyDetailsWidget> {
  late TextEditingController companyNameController;
  late TextEditingController? gstinController;
  late TextEditingController? accnoController;
  late TextEditingController? ifscController;
  late TextEditingController panController;
  late TextEditingController businessTypeController;
  late TextEditingController? upiController;
  late TextEditingController termsController;
 File? logo;
  File? signature;
   File? seal;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
    gstinController = TextEditingController();
    accnoController = TextEditingController();
    ifscController = TextEditingController();
    panController = TextEditingController();
    businessTypeController = TextEditingController();
    upiController = TextEditingController();
    termsController = TextEditingController();
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
          'Company',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text(
                          'Company Details',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              setState(() {
                                logo = File(result.files.single.path!);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Can't upload logo")));
                            }
                          },
                          child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!)),
                              child:Stack(children: [
                                logo != null
                                  ? Image(image: FileImage(logo!))
                                  :Center(
                                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: 40,
                                        ),
                                        Text('upload logo')
                                      ],
                                    ),
                                                      ),
                                    logo == null ?Container():   Padding(
                                                        padding: const EdgeInsets.only(top: 120),
                                                        child: Center(
                                                          child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue

                                        ),
                                        child: Text("Change image")),
                                                        ),
                                                      )
                              ],) 
                                    
                                    ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: companyNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          onChanged: (_) => EasyDebounce.debounce(
                            'companyNameController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Company name',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: businessTypeController,
                          onChanged: (_) => EasyDebounce.debounce(
                            'businessTypeController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Business Type',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: gstinController,

                          onChanged: (_) => EasyDebounce.debounce(
                            'gstinController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Gstin',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: accnoController,

                          onChanged: (_) => EasyDebounce.debounce(
                            'accnoController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Acc no.',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: ifscController,

                          onChanged: (_) => EasyDebounce.debounce(
                            'ifscController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'IFSC',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          controller: upiController,
                          onChanged: (_) => EasyDebounce.debounce(
                            'upiController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'UPI Id',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: TextFormField(
                          maxLines: 2,
                          controller: termsController,
                          onChanged: (_) => EasyDebounce.debounce(
                            'termsController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Terms & Conditions',
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
                          style: FlutterFlowTheme.of(context).bodyText1,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 16),
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              setState(() {
                                signature = File(result.files.single.path!);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Can't upload sign")));
                            }
                          },
                          child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!)),
                              child:Stack(children: [
                                signature != null
                                  ? Center(child: Image(image: FileImage(signature!)))
                                  :Center(
                                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: 40,
                                        ),
                                        Text('upload signature')
                                      ],
                                    ),
                                                      ),
                                    signature == null ?Container():   Padding(
                                                        padding: const EdgeInsets.only(top: 120),
                                                        child: Center(
                                                          child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue

                                        ),
                                        child: Text("Change signature")),
                                                        ),
                                                      )
                              ],) 
                                    
                                    ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult ?result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              setState(() {
                                seal = File(result.files.single.path!);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Can't upload seal")));
                            }
                          },
                          child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!)),
                              child:Stack(children: [
                                seal != null
                                  ? Center(child: Image(image: FileImage(seal!)))
                                  :Center(
                                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: 40,
                                        ),
                                        Text('upload seal')
                                      ],
                                    ),
                                                      ),
                                    seal == null  ?Container():   Padding(
                                                        padding: const EdgeInsets.only(top: 120),
                                                        child: Center(
                                                          child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue

                                        ),
                                        child: Text("Change seal")),
                                                        ),
                                                      )
                              ],) 
                                    
                                    ),
                        ),
                      ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  Divider(
                    height: 10,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Color(0x56000000),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print(upiController!.text);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CredentialsWidget(
                                  name: widget.name,
                                  upi: upiController!.text.trim(),
                                  businessType:
                                      businessTypeController.text.trim(),
                                  logo: logo,
                                  seal: seal,
                                  sign: signature,
                                  terms: termsController.text.trim(),
                                  dob: widget.dob,
                                  address: widget.address,
                                  phone: widget.phone,
                                  company: companyNameController.text.trim(),
                                  acc: accnoController!.text!,
                                  gstin: gstinController!.text!,
                                  ifsc: ifscController!.text!),
                            ),
                          );
                        }
                      },
                      text: 'Next',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).primaryColor,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
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
                  Divider(
                    height: 10,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Color(0x56000000),
                  ),
                  // Text(
                  //   'already a user?',
                  //   style: FlutterFlowTheme.of(context).bodyText1.override(
                  //         fontFamily: 'Poppins',
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  //   child: FFButtonWidget(
                  //     onPressed: () async {
                  //       Navigator.of(context).pop();
                  //       Navigator.of(context).pop();
                  //     },
                  //     text: 'Login',
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
