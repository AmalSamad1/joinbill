import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/components/added_item_card.dart';
import 'package:ziptech/components/circleLoading.dart';
import 'package:ziptech/helpers/loadingStates.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/providers/item_add_bill_provider.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';
import 'package:ziptech/providers/people_provider/people_provider.dart';
import 'package:ziptech/providers/sales_providers/sales_invoice_provider.dart';
import 'package:ziptech/widget/button_widget.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_radio_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../components/item_add_to_bill_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/dashboard_widget_main.dart';

class SaleInvoiceAddWidget extends StatefulWidget {
  final bool isDrawer;
  final bool isEdit;
  final Map? data;
  final String? id;
  final bool quickAdd;
  const SaleInvoiceAddWidget(this.isDrawer,
      {Key? key, required this.isEdit, this.data, this.id, this.quickAdd = false})
      : super(key: key);

  @override
  _SaleInvoiceAddWidgetState createState() => _SaleInvoiceAddWidgetState();
}

class _SaleInvoiceAddWidgetState extends State<SaleInvoiceAddWidget> {
  String radioButtonValue1 = 'Cash';
  DateTime datePicked = DateTime.now();
  TextEditingController? billingNameController;
  TextEditingController? phoneController;
  TextEditingController? paidController;
  TextEditingController? discountAmountController;
  String? invNo;
  double balance = 0.0;
  bool isEnabled = true;

  List<String> custItems = [];
  String? custId;
  Map cust = {};

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
    final itemData = Provider.of<ItemAddBill>(context, listen: false);
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final salesData = Provider.of<SalesInvoiceProvider>(context, listen: false);
    itemData.reset();
    billingNameController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: widget.data!['customer']);
    phoneController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: widget.data!['phone']);
    paidController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['paid']}');
    discountAmountController = !widget.isEdit
        ? TextEditingController(text: "0")
        : TextEditingController(text: '${widget.data!['discount']}');
    if (widget.isEdit) {
      setState(() {
        datePicked = !widget.isEdit ? null : widget.data!['date'].toDate();
        radioButtonValue1 = !widget.isEdit ? null : widget.data!['payment_mode'];
        itemData.setItem(widget.data!['items']);
        itemData.setGrandDiscount(discount: widget.data!['discount']);
        itemData.setGrandTax();
        itemData.setGrandPrice();
        itemData.setGrandTotal();
        isEnabled = false;
      });
    }
    setState(() {
      invNo =
          '${widget.isEdit ? widget.data!['invoice_no'] : salesData.setBill(prefix: userData.userData!["billing_settings"]["sales_invoice"]["prefix"], number: userData.userData!["billing_settings"]["sales_invoice"]["starting_number"])}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemAddBill>(context);
    final salesData = Provider.of<SalesInvoiceProvider>(context, listen: false);
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final items = Provider.of<ItemProvider>(context);
    final peopleData = Provider.of<PeopleProvider>(context);
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
                      ? 
                      Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(DashboardWidgetMain(false));
                },
              ),
              title: Text(
                'Add Invoice',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [
                widget.isEdit
                    ? salesData.loadingState == LoadingStates.loading
                        ? circleLoading(context, clr: Colors.white)
                        : IconButton(
                            onPressed: () async {
                              await salesData
                                  .deleteItems(
                                id: widget.id,
                              )
                                  .then((value) {
                                peopleData
                                    .editBalance(
                                        balance: widget.data!["paid"],
                                        custId: widget.data!["customer_id"],
                                        isMinus: false,
                                        id: widget.data!["customer_id"])
                                    .then((value) {
                                  for (var i = 0;
                                      i < itemData.items.length;
                                      i++) {
                                    items.editStock(
                                        isMinus: false,
                                        id: itemData.items[i]["id"],
                                        stock: itemData.items[i]['quantity'],
                                        barcode: itemData.items[i]
                                            ['item_name']);
                                  }
                                  items.fetchItems();
                                  salesData
                                      .fetchSalesInvoice()
                                      .then((value) => Navigator.pop(context));
                                });
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ))
                    : Container(),
                widget.isEdit!
                    ? salesData.loadingState == LoadingStates.loading
                        ? circleLoading(context, clr: FlutterFlowTheme.of(context).primaryColor)
                        : IconButtonWidget(
                            onClicked: () {
                              getPdf(
                                  themeColor:
                                      userData.userData!["theme_color"] ?? 0,
                                  invoiceTheme:
                                      userData.userData!["invoice_theme"] ?? 0,
                                  logo: userData.userData!['company_details']
                                      ["logo"],
                                  seal: userData.userData!['company_details']
                                      ["seal"],
                                  sign: userData.userData!['company_details']
                                      ["sign"],
                                  tnc: userData.userData!['company_details']
                                      ["terms_and_conditions"],
                                  customerName:
                                      billingNameController!.text.isEmpty ||
                                              billingNameController!.text == null
                                          ? ""
                                          : billingNameController!.text.trim(),
                                  customerAddress: phoneController!.text.isEmpty ||
                                          phoneController!.text == null
                                      ? ""
                                      : phoneController!.text.trim(),
                                  description: 'Sale Invoice',
                                  invDate: datePicked,
                                  invNo: invNo!,
                                  items: itemData.items,
                                  total: itemData.grandPrice,
                                  grandTotal: itemData.grandTotal,
                                  discount: double.parse(
                                      discountAmountController!.text.trim()),
                                  ourAddress: userData.userData!['address'],
                                  ourCompany:
                                      userData.userData!['company_details']
                                          ["company_name"],
                                  ourGst:
                                      "GSTIN:${userData.userData!['company_details']['gstin']}",
                                  ourPhone: userData.userData!['phone_number'],
                                  custPhone: cust == {} ? '' : cust['address'],
                                  custgst: cust == {} ? '' : "GSTIN:${cust['gstin']}");
                            },
                            text: "",
                          )
                    : Container(),
              ],
              centerTitle: true,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: widget.isEdit
                ? Container()
                : FloatingActionButton.extended(
                    onPressed: () async {
                      if (widget.isEdit) {
                        await salesData
                            .editSalesInvoice(
                                id: widget.id,
                                billingName:
                                    billingNameController!.text.isEmpty ||
                                            billingNameController!.text == null
                                        ? ""
                                        : billingNameController!.text.trim(),
                                date: datePicked,
                                grandTotal: itemData.grandTotal,
                                items: itemData.items,
                                payMode: radioButtonValue1,
                                phone: phoneController!.text.isEmpty ||
                                        phoneController!.text == null
                                    ? ""
                                    : phoneController!.text.trim(),
                                subTotal: itemData.grandPrice,
                                paid: double.parse(paidController!.text.trim()),
                                invoiceNo: '${widget.data!['invoice_no']}',
                                discount: double.parse(
                                    discountAmountController!.text.trim()),
                                custId: custId,
                                tax: itemData.grandTax)
                            .then((value) {
                          salesData
                              .fetchSalesInvoice()
                              .then((value) => Navigator.pop(context));
                        });
                      } else {
                        await salesData
                            .postSalesInvoice(
                                billingName:
                                    billingNameController!.text.isEmpty ||
                                            billingNameController!.text == null
                                        ? ""
                                        : billingNameController!.text.trim(),
                                balance: balance,
                                date: datePicked,
                                grandTotal: itemData.grandTotal,
                                items: itemData.items,
                                payMode: radioButtonValue1,
                                phone: phoneController!.text.isEmpty ||
                                        phoneController!.text == null
                                    ? ""
                                    : phoneController!.text.trim(),
                                invoiceNo:
                                    '${salesData.setBill(prefix: userData.userData!["billing_settings"]["sales_invoice"]["prefix"], number: userData.userData!["billing_settings"]["sales_invoice"]["starting_number"])}',
                                subTotal: itemData.grandPrice,
                                paid: double.parse(paidController!.text.trim()),
                                discount: double.parse(
                                    discountAmountController!.text.trim()),
                                custId: custId,
                                tax: itemData.grandTax)
                            .then((value) {
                          peopleData
                              .editBalance(
                                  balance:
                                      double.parse(paidController!.text.trim()),
                                  custId: custId,
                                  isMinus: true,
                                  id: custId)
                              .then((value) {
                            for (var i = 0; i < itemData.items.length; i++) {
                              items.editStock(
                                  isMinus: true,
                                  id: itemData.items[i]["id"],
                                  stock: itemData.items[i]['quantity'],
                                  barcode: itemData.items[i]['item_name']);
                            }
                            items.fetchItems();
                            salesData.fetchSalesInvoice().then((value) {
                              Navigator.pop(context);
                              getPdf(
                                  themeColor:
                                      userData.userData!["theme_color"] ?? 0,
                                  invoiceTheme:
                                      userData.userData!["invoice_theme"] ?? 0,
                                  logo: userData.userData!['company_details']
                                      ["logo"],
                                  seal: userData.userData!['company_details']
                                      ["seal"],
                                  sign: userData.userData!['company_details']
                                      ["sign"],
                                  tnc: userData.userData!['company_details']
                                      ["terms_and_conditions"],
                                  customerName: billingNameController!.text.isEmpty ||
                                          billingNameController!.text == null
                                      ? ""
                                      : billingNameController!.text.trim(),
                                  customerAddress: phoneController!.text.isEmpty ||
                                          phoneController!.text == null
                                      ? ""
                                      : phoneController!.text.trim(),
                                  description: 'Sale Invoice',
                                  invDate: datePicked,
                                  invNo: invNo!,
                                  total:
                                      itemData.grandPrice - itemData.grandTax,
                                  grandTotal: itemData.grandTotal,
                                  items: itemData.items,
                                  discount: double.parse(
                                      discountAmountController!.text.trim()),
                                  ourAddress: userData.userData!['address'],
                                  ourCompany: userData.userData!['company_details']
                                      ["company_name"],
                                  ourGst: userData.userData!['company_details']
                                      ['gstin'],
                                  ourPhone: userData.userData!['phone_number'],
                                  custPhone: cust == {} ? '' : cust['address'],
                                  custgst: cust == {} ? '' : cust['gstin']);
                            });
                          });
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
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                    ),
                          ),
                  ),
            body: SafeArea(
              child: _saleInvoiceAddMain(context),
            ))
        : _saleInvoiceAddMain(context);
  }

  Widget _saleInvoiceAddMain(BuildContext context) {
    final itemData = Provider.of<ItemAddBill>(context);
    final salesData = Provider.of<SalesInvoiceProvider>(context, listen: false);
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final items = Provider.of<ItemProvider>(context);
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
                    'Invoice no: ${widget.isEdit! ? widget.data!['invoice_no'] : salesData.setBill(prefix: userData.userData!["billing_settings"]["sales_invoice"]["prefix"], number: userData.userData!["billing_settings"]["sales_invoice"]["starting_number"])}',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.isEdit!) {
                      await DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            datePicked = date;
                          });
                        },
                        currentTime: getCurrentTimestamp,
                        // minTime: getCurrentTimestamp,
                      );
                    }
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
            // Divider(
            //   height: 10,
            //   thickness: 10,
            // ),
            widget.quickAdd
                ? Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: 349,
                      height: 55,
                      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, color: Color(0xFFCCD8ED)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: TextFormField(
                        enabled: isEnabled,
                        controller: billingNameController,
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
                              balance =
                                  peopleData.customers[ind].data()['balance'];

                              custId = peopleData.customers[ind].id;
                              cust = peopleData.customers[ind].data();
                            });
                          }
                        },
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Billing Name',
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: FlutterFlowTheme.of(context).primaryColor,
                          //     width: 1,
                          //   ),
                          //   borderRadius: BorderRadius.circular(1),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: FlutterFlowTheme.of(context).primaryColor,
                          //     width: 1,
                          //   ),
                          //   borderRadius: BorderRadius.circular(1),
                          // ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyText1,
                        textAlign: TextAlign.start,
                        //keyboardType: TextInputType.number,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                    child: Container(
                      width: 349,
                      height: 57,
                      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, 0color: Color(0xFFCCD8ED)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: DropdownSearch<String>(
                        showSelectedItems: true,
                        showSearchBox: true,
                        mode: Mode.DIALOG,
                        dropdownBuilderSupportsNullItem: true,
                        items: widget.isEdit!
                            ? [billingNameController!.text]
                            : custItems,
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
                            borderRadius: BorderRadius.circular(1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryColor!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        onChanged: (value) {
                          if (widget.isEdit != true) {
                            int ind = peopleData.customers.indexWhere(
                                (element) => element.data()['name'] == value);

                            setState(() {
                              phoneController!.text =
                                  '${peopleData.customers[ind].data()['phone']}';
                              print("hoooi");
                              balance = double.parse(
                                  "${peopleData.customers[ind].data()['balance']}");
                              print("jjjoooi");
                              billingNameController!.text = value!;
                              custId = peopleData.customers[ind].id;
                              cust = peopleData.customers[ind].data();
                            });
                          }
                        },
                        selectedItem: billingNameController!.text,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                width: 349,
                height: 55,
                // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(width: 1, color: Color(0xFFCCD8ED)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: TextFormField(
                  enabled: isEnabled,
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
                        balance = peopleData.customers[ind].data()['balance'];

                        custId = peopleData.customers[ind].id;
                        cust = peopleData.customers[ind].data();
                      });
                    }
                  },
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: FlutterFlowTheme.of(context).primaryColor,
                    //     width: 1,
                    //   ),
                    //   borderRadius: BorderRadius.circular(1),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: FlutterFlowTheme.of(context).primaryColor,
                    //     width: 1,
                    //   ),
                    //   borderRadius: BorderRadius.circular(1),
                    // ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyText1,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            // Divider(
            //   height: 10,
            //   thickness: 10,
            // ),
            Consumer<ItemAddBill>(
              builder: (context, items, child) => Column(
                children: List.generate(
                  items.items.length,
                  (index) => Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                      child: itemAddedCard(
                          isEdit: widget.isEdit!,
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
            widget.isEdit!
                ? Container()
                : Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleInvoiceItemAddWidget(
                                index: 0, isEdit: false, isSale: true),
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
            // Divider(
            //   height: 10,
            //   thickness: 10,
            // ),
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
                        '₹ ${itemData.grandPrice.toStringAsFixed(2)}',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child:Container(
                    width: 349,
                    height: 55,
                    // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        // side: BorderSide(width: 1, color: FlutterFlowTheme.of(context).primaryColor,),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: TextFormField(
                      controller: discountAmountController,
                      enabled: isEnabled,
                      //initialValue: '0',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        itemData.setGrandDiscount(
                            discount: double.parse(value.trim()));
                        setState(() {
                          paidController!.text = radioButtonValue1 ==
                              'Cash'
                              ? '${itemData.grandTotal.toStringAsFixed(2)}'
                              : '0.00';
                        });
                      },
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: ' Discount ',
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color:
                        //         FlutterFlowTheme.of(context).primaryColor,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(1),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color:
                        //         FlutterFlowTheme.of(context).primaryColor,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(1),
                        // ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
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
                  child: Container(
                    width: 349,
                    height: 55,
                    // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        // side: BorderSide(width: 1, color: FlutterFlowTheme.of(context).primaryColor,),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: TextFormField(
                      enabled: isEnabled,
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
                        labelText: 'Amount Paying',
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: FlutterFlowTheme.of(context).primaryColor,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(1),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: FlutterFlowTheme.of(context).primaryColor,
                        //     width: 1,
                        //   ),
                        //   borderRadius: BorderRadius.circular(1),
                        // ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            // Divider(
            //   height: 10,
            //   thickness: 10,
            // ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
              child: Text(
                'Payment mode',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
              child: FlutterFlowRadioButton(
                options: ['Cash', 'Credit'].toList(),
                initialValue: radioButtonValue1 ??= 'Cash',
                onChanged: (value) {
                  setState(() {
                    radioButtonValue1 = value;
                    paidController!.text = radioButtonValue1 == 'Cash'
                        ? '${itemData.grandTotal.toStringAsFixed(2)}'
                        : '0.00';
                  });
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
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
