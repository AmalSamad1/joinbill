import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/view/profile/account_details.dart';

import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/circleLoading.dart';
import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';

class CompanyEdit extends StatefulWidget {
  final bool isDrawer;
  final Map? data;
  const CompanyEdit(
    this.isDrawer, {
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _CompanyEditState createState() => _CompanyEditState();
}

class _CompanyEditState extends State<CompanyEdit> {
  TextEditingController? companyNameController;
  TextEditingController? gstinController;
  TextEditingController? accnoController;
  TextEditingController? ifscController;

  TextEditingController? businessTypeController;
  TextEditingController? upiController;
  TextEditingController? termsController;
  File? logo;
  File? signature;
  File? seal;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController(
        text: widget.data!['company_details']["company_name"]);
    gstinController =
        TextEditingController(text: widget.data!['company_details']["gstin"]);
    accnoController = TextEditingController(
        text: widget.data!['company_details']["account_no"]);
    ifscController = TextEditingController(
        text: widget.data!['company_details']["ifsc_code"]);

    businessTypeController = TextEditingController(
        text: widget.data!['company_details']["business_type"]);
    upiController =
        TextEditingController(text: widget.data!['company_details']["upi"]);
    termsController = TextEditingController(
        text: widget.data!['company_details']["terms_and_conditions"]);
  }
  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      pickFiles();
      if (status.isDenied) {
        // Handle case when permission is denied
      }
    }
  }
  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Handle picked files
        // You can access files via result.files
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle errors
    }
  }
  @override
  Widget build(BuildContext context) {

    return widget.isDrawer
        ? Scaffold(
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
                  widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(AccountDetails(false));
                },
              ),
              title: Text(
                'Edit Company',
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
            body: SafeArea(
              child: _companyEditMain(context),
            ))
        : _companyEditMain(context);
  }

  Widget _companyEditMain(BuildContext context) {
     final authData = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
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
                    style: FlutterFlowTheme.of(context).bodyText1.override(
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
                        child: Stack(
                          children: [
                            logo != null
                                ? Image(image: FileImage(logo!))
                                : widget.data!["company_details"]["logo"] !=
                                            '' ||
                                        widget.data!["company_details"]["logo"] !=
                                            null
                                    ? Image(
                                        image: NetworkImage(
                                            widget.data!["company_details"]
                                                ["logo"]))
                                    : Center(
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
                            logo == null &&
                                    (widget.data!["company_details"]
                                                ["logo"] ==
                                            '' ||
                                        widget.data!["company_details"]
                                                ["logo"] ==
                                            null)
                                ? Container()
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(top: 120),
                                    child: Center(
                                      child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.blue),
                                          child: Text("Change image")),
                                    ),
                                  )
                          ],
                        )),
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                          color: FlutterFlowTheme.of(context).primaryColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor!,
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                      child: GestureDetector(
                        onTap: () async {
       FilePickerResult? result = await FilePicker
           .platform
           .pickFiles(type: FileType.image);

       if (result != null) {
         setState(() {
           signature = File(result.files.single.path!);
         });

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Can't upload sign")));
                          }
                        },
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey[300]!)),
                            child: Stack(
                              children: [
                                signature != null
                                    ? Center(
                                        child: Image(
                                            image: FileImage(signature!)))
                                    : widget.data!["company_details"]
                                                    ["sign"] !=
                                                '' ||
                                            widget.data!["company_details"]
                                                    ["sign"] !=
                                                null
                                        ? Center(
                                            child: Image(
                                                image: NetworkImage(widget
                                                            .data![
                                                        "company_details"]
                                                    ["sign"])),
                                          )
                                        : Center(
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
                                signature == null &&
                                        (widget.data!["company_details"]
                                                    ["sign"] ==
                                                '' ||
                                            widget.data!["company_details"]
                                                    ["sign"] ==
                                                null)
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 120),
                                        child: Center(
                                          child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                  color: Colors.blue),
                                              child:
                                                  Text("Change signature")),
                                        ),
                                      )
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      child: GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker
                              .platform
                              .pickFiles(type: FileType.image);

                          if (result != null) {
                            setState(() {
                              seal = File(result.files.single.path!);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Can't upload seal")));
                          }
                        },
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey[300]!)),
                            child: Stack(
                              children: [
                                seal != null
                                    ? Center(
                                        child:
                                            Image(image: FileImage(seal!)))
                                    : widget.data!["company_details"]
                                                    ["seal"] !=
                                                '' ||
                                            widget.data!["company_details"]
                                                    ["seal"] !=
                                                null
                                        ? Center(
                                            child: Image(
                                                image: NetworkImage(widget
                                                            .data![
                                                        "company_details"]
                                                    ["seal"])),
                                          )
                                        : Center(
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
                                seal == null &&
                                        (widget.data!["company_details"]
                                                    ["seal"] ==
                                                '' ||
                                            widget.data!["company_details"]
                                                    ["seal"] ==
                                                null)
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 120),
                                        child: Center(
                                          child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                  color: Colors.blue),
                                              child: Text("Change seal")),
                                        ),
                                      )
                              ],
                            )),
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
                    authData
                        .userEdit(
                            email: widget.data!['email'],
                            billingSettings:
                                widget.data!['billing_settings'],
                            upi: upiController!.text.trim(),
                            businessType:
                                businessTypeController!.text.trim(),
                            acc: accnoController!.text.trim(),
                            address: widget.data!['address'],
                            companyName: companyNameController!.text.trim(),
                            dob: widget.data!['date_of_birth'].toDate(),
                            gstin: gstinController!.text.trim(),
                            ifsc: ifscController!.text.trim(),
                            name: widget.data!['full_name'],
                            phone: widget.data!['phone_number'],
                            logo: logo,
                            seal: seal,
                            sign: signature,
                            terms: termsController!.text.trim())
                        .then((value) {
                      authData.fetchUser().then((value) {
                        if (authData.loadingState ==
                            LoadingStates.success) {
                          widget.isDrawer
                              ? Navigator.pop(context)
                              : context
                                  .read<AuthProvider>()
                                  .setCurrentPage(AccountDetails(false));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(authData.message)));
                        }
                      });
                    });
                  }
                },
                text: 'Done',
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
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}


class Multiplefilepicker extends StatefulWidget {
  List<PlatformFile>? files;
  Multiplefilepicker({required this.files, super.key});

  @override
  State<Multiplefilepicker> createState() => _MultiplefilepickerState();
}

class _MultiplefilepickerState extends State<Multiplefilepicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Files'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 225, 121),
      ),
      body: ListView.builder(
          itemCount: widget.files!.length,
          itemBuilder: (context, index) {
            return buildfile(widget.files!, index);
          }),
    );
  }

  Widget buildfile(List<PlatformFile> file, index) {
    return InkWell(
      child: ListTile(
        title: Text(file[index].name),
        onTap: () {},
      ),
    );
  }
}

