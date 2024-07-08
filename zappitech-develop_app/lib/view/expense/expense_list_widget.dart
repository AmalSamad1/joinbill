import 'package:provider/provider.dart';
import 'package:ziptech/providers/expense_provider/expense_provider.dart';

import '../../components/circleLoading.dart';
import '../../providers/authProvider.dart';
import '../dashboard/dashboard_widget_main.dart';
import 'expenses_add_widget.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseListWidget extends StatefulWidget {
  final bool isDrawer;
  const ExpenseListWidget(this.isDrawer, {Key? key}) : super(key: key);

  @override
  _ExpenseListWidgetState createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
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
                  Icons.arrow_back,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(DashboardWidgetMain(false));
                },
              ),
              title: Text(
                'Expenses',
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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                widget.isDrawer
                    ? await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpensesAddWidget(
                            true,
                            data: {},
                            id: '',
                            isEdit: false,
                          ),
                        ),
                      )
                    : context
                        .read<AuthProvider>()
                        .setCurrentPage(
                    ExpensesAddWidget(
                          false,
                          data: {},
                          id: '',
                          isEdit: false,
                        )
                );
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                child: Text(
                  '+ Add',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                      ),
                ),
              ),
            ),
            body: SafeArea(child: _expenseListMain(context)),
          )
        : _expenseListMain(context);
  }

  Widget _expenseListMain(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ExpenseProvider>(context, listen: false)
            .fetchExpenses(),
        builder: (context, snapShot) {
          return snapShot.connectionState == ConnectionState.waiting
              ? circleLoading(context)
              : snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Text("Something went wrong"),
                    )
                  : SingleChildScrollView(
                      child: Consumer<ExpenseProvider>(
                        builder: (context, salesData, child) => Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Color(0x35000000),
                                      offset: Offset(-2, 5),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: AlignmentDirectional(0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 0),
                                      child: FlutterFlowDropDown(
                                        initialOption: dropDownValue ??=
                                            'All Expenses',
                                        options: [
                                          'All Expenses',
                                          'Fuel',
                                          'Food',
                                          'Salary',
                                          'Grocery',
                                          'Business Expenses',
                                          'Maintanance',
                                          'Bills',
                                          "Travel",
                                          'Recreation',
                                          'Others'
                                        ].toList(),
                                        onChanged: (val) {
                                          // setState(
                                          //     () => dropDownValue = val);
                                          salesData.searchItems(val);
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
                                        hintText: 'type',
                                        fillColor: Colors.white,
                                        elevation: 2,
                                        borderColor: Colors.transparent,
                                        borderWidth: 0,
                                        borderRadius: 0,
                                        margin:
                                            EdgeInsetsDirectional.fromSTEB(
                                                12, 4, 12, 4),
                                        hidesUnderline: true,
                                      ),
                                    ),
                                    // Padding(
                                    //   padding:
                                    //       EdgeInsetsDirectional.fromSTEB(
                                    //           0, 0, 8, 0),
                                    //   child: FFButtonWidget(
                                    //     onPressed: () {
                                    //       print('Button pressed ...');
                                    //     },
                                    //     text: 'Add type',
                                    //     options: FFButtonOptions(
                                    //       width: 100,
                                    //       height: 40,
                                    //       color: Color(0xFF4B39EF),
                                    //       textStyle:
                                    //           FlutterFlowTheme.of(context)
                                    //               .subtitle2
                                    //               .override(
                                    //                 fontFamily:
                                    //                     'Lexend Deca',
                                    //                 color: Colors.white,
                                    //                 fontSize: 16,
                                    //                 fontWeight:
                                    //                     FontWeight.normal,
                                    //               ),
                                    //       elevation: 2,
                                    //       borderSide: BorderSide(
                                    //         color: Colors.transparent,
                                    //         width: 1,
                                    //       ),
                                    //       borderRadius: 50,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 16, 0, 0),
                                  child: Text(
                                    'Total Expenses',
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
                                      0, 16, 16, 0),
                                  child: Text(
                                    '₹ ${salesData.expenseTotal.toStringAsFixed(2)}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFE4300D),
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            salesData.expenses == null
                                ? Center(
                                    child: Text("no expenses added yet!"),
                                  )
                                : salesData.searchExpenses.isEmpty
                                    ? Center(
                                        child: Text(
                                            "no expense mathces your search!"),
                                      )
                                    : Column(
                                        children: List.generate(
                                        salesData.searchExpenses.length,
                                        (index) => Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(8, 10, 8, 0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              widget.isDrawer
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExpensesAddWidget(
                                                                true,
                                                                data: salesData
                                                                    .searchExpenses[
                                                                        index]
                                                                    .data(),
                                                                isEdit:
                                                                    true,
                                                                id: salesData
                                                                    .searchExpenses[
                                                                        index]
                                                                    .id),
                                                      ),
                                                    )
                                                  : context
                                                      .read<AuthProvider>()
                                                      .setCurrentPage(
                                                          ExpensesAddWidget(
                                                              false,
                                                              data: salesData
                                                                  .searchExpenses[
                                                                      index]
                                                                  .data(),
                                                              isEdit: true,
                                                              id: salesData
                                                                  .searchExpenses[
                                                                      index]
                                                                  .id));
                                            },
                                            child:
                                            Column(
                                                children:[
                                                  Container(
                                                    decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(width: 1, color: Color(0xFFCCD8ED)),
                                                        borderRadius: BorderRadius.circular(13.0),
                                                      ),),
                                                    // elevation: 5.0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Align( alignment: Alignment.topCenter, child:
                                                              Text("${salesData.searchExpenses[index].data()['type']}",
                                                                textAlign: TextAlign.center,
                                                                style: new TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w700
                                                                ),),),

                                                              // Text("",
                                                              //   textAlign: TextAlign.center,
                                                              //   style: new TextStyle(
                                                              //     fontWeight: FontWeight.w500,
                                                              //
                                                              //   ),),
                                                            ],
                                                          ),
                                                          Divider(thickness: 1,),

                                                          SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Align( alignment: Alignment.topCenter, child:
                                                              Text("Date",
                                                                  style: new TextStyle(
                                                                    fontWeight: FontWeight.w500,) ),),
                                                              Text("₹${DateFormat("yyyy/MM/dd").format(salesData.searchExpenses[index].data()['date'].toDate())}",
                                                                  style: new TextStyle(
                                                                    fontWeight: FontWeight.w500,)  ),

                                                            ],
                                                          ),
                                                          Divider(thickness: 1),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Align( alignment: Alignment.topCenter, child:
                                                              Text("Total Amount",
                                                                  style: new TextStyle(
                                                                    fontWeight: FontWeight.w500,) ),),
                                                              Text("₹ ${salesData.searchExpenses[index].data()['grand_total'].toStringAsFixed(2)}",
                                                                  style: new TextStyle(
                                                                    color:Colors.red.shade900,
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w700,) ),

                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),


                                                ]
                                            ),

                                          ),
                                        ),
                                      )),
                          ],
                        ),
                      ),
                    );
        });
  }
}
