import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/entry.dart';

import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/view/profile/account_details.dart';
import 'package:ziptech/view/profile/change_email.dart';
import 'package:ziptech/view/profile/change_password.dart';
import 'package:ziptech/view/profile/invoice_themes.dart';
import 'package:ziptech/view/profile/qr_scanning_screen.dart';
import 'package:ziptech/view/profile/settings_widget.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../auth/sign_in/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/dashboard_widget_main.dart';
import '../dashboard/drawerWidget.dart';

class ProfileWidget extends StatefulWidget {
  final bool isDrawer;
  const ProfileWidget(this.isDrawer, {Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
  }
  final double circleRadius = 100.0;
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
         future: Provider.of<AuthProvider>(context, listen: false).fetchUser(),
        builder: (context, snapShot) {
      return
    widget.isDrawer
        ? Scaffold(
            key: scaffoldKey,
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   automaticallyImplyLeading: false,
            //   // leading: FlutterFlowIconButton(
            //   //   borderColor: Colors.transparent,
            //   //   borderRadius: 30,
            //   //   borderWidth: 1,
            //   //   buttonSize: 60,
            //   //   icon: Icon(
            //   //     Icons.arrow_back_rounded,
            //   //     color: Colors.white,
            //   //     size: 30,
            //   //   ),
            //   //   onPressed: () async {
            //   //     widget.isDrawer
            //   //         ? Navigator.pop(context)
            //   //         : context
            //   //             .read<AuthProvider>()
            //   //             .setCurrentPage(DashboardWidgetMain(false));
            //   //   },
            //   // ),
            //   title: Text(
            //     'Profile',
            //     style: FlutterFlowTheme.of(context).title2.override(
            //           fontFamily: 'Poppins',
            //           color: FlutterFlowTheme.of(context).primaryColor,
            //           fontSize: 22,
            //         ),
            //   ),
            //   actions: [],
            //   centerTitle: true,
            //   elevation: 2,
            // ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body:snapShot.connectionState == ConnectionState.waiting
          ? circleLoading(context)
          : snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: Text("Something went wrong"),
                )
              :  _profileWidgetMain(context))
        :snapShot.connectionState == ConnectionState.waiting
          ? circleLoading(context)
          : snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: Text("Something went wrong"),
                )
              :  _profileWidgetMain(context);});
  }

  Widget _profileWidgetMain(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);

    return
      ListView(
      children: [
        Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.only(top: circleRadius / 2.0, ),  ///here we create space for the circle avatar to get ut of the box
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: circleRadius/2,),
                              Text('${userData.userData!["full_name"] ??"userName"}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                              Text('${userData.userData!["email"] ??""}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0,),),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///Image Avatar
                    Container(
                      width: circleRadius,
                      height: circleRadius,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                                "${userData.userData!["company_details"]["logo"]??""}"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),

        Card(
          elevation: 10,
          child: Column(
            children: [
              SizedBox(height: 10,),
              // Text("Account Detials",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
              InkWell(onTap:(){
                Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountDetails(true)));
              },
                  child: ListTile(leading: Icon(Icons.switch_account_rounded),title:Text("Account Detials"),trailing: Icon(Icons.chevron_right),)),
              InkWell(onTap:(){
                Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SettingsWidget(true)));
              },child: ListTile(leading: Icon(Icons.settings),title:Text("Settings"),trailing: Icon(Icons.chevron_right),)),
              InkWell(onTap:(){
                Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InvoiceThemes(true)));
              },child: ListTile(leading: Icon(Icons.inventory_outlined),title:Text("Invoice Themes"),trailing: Icon(Icons.chevron_right),)),
              InkWell(onTap:() async {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => QRViewExample()));
                String barcodeScanRes;
                // Platform messages may fail, so we use a try/catch PlatformException.
                try {
                  barcodeScanRes =
                      await FlutterBarcodeScanner
                      .scanBarcode(
                      '#ff6666',
                      'Cancel',
                      false,
                      ScanMode.QR);
                  print("*******&&&********");
                  print(barcodeScanRes);
                  if (barcodeScanRes.isNotEmpty &&
                      barcodeScanRes !=  null) {
                    userData.createQr(barcodeScanRes);
                  }
                } on PlatformException {
                  barcodeScanRes = '';
                }

                // If the widget was removed from the tree while the asynchronous platform
                // message was in flight, we want to discard the reply rather than calling
                // setState to update our non-existent appearance.
                if (!mounted) return;
              },child: ListTile(leading: Icon(Icons.desktop_mac_outlined),title:Text("Desktop Login"),trailing: Icon(Icons.chevron_right),)),
               SizedBox(height: 40,),
          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<AuthProvider>(
                                  builder: ((context, value, _) =>
                                      FFButtonWidget(
                                        onPressed: () async {
                                          await value.logOut();
                                          print(value.uid);
                                          Navigator.of(context).pop();
                                           await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Entry(),));
                                          // await Navigator.pushReplacement(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         Entry(),
                                          //   ),
                                          // );
                                        },
                                        text: 'Log Out',
                                        options: FFButtonOptions(
                                          width: 250,
                                          height: 40,
                                          color:
                                              FlutterFlowTheme.of(context)
                                                  .primaryColor,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Lexend Deca',
                                                color:
                                                    FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBtnText,
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.normal,
                                              ),
                                          elevation: 3,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: 8,
                                        ),
                                      )),),]),),
              SizedBox(
                height: 30,
              ),

            ],
          ),
        ),


      ],
    );

      // SingleChildScrollView(
      //           child: Column(
      //             mainAxisSize: MainAxisSize.max,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: double.infinity,
      //                 decoration: BoxDecoration(
      //                   color:
      //                       FlutterFlowTheme.of(context).primaryColor,
      //                 ),
      //                 child: Padding(
      //                   padding: EdgeInsetsDirectional.fromSTEB(
      //                       24, 20, 0, 0),
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.max,
      //                     children: [
      //                       Row(
      //                         mainAxisSize: MainAxisSize.max,
      //                         children: [
      //                           FaIcon(
      //                             FontAwesomeIcons.userCircle,
      //                             color: FlutterFlowTheme.of(context)
      //                                 .primaryBtnText,
      //                             size: 80,
      //                           ),
      //                         ],
      //                       ),
      //                       Row(
      //                         mainAxisSize: MainAxisSize.max,
      //                         children: [
      //                           Padding(
      //                             padding:
      //                                 EdgeInsetsDirectional.fromSTEB(
      //                                     0, 8, 0, 0),
      //                             child: Text(
      //                               userData.userData["full_name"] ??
      //                                   "userName",
      //                               style: FlutterFlowTheme.of(
      //                                       context)
      //                                   .title1
      //                                   .override(
      //                                     fontFamily: 'Lexend Deca',
      //                                     color: Colors.white,
      //                                     fontSize: 24,
      //                                     fontWeight: FontWeight.bold,
      //                                   ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       Padding(
      //                         padding: EdgeInsetsDirectional.fromSTEB(
      //                             0, 0, 0, 12),
      //                         child: Row(
      //                           mainAxisSize: MainAxisSize.max,
      //                           children: [
      //                             Padding(
      //                               padding: EdgeInsetsDirectional
      //                                   .fromSTEB(0, 8, 0, 0),
      //                               child: Text(
      //                                 userData.userData["email"] ??
      //                                     "user@mail.com",
      //                                 style: FlutterFlowTheme.of(
      //                                         context)
      //                                     .bodyText1
      //                                     .override(
      //                                       fontFamily: 'Lexend Deca',
      //                                       color: Color(0xFFEE8B60),
      //                                       fontSize: 14,
      //                                       fontWeight:
      //                                           FontWeight.normal,
      //                                     ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               GestureDetector(
      //                 onTap: () {
      //                  widget.isDrawer ?  Navigator.of(context).push(
      //                       MaterialPageRoute(
      //                           builder: (context) =>
      //                               AccountDetails(true))): context.read<AuthProvider>().setCurrentPage(AccountDetails(false));
      //                 },
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.max,
      //                   children: [
      //                     Container(
      //                        width:MediaQuery.of(context).size.width < 1000
      //
      //
      //                                 ? MediaQuery.of(context).size.width > 660?
      //                                 MediaQuery.of(context).size.width * 0.9:MediaQuery.of(context).size.width
      //                                 : MediaQuery.of(context).size.width * 0.8,
      //                       height: 50,
      //                       decoration: BoxDecoration(
      //                         color: FlutterFlowTheme.of(context)
      //                             .lineColor,
      //                         shape: BoxShape.rectangle,
      //                         border: Border.all(
      //                           color: FlutterFlowTheme.of(context)
      //                               .lineColor,
      //                         ),
      //                       ),
      //                       child: Row(
      //                         mainAxisSize: MainAxisSize.max,
      //                         children: [
      //                           Padding(
      //                             padding: EdgeInsetsDirectional
      //                                 .fromSTEB(24, 0, 0, 0),
      //                             child: Text(
      //                               'Account Details',
      //                               style: FlutterFlowTheme.of(
      //                                       context)
      //                                   .bodyText1
      //                                   .override(
      //                                     fontFamily: 'Lexend Deca',
      //                                     color: Color(0xC1000000),
      //                                     fontSize: 14,
      //                                     fontWeight:
      //                                         FontWeight.normal,
      //                                   ),
      //                             ),
      //                           ),
      //                           Expanded(
      //                             child: Align(
      //                               alignment: AlignmentDirectional(
      //                                   0.9, 0),
      //                               child: Icon(
      //                                 Icons.arrow_forward_ios,
      //                                 color: Color(0xFF95A1AC),
      //                                 size: 18,
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsetsDirectional.fromSTEB(
      //                     0, 1, 0, 0),
      //                 child: GestureDetector(
      //                   onTap: () {
      //                   widget.isDrawer ?  Navigator.of(context).push(
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 SettingsWidget(true))): context.read<AuthProvider>().setCurrentPage(SettingsWidget(false));
      //                   },
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.max,
      //                     children: [
      //                       Container(
      //                          width:MediaQuery.of(context).size.width < 1000
      //
      //
      //                                 ? MediaQuery.of(context).size.width > 660?
      //                                 MediaQuery.of(context).size.width * 0.9:MediaQuery.of(context).size.width
      //                                 : MediaQuery.of(context).size.width * 0.8,
      //                         height: 50,
      //                         decoration: BoxDecoration(
      //                           color: FlutterFlowTheme.of(context)
      //                               .lineColor,
      //                           shape: BoxShape.rectangle,
      //                           border: Border.all(
      //                             color:
      //                                 FlutterFlowTheme.of(context)
      //                                     .lineColor,
      //                           ),
      //                         ),
      //                         child: Row(
      //                           mainAxisSize: MainAxisSize.max,
      //                           children: [
      //                             Padding(
      //                               padding: EdgeInsetsDirectional
      //                                   .fromSTEB(24, 0, 0, 0),
      //                               child: Text(
      //                                 'Settings',
      //                                 style: FlutterFlowTheme.of(
      //                                         context)
      //                                     .bodyText1
      //                                     .override(
      //                                       fontFamily:
      //                                           'Lexend Deca',
      //                                       color:
      //                                           Color(0xC1000000),
      //                                       fontSize: 14,
      //                                       fontWeight:
      //                                           FontWeight.normal,
      //                                     ),
      //                               ),
      //                             ),
      //                             Expanded(
      //                               child: Align(
      //                                 alignment:
      //                                     AlignmentDirectional(
      //                                         0.9, 0),
      //                                 child: Icon(
      //                                   Icons.arrow_forward_ios,
      //                                   color: Color(0xFF95A1AC),
      //                                   size: 18,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsetsDirectional.fromSTEB(
      //                     0, 1, 0, 0),
      //                 child: GestureDetector(
      //                   onTap: () {
      //                   widget.isDrawer ?  Navigator.of(context).push(
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 InvoiceThemes(true))): context.read<AuthProvider>().setCurrentPage(InvoiceThemes(false));
      //                   },
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.max,
      //                     children: [
      //                       Container(
      //                           width:MediaQuery.of(context).size.width < 1000
      //
      //
      //                                 ? MediaQuery.of(context).size.width > 660?
      //                                 MediaQuery.of(context).size.width * 0.9:MediaQuery.of(context).size.width
      //                                 : MediaQuery.of(context).size.width * 0.8,
      //                         height: 50,
      //                         decoration: BoxDecoration(
      //                           color: FlutterFlowTheme.of(context)
      //                               .lineColor,
      //                           shape: BoxShape.rectangle,
      //                           border: Border.all(
      //                             color:
      //                                 FlutterFlowTheme.of(context)
      //                                     .lineColor,
      //                           ),
      //                         ),
      //                         child: Row(
      //                           mainAxisSize: MainAxisSize.max,
      //                           children: [
      //                             Padding(
      //                               padding: EdgeInsetsDirectional
      //                                   .fromSTEB(24, 0, 0, 0),
      //                               child: Text(
      //                                 'Invoice Themes',
      //                                 style: FlutterFlowTheme.of(
      //                                         context)
      //                                     .bodyText1
      //                                     .override(
      //                                       fontFamily:
      //                                           'Lexend Deca',
      //                                       color:
      //                                           Color(0xC1000000),
      //                                       fontSize: 14,
      //                                       fontWeight:
      //                                           FontWeight.normal,
      //                                     ),
      //                               ),
      //                             ),
      //                             Expanded(
      //                               child: Align(
      //                                 alignment:
      //                                     AlignmentDirectional(
      //                                         0.9, 0),
      //                                 child: Icon(
      //                                   Icons.arrow_forward_ios,
      //                                   color: Color(0xFF95A1AC),
      //                                   size: 18,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               // Padding(
      //               //   padding: EdgeInsetsDirectional.fromSTEB(
      //               //       0, 1, 0, 0),
      //               //   child: GestureDetector(
      //               //     onTap: () {
      //               //       Navigator.of(context).push(
      //               //           MaterialPageRoute(
      //               //               builder: (context) =>
      //               //                   ChangeEmail(
      //               //                     data: userData.userData,
      //               //                   )));
      //               //     },
      //               //     child: Row(
      //               //       mainAxisSize: MainAxisSize.max,
      //               //       children: [
      //               //         Container(
      //               //           width: MediaQuery.of(context)
      //               //               .size
      //               //               .width,
      //               //           height: 50,
      //               //           decoration: BoxDecoration(
      //               //             color:
      //               //                 FlutterFlowTheme.of(context)
      //               //                     .lineColor,
      //               //             shape: BoxShape.rectangle,
      //               //           ),
      //               //           child: Row(
      //               //             mainAxisSize: MainAxisSize.max,
      //               //             children: [
      //               //               Padding(
      //               //                 padding: EdgeInsetsDirectional
      //               //                     .fromSTEB(24, 0, 0, 0),
      //               //                 child: Text(
      //               //                   'Change Email',
      //               //                   style: FlutterFlowTheme.of(
      //               //                           context)
      //               //                       .bodyText1
      //               //                       .override(
      //               //                         fontFamily:
      //               //                             'Lexend Deca',
      //               //                         color:
      //               //                             Color(0xC1000000),
      //               //                         fontSize: 14,
      //               //                         fontWeight:
      //               //                             FontWeight.normal,
      //               //                       ),
      //               //                 ),
      //               //               ),
      //               //               Expanded(
      //               //                 child: Align(
      //               //                   alignment:
      //               //                       AlignmentDirectional(
      //               //                           0.9, 0),
      //               //                   child: Icon(
      //               //                     Icons.arrow_forward_ios,
      //               //                     color: Color(0xFF95A1AC),
      //               //                     size: 18,
      //               //                   ),
      //               //                 ),
      //               //               ),
      //               //             ],
      //               //           ),
      //               //         ),
      //               //       ],
      //               //     ),
      //               //   ),
      //               // ),
      //               // Padding(
      //               //   padding: EdgeInsetsDirectional.fromSTEB(
      //               //       0, 1, 0, 0),
      //               //   child: GestureDetector(
      //               //     onTap: () {
      //               //       Navigator.of(context).push(
      //               //           MaterialPageRoute(
      //               //               builder: (context) =>
      //               //                   ChangePassword(
      //               //                     data: userData.userData,
      //               //                   )));
      //               //     },
      //               //     child: Row(
      //               //       mainAxisSize: MainAxisSize.max,
      //               //       children: [
      //               //         Container(
      //               //           width: MediaQuery.of(context)
      //               //               .size
      //               //               .width,
      //               //           height: 50,
      //               //           decoration: BoxDecoration(
      //               //             color:
      //               //                 FlutterFlowTheme.of(context)
      //               //                     .lineColor,
      //               //             shape: BoxShape.rectangle,
      //               //           ),
      //               //           child: Row(
      //               //             mainAxisSize: MainAxisSize.max,
      //               //             children: [
      //               //               Padding(
      //               //                 padding: EdgeInsetsDirectional
      //               //                     .fromSTEB(24, 0, 0, 0),
      //               //                 child: Text(
      //               //                   'Change Password',
      //               //                   style: FlutterFlowTheme.of(
      //               //                           context)
      //               //                       .bodyText1
      //               //                       .override(
      //               //                         fontFamily:
      //               //                             'Lexend Deca',
      //               //                         color:
      //               //                             Color(0xC1000000),
      //               //                         fontSize: 14,
      //               //                         fontWeight:
      //               //                             FontWeight.normal,
      //               //                       ),
      //               //                 ),
      //               //               ),
      //               //               Expanded(
      //               //                 child: Align(
      //               //                   alignment:
      //               //                       AlignmentDirectional(
      //               //                           0.9, 0),
      //               //                   child: Icon(
      //               //                     Icons.arrow_forward_ios,
      //               //                     color: Color(0xFF95A1AC),
      //               //                     size: 18,
      //               //                   ),
      //               //                 ),
      //               //               ),
      //               //             ],
      //               //           ),
      //               //         ),
      //               //       ],
      //               //     ),
      //               //   ),
      //               // ),
      //               Padding(
      //                 padding: EdgeInsetsDirectional.fromSTEB(
      //                     0, 1, 0, 0),
      //                 child: GestureDetector(
      //                   onTap: () async {
      //                    // Navigator.of(context).push(MaterialPageRoute(
      //                     //     builder: (context) => QRViewExample()));
      //                     String barcodeScanRes;
      //                     // Platform messages may fail, so we use a try/catch PlatformException.
      //                     try {
      //                       barcodeScanRes =
      //                           await FlutterBarcodeScanner
      //                               .scanBarcode(
      //                                   '#ff6666',
      //                                   'Cancel',
      //                                   false,
      //                                   ScanMode.QR);
      //                       print("*******&&&********");
      //                       print(barcodeScanRes);
      //                       if (barcodeScanRes.isNotEmpty &&
      //                           barcodeScanRes !=  null) {
      //                         userData.createQr(barcodeScanRes);
      //                       }
      //                     } on PlatformException {
      //                       barcodeScanRes = '';
      //                     }
      //
      //                     // If the widget was removed from the tree while the asynchronous platform
      //                     // message was in flight, we want to discard the reply rather than calling
      //                     // setState to update our non-existent appearance.
      //                     if (!mounted) return;
      //                   },
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.max,
      //                     children: [
      //                       Container(
      //                          width:MediaQuery.of(context).size.width < 1000
      //
      //
      //                                 ? MediaQuery.of(context).size.width > 660?
      //                                 MediaQuery.of(context).size.width * 0.9:MediaQuery.of(context).size.width
      //                                 : MediaQuery.of(context).size.width * 0.8,
      //                         height: 50,
      //                         decoration: BoxDecoration(
      //                           color: FlutterFlowTheme.of(context)
      //                               .lineColor,
      //                           shape: BoxShape.rectangle,
      //                         ),
      //                         child: Row(
      //                           mainAxisSize: MainAxisSize.max,
      //                           children: [
      //                             Padding(
      //                               padding: EdgeInsetsDirectional
      //                                   .fromSTEB(24, 0, 0, 0),
      //                               child: Text(
      //                                 'Desktop Login',
      //                                 style: FlutterFlowTheme.of(
      //                                         context)
      //                                     .bodyText1
      //                                     .override(
      //                                       fontFamily:
      //                                           'Lexend Deca',
      //                                       color:
      //                                           Color(0xC1000000),
      //                                       fontSize: 14,
      //                                       fontWeight:
      //                                           FontWeight.normal,
      //                                     ),
      //                               ),
      //                             ),
      //                             Expanded(
      //                               child: Align(
      //                                 alignment:
      //                                     AlignmentDirectional(
      //                                         0.9, 0),
      //                                 child: Icon(
      //                                   Icons.arrow_forward_ios,
      //                                   color: Color(0xFF95A1AC),
      //                                   size: 18,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsetsDirectional.fromSTEB(
      //                     0, 20, 0, 20),
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.max,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Consumer<AuthProvider>(
      //                       builder: ((context, value, _) =>
      //                           FFButtonWidget(
      //                             onPressed: () async {
      //                               await value.logOut();
      //                               print(value.uid);
      //                               Navigator.of(context).pop();
      //
      //                               await Navigator.pushReplacement(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       Entry(),
      //                                 ),
      //                               );
      //                             },
      //                             text: 'Log Out',
      //                             options: FFButtonOptions(
      //                               width: 90,
      //                               height: 40,
      //                               color:
      //                                   FlutterFlowTheme.of(context)
      //                                       .primaryColor,
      //                               textStyle: FlutterFlowTheme.of(
      //                                       context)
      //                                   .bodyText2
      //                                   .override(
      //                                     fontFamily: 'Lexend Deca',
      //                                     color:
      //                                         FlutterFlowTheme.of(
      //                                                 context)
      //                                             .primaryBtnText,
      //                                     fontSize: 14,
      //                                     fontWeight:
      //                                         FontWeight.normal,
      //                                   ),
      //                               elevation: 3,
      //                               borderSide: BorderSide(
      //                                 color: Colors.transparent,
      //                                 width: 1,
      //                               ),
      //                               borderRadius: 8,
      //                             ),
      //                           )),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
    
  }
}
