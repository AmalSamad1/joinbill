import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';
import 'package:ziptech/view/dashboard/ledger_list.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../providers/authProvider.dart';
import '../../providers/people_provider/people_provider.dart';

class ItemLedger extends StatefulWidget {
  final bool isDrawer;
  const ItemLedger(this.isDrawer, {Key? key}) : super(key: key);

  @override
  State<ItemLedger> createState() => _ItemLedgerState();
}

class _ItemLedgerState extends State<ItemLedger> {
  TextEditingController billingNameController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  DateTime? from;
  DateTime? to;
  List<String> custItems = [];
  String? custId;
  Map cust = {};
  @override
  void initState() {
    super.initState();

    final itemData = Provider.of<ItemProvider>(context, listen: false);
    itemData.setParticular();
    itemData.fetchItems().then((value) {
      for (var i = 0; i < itemData.items!.length; i++) {
        custItems.add(
            '${itemData.items![i].data()['item_code_or_barcode']}/${itemData.items![i].data()['item_name']}');
      }
    });
    print("hrkfkdsf");
  }

  @override
  void dispose() {
    super.dispose();
    billingNameController.clear();
    fromController.clear();
    toController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDrawer
        ? Scaffold(
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
                  widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(LedgerList(false));
                },
              ),
              title: Text(
                'Item Ledger',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryColor,
                      fontSize: 22,
                    ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(child: _itemLedgerMain(context)))
        : _itemLedgerMain(context);
  }

  Widget _itemLedgerMain(BuildContext context) {
    final peopleData = Provider.of<ItemProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 10),
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
                labelText: 'Customer',
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
                int ind = peopleData.items!.indexWhere((element) =>
                    element.data()['item_code_or_barcode'] ==
                    value!.split('/')[0]);
                // for (var i = 0; i < data.items.length; i++) {
                //   if (data.items[i].data()['item_name'] == value) {
                //     ind = i;
                //     break;
                //   } else {
                //     continue;
                //   }
                // }

                print(ind);

                setState(() {
                  billingNameController.text = value!;
                  custId = peopleData.items![ind].id;
                  cust = peopleData.items![ind].data();
                });
              },
              selectedItem: billingNameController.text,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                  child: TextFormField(
                    controller: fromController,
                    onTap: () async {
                      await DatePicker.showDatePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          from = date;
                          fromController.text =
                              DateFormat("dd/MM/yyyy").format(date);
                        });
                      },
                          currentTime: getCurrentTimestamp,
                          maxTime: DateTime.now());
                    },
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'From',
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
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                  child: TextFormField(
                    controller: toController,
                    onTap: () async {
                      await DatePicker.showDatePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          to = date;
                          toController.text =
                              DateFormat("dd/MM/yyyy").format(date);
                        });
                      },
                          currentTime: getCurrentTimestamp,
                          maxTime: DateTime.now());
                    },
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'To',
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    Provider.of<ItemProvider>(context, listen: false)
                        .fetchLedger(itemId: custId, from: from, to: to);
                  },
                  text: 'Get Data',
                  options: FFButtonOptions(
                    width: 100,
                    height: 40,
                    color: Color(0xFF4B39EF),
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                    elevation: 2,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 12,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 10,
          ),
          Center(
              child: peopleData.particulars.isEmpty
                  ? Container()
                  : Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Table(
                          //defaultColumnWidth: FixedColumnWidth(120.0),

                          border: TableBorder.all(
                              color: Colors.black54,
                              //style: BorderStyle.solid,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              width: 1),
                          children: [
                            TableRow(
                                //decoration: Decoration,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('Date',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('Particular',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('Remarks',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('In',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('Out',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(children: [
                                      Text('Stock',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(DateFormat("dd/MM/yyyy").format(from!),
                                        style: TextStyle(fontSize: 12.0))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Text("Opening stock",
                                      style: TextStyle(fontSize: 12.0))
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Text('', style: TextStyle(fontSize: 12.0))
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Text("", style: TextStyle(fontSize: 12.0))
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Text("", style: TextStyle(fontSize: 12.0))
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Text(
                                      '${peopleData.particulars[0][1]["prev_stock"].toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 12.0))
                                ]),
                              ),
                            ]),
                            ...List.generate(
                              peopleData.particulars.length,
                              (index) => TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              peopleData.particulars[index][0]
                                                      ["date"]
                                                  .toDate()),
                                          style: TextStyle(fontSize: 12.0))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                        peopleData.particulars[index][0]
                                            ["type"],
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text('', style: TextStyle(fontSize: 12.0))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                        peopleData.particulars[index][0]
                                                        ["type"] ==
                                                    "sale return" ||
                                                peopleData.particulars[index][0]
                                                        ["type"] ==
                                                    "sale invoice"
                                            ? ''
                                            : "${peopleData.particulars[index][1]["quantity"].toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                        peopleData.particulars[index][0]
                                                        ["type"] !=
                                                    "sale return" &&
                                                peopleData.particulars[index][0]
                                                        ["type"] !=
                                                    "sale invoice"
                                            ? ''
                                            : "${peopleData.particulars[index][1]["quantity"].toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                        peopleData.particulars[index][0]
                                                        ["type"] !=
                                                    "sale return" &&
                                                peopleData.particulars[index][0]
                                                        ["type"] !=
                                                    "sale invoice"
                                            ? '${(peopleData.particulars[index][1]["prev_stock"] + peopleData.particulars[index][1]["quantity"]).toStringAsFixed(2)}'
                                            : '${(peopleData.particulars[index][1]["prev_stock"] - peopleData.particulars[index][1]["quantity"]).toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ]))
        ],
      ),
    );
  }
}
