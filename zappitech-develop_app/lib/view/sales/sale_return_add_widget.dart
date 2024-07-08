import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/sales_providers/sale_return_provider.dart';

import '../../components/added_item_card.dart';
import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_radio_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../components/item_add_to_bill_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';
import '../../providers/item_add_bill_provider.dart';
import '../../providers/item_provider/item_provider.dart';
import '../../providers/people_provider/people_provider.dart';

class SaleReturnAddWidget extends StatefulWidget {
  final bool isDrawer;
  final bool? isEdit;
  final Map? data;
  final String? id;
  const SaleReturnAddWidget(this.isDrawer,
      {Key? key, this.isEdit, this.data, this.id})
      : super(key: key);

  @override
  _SaleReturnAddWidgetState createState() => _SaleReturnAddWidgetState();
}

class _SaleReturnAddWidgetState extends State<SaleReturnAddWidget> {
  DateTime datePicked = DateTime.now();
  TextEditingController? billingNameController;
  TextEditingController? phoneController;
  TextEditingController? paidController;
  TextEditingController? invoiceNoController;
  TextEditingController? dateController;
  DateTime? datePicked2;
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

    billingNameController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['customer']);
    phoneController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['phone']);
    paidController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(
            text: '${widget.data!['paid'] - widget.data!['grand_total']}');
    invoiceNoController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['invoice_no']}');
    dateController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(
            text: DateFormat("yyyy/MM/dd")
                .format(widget.data!['invoice_date'].toDate()));
    if (widget.isEdit!) {
      setState(() {
        datePicked = !widget.isEdit! ? null : widget.data!['date'].toDate();

        datePicked2 =
            !widget.isEdit! ? null : widget.data!['invoice_date'].toDate();
        Provider.of<ItemAddBill>(context, listen: false)
            .setItem(widget.data!['items']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemAddBill>(context);
    final salesData = Provider.of<SalesReturnProvider>(context, listen: false);
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final items = Provider.of<ItemProvider>(context);
    final peopleData = Provider.of<PeopleProvider>(context);
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
                onPressed: () async {
                  widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(SaleReturnListWidget(false));
                },
              ),
              title: Text(
                'Add Return',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
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
                                salesData.fetchsaleReturn().then((value) =>
                                    widget.isDrawer
                                        ? Navigator.pop(context)
                                        : context
                                            .read<AuthProvider>()
                                            .setCurrentPage(
                                                SaleReturnListWidget(false)));
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (widget.isEdit!) {
                  await salesData
                      .editsaleReturn(
                          id: widget.id,
                          billingName: billingNameController!.text.trim(),
                          date: datePicked,
                          grandTotal: itemData.grandTotal,
                          items: itemData.items,
                          invoiceNum: '${widget.data!['invoice_num']}',
                          phone: phoneController!.text.trim(),
                          subTotal: itemData.grandPrice,
                          paid: double.parse(paidController!.text.trim()),
                          custId: custId,
                          tax: itemData.grandTax,
                          invoiceDate: datePicked2,
                          invoiceNo: invoiceNoController!.text.trim())
                      .then((value) {
                    salesData.fetchsaleReturn().then((value) => widget.isDrawer
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(SaleReturnListWidget(false)));
                  });
                } else {
                  await salesData
                      .postSalesReturns(
                          billingName: billingNameController!.text.trim(),
                          date: datePicked,
                          grandTotal: itemData.grandTotal,
                          items: itemData.items,
                          invoiceNum:
                              '${salesData.setBill(prefix: userData.userData!["billing_settings"]["sales_return"]["prefix"], number: userData.userData!["billing_settings"]["sales_return"]["starting_number"])}',
                          phone: phoneController!.text.trim(),
                          subTotal: itemData.grandPrice,
                          paid: double.parse(paidController!.text.trim()),
                          custId: custId,
                          tax: itemData.grandTax,
                          invoiceDate: datePicked2,
                          invoiceNo: invoiceNoController!.text.trim())
                      .then((value) {
                    for (var i = 0; i < itemData.items.length; i++) {
                      items.editStock(
                          isMinus: false,
                          id: itemData.items[i]["id"],
                          stock: itemData.items[i]['quantity'],
                          barcode: itemData.items[i]['item_name']);
                    }
                    items.fetchItems();
                    salesData.fetchsaleReturn().then((value) => widget.isDrawer
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(SaleReturnListWidget(false)));
                  });
                }
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: salesData.loadingState == LoadingStates.loading ||
                      items.loadingState == LoadingStates.loading
                  ? circleLoading(context)
                  : Text(
                      widget.isEdit! ? 'Edit' : 'Save',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                          ),
                    ),
            ),
            body: _saleReturnAddMain(context))
        : _saleReturnAddMain(context);
  }

  Widget _saleReturnAddMain(BuildContext context) {
    final itemData = Provider.of<ItemAddBill>(context);
    final salesData = Provider.of<SalesReturnProvider>(context, listen: false);
    final userData = Provider.of<AuthProvider>(context, listen: false);

    final peopleData = Provider.of<PeopleProvider>(context);
    return Form(
      key: _formKey,
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
                    'Invoice no: ${widget.isEdit! ? widget.data!['invoice_num'] : salesData.setBill(prefix: userData.userData!["billing_settings"]["sales_return"]["prefix"], number: userData.userData!["billing_settings"]["sales_return"]["starting_number"])}',
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
                  int ind = peopleData.customers
                      .indexWhere((element) => element.data()['name'] == value);

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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: TextFormField(
                      controller: dateController,
                      onTap: () async {
                        await DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          onConfirm: (date) {
                            setState(() {
                              datePicked2 = date;
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
                        labelText: 'Invoice Date',
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
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: TextFormField(
                      controller: invoiceNoController,
                      onChanged: (_) => EasyDebounce.debounce(
                        'textController4',
                        Duration(milliseconds: 2000),
                        () => setState(() {}),
                      ),
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Invoice no.',
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
              ],
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
                      padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                      child: itemAddedCard(
                          ctx: context,
                          discount: items.items[index]['discount_amount'],
                          discountPercent: items.items[index]
                              ["discount_percent"],
                          itemName: items.items[index]['item_name'],
                          pricePerUnit: items.items[index]['rate_per_unit'],
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
                        index: 0,
                        isEdit: false,
                        isSale: true,
                      ),
                    ),
                  );
                },
                text: '+ Add Items',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 40,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  textStyle: FlutterFlowTheme.of(context).subtitle2.override(
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Base Price',
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF7C8791),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Text(
                        '₹ ${(itemData.grandPrice - itemData.grandTax).toStringAsFixed(2)}',
                        style: FlutterFlowTheme.of(context).subtitle2.override(
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
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF7C8791),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      Text(
                        '₹ ${itemData.grandTax.toStringAsFixed(2)}',
                        style: FlutterFlowTheme.of(context).subtitle2.override(
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
                            style:
                                FlutterFlowTheme.of(context).subtitle1.override(
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
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF090F13),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextFormField(
                    controller: paidController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field can not be empty";
                      }
                      return null;
                    },
                    onChanged: (_) => EasyDebounce.debounce(
                      'paidController',
                      Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Extra Charges',
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
    );
  }
}
