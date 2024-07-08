import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/view/invoice_themes/invoice_modern.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';
import '../auth/sign_in/sign_in_widget.dart';

class InvoiceThemes extends StatefulWidget {
  final bool isDrawer;
  const InvoiceThemes(this.isDrawer,{Key? key}) : super(key: key);

  @override
  State<InvoiceThemes> createState() => _InvoiceThemesState();
}

class _InvoiceThemesState extends State<InvoiceThemes> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int themeColor = 0;
  int invoiceTheme = 0;

  List images = [
    [
      "assets/images/00.jpg",
      "assets/images/01.jpg",
      "assets/images/02.jpg"
    ],
    [
      "assets/images/10.jpg",
      "assets/images/11.jpg",
      "assets/images/12.jpg"
    ]
  ];

  @override
  void initState() {
    super.initState();
    print("kooooii");
    final data = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      invoiceTheme = data.userData!['invoice_theme'] ?? 0;
      themeColor = data.userData!['theme_color'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    return  widget.isDrawer ? Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryColor,
            size: 30,
          ),
          onPressed: () async {
             widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(ProfileWidget (false));
          },
        ),
        title: Text(
          'Invoice Themes',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color:FlutterFlowTheme.of(context).primaryColor,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(child: _invoiceThemesMain(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: userData.userData!['invoice_theme'] ==
                  invoiceTheme &&
              userData.userData!['theme_color'] == themeColor
          ? Container()
          : FloatingActionButton.extended(
              onPressed: () async {
                userData
                    .userEdit(
                        name: userData.userData!['full_name'],
                        address: userData.userData!['address'],
                        acc: userData.userData!['company_details']['account_no'],
                        companyName: userData.userData!['company_details']
                            ['company_name'],
                        dob: userData.userData!['date_of_birth'].toDate(),
                        email: userData.userData!['email'],
                        gstin: userData.userData!['company_details']['gstin'],
                        ifsc: userData.userData!['company_details']['ifsc_code'],
                        phone: userData.userData!['phone_number'],
                        businessType: userData.userData!["company_details"]
                            ["business_type"],
                        invoiceTheme: invoiceTheme ?? 0,
                        themeColor: themeColor ?? 0,
                        terms: userData.userData!["company_details"]
                            ["terms_and_conditions"],
                        upi: userData.userData!["company_details"]["upi"],
                        billingSettings: userData.userData!["billing_settings"])
                    .then((value) {
                  if (userData.loadingState == LoadingStates.success) {
                    userData
                        .fetchUser()
                        .then((value) => Navigator.of(context).pop());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(userData.message)));
                  }
                });
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: userData.loadingState == LoadingStates.loading
                  ? circleLoading(context)
                  : Text(
                      'Save',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
            ),
    ): _invoiceThemesMain();
  }

  Widget _invoiceThemesMain() {
    return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image(
            image: AssetImage(images[invoiceTheme][themeColor]),
            height: 500,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        invoiceTheme = 0;
                      });
                    },
                    text: 'Wholesale',
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      elevation: 5,
                      color: invoiceTheme == 0
                          ? Colors.grey[300]
                          : FlutterFlowTheme.of(context).primaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: invoiceTheme == 0
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                      borderSide: BorderSide(
                        color: invoiceTheme == 0
                            ? FlutterFlowTheme.of(context).primaryColor!
                            : Colors.black45,
                        width: 1,
                      ),
                      borderRadius: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        invoiceTheme = 1;
                      });
                    },
                    text: 'Retail',
                    options: FFButtonOptions(
                      elevation: 5,
                      width: 130,
                      height: 40,
                      color: invoiceTheme == 1
                          ? Colors.grey[300]
                          : FlutterFlowTheme.of(context).primaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: invoiceTheme == 1
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                      borderSide: BorderSide(
                        color: invoiceTheme == 1
                            ? FlutterFlowTheme.of(context).primaryColor!
                            : Colors.black45,
                        width: 1,
                      ),
                      borderRadius: 12,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      themeColor = 0;
                    });
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: themeColor == 0
                                  ? FlutterFlowTheme.of(context).primaryColor!
                                  : Colors.grey[100]!,
                              width: 2),
                          color: Colors.red[300],
                          shape: BoxShape.circle),
                      child: themeColor == 0
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : SizedBox()),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      themeColor = 1;
                    });
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: themeColor == 1
                                  ? FlutterFlowTheme.of(context).primaryColor!
                                  : Colors.grey[100]!,
                              width: 2),
                          color: Colors.grey[300],
                          shape: BoxShape.circle),
                      child: themeColor == 1
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : SizedBox()),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      themeColor = 2;
                    });
                  },
                  child: Container(
                      height: 50,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: themeColor == 2
                                  ? FlutterFlowTheme.of(context).primaryColor!
                                  : Colors.grey[100]!,
                              width: 2),
                          color: Colors.deepOrange[300],
                          shape: BoxShape.circle),
                      child: themeColor == 2
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : SizedBox()),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
          ),
        ],
      );
  }

}
