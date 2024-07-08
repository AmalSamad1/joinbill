import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/expense_provider/expense_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/loadingStates.dart';
import '../../providers/authProvider.dart';

class ExpensesAddWidget extends StatefulWidget {
  final bool isDrawer;
  final bool? isEdit;
  final Map? data;
  final String? id;
  const ExpensesAddWidget(this.isDrawer,
      {Key? key, this.isEdit, this.data, this.id})
      : super(key: key);

  @override
  _ExpensesAddWidgetState createState() => _ExpensesAddWidgetState();
}

class _ExpensesAddWidgetState extends State<ExpensesAddWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? dropDownValue;
  DateTime? datePicked;
  TextEditingController? textController;
  TextEditingController?dateController;
  TextEditingController? descController;

  @override
  void initState() {
    super.initState();
    textController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: "${widget.data!['grand_total']}");
    descController = !widget.isEdit!
        ? TextEditingController()
        : TextEditingController(text: widget.data!['description']);
    dateController = !widget.isEdit!
        ? TextEditingController(
            text: DateFormat("yyyy/MM/dd").format(DateTime.now()))
        : TextEditingController(
            text:
                DateFormat("yyyy/MM/dd").format(widget.data!['date'].toDate()));
    setState(() {
      datePicked =
          widget.isEdit! ? widget.data!['date'].toDate() : DateTime.now();
      if (widget.isEdit!) {
        dropDownValue = widget.data!['type'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesData = Provider.of<ExpenseProvider>(context, listen: false);
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
                  Icons.close,
                  color:  FlutterFlowTheme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                 widget.isDrawer
                      ? Navigator.pop(context)
                      : context
                          .read<AuthProvider>()
                          .setCurrentPage(ExpenseListWidget(false));
                },
              ),
              title: Text(
                'Add Expense',
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
                if (widget.isEdit!) {
                  await salesData
                      .editExpense(
                          id: widget.id,
                          date: datePicked,
                          discription: descController!.text.trim(),
                          total: double.parse(textController!.text.trim()),
                          type: dropDownValue,
                          typeId: '1')
                      .then((value) {
                    salesData.fetchExpenses().then((value) => Navigator.pop(context));
                  });
                } else {
                  await salesData
                      .postExpense(
                          date: datePicked,
                          discription: descController!.text.trim(),
                          total: double.parse(textController!.text.trim()),
                          type: dropDownValue,
                          typeId: '1')
                      .then((value) {
                    salesData.fetchExpenses().then((value) => Navigator.pop(context));
                  });
                }
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              label: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                child: salesData.loadingState == LoadingStates.loading
                    ? circleLoading(context)
                    : Text(
                        widget.isEdit! ? 'Edit' : 'Save',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryBtnText,
                            ),
                      ),
              ),
            ),
            body: SafeArea(
              child: _expensesAddMain(),
            ),
          )
        : _expensesAddMain();
  }

  Widget _expensesAddMain() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.transparent,
                    offset: Offset(-2, 5),
                  )
                ],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primaryColor!,
                ),
              ),
              alignment: AlignmentDirectional(0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                    child: FlutterFlowDropDown(
                      initialOption: dropDownValue,
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
                      onChanged: (val) => setState(() => dropDownValue = val),
                      width: 180,
                      height: 50,
                      textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                      hintText: 'Expense Category',
                      fillColor: Colors.white,
                      elevation: 2,
                      borderColor: Colors.transparent,
                      borderWidth: 0,
                      borderRadius: 0,
                      margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                      hidesUnderline: true,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
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
                  //           FlutterFlowTheme.of(context).subtitle2.override(
                  //                 fontFamily: 'Lexend Deca',
                  //                 color: Colors.white,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.normal,
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: TextFormField(
              controller: textController,
              onChanged: (_) => EasyDebounce.debounce(
                'textController',
                Duration(milliseconds: 2000),
                () => setState(() {}),
              ),
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Total Amount',
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: TextFormField(
              controller: dateController,
              onTap: () async {
                await DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      datePicked = date;
                      dateController!.text = DateFormat("yyyy/MM/dd").format(date);
                    });
                  },
                  currentTime: getCurrentTimestamp,
                );
              },
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Date',
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: TextFormField(
              controller: descController,
              onChanged: (_) => EasyDebounce.debounce(
                'descController',
                Duration(milliseconds: 2000),
                () => setState(() {}),
              ),
              autofocus: true,
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
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
