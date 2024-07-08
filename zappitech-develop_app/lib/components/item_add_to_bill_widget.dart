import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/item_add_bill_provider.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';

import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/dashboard/drawerWidget.dart';

class SaleInvoiceItemAddWidget extends StatefulWidget {
  final bool isEdit;
  final int index;
  final bool isSale;

  const SaleInvoiceItemAddWidget(
      {Key? key, required this.isEdit, required this.index, this.isSale = true})
      : super(key: key);

  @override
  _SaleInvoiceItemAddWidgetState createState() =>
      _SaleInvoiceItemAddWidgetState();
}

class _SaleInvoiceItemAddWidgetState extends State<SaleInvoiceItemAddWidget> {
  String? unitSelect;
  String? id;
  TextEditingController? quantityController;
  TextEditingController? itemNameController;
  String? rateTaxSelect;
  TextEditingController? rateController;
  TextEditingController? percentController;
  TextEditingController? discountAmountController;
  String? gstSelect;
  double? stock;
  TextEditingController? taxAmountController;
  TextEditingController? totalAmountController;
  List<String> items = [];
  List<String> units = [''];
  int ind = -1;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final itemData = Provider.of<ItemProvider>(context, listen: false);

    itemData.fetchItems().then((value) {
      for (var i = 0; i < itemData.items!.length; i++) {
        items.add(
            '${itemData.items![i].data()['item_name']}/${itemData.items![i].data()['item_code_or_barcode']}');
      }
    });
    final data = Provider.of<ItemAddBill>(context, listen: false).items;
    print('object');
    itemNameController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: '${data[widget.index]["item_name"]}');
    quantityController = !widget.isEdit
        ? TextEditingController(text: '1')
        : TextEditingController(text: '${data[widget.index]["quantity"]}');
    rateController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: '${data[widget.index]["rate_per_unit"]}');
    percentController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(
            text: '${data[widget.index]["discount_percent"]}');
    discountAmountController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(
            text: '${data[widget.index]["discount_amount"]}');
    taxAmountController = !widget.isEdit
        ? TextEditingController(text: '0.0')
        : TextEditingController(text: '${data[widget.index]["gst_amount"]}');
    totalAmountController = !widget.isEdit
        ? TextEditingController()
        : TextEditingController(text: '${data[widget.index]["total"]}');
    if (widget.isEdit) {
      gstSelect = data[widget.index]["gst_type"];
      rateTaxSelect = data[widget.index]["tax_type"];
      unitSelect = data[widget.index]["unit"];
      id = data[widget.index]["id"];
    }
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#A3A3A3', "CANCEL", false, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      return barcodeScanRes = '';
    }

    if (barcodeScanRes != "-1") {
      return barcodeScanRes;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemProvider>(context).items;
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
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.isEdit ? 'Edit item' : 'Add item',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (widget.isEdit) {
            print(widget.isEdit);
            Provider.of<ItemAddBill>(context, listen: false).editItem(
                index: widget.index,
                id: id!,
                discountAmount: 0.0,
                discountPercent: 0.0,
                gstAmount: rateTaxSelect == 'Tax Included'
                    ? 0.0
                    : double.parse(taxAmountController!.text.trim()),
                hsn: itemData![ind].data()["hsn_or_sac_code"],
                gstType:
                    rateTaxSelect == 'Tax Included' ? 'Included' : gstSelect!,
                itemName: itemNameController!.text.trim(),
                quantity: double.parse(quantityController!.text.trim()),
                ratePerUnit: double.parse(rateController!.text.trim()),
                subTotal: double.parse(totalAmountController!.text.trim()),
                taxType: rateTaxSelect!,
                total: double.parse(totalAmountController!.text.trim()),
                unit: unitSelect!);
          } else {
            if (_formKey.currentState!.validate()) {
              print(widget.isEdit);
              Provider.of<ItemAddBill>(context, listen: false).addToItem(
                  id: id!,
                  discountAmount: 0.0,
                  discountPercent: 0.0,
                  gstAmount: rateTaxSelect == 'Tax Included'
                      ? 0.0
                      : double.parse(taxAmountController!.text.trim()),
                  gstType:
                      rateTaxSelect == 'Tax Included' ? 'Included' : gstSelect!,
                  itemName: itemNameController!.text.trim(),
                  hsn: itemData![ind].data()["hsn_or_sac_code"],
                  quantity: double.parse(quantityController!.text.trim()),
                  ratePerUnit: double.parse(rateController!.text.trim()),
                  subTotal: double.parse(totalAmountController!.text.trim()),
                  taxType: rateTaxSelect!,
                  total: double.parse(totalAmountController!.text.trim()),
                  prevStock: stock!,
                  unit: unitSelect!);
            }
          }
          Navigator.pop(context);
        },
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        elevation: 8,
        label: Text(
          widget.isEdit ? 'Edit' : '+ Add',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Poppins',
                color: FlutterFlowTheme.of(context).primaryBtnText,
              ),
        ),
      ),
      body: Consumer<ItemAddBill>(
        builder: (context, data, child) => Form(
          key: _formKey,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediaQuery.of(context).size.width < 660
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width < 1000
                              ? MediaQuery.of(context).size.width * 0.1
                              : MediaQuery.of(context).size.width * 0.2,
                          child: DrawerWidget(false)),
                  Container(
                    width: MediaQuery.of(context).size.width < 660
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          //mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 20, 16, 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      mode: Mode.DIALOG,
                                      dropdownBuilderSupportsNullItem: true,
                                      items: items,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Field can not be empty";
                                        }
                                        return null;
                                      },
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: 'Item Name',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        ind = itemData!.indexWhere((element) =>
                                            element.data()[
                                                'item_code_or_barcode'] ==
                                            value!.split('/')[1]);
                                        // for (var i = 0; i < data.items.length; i++) {
                                        //   if (data.items[i].data()['item_name'] == value) {
                                        //     ind = i;
                                        //     break;
                                        //   } else {
                                        //     continue;
                                        //   }
                                        // }
                                        print(itemData);
                                        print(ind);
                                        setState(() {
                                          stock = itemData[ind].data()["stock"];

                                          id = itemData[ind].id;

                                          itemNameController!.text = value!;
                                          rateController!.text = widget.isSale
                                              ? '${itemData[ind].data()['sale_price']}'
                                              : '${itemData[ind].data()['purchase_price']}';
                                          gstSelect =
                                              itemData[ind].data()['tax_type'];
                                          unitSelect = itemData[ind]
                                              .data()['primary_unit'];
                                          units = [
                                            "${itemData[ind].data()['primary_unit']}",
                                            "${itemData[ind].data()['secondary_unit']}"
                                          ];
                                          data.setSubTotal(
                                              quantity: double.parse(
                                                  quantityController!.text
                                                      .trim()),
                                              ratePerUnit: double.parse(
                                                  rateController!.text.trim()));

                                          data.setAmountFromGst(
                                              gstType: gstSelect!,
                                              subTotal: data.subTotal);
                                          data.setTotal(
                                              discount: data.discountAmount,
                                              subTotal: data.subTotal);

                                          taxAmountController!.text =
                                              '${data.gstAmount}';
                                          totalAmountController!.text =
                                              '${data.total}';
                                        });
                                      },
                                      selectedItem: itemNameController!.text,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String value = await scanBarcodeNormal();
                                      print("*****$value*******");
                                      ind = itemData!.indexWhere((element) =>
                                          element
                                              .data()['item_code_or_barcode'] ==
                                          value);
                                      // for (var i = 0; i < data.items.length; i++) {
                                      //   if (data.items[i].data()['item_name'] == value) {
                                      //     ind = i;
                                      //     break;
                                      //   } else {
                                      //     continue;
                                      //   }
                                      // }
                                      print("******item data $itemData");
                                      print(ind);
                                      if (ind != -1) {
                                        setState(() {
                                          stock = itemData[ind].data()["stock"];

                                          id = itemData[ind].id;

                                          itemNameController!.text =
                                              "${itemData[ind].data()['item_name']}/${itemData[ind].data()['item_code_or_barcode']}";
                                          rateController!.text = widget.isSale
                                              ? '${itemData[ind].data()['sale_price']}'
                                              : '${itemData[ind].data()['purchase_price']}';
                                          gstSelect =
                                              itemData[ind].data()['tax_type'];
                                          unitSelect = itemData[ind]
                                              .data()['primary_unit'];
                                          units = [
                                            "${itemData[ind].data()['primary_unit']}",
                                            "${itemData[ind].data()['secondary_unit']}"
                                          ];
                                          data.setSubTotal(
                                              quantity: double.parse(
                                                  quantityController!.text
                                                      .trim()),
                                              ratePerUnit: double.parse(
                                                  rateController!.text.trim()));

                                          data.setAmountFromGst(
                                              gstType: gstSelect!,
                                              subTotal: data.subTotal);
                                          data.setTotal(
                                              discount: data.discountAmount,
                                              subTotal: data.subTotal);

                                          taxAmountController!.text =
                                              '${data.gstAmount}';
                                          totalAmountController!.text =
                                              '${data.total}';
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "No Products Found!")));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 2),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.barcode,
                                        color: Color(0xFF757575),
                                        size: 22,
                                      ),
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 20, 16, 16),
                                    child: TextFormField(
                                      controller: quantityController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        if (widget.isSale &&
                                            int.parse(quantityController!.text
                                                    .trim()) >
                                                stock!) {
                                          return "quantiy can't be greater than stock";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (widget.isSale &&
                                            int.parse(quantityController!.text
                                                    .trim()) >
                                                stock!) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "quantiy can't be greater than stock : $stock")));
                                          setState(() {
                                            quantityController!.text = '1';
                                          });
                                        }
                                        setState(() {
                                          if (itemData![ind]
                                                  .data()['secondary_unit'] ==
                                              unitSelect) {
                                            rateController!.text = widget.isSale
                                                ? '${(itemData[ind].data()['sale_price'] / itemData[ind].data()["conversion"]).toStringAsFixed(2)}'
                                                : '${(itemData[ind].data()['purchase_price'] / itemData[ind].data()["conversion"]).toStringAsFixed(2)}';
                                          } else {
                                            rateController!.text = widget.isSale
                                                ? '${itemData[ind].data()['sale_price']}'
                                                : '${itemData[ind].data()['purchase_price']}';
                                          }
                                          data.setSubTotal(
                                              quantity: double.parse(
                                                  quantityController!.text
                                                      .trim()),
                                              ratePerUnit: double.parse(
                                                  rateController!.text.trim()));

                                          data.setAmountFromGst(
                                              gstType: gstSelect!,
                                              subTotal: data.subTotal);
                                          data.setTotal(
                                              discount: data.discountAmount,
                                              subTotal: data.subTotal);

                                          taxAmountController!.text =
                                              '${data.gstAmount}';
                                          totalAmountController!.text =
                                              '${data.total}';
                                        });
                                      },
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: FlutterFlowDropDown(
                                    initialOption: unitSelect,
                                    options: units,
                                    onChanged: (val) {
                                      setState(() {
                                        unitSelect = val;
                                        if (itemData![ind]
                                                .data()['secondary_unit'] ==
                                            unitSelect) {
                                          rateController!.text = widget.isSale
                                              ? '${(itemData[ind].data()['sale_price'] / itemData[ind].data()["conversion"]).toStringAsFixed(2)}'
                                              : '${(itemData[ind].data()['purchase_price'] / itemData[ind].data()["conversion"]).toStringAsFixed(2)}';
                                        } else {
                                          rateController!.text = widget.isSale
                                              ? '${itemData[ind].data()['sale_price']}'
                                              : '${itemData[ind].data()['purchase_price']}';
                                        }
                                        data.setSubTotal(
                                            quantity: double.parse(
                                                quantityController!.text.trim()),
                                            ratePerUnit: double.parse(
                                                rateController!.text.trim()));

                                        data.setAmountFromGst(
                                            gstType: gstSelect!,
                                            subTotal: data.subTotal);
                                        data.setTotal(
                                            discount: data.discountAmount,
                                            subTotal: data.subTotal);

                                        taxAmountController!.text =
                                            '${data.gstAmount}';
                                        totalAmountController!.text =
                                            '${data.total}';
                                      });
                                    },
                                    width: 180,
                                    height: 50,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                        ),
                                    hintText: 'Unit',
                                    fillColor: Colors.white,
                                    elevation: 2,
                                    borderColor: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                    borderWidth: 0,
                                    borderRadius: 8,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12, 4, 12, 4),
                                    hidesUnderline: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 20, 16, 16),
                                    child: TextFormField(
                                      controller: rateController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        data.setSubTotal(
                                            quantity: double.parse(
                                                quantityController!.text.trim()),
                                            ratePerUnit:
                                                double.parse(value.trim()));
                                        data.setTotal(
                                            discount: data.discountAmount,
                                            subTotal: data.subTotal);
                                        setState(() {
                                          totalAmountController!.text =
                                              '${data.total}';
                                        });
                                        EasyDebounce.debounce(
                                          'rateController',
                                          Duration(milliseconds: 2000),
                                          () => setState(() {}),
                                        );
                                      },
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Rate (price/unit)',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: FlutterFlowDropDown(
                                    initialOption: rateTaxSelect ??=
                                        'Tax Excluded',
                                    options: ['Tax Included', 'Tax Excluded']
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() => rateTaxSelect = val);
                                      if (val == 'Tax Included') {
                                        data.setAmountFromGst(
                                            gstType: 'None 0.0 %',
                                            subTotal: data.subTotal);
                                        data.setTotal(
                                            discount: data.discountAmount,
                                            subTotal: data.subTotal);
                                        setState(() {
                                          taxAmountController!.text = '0';
                                          totalAmountController!.text =
                                              '${data.total}';
                                          gstSelect = 'None 0.0 %';
                                        });
                                      }
                                    },
                                    width: 180,
                                    height: 50,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                        ),
                                    hintText: 'Tax',
                                    fillColor: Colors.white,
                                    elevation: 2,
                                    borderColor: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                    borderWidth: 0,
                                    borderRadius: 8,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12, 4, 12, 4),
                                    hidesUnderline: true,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                              thickness: 10,
                              color: Color(0x2A000000),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                              child: Text(
                                'Totals & Taxes',
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            ),
                            Divider(
                              indent: 16,
                              endIndent: 16,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 0),
                                  child: Text(
                                    'Subtotal (Rate x Qty)',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: Text(
                                    '₹ ${data.subTotal}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                            //       Padding(
                            //         padding:
                            //             EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                            //         child: Text(
                            //           'Discount',
                            //           style: FlutterFlowTheme.of(context)
                            //               .bodyText1
                            //               .override(
                            //                 fontFamily: 'Poppins',
                            //                 fontWeight: FontWeight.w300,
                            //               ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: Padding(
                            //           padding: EdgeInsetsDirectional.fromSTEB(
                            //               16, 20, 0, 16),
                            //           child: TextFormField(
                            //             controller: percentController,
                            //             //initialValue: '0',
                            //             validator: (value) {
                            //               if (value == null || value.isEmpty) {
                            //                 return 'Field cannot be empty';
                            //               }
                            //               return null;
                            //             },
                            //             onChanged: (value) {
                            //               data.setDiscountAmount(
                            //                   percent: double.parse(value.trim()));
                            //               data.setTotal(
                            //                   discount: data.discountAmount,
                            //                   subTotal: data.subTotal);
                            //               setState(() {
                            //                 discountAmountController.text =
                            //                     '${data.discountAmount}';
                            //                 totalAmountController.text =
                            //                     '${data.total}';
                            //               });

                            //               EasyDebounce.debounce(
                            //                 'percentController',
                            //                 Duration(milliseconds: 2000),
                            //                 () => setState(() {}),
                            //               );
                            //             },
                            //             autofocus: true,
                            //             obscureText: false,
                            //             decoration: InputDecoration(
                            //               labelText: 'percentage',
                            //               enabledBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                   color: FlutterFlowTheme.of(context)
                            //                       .primaryColor,
                            //                   width: 1,
                            //                 ),
                            //                 borderRadius: BorderRadius.circular(8),
                            //               ),
                            //               focusedBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                   color: FlutterFlowTheme.of(context)
                            //                       .primaryColor,
                            //                   width: 1,
                            //                 ),
                            //                 borderRadius: BorderRadius.circular(8),
                            //               ),
                            //             ),
                            //             style: FlutterFlowTheme.of(context).bodyText1,
                            //             textAlign: TextAlign.start,
                            //             keyboardType: TextInputType.number,
                            //           ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: Padding(
                            //           padding: EdgeInsetsDirectional.fromSTEB(
                            //               8, 20, 16, 16),
                            //           child: TextFormField(
                            //             controller: discountAmountController,
                            //             //initialValue: '0',
                            //             validator: (value) {
                            //               if (value == null || value.isEmpty) {
                            //                 return 'Field cannot be empty';
                            //               }
                            //               return null;
                            //             },
                            //             onChanged: (value) {
                            //               data.setDiscountPercent(
                            //                   amount: double.parse(value.trim()));
                            //               data.setTotal(
                            //                   discount: double.parse(value),
                            //                   subTotal: data.subTotal);
                            //               setState(() {
                            //                 percentController.text =
                            //                     '${data.discountPercent}';
                            //                 totalAmountController.text =
                            //                     '${data.total}';
                            //               });
                            //               EasyDebounce.debounce(
                            //                 'discountAmountController',
                            //                 Duration(milliseconds: 2000),
                            //                 () => setState(() {}),
                            //               );
                            //             },
                            //             autofocus: true,
                            //             obscureText: false,
                            //             decoration: InputDecoration(
                            //               labelText: 'Amount',
                            //               enabledBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                   color: FlutterFlowTheme.of(context)
                            //                       .primaryColor,
                            //                   width: 1,
                            //                 ),
                            //                 borderRadius: BorderRadius.circular(8),
                            //               ),
                            //               focusedBorder: OutlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                   color: FlutterFlowTheme.of(context)
                            //                       .primaryColor,
                            //                   width: 1,
                            //                 ),
                            //                 borderRadius: BorderRadius.circular(8),
                            //               ),
                            //             ),
                            //             style: FlutterFlowTheme.of(context).bodyText1,
                            //             textAlign: TextAlign.start,
                            //             keyboardType: TextInputType.number,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            rateTaxSelect == 'Tax Included'
                                ? Container()
                                : Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 0),
                                        child: Text(
                                          'Tax %',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 0),
                                        child: FlutterFlowDropDown(
                                          initialOption: gstSelect,
                                          options: [
                                            'None 0.0 %',
                                            'Exempted 0.0 %',
                                            "GST@0% 0.0 %",
                                            'IGST@0% 0.0 %',
                                            'GST@0.25% 0.25 %',
                                            'IGST@0.25% 0.25 %',
                                            'GST@3.0% 3.0 %',
                                            'IGST@3.0% 3.0 %',
                                            'GST@5.0% 5.0 %',
                                            'IGST@5.0% 5.0 %',
                                            'GST@12.0% 12.0 %',
                                            'IGST@12.0% 12.0 %',
                                            'GST@18.0% 18.0 %',
                                            'IGST@12.0% 12.0 %',
                                            'GST@18.0% 18.0 %',
                                            'IGST@18.0% 18.0 %',
                                            'GST@28.0% 28.0 %',
                                            'IGST@28.0% 28.0 %',
                                          ].toList(),
                                          onChanged: (val) {
                                            data.setAmountFromGst(
                                                gstType: val,
                                                subTotal: data.subTotal);
                                            data.setTotal(
                                                discount: data.discountAmount,
                                                subTotal: data.subTotal);
                                            setState(() {
                                              taxAmountController!.text =
                                                  '${data.gstAmount}';
                                              totalAmountController!.text =
                                                  '${data.total}';
                                              gstSelect = val;
                                            });
                                          },
                                          width: 180,
                                          height: 50,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                          hintText: 'GST',
                                          fillColor: Colors.white,
                                          elevation: 2,
                                          borderColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryColor,
                                          borderWidth: 0,
                                          borderRadius: 8,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 4, 12, 4),
                                          hidesUnderline: true,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 20, 16, 16),
                                          child: TextFormField(
                                            controller: taxAmountController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              'taxAmountController',
                                              Duration(milliseconds: 2000),
                                              () => setState(() {}),
                                            ),
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Amount',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor!,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor!,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 0),
                                  child: Text(
                                    'Total Amount(₹)',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 20, 16, 16),
                                    child: TextFormField(
                                      controller: totalAmountController,
                                      //initialValue: "0",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) => EasyDebounce.debounce(
                                        'totalAmountController',
                                        Duration(milliseconds: 2000),
                                        () => setState(() {}),
                                      ),
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
