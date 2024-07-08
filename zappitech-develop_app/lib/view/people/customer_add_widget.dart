import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/people_provider/people_provider.dart';
import 'package:ziptech/view/people/customers_list_widget.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_radio_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';

class CustomerAddWidget extends StatefulWidget {
  final bool? isDrawer;
  final bool? isEdit;
  final Map? data;
  final String? id;
  const CustomerAddWidget(this.isDrawer,
      {Key? key, this.isEdit, this.data, this.id})
      : super(key: key);

  @override
  _CustomerAddWidgetState createState() => _CustomerAddWidgetState();
}

class _CustomerAddWidgetState extends State<CustomerAddWidget> {
  DateTime? datePicked;
  TextEditingController? dateController;
  TextEditingController? balanceController;
  String ?gstType;
  TextEditingController? nameController;
  TextEditingController? gstinController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? addressController;
  TextEditingController? panController;

  TextEditingController? accController;
  TextEditingController? ifscController;
  TextEditingController? upiController;

  TextEditingController? creditController;
  TextEditingController? creditExpiryController;

  DateTime? expiryDate;

  String? stateSelect;
  String? radioButtonValue1;
  String? radioButtonType;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    nameController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['name']);
    gstinController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['gstin']);
    phoneController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['phone']);
    emailController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['email']);
    addressController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['address']);
    balanceController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['balance']}');
    panController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['pan']}');

    accController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['acc_number']}');
    ifscController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['ifsc']}');
    upiController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['upi']}');

    creditController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['credit_limit']}');
    dateController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(
            text:
                DateFormat("yyyy/MM/dd").format(widget.data!['date'].toDate()));
    creditExpiryController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(
            text: DateFormat("yyyy/MM/dd")
                .format(widget.data!['credit_expiry'].toDate()));
    setState(() {
      datePicked = !widget.isEdit! ? null : widget.data!['date'].toDate();
      expiryDate =
          !widget.isEdit! ? null : widget.data!['credit_expiry'].toDate();
      gstType = !widget.isEdit! ? null : widget.data!['gst_type'];
      stateSelect = !widget.isEdit! ? "Kerala" : widget.data!['state'];
      radioButtonValue1 =
          !widget.isEdit! ? 'To Receive' : widget.data!['balance_type'];
      radioButtonType = !widget.isEdit! ? 'Customer' : widget.data!['category'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<PeopleProvider>(context);
    return widget.isDrawer!
        ? Scaffold(
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
                  Icons.close,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  widget.isDrawer!
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(PeopleListWidget(false));
                },
              ),
              title: Text(
                'Add Customer',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [
                widget.isEdit!
                    ? itemData.loadingState == LoadingStates.loading
                        ? circleLoading(context, clr: Colors.white)
                        : IconButton(
                            onPressed: () async {
                              await itemData
                                  .deletecutomers(
                                id: widget.id,
                              )
                                  .then((value) {
                                itemData.fetchcutomers().then((value) =>
                                    widget.isDrawer!
                                        ? Navigator.pop(context)
                                        : context
                                            .read<AuthProvider>()
                                            .setCurrentPage(
                                                PeopleListWidget(false)));
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ))
                    : Container(),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: Icon(

                    Icons.camera_alt,
                    color: FlutterFlowTheme.of(context).primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
              centerTitle: true,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (widget.isEdit!) {
                  await itemData
                      .editcutomers(
                          id: widget.id,
                          date: datePicked,
                          address: addressController!.text.trim(),
                          balance: double.parse(balanceController!.text.trim()),
                          balanceType: radioButtonValue1,
                          category: radioButtonType,
                          email: emailController!.text.trim(),
                          gstType: gstType,
                          gstin: gstinController!.text.trim(),
                          name: nameController!.text.trim(),
                          phone: phoneController!.text.trim(),
                          state: stateSelect,
                          total: 0.0)
                      .then((value) {
                    itemData.fetchcutomers().then((value) => widget.isDrawer!
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(PeopleListWidget(false)));
                  });
                } else {
                  await itemData
                      .postCustomers(
                          acc: accController!.text.trim(),
                          credit: double.parse(creditController!.text.trim()),
                          expiry: expiryDate,
                          ifsc: ifscController!.text.trim(),
                          pan: panController!.text.trim(),
                          upi: upiController!.text.trim(),
                          date: datePicked,
                          address: addressController!.text.trim(),
                          balance: double.parse(balanceController!.text.trim()),
                          balanceType: radioButtonValue1,
                          category: radioButtonType,
                          email: emailController!.text.trim(),
                          gstType: gstType,
                          gstin: gstinController!.text.trim(),
                          name: nameController!.text.trim(),
                          phone: phoneController!.text.trim(),
                          state: stateSelect,
                          total: 0.0)
                      .then((value) {
                    if (itemData.loadingState == LoadingStates.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(itemData.message)));
                    } else {
                      itemData.fetchcutomers().then((value) => widget.isDrawer!
                          ? Navigator.pop(context)
                          : context
                              .read<AuthProvider>()
                              .setCurrentPage(PeopleListWidget(false)));
                    }
                  });
                }
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: itemData.loadingState == LoadingStates.loading
                  ? circleLoading(context, clr: Colors.white)
                  : Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Text(
                        widget.isEdit! ? 'Edit' : 'Save',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                            ),
                      ),
                    ),
            ),
            body: SafeArea(child: _partyAddMain()))
        : _partyAddMain();
  }

  Widget _partyAddMain() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                  child: FlutterFlowRadioButton(
                    initialValue: radioButtonType ??= 'Customer',
                    options: ['Customer', 'Supplier'].toList(),
                    onChanged: (value) {
                      setState(() => radioButtonType = value);
                    },
                    optionHeight: 25,
                    textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                    buttonPosition: RadioButtonPosition.left,
                    direction: Axis.horizontal,
                    radioButtonColor: Colors.blue,
                    inactiveRadioButtonColor: Color(0x8A000000),
                    toggleable: false,
                    horizontalAlignment: WrapAlignment.start,
                    verticalAlignment: WrapCrossAlignment.start,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: TextFormField(
              controller: nameController,
              onChanged: (_) => EasyDebounce.debounce(
                'nameController',
                Duration(milliseconds: 2000),
                () => setState(() {}),
              ),
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Name',
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
              controller: phoneController,
              onChanged: (_) => EasyDebounce.debounce(
                'phoneController',
                Duration(milliseconds: 2000),
                () => setState(() {}),
              ),
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Contact number',
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
              keyboardType: TextInputType.phone,
              style: FlutterFlowTheme.of(context).bodyText1,
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: TextFormField(
              controller: emailController,
              onChanged: (_) => EasyDebounce.debounce(
                'emailController',
                Duration(milliseconds: 2000),
                () => setState(() {}),
              ),
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Email Address',
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
          Divider(
            height: 10,
            thickness: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                  child: TextFormField(
                    maxLines: 2,
                    controller: addressController,
                    onChanged: (_) => EasyDebounce.debounce(
                      'addressController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Billing Address',
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
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: FlutterFlowDropDown(
              initialOption: gstType,
              options: [
                'Unregistered/Consumer',
                'Registered - Regular',
                'Registered - Composit'
              ].toList(),
              onChanged: (val) {
                setState(() {
                  gstType = val;
                });
              },
              height: 50,
              textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
              hintText: 'GST',
              fillColor: Colors.white,
              elevation: 2,
              borderColor: FlutterFlowTheme.of(context).primaryColor,
              borderWidth: 0,
              borderRadius: 8,
              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
              hidesUnderline: true,
            ),
          ),
          gstType == 'Unregistered/Consumer'
              ? Container()
              : Padding(
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
                      labelText: 'GSTIN',
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
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: FlutterFlowDropDown(
              initialOption: stateSelect,
              options: [
                "Andhra Pradesh",
                "Arunachal Pradesh",
                "Assam",
                "Bihar",
                "Chhattisgarh",
                "Goa",
                "Gujarat",
                "Haryana",
                "Himachal Pradesh",
                "Jammu and Kashmir",
                "Jharkhand",
                "Karnataka",
                "Kerala",
                "Madhya Pradesh",
                "Maharashtra",
                "Manipur",
                "Meghalaya",
                "Mizoram",
                "Nagaland",
                "Odisha",
                "Punjab",
                "Rajasthan",
                "Sikkim",
                "Tamil Nadu",
                "Telangana",
                "Tripura",
                "Uttarakhand",
                "Uttar Pradesh",
                "West Bengal",
                "Andaman and Nicobar Islands",
                "Chandigarh",
                "Dadra and Nagar Haveli",
                "Daman and Diu",
                "Delhi",
                "Lakshadweep",
                "Puducherry"
              ].toList(),
              onChanged: (val) => setState(() => stateSelect = val),
              height: 50,
              textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
              hintText: 'State',
              fillColor: Colors.white,
              elevation: 2,
              borderColor: FlutterFlowTheme.of(context).primaryColor,
              borderWidth: 0,
              borderRadius: 8,
              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
              hidesUnderline: true,
            ),
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                  child: FlutterFlowRadioButton(
                    initialValue: radioButtonValue1 ??= 'To Receive',
                    options: ['To Receive', 'To Pay'].toList(),
                    onChanged: (value) {
                      setState(() => radioButtonValue1 = value);
                    },
                    optionHeight: 25,
                    textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                    buttonPosition: RadioButtonPosition.left,
                    direction: Axis.vertical,
                    radioButtonColor: Colors.blue,
                    inactiveRadioButtonColor: Color(0x8A000000),
                    toggleable: false,
                    horizontalAlignment: WrapAlignment.start,
                    verticalAlignment: WrapCrossAlignment.start,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextFormField(
                    controller: balanceController,
                    onChanged: (_) => EasyDebounce.debounce(
                      'balanceController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Opening Balance',
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextFormField(
                    controller: dateController,
                    onChanged: (_) => EasyDebounce.debounce(
                      'dateController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    onTap: () async {
                      await DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            datePicked = date;
                            dateController!.text =
                                DateFormat("yyyy/MM/dd").format(date);
                          });
                        },
                        currentTime: getCurrentTimestamp,
                      );
                    },
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'As of Date',
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
                    //keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextFormField(
                    controller: creditController,
                    onChanged: (_) => EasyDebounce.debounce(
                      'creditController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Credit Limit',
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextFormField(
                    controller: creditExpiryController,
                    onChanged: (_) => EasyDebounce.debounce(
                      'creditExpiryController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    onTap: () async {
                      await DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            expiryDate = date;
                            creditExpiryController!.text =
                                DateFormat("yyyy/MM/dd").format(date);
                          });
                        },
                        currentTime: getCurrentTimestamp,
                        minTime: getCurrentTimestamp,
                      );
                    },
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Credit Upto',
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
                    //keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Container(
            height: 200,
          ),
        ],
      ),
    );
  }
}
