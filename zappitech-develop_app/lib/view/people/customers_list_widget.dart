import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';
import 'package:ziptech/providers/people_provider/people_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/authProvider.dart';
import '../dashboard/dashboard_widget_main.dart';
import '../dashboard/drawerWidget.dart';

class PeopleListWidget extends StatefulWidget {
  final bool isDrawer;
  const PeopleListWidget(this.isDrawer, {Key? key}) : super(key: key);

  @override
  _PeopleListWidgetState createState() => _PeopleListWidgetState();
}

class _PeopleListWidgetState extends State<PeopleListWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDrawer
        ? Scaffold(
            key: scaffoldKey,
            // appBar: AppBar(
            //   backgroundColor:Colors.white,
            //   automaticallyImplyLeading: false,
            //   // leading: FlutterFlowIconButton(
            //   //   borderColor: Colors.transparent,
            //   //   borderRadius: 30,
            //   //   borderWidth: 1,
            //   //   buttonSize: 60,
            //   //   icon: Icon(
            //   //     Icons.arrow_back,
            //   //     color: Colors.white,
            //   //     size: 30,
            //   //   ),
            //   //   onPressed: () async {
            //   //     widget.isDrawer
            //   //         ? Navigator.pop(context)
            //   //         : context
            //   //             .read<AuthProvider>()
            //   //             .setCurrentPage(DashboardWidgetMain(false));
            //   //   },
            //   // ),
            //   title: Text(
            //     'Party',
            //     style: FlutterFlowTheme.of(context).title2.override(
            //           fontFamily: 'Poppins',
            //           color: FlutterFlowTheme.of(context).primaryColor,
            //           fontSize: 22,
            //         ),
            //   ),
            //   actions: [],
            //   centerTitle: true,
            //   elevation: 2,
            // ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                widget.isDrawer
                    ? await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerAddWidget(true,
                              data: {}, id: '', isEdit: false),
                        ),
                      )
                    : context.read<AuthProvider>().setCurrentPage(
                        CustomerAddWidget(false,
                            data: {}, id: '', isEdit: false));
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                child:  Icon(
                  Icons.add,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  size: 24,
                ),
              ),
            ),
            body: SafeArea(child: _partyListMain(context)))
        : _partyListMain(context);
  }

  Widget _partyListMain(BuildContext context) {
   return FutureBuilder(
        future:
            Provider.of<PeopleProvider>(context, listen: false).fetchcutomers(),
        builder: (context, snapShot) {
          return snapShot.connectionState == ConnectionState.waiting
              ? circleLoading(context)
              : snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Text("Something went wrong"),
                    )
                  : SingleChildScrollView(
                    child: Consumer<PeopleProvider>(
                        builder: (context, itemData, child) => Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 4, 0),
                                        child: TextFormField(
                                          controller: textController,
                                          obscureText: false,
                                          onChanged: (value) {
                                            itemData.searchcutomers(value);
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Search people',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1
                                                    .override(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF57636C),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Lexend Deca',
                                                color: Color(0xFF262D34),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 8, 0),
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
                                              FlutterFlowTheme.of(context)
                                                  .subtitle2
                                                  .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                            Container(
                height: MediaQuery.of(context).size.height*0.8,
                              child: DefaultTabController(
                                length: 2,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    TabBar(
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                      unselectedLabelColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryColor,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                      indicatorColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryColor,
                                      tabs: [
                                        Tab(
                                          text: 'Customers',
                                        ),
                                        Tab(
                                          text: 'Suppliers',
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          itemData.customers.isEmpty
                                              ? Center(
                                                  child: Text(
                                                      "no customers added yet!"),
                                                )
                                              : itemData.searchCustomers.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                          "no customers mathces your search!"),
                                                    )
                                                  : SingleChildScrollView(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 80),
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children:
                                                                List.generate(
                                                              itemData
                                                                  .searchCustomers
                                                                  .length,
                                                              (index) =>
                                                                  Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            8,
                                                                            8,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                widget.isDrawer ?    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => CustomerAddWidget(true,
                                                                            data:
                                                                                itemData.searchCustomers[index].data(),
                                                                            isEdit: true,
                                                                            id: itemData.searchCustomers[index].id),
                                                                      ),
                                                                    ): context.read<AuthProvider>().setCurrentPage(CustomerAddWidget(false,
                                                                            data:
                                                                                itemData.searchCustomers[index].data(),
                                                                            isEdit: true,
                                                                            id: itemData.searchCustomers[index].id));
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
                                                                                    Text('${itemData.searchCustomers[index].data()['name']}',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: new TextStyle(
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.w700
                                                                                      ),),),
                                                                                    Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 60,
                                                                                          decoration: BoxDecoration(
                                                                                            color:  itemData.searchCustomers[index].data()['balance_type'] == 'To Receive'
                                                                                                ? Color(0xFF72C44A)
                                                                                                : Colors.red,
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(8),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding:
                                                                                            EdgeInsetsDirectional.fromSTEB(
                                                                                                4, 4, 4, 4),
                                                                                            child: Text(

                                                                                              "${itemData.searchCustomers[index].data()['balance_type'] == 'To Receive' ? '↓' : '↑'}",
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                  fontSize: 18,
                                                                                                    color: Colors.white,
                                                                                                    fontStyle: FontStyle.italic,
                                                                                                    fontWeight: FontWeight.w700
                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                        ),


                                                                                      ],
                                                                                    ),
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



                                                                                SizedBox(height: 5),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: <Widget>[
                                                                                    Align( alignment: Alignment.topCenter, child:
                                                                                    Text("Balance",
                                                                                        style: new TextStyle(
                                                                                          fontWeight: FontWeight.w500,) ),),
                                                                                    Text("₹${double.parse("${itemData.searchCustomers[index].data()['balance']}").toStringAsFixed(2)}",
                                                                                        style: new TextStyle(
                                                                                          color:  itemData.searchCustomers[index].data()['balance_type'] == 'To Receive'
                                                                                              ? Color(0xFF72C44A)
                                                                                              : Colors.red,
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
                                                                                    Text("₹ ${itemData.searchCustomers[index].data()['total'].toStringAsFixed(2)}",
                                                                                        style: new TextStyle(
                                                                                          color: Colors.black,
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
                                                                  //     Container(
                                                                  //   width: MediaQuery.of(
                                                                  //           context)
                                                                  //       .size
                                                                  //       .width,
                                                                  //   height: 120,
                                                                  //   decoration:
                                                                  //       BoxDecoration(
                                                                  //     color: Colors
                                                                  //         .white,
                                                                  //     boxShadow: [
                                                                  //       BoxShadow(
                                                                  //         blurRadius:
                                                                  //             12,
                                                                  //         color:
                                                                  //             Color(0x34000000),
                                                                  //         offset: Offset(
                                                                  //             -2,
                                                                  //             5),
                                                                  //       )
                                                                  //     ],
                                                                  //     borderRadius:
                                                                  //         BorderRadius.circular(
                                                                  //             8),
                                                                  //   ),
                                                                  //   child:
                                                                  //       Padding(
                                                                  //     padding: EdgeInsetsDirectional
                                                                  //         .fromSTEB(
                                                                  //             8,
                                                                  //             8,
                                                                  //             12,
                                                                  //             8),
                                                                  //     child:
                                                                  //         Row(
                                                                  //       mainAxisSize:
                                                                  //           MainAxisSize.max,
                                                                  //       children: [
                                                                  //         Container(
                                                                  //           width:
                                                                  //               4,
                                                                  //           height:
                                                                  //               double.infinity,
                                                                  //           decoration:
                                                                  //               BoxDecoration(
                                                                  //             color: Color(0xFF4B39EF),
                                                                  //             borderRadius: BorderRadius.circular(4),
                                                                  //           ),
                                                                  //         ),
                                                                  //         Expanded(
                                                                  //           child:
                                                                  //               Padding(
                                                                  //             padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                                  //             child: Column(
                                                                  //               mainAxisSize: MainAxisSize.max,
                                                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                                                  //               children: [
                                                                  //                 Text(
                                                                  //                   '${itemData.searchCustomers[index].data()['name']}',
                                                                  //                   style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                  //                         fontFamily: 'Lexend Deca',
                                                                  //                         color: Color(0xFF4B39EF),
                                                                  //                         fontSize: 14,
                                                                  //                         fontWeight: FontWeight.w500,
                                                                  //                       ),
                                                                  //                 ),
                                                                  //                 Text(
                                                                  //                   'Total:  ₹ ${itemData.searchCustomers[index].data()['total'].toStringAsFixed(2)}',
                                                                  //                   style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                  //                         fontFamily: 'Lexend Deca',
                                                                  //                         color: Color(0xFF57636C),
                                                                  //                         fontSize: 14,
                                                                  //                         fontWeight: FontWeight.normal,
                                                                  //                       ),
                                                                  //                 ),
                                                                  //                 Padding(
                                                                  //                   padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                                  //                   child: Text(
                                                                  //                     'Balance: ₹ ${double.parse("${itemData.searchCustomers[index].data()['balance']}").toStringAsFixed(2)} ${itemData.searchCustomers[index].data()['balance_type'] == 'To Receive' ? '↓' : '↑'}',
                                                                  //                     style: FlutterFlowTheme.of(context).title1.override(
                                                                  //                           fontFamily: 'Lexend Deca',
                                                                  //                           color: itemData.searchCustomers[index].data()['balance_type'] == 'To Receive' ? Colors.green : Colors.red,
                                                                  //                           fontSize: 14,
                                                                  //                           fontWeight: FontWeight.w600,
                                                                  //                         ),
                                                                  //                   ),
                                                                  //                 ),
                                                                  //               ],
                                                                  //             ),
                                                                  //           ),
                                                                  //         ),
                                                                  //       ],
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                          itemData.suppliers.isEmpty
                                              ? Center(
                                                  child: Text(
                                                      "no suppliers added yet!"),
                                                )
                                              : itemData.searchSuppliers.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                          "no suppliers mathces your search!"),
                                                    )
                                                  : SingleChildScrollView(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 80.0),
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children:
                                                                List.generate(
                                                              itemData
                                                                  .searchSuppliers
                                                                  .length,
                                                              (index) =>
                                                                  Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            8,
                                                                            8,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                 widget.isDrawer ?    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => CustomerAddWidget(true,
                                                                            data:
                                                                                itemData.searchSuppliers[index].data(),
                                                                            isEdit: true,
                                                                            id: itemData.searchSuppliers[index].id),
                                                                      ),
                                                                    ): context.read<AuthProvider>().setCurrentPage(CustomerAddWidget(false,
                                                                            data:
                                                                                itemData.searchSuppliers[index].data(),
                                                                            isEdit: true,
                                                                            id: itemData.searchSuppliers[index].id));
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
                                                                                    Text('${itemData.searchCustomers[index].data()['name']}',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: new TextStyle(
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.w700
                                                                                      ),),),
                                                                                    Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 60,
                                                                                          decoration: BoxDecoration(
                                                                                            color:  itemData.searchCustomers[index].data()['balance_type'] == 'To Receive'
                                                                                                ? Color(0xFF72C44A)
                                                                                                : Colors.red,
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(8),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding:
                                                                                            EdgeInsetsDirectional.fromSTEB(
                                                                                                4, 4, 4, 4),
                                                                                            child: Text(

                                                                                                "${itemData.searchCustomers[index].data()['balance_type'] == 'To Receive' ? '↓' : '↑'}",
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                    fontSize: 18,
                                                                                                    color: Colors.white,
                                                                                                    fontStyle: FontStyle.italic,
                                                                                                    fontWeight: FontWeight.w700
                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                        ),


                                                                                      ],
                                                                                    ),
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



                                                                                SizedBox(height: 5),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: <Widget>[
                                                                                    Align( alignment: Alignment.topCenter, child:
                                                                                    Text("Balance",
                                                                                        style: new TextStyle(
                                                                                          fontWeight: FontWeight.w500,) ),),
                                                                                    Text("₹${double.parse("${itemData.searchCustomers[index].data()['balance']}").toStringAsFixed(2)}",
                                                                                        style: new TextStyle(
                                                                                          color:  itemData.searchCustomers[index].data()['balance_type'] == 'To Receive'
                                                                                              ? Color(0xFF72C44A)
                                                                                              : Colors.red,
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
                                                                                    Text("₹ ${itemData.searchCustomers[index].data()['total'].toStringAsFixed(2)}",
                                                                                        style: new TextStyle(
                                                                                          color: Colors.black,
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
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  );
        });
  }
}
