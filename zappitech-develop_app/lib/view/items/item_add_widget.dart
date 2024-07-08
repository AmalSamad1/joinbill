import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_radio_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';
import '../../providers/sales_providers/sales_invoice_provider.dart';

class ItemAddWidget extends StatefulWidget {
  final bool? isDrawer;
  final bool? isEdit;
  final Map ?data;
  final String? id;
  const ItemAddWidget(this.isDrawer, {Key? key, this.isEdit, this.data, this.id})
      : super(key: key);

  @override
  _ItemAddWidgetState createState() => _ItemAddWidgetState();
}

class _ItemAddWidgetState extends State<ItemAddWidget> {
  bool? isSwitched = false;
  DateTime? datePicked;
  TextEditingController? dateController;
  TextEditingController? oprningStockController;
  String? saleTaxType;
  TextEditingController? salePriceController;
  String? radioButtonValue1;

  TextEditingController? itemNameController;
  TextEditingController? itemCodeController;
  TextEditingController? codeController;
  String? purchaseTaxtype;
  TextEditingController? purchasePriceController;
  TextEditingController? mrpController;
  TextEditingController? minStockController;
  TextEditingController? conversionController;
  String? gstType;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    final data = Provider.of<ItemProvider>(context, listen: false).items;
    itemNameController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['item_name']);
    itemCodeController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['item_code_or_barcode']);
    codeController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['hsn_or_sac_code']);
    salePriceController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['sale_price']}');
    purchasePriceController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['purchase_price']}');
    oprningStockController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['opening_stock']}');
    mrpController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: '${widget.data!['mrp']}');
    minStockController = !widget.isEdit!
        ? TextEditingController(text: '0')
        : TextEditingController(text: '${widget.data!['minimum_stock']}');
    conversionController = !widget.isEdit!
        ? TextEditingController(text: '0')
        : TextEditingController(text: '${widget.data!['conversion']}');
    dateController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(
            text:
                DateFormat("yyyy/MM/dd").format(widget.data!['date'].toDate()));
    setState(() {
      datePicked = !widget.isEdit! ? null : widget.data!['date'].toDate();
      saleTaxType = !widget.isEdit! ? null : widget.data!['primary_unit'];
      purchaseTaxtype = !widget.isEdit! ? null : widget.data!['secondary_unit'];
      radioButtonValue1 =
          !widget.isEdit! ? 'Product' : widget.data!['item_category'];
      gstType = !widget.isEdit! ? null : widget.data!['tax_type'];
    });
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
    final itemData = Provider.of<ItemProvider>(context);
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
                          .setCurrentPage(ItemsListWidget(false));
                },
              ),
              title: Text(
                widget.isEdit! ? widget.data!["item_name"] : 'Add Item',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [
                widget.isEdit!
                    ? itemData.loadingState == LoadingStates.loading
                        ? circleLoading(context, clr: FlutterFlowTheme.of(context).primaryColor)
                        : IconButton(
                            onPressed: () async {
                              await itemData
                                  .deleteItems(
                                id: widget.id,
                              )
                                  .then((value) {
                                itemData.fetchItems().then((value) =>
                                    widget.isDrawer!
                                        ? Navigator.pop(context)
                                        : context
                                            .read<AuthProvider>()
                                            .setCurrentPage(
                                                ItemsListWidget(false)));
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ))
                    : Container(),
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
                      .editItems(
                          id: widget.id,
                          date: radioButtonValue1 == "Service"
                              ? DateTime.now()
                              : datePicked,
                          mrp: double.parse(mrpController!.text.trim()),
                          hsnCode: codeController!.text.trim(),
                          itemCategory: radioButtonValue1,
                          itemCode: itemCodeController!.text.trim(),
                          itemName: itemNameController!.text.trim(),
                          purchasePrice: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(
                                  purchasePriceController!.text.trim()),
                          purchaseUnit: radioButtonValue1 == "Service"
                              ? ''
                              : purchaseTaxtype,
                          minStock: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(minStockController!.text.trim()),
                          salePrice: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(salePriceController!.text.trim()),
                          saleUnit: saleTaxType,
                          conversion:
                              double.parse(conversionController!.text.trim()),
                          stock: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(
                                  oprningStockController!.text.trim()),
                          tax: gstType == 'None 0.0 %' ||
                                  gstType == 'Tax Included' ||
                                  gstType == 'Exempted 0.0 %'
                              ? 0.0
                              : double.parse(gstType!.split('%')[1].trim()),
                          taxType: gstType)
                      .then((value) {
                    itemData.fetchItems().then((value) => widget.isDrawer!
                        ? Navigator.pop(context)
                        : context
                            .read<AuthProvider>()
                            .setCurrentPage(ItemsListWidget(false)));
                  });
                } else {
                  await itemData
                      .postItems(
                          date: radioButtonValue1 == "Service"
                              ? DateTime.now()
                              : datePicked,
                          hsnCode: codeController!.text.trim(),
                          mrp: double.parse(mrpController!.text.trim()),
                          itemCategory: radioButtonValue1,
                          itemCode: itemCodeController!.text.trim(),
                          itemName: itemNameController!.text.trim(),
                          purchasePrice: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(
                                  purchasePriceController!.text.trim()),
                          purchaseUnit: radioButtonValue1 == "Service"
                              ? ''
                              : purchaseTaxtype,
                          minStock: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(minStockController!.text.trim()),
                          salePrice: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(salePriceController!.text.trim()),
                          saleUnit: saleTaxType,
                          conversion:
                              double.parse(conversionController!.text.trim()),
                          stock: radioButtonValue1 == "Service"
                              ? 0.0
                              : double.parse(
                                  oprningStockController!.text.trim()),
                          tax: gstType == 'None 0.0 %' ||
                                  gstType == 'Tax Included' ||
                                  gstType == 'Exempted 0.0 %'
                              ? 0.0
                              : double.parse(gstType!.split('%')[1].trim()),
                          taxType: gstType)
                      .then((value) {
                    if (itemData.loadingState == LoadingStates.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(itemData.message)));
                    } else {
                      itemData.fetchItems().then((value) => widget.isDrawer!
                          ? Navigator.pop(context)
                          : context
                              .read<AuthProvider>()
                              .setCurrentPage(ItemsListWidget(false)));
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
            body: SafeArea(child: _itemAddMain()))
        : _itemAddMain();
  }

  Widget _itemAddMain() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                  child: FlutterFlowRadioButton(
                    options: ['Product', 'Service'].toList(),
                    initialValue: radioButtonValue1 ??= 'Product',
                    onChanged: (value) {
                      setState(() => radioButtonValue1 = value);
                    },
                    optionHeight: 25,
                    textStyle:
                        FlutterFlowTheme.of(context).bodyText1.override(
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

            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
              child: TextFormField(
                controller: itemNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field can not be empty";
                  }
                  return null;
                },
                onChanged: (_) => EasyDebounce.debounce(
                  'itemNameController',
                  Duration(milliseconds: 2000),
                  () => setState(() {}),
                ),
                //autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Item Name',
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
                controller: itemCodeController,
                onChanged: (_) => EasyDebounce.debounce(
                  'itemCodeController',
                  Duration(milliseconds: 2000),
                  () => setState(() {}),
                ),
                // autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Item Code / Barcode',
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
                  suffixIcon: TextButton(
                    onPressed: () async {
                      itemCodeController!.text = await scanBarcodeNormal();
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFF757575), width: 2),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.barcode,
                        color: Color(0xFF757575),
                        size: 22,
                      ),
                    ),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyText1,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
              child: TextFormField(
                controller: codeController,
                onChanged: (_) => EasyDebounce.debounce(
                  'codeController',
                  Duration(milliseconds: 2000),
                  () => setState(() {}),
                ),
                //autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'HSN / SAC Code',
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

            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 16),
                  child: FlutterFlowDropDown(
                    initialOption: saleTaxType,
                    options:
                        // radioButtonValue1 == "Service"
                        //     ? ['Number', 'Hour', 'Day', 'Month'].toList()
                        //   :
                        [
                      "BAGS(Bag)",
                      "BOTTLES(Btl)",
                      "BOX(Box)",
                      "BUNDLE(Bdl)",
                      "CANS(Can)",
                      "CARTONS(Ctn)",
                      "DOZENS(Dzn)",
                      "GRAMMES(Gm)",
                      "KILOGRAMS(Kg)",
                      "LITRE(Ltr)",
                      "METERS(Mtr)",
                      "MILILITRE(Ml)",
                      "NUMBERS(Nos)",
                      "PACKS(Pac)",
                      "PAIRS(Prs)",
                      "PIECES(Pcs)",
                      "QUINTAL(Qtl)",
                      "ROLLS(Rol)",
                      "SQUARE FEET(Sqf)",
                      "TABLETS(Tbs)"
                    ].toList(),
                    onChanged: (val) => setState(() => saleTaxType = val),
                    width: 180,
                    height: 50,
                    textStyle:
                        FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                    hintText: 'Primary Unit',
                    fillColor: Colors.white,
                    elevation: 2,
                    borderColor: FlutterFlowTheme.of(context).primaryColor,
                    borderWidth: 0,
                    borderRadius: 8,
                    margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                    hidesUnderline: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 16),
                  child: FlutterFlowDropDown(
                    initialOption: purchaseTaxtype,
                    options: [
                      "BAGS(Bag)",
                      "BOTTLES(Btl)",
                      "BOX(Box)",
                      "BUNDLE(Bdl)",
                      "CANS(Can)",
                      "CARTONS(Ctn)",
                      "DOZENS(Dzn)",
                      "GRAMMES(Gm)",
                      "KILOGRAMS(Kg)",
                      "LITRE(Ltr)",
                      "METERS(Mtr)",
                      "MILILITRE(Ml)",
                      "NUMBERS(Nos)",
                      "PACKS(Pac)",
                      "PAIRS(Prs)",
                      "PIECES(Pcs)",
                      "QUINTAL(Qtl)",
                      "ROLLS(Rol)",
                      "SQUARE FEET(Sqf)",
                      "TABLETS(Tbs)"
                    ].toList(),
                    onChanged: (val) =>
                        setState(() => purchaseTaxtype = val),
                    width: 180,
                    height: 50,
                    textStyle:
                        FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                    hintText: 'Secondary Unit',
                    fillColor: Colors.white,
                    elevation: 2,
                    borderColor: FlutterFlowTheme.of(context).primaryColor,
                    borderWidth: 0,
                    borderRadius: 8,
                    margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                    hidesUnderline: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "1 ${saleTaxType == null ? "Primary Unit" : saleTaxType} = "),
                  Expanded(
                    child: TextFormField(
                      controller: conversionController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Text(
                      "${purchaseTaxtype == null ? "Secondary Unit" : purchaseTaxtype}")
                ],
              ),
            ),
            radioButtonValue1 == "Service"
                ? Container()
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16, 20, 16, 16),
                          child: TextFormField(
                            controller: salePriceController,
                            onChanged: (_) => EasyDebounce.debounce(
                              'salePriceController',
                              Duration(milliseconds: 2000),
                              () => setState(() {}),
                            ),
                            // autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Sale Price',
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16, 20, 16, 16),
                          child: TextFormField(
                            controller: purchasePriceController,
                            onChanged: (_) => EasyDebounce.debounce(
                              'purchasePriceController',
                              Duration(milliseconds: 2000),
                              () => setState(() {}),
                            ),
                            // autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Purchase Price',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
              child: FlutterFlowDropDown(
                initialOption: gstType ??= "None 0.0 %",
                options: [
                  'None 0.0 %',
                  'Tax Included',
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
                onChanged: (val) => setState(() => gstType = val),
                width: 180,
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
            //             Padding(
            //               padding: EdgeInsetsDirectional.fromSTEB(
            //                               16, 20, 16, 16),
            //               child: Row(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children:[
            //      Text('Add Size', style: TextStyle(fontSize: 14),) ,
            //      SizedBox(width: 8,),
            //      Transform.scale(
            //       scale: 1,
            //       child: Switch(
            //         onChanged: (value){

            // setState(() {
            //   isSwitched = value;

            // });
            // print('Switch Button is ON');

            //         },
            //         value: isSwitched,
            //         activeColor: FlutterFlowTheme.of(context).primaryColor,
            //         activeTrackColor: FlutterFlowTheme.of(context).secondaryColor,
            //         inactiveThumbColor: Colors.grey[700],
            //         inactiveTrackColor: Colors.grey[300],
            //       )
            //     ),

            //   ]),
            //             ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
              child: TextFormField(
                controller: mrpController,
                onChanged: (_) => EasyDebounce.debounce(
                  'mrpController',
                  Duration(milliseconds: 2000),
                  () => setState(() {}),
                ),
                //autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'MRP',
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
            radioButtonValue1 == "Service"
                ? Container()
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 16),
                          child: TextFormField(
                            controller: oprningStockController,
                            onChanged: (_) => EasyDebounce.debounce(
                              'oprningStockController',
                              Duration(milliseconds: 2000),
                              () => setState(() {}),
                            ),
                            // autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Opening Stock',
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 16),
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
                                        DateFormat("yyyy/MM/dd")
                                            .format(date);
                                  });
                                },
                                currentTime: getCurrentTimestamp,
                              );
                            },
                            // autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'As of Date',
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
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ),
                    ],
                  ),
            radioButtonValue1 == "Service"
                ? Container()
                : Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                    child: TextFormField(
                      controller: minStockController,
                      onChanged: (_) => EasyDebounce.debounce(
                        'minStockController',
                        Duration(milliseconds: 2000),
                        () => setState(() {}),
                      ),
                      //autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Minimum Stock',
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
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
