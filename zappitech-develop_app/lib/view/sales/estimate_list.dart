import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/sales_providers/estimate_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../providers/authProvider.dart';

class EstimateList extends StatefulWidget {
  final bool isDrawer;
  const EstimateList(this.isDrawer, {Key? key}) : super(key: key);

  @override
  _EstimateListState createState() => _EstimateListState();
}

class _EstimateListState extends State<EstimateList> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<EstimateProvider>(context, listen: false)
            .fetchSalesInvoice(),
        builder: (context, snapShot) {
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
                                .setCurrentPage(SalesListWidget(false));
                      },
                    ),
                    title: Text(
                      'Sales Estimates',
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
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () async {
                      widget.isDrawer
                          ? await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalesEstimateAddWidget(
                                  true,
                                  data: {},
                                  id: '',
                                  isEdit: false,
                                ),
                              ),
                            )
                          : context
                              .read<AuthProvider>()
                              .setCurrentPage(SalesEstimateAddWidget(
                                false,
                                data: {},
                                id: '',
                                isEdit: false,
                              ));
                    },
                    backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                    elevation: 8,
                    label: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Text(
                        '+ Add',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                            ),
                      ),
                    ),
                  ),
                  body: snapShot.connectionState == ConnectionState.waiting
                      ? circleLoading(context)
                      : snapShot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: Text("Something went wrong"),
                            )
                          : _estimateListMain())
              : _estimateListMain();
        });
  }

  Widget _estimateListMain() {
    return Consumer<EstimateProvider>(
      builder: (context, salesData, child) => SingleChildScrollView(
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
                      color: Color(0x35000000),
                      offset: Offset(-2, 5),
                    )
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: AlignmentDirectional(0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: TextFormField(
                          controller: textController,
                          obscureText: false,
                          onChanged: (value) {
                            salesData.searchItems(value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Search estimates',
                            labelStyle:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF262D34),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Search',
                        options: FFButtonOptions(
                          width: 100,
                          height: 40,
                          color: Color(0xFF4B39EF),
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
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
                          borderRadius: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                  child: Text(
                    'Total Sales',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
                  child: Text(
                    '₹ ${salesData.salesInvoice == null ? 0.00 : salesData.saleTotal.toStringAsFixed(2)}',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Color(0xFF4DC412),
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
            ),
            salesData.salesInvoice == null
                ? Center(
                    child: Text("no estimates added yet!"),
                  )
                : salesData.searchInvoices.isEmpty
                    ? Center(
                        child: Text("no estimates mathces your search!"),
                      )
                    : Column(
                        children: List.generate(
                          salesData.searchInvoices.length,
                          (index) => Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
                            child: GestureDetector(
                              onTap: () async {
                                widget.isDrawer
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SalesEstimateAddWidget(true,
                                                  data: salesData
                                                      .searchInvoices[index]
                                                      .data(),
                                                  isEdit: true,
                                                  id: salesData
                                                      .searchInvoices[index]
                                                      .id),
                                        ),
                                      )
                                    : context
                                        .read<AuthProvider>()
                                        .setCurrentPage(SalesEstimateAddWidget(
                                            false,
                                            data: salesData
                                                .searchInvoices[index]
                                                .data(),
                                            isEdit: true,
                                            id: salesData
                                                .searchInvoices[index].id));
                              },
                              child: Column(
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
                                                Text( salesData.searchInvoices[index]
                                                    .data()["customer"],
                                                  textAlign: TextAlign.center,
                                                  style: new TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700
                                                  ),),),

                                              ],
                                            ),
                                            Divider(thickness: 1,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Align( alignment: Alignment.topCenter, child:
                                                Text("Total Amount",
                                                    style: new TextStyle(
                                                      fontWeight: FontWeight.w500,) ),),
                                                Text("₹ ${salesData.searchInvoices[index].data()["grand_total"].toStringAsFixed(2)}",
                                                    style: new TextStyle(
                                                      color: Colors.red.shade900,
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
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
