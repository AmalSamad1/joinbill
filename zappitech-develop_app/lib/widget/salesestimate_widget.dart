import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../components/added_item_card.dart';
import '../components/item_add_to_bill_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_radio_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../providers/item_add_bill_provider.dart';
import '../providers/people_provider/people_provider.dart';
import '../view/dashboard/drawerWidget.dart';
import '../view/sales/sales_estimate_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesestimateWidget extends StatefulWidget {
  const SalesestimateWidget({Key? key}) : super(key: key);

  @override
  _SalesestimateWidgetState createState() => _SalesestimateWidgetState();
}

class _SalesestimateWidgetState extends State<SalesestimateWidget> {
  
  DateTime datePicked = DateTime.now();
  TextEditingController? billingNameController;
  TextEditingController? phoneController;
  
  List<String> custItems = [];
  String? custId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("kooooii");
    final data = Provider.of<PeopleProvider>(context, listen: false);

    data.fetchcutomers().then((value) {
      print("kooooii");
      print(data.customers);
      for (var i = 0; i < data.customers.length; i++) {
        custItems.add(data.customers[i].data()['name']);
      }
    });
    Provider.of<ItemAddBill>(context, listen: false).reset();

    billingNameController = TextEditingController();

    phoneController = TextEditingController();

    
  }

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemAddBill>(context);

    final peopleData = Provider.of<PeopleProvider>(context);
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
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Create Estimate',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [
          
        ],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // if (widget.isEdit) {
          //   await salesData
          //       .editSalesInvoice(
          //           id: widget.id,
          //           billingName: billingNameController.text.trim(),
          //           date: datePicked,
          //           grandTotal: itemData.grandTotal,
          //           items: itemData.items,
          //           payMode: radioButtonValue1,
          //           phone: phoneController.text.trim(),
          //           subTotal: itemData.grandPrice,
          //           paid: double.parse(paidController.text.trim()),
          //           custId: custId,
          //           tax: itemData.grandTax)
          //       .then((value) {
          //     salesData
          //         .fetchSalesInvoice()
          //         .then((value) => Navigator.pop(context));
          //   });
          // } else {
          //   await salesData
          //       .postSalesInvoice(
          //           billingName: billingNameController.text.trim(),
          //           date: datePicked,
          //           grandTotal: itemData.grandTotal,
          //           items: itemData.items,
          //           payMode: radioButtonValue1,
          //           phone: phoneController.text.trim(),
          //           subTotal: itemData.grandPrice,
          //           paid: double.parse(paidController.text.trim()),
          //           custId: custId,
          //           tax: itemData.grandTax)
          //       .then((value) {
          //     salesData
          //         .fetchSalesInvoice()
          //         .then((value) => Navigator.pop(context));
          //   });
          // }
        },
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        elevation: 8,
        label:
        //  salesData.loadingState == LoadingStates.loading
        //     ? circleLoading(context)
        //     :
             Text(
                // widget.isEdit ? 'Edit' :
                 'Save',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryBtnText,
                    ),
              ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Row(
                      children: [
                       MediaQuery.of(context).size.width<660?Container(): Container(
                        width:MediaQuery.of(context).size.width<1000? MediaQuery.of(context).size.width*0.1:MediaQuery.of(context).size.width*0.2,
                        child: DrawerWidget(false)),
                    Container(
                       width: MediaQuery.of(context).size.width<660?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.8,
                  child: SingleChildScrollView(
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
                                '',
                                style:
                                    FlutterFlowTheme.of(context).bodyText1.override(
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
                                  style:
                                      FlutterFlowTheme.of(context).bodyText1.override(
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
                              int ind = peopleData.customers.indexWhere(
                                  (element) => element.data()['name'] == value);
                
                              setState(() {
                                phoneController!.text =
                                    '${peopleData.customers[ind].data()['phone']}';
                                billingNameController!.text = value!;
                                custId = peopleData.customers[ind].id;
                              });
                            },
                            selectedItem: billingNameController!.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          child: TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field can not be empty";
                              }
                              return null;
                            },
                           onChanged: (value) {
                              int ind = peopleData.customers.indexWhere(
                                  (element) => element.data()['phone'] == value);
                              if (ind != -1) {
                                setState(() {
                                  billingNameController!.text =
                                      '${peopleData.customers[ind].data()['name']}';
                
                                  custId = peopleData.customers[ind].id;
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
                        Consumer<ItemAddBill>(
                          builder: (context, items, child) => Column(
                            children: List.generate(
                              items.items.length,
                              (index) => Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                                  child: itemAddedCard(
                                      ctx: context,
                                      discount: items.items[index]['discount_amount'],
                                      discountPercent: items.items[index]
                                          ["discount_percent"],
                                      itemName: items.items[index]['item_name'],
                                      pricePerUnit: items.items[index]
                                          ['rate_per_unit'],
                                      quantity: items.items[index]['quantity'],
                                      tax: items.items[index]['gst_amount'],
                                      taxName: items.items[index]['gst_type'],
                                      total: items.items[index]['total'],
                                      units: items.items[index]['unit'],
                                      index: index)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaleInvoiceItemAddWidget(
                                      index: 0, isEdit: false,isSale: true,),
                                ),
                              );
                            },
                            text: '+ Add Items',
                            options: FFButtonOptions(
                              width: double.infinity,
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
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Lexend Deca',
                                          color: Color(0xFF7C8791),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Base Price',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF7C8791),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  Text(
                                    '₹ ${itemData.grandPrice.toStringAsFixed(2)}',
                                    style: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF090F13),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Taxes',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF7C8791),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  Text(
                                    '₹ ${itemData.grandTax.toStringAsFixed(2)}',
                                    style: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF090F13),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
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
                            //         'Discount',
                            //         style: FlutterFlowTheme.of(context)
                            //             .bodyText2
                            //             .override(
                            //               fontFamily: 'Outfit',
                            //               color: Color(0xFF4DC412),
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.normal,
                            //             ),
                            //       ),
                            //       Text(
                            //         '₹ 40.00',
                            //         style: FlutterFlowTheme.of(context)
                            //             .subtitle2
                            //             .override(
                            //               fontFamily: 'Outfit',
                            //               color: Color(0xFF4DC412),
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.normal,
                            //             ),
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
                                        'Total',
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle1
                                            .override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF7C8791),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30,
                                        borderWidth: 1,
                                        buttonSize: 36,
                                        icon: Icon(
                                          Icons.info_outlined,
                                          color: Color(0xFF7C8791),
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          print('IconButton pressed ...');
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹ ${itemData.grandTotal.toStringAsFixed(2)}',
                                    style:
                                        FlutterFlowTheme.of(context).title1.override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF090F13),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
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
                        
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
