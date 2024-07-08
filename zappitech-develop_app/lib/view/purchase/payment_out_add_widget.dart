import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/people_provider/people_provider.dart';
import 'package:ziptech/providers/purchase_providers/paymentOut_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_radio_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';

class PaymentOutAddWidget extends StatefulWidget {
  final bool isDrawer;
  final bool? isEdit;
  final Map? data;
  final String? id;
  const PaymentOutAddWidget(this.isDrawer,
      {Key? key, this.isEdit, this.data, this.id})
      : super(key: key);

  @override
  _PaymentOutAddWidgetState createState() => _PaymentOutAddWidgetState();
}

class _PaymentOutAddWidgetState extends State<PaymentOutAddWidget> {
  TextEditingController? billingNameController;
  TextEditingController? numberController;
  TextEditingController? amountController;
  TextEditingController? descriptionController;

  DateTime datePicked = DateTime.now();
  List<String> custItems = [];
  String? custId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final data = Provider.of<PeopleProvider>(context, listen: false);

    data.fetchcutomers().then((value) {
      print("kooooii");
      print(data.customers);
      for (var i = 0; i < data.suppliers.length; i++) {
        custItems.add(data.suppliers[i].data()['name']);
      }
    });
    billingNameController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['customer']}');
    numberController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['phone']}');
    amountController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['paid']}');
    descriptionController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['description']}');

    if (widget.isEdit!) {
      setState(() {
        datePicked = !widget.isEdit! ? null : widget.data!['date'].toDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesData = Provider.of<PaymentOutProvider>(context, listen: false);

    return widget.isDrawer
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
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(PaymentOutListWidget(false));
                },
              ),
              title: Text(
                'Add Payment-out',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [
                widget.isEdit!
                    ? salesData.loadingState == LoadingStates.loading
                        ? circleLoading(context, clr: Colors.white)
                        : IconButton(
                            onPressed: () async {
                              await salesData
                                  .deleteItems(
                                id: widget.id,
                              )
                                  .then((value) {
                                salesData.fetchSalesIn().then((value) =>
                                    widget.isDrawer
                                        ? Navigator.pop(context)
                                        : context
                                            .read<AuthProvider>()
                                            .setCurrentPage(
                                                PaymentOutListWidget(false)));
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))
                    : Container(),
              ],
              centerTitle: true,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (widget.isEdit!) {
                  await salesData
                      .editSalesIn(
                    id: widget.id,
                    billingName: billingNameController!.text.trim(),
                    date: datePicked,
                    description: descriptionController!.text.trim(),
                    phone: numberController!.text.trim(),
                    paid: double.parse(amountController!.text.trim()),
                    custId: custId,
                  )
                      .then((value) {
                    salesData.fetchSalesIn().then((value) => widget.isDrawer
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(PaymentOutListWidget(false)));
                  });
                } else {
                  await salesData
                      .postSalesIn(
                    billingName: billingNameController!.text.trim(),
                    date: datePicked,
                    description: descriptionController!.text.trim(),
                    phone: numberController!.text.trim(),
                    paid: double.parse(amountController!.text.trim()),
                    custId: custId,
                  )
                      .then((value) {
                    salesData.fetchSalesIn().then((value) => widget.isDrawer
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(PaymentOutListWidget(false)));
                  });
                }
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: salesData.loadingState == LoadingStates.loading
                  ? circleLoading(context)
                  : Text(
                      widget.isEdit! ? 'Edit' : 'Save',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
            ),
            body: SafeArea(child: _paymentOutAddMain(context)),
          )
        : _paymentOutAddMain(context);
  }

  Widget _paymentOutAddMain(BuildContext context) {
    final peopleData = Provider.of<PeopleProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Text(
                  'Invoice no:\n#3',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    onConfirm: (date) {
                      setState(() {
                        datePicked = date;
                      });
                    },
                    currentTime: getCurrentTimestamp,
                    minTime: getCurrentTimestamp,
                  );
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                  child: Text(
                    DateFormat("yyyy/MM/dd").format(datePicked),
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: DropdownSearch<String>(
              showSelectedItems: true,
              showSearchBox: true,
              mode: Mode.DIALOG,
              dropdownBuilderSupportsNullItem: true,
              items: custItems,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Field can not be empty";
                }
                return null;
              },
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Billing Name',
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
              onChanged: (value) {
                int ind = peopleData.suppliers
                    .indexWhere((element) => element.data()['name'] == value);

                setState(() {
                  numberController!.text =
                      '${peopleData.suppliers[ind].data()['phone']}';
                  billingNameController!.text = value!;
                  custId = peopleData.suppliers[ind].id;
                });
              },
              selectedItem: billingNameController!.text,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: TextFormField(
              controller: numberController,
              onChanged: (value) {
                int ind = peopleData.suppliers
                    .indexWhere((element) => element.data()['phone'] == value);
                if (ind != -1) {
                  setState(() {
                    billingNameController!.text =
                        '${peopleData.suppliers[ind].data()['name']}';

                    custId = peopleData.suppliers[ind].id;
                  });
                }
              },
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Phone Number',
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
          Divider(
            height: 10,
            thickness: 10,
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Price Breakdown',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF7C8791),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Balance',
              //         style:
              //             FlutterFlowTheme.of(context).bodyText2.override(
              //                   fontFamily: 'Outfit',
              //                   color: Color(0xFF4DC412),
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.normal,
              //                 ),
              //       ),
              //       Text(
              //         '₹ 40.00',
              //         style:
              //             FlutterFlowTheme.of(context).subtitle2.override(
              //                   fontFamily: 'Outfit',
              //                   color: Color(0xFF4DC412),
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.normal,
              //                 ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Total Amount (₹)',
                          style:
                              FlutterFlowTheme.of(context).subtitle1.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF7C8791),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 16),
                        child: TextFormField(
                          controller: amountController,
                          onChanged: (_) => EasyDebounce.debounce(
                            'amountController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Amount',
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: TextFormField(
              controller: descriptionController,
              //  onChanged: (value) {
              //       int ind = peopleData.customers.indexWhere(
              //           (element) => element.data()['phone'] == value);
              //       if (ind != -1) {
              //         setState(() {
              //           billingNameController.text =
              //               '${peopleData.customers[ind].data()['name']}';

              //           custId = peopleData.customers[ind].id;
              //         });
              //       }
              //     },
              maxLines: 3,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Description',
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
        ],
      ),
    );
  }
}
