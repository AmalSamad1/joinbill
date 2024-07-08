import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/view/profile/profile_widget.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';
import '../auth/sign_in/sign_in_widget.dart';

class SettingsWidget extends StatefulWidget {
  final bool isDrawer;
  const SettingsWidget(this.isDrawer, {Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? saleInvoicePrefixController;
  TextEditingController? saleInvoiceNumberController;
  TextEditingController? saleReturnPrefixController;
  TextEditingController? saleReturneNumberController;
  TextEditingController? saleEstimatePrefixController;
  TextEditingController? saleEstimateNumberController;
  TextEditingController? purchaseBillPrefixController;
  TextEditingController? purchaseBillNumberController;
  TextEditingController? purchaseOrderPrefixController;
  TextEditingController? purchaseOrderNumberController;
  TextEditingController? purchaseReturnPrefixController;
  TextEditingController? purchaseReturnNumberController;

  @override
  void initState() {
    super.initState();
    print("kooooii");
    final data = Provider.of<AuthProvider>(context, listen: false);

    saleInvoicePrefixController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["sales_invoice"]["prefix"]}');
    saleInvoiceNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["sales_invoice"]["starting_number"]}');
    saleReturnPrefixController = TextEditingController(
        text: '${data.userData!["billing_settings"]["sales_return"]["prefix"]}');
    saleReturneNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["sales_return"]["starting_number"]}');
    saleEstimatePrefixController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["sales_estimate"]["prefix"]}');
    saleEstimateNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["sales_estimate"]["starting_number"]}');
    purchaseBillPrefixController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_bill"]["prefix"]}');
    purchaseBillNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_bill"]["starting_number"]}');
    purchaseOrderPrefixController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_order"]["prefix"]}');
    purchaseOrderNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_order"]["starting_number"]}');
    purchaseReturnPrefixController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_return"]["prefix"]}');
    purchaseReturnNumberController = TextEditingController(
        text:
            '${data.userData!["billing_settings"]["purchase_return"]["starting_number"]}');
  }

  @override
  Widget build(BuildContext context) {
   
    return widget.isDrawer
        ? Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor:Colors.white,
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
                          .setCurrentPage(ProfileWidget(false));
                },
              ),
              title: Text(
                'Settings',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color:  FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: _settingsWidgetMain(context),
            ))
        : _settingsWidgetMain(context);
  }

  Widget _settingsWidgetMain(BuildContext context) {
     final userData = Provider.of<AuthProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      // color: FlutterFlowTheme.of(context).lineColor,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).lineColor!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                          child: Text(
                            'Sales Invoice',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xC1000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: TextFormField(
                              controller: saleInvoicePrefixController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field can not be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // int ind = peopleData.customers.indexWhere(
                                //     (element) => element.data()['phone'] == value);
                                // if (ind != -1) {
                                //   setState(() {
                                //     billingNameController.text =
                                //         '${peopleData.customers[ind].data()['name']}';

                                //     custId = peopleData.customers[ind].id;
                                //   });
                                // }
                              },
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Prefix',
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
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: TextFormField(
                              controller: saleInvoiceNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field can not be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // int ind = peopleData.customers.indexWhere(
                                //     (element) => element.data()['phone'] == value);
                                // if (ind != -1) {
                                //   setState(() {
                                //     billingNameController.text =
                                //         '${peopleData.customers[ind].data()['name']}';

                                //     custId = peopleData.customers[ind].id;
                                //   });
                                // }
                              },
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'number',
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
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: FlutterFlowTheme.of(context).lineColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).lineColor!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                            child: Text(
                              'Sales Return',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xC1000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: saleReturnPrefixController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Prefix',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: saleReturneNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'number',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: FlutterFlowTheme.of(context).lineColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).lineColor!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                            child: Text(
                              'Sales Estimate',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xC1000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: saleEstimatePrefixController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Prefix',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: saleEstimateNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'number',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: FlutterFlowTheme.of(context).lineColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).lineColor!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                            child: Text(
                              'Purchase Bill',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xC1000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseBillPrefixController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Prefix',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseBillNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'number',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: FlutterFlowTheme.of(context).lineColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).lineColor!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                            child: Text(
                              'Purchase Order',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xC1000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseOrderPrefixController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Prefix',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseBillNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'number',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: FlutterFlowTheme.of(context).lineColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).lineColor!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                            child: Text(
                              'Purchase Return',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xC1000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseReturnPrefixController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Prefix',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: TextFormField(
                                controller: purchaseReturnNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field can not be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // int ind = peopleData.customers.indexWhere(
                                  //     (element) => element.data()['phone'] == value);
                                  // if (ind != -1) {
                                  //   setState(() {
                                  //     billingNameController.text =
                                  //         '${peopleData.customers[ind].data()['name']}';

                                  //     custId = peopleData.customers[ind].id;
                                  //   });
                                  // }
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'number',
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
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    userData.loadingState == LoadingStates.loading
                        ? circleLoading(context)
                        : FFButtonWidget(
                            onPressed: () async {
                              userData.userEdit(
                                  name: userData.userData!['full_name'],
                                  address: userData.userData!['address'],
                                  acc: userData.userData!['company_details']
                                      ['account_no'],
                                  companyName:
                                      userData.userData!['company_details']
                                          ['company_name'],
                                  dob: userData.userData!['date_of_birth']
                                      .toDate(),
                                  email: userData.userData!['email'],
                                  gstin: userData.userData!['company_details']
                                      ['gstin'],
                                  ifsc: userData.userData!['company_details']
                                      ['ifsc_code'],
                                  phone: userData.userData!['phone_number'],
                                  businessType:
                                      userData.userData!["company_details"]
                                          ["business_type"],
                                  terms: userData.userData!["company_details"]
                                      ["terms_and_conditions"],
                                  upi: userData.userData!["company_details"]
                                      ["upi"],
                                  billingSettings: {
                                    'sales_invoice': {
                                      'prefix':
                                          saleInvoicePrefixController!.text,
                                      "starting_number":
                                          saleInvoiceNumberController!.text,
                                      'current_number':
                                          '${saleInvoicePrefixController!.text}${saleInvoiceNumberController!.text}',
                                      'is_reset': true
                                    },
                                    'sales_return': {
                                      'prefix': saleReturnPrefixController!.text,
                                      "starting_number":
                                          saleReturneNumberController!.text,
                                      'current_number':
                                          '${saleReturnPrefixController!.text}${saleReturneNumberController!.text}',
                                      'is_reset': true
                                    },
                                    'sales_estimate': {
                                      'prefix':
                                          saleEstimatePrefixController!.text,
                                      "starting_number":
                                          saleEstimateNumberController!.text,
                                      'current_number':
                                          '${saleEstimatePrefixController!.text}${saleEstimateNumberController!.text}',
                                      'is_reset': true
                                    },
                                    'purchase_bill': {
                                      'prefix':
                                          purchaseBillPrefixController!.text,
                                      "starting_number":
                                          purchaseBillNumberController!.text,
                                      'current_number':
                                          '${purchaseBillPrefixController!.text}${purchaseBillNumberController!.text}',
                                      'is_reset': true
                                    },
                                    'purchase_order': {
                                      'prefix':
                                          purchaseOrderPrefixController!.text,
                                      "starting_number":
                                          purchaseOrderNumberController!.text,
                                      'current_number':
                                          '${purchaseOrderPrefixController!.text}${purchaseOrderNumberController!.text}',
                                      'is_reset': true
                                    },
                                    'purchase_return': {
                                      'prefix':
                                          purchaseReturnPrefixController!.text,
                                      "starting_number":
                                          purchaseReturnNumberController!.text,
                                      'current_number':
                                          '${purchaseReturnPrefixController!.text}${purchaseReturnNumberController!.text}',
                                      'is_reset': true
                                    },
                                  }).then((value) {
                                if (userData.loadingState ==
                                    LoadingStates.success) {
                                  userData.fetchUser().then(
                                      (value) =>widget.isDrawer ? Navigator.of(context).pop():context.read<AuthProvider>().setCurrentPage(ProfileWidget(false)));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(userData.message)));
                                }
                              });
                            },
                            text: 'Save',
                            options: FFButtonOptions(
                              width: 90,
                              height: 40,
                              color: FlutterFlowTheme.of(context).primaryColor,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: 8,
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
