import 'package:provider/provider.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';

import '../../components/circleLoading.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../providers/authProvider.dart';
import '../dashboard/dashboard_widget_main.dart';
import '../dashboard/drawerWidget.dart';
import 'item_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemsListWidget extends StatefulWidget {
  final bool isDrawer;
  const ItemsListWidget(this.isDrawer,{Key? key}) : super(key: key);

  @override
  _ItemsListWidgetState createState() => _ItemsListWidgetState();
}

class _ItemsListWidgetState extends State<ItemsListWidget> {
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
        future: Provider.of<ItemProvider>(context, listen: false).fetchItems(),
        builder: (context, snapShot) {
          return 
            widget.isDrawer ? Scaffold(
            key: scaffoldKey,
            // appBar: AppBar(
            //   backgroundColor: FlutterFlowTheme.of(context).primaryColor,
            //   automaticallyImplyLeading: false,
            //   leading: FlutterFlowIconButton(
            //     borderColor: Colors.transparent,
            //     borderRadius: 30,
            //     borderWidth: 1,
            //     buttonSize: 60,
            //     icon: Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //     onPressed: () async {
            //      widget.isDrawer
            //           ? Navigator.pop(context)
            //           : context
            //               .read<AuthProvider>()
            //               .setCurrentPage(DashboardWidgetMain(false));
            //     },
            //   ),
            //   title: Text(
            //     'Items',
            //     style: FlutterFlowTheme.of(context).title2.override(
            //           fontFamily: 'Poppins',
            //           color: Colors.white,
            //           fontSize: 22,
            //         ),
            //   ),
            //   // actions: [
            //   //   FlutterFlowIconButton(
            //   //   borderColor: Colors.transparent,
            //   //   borderRadius: 30,
            //   //   borderWidth: 1,
            //   //   buttonSize: 60,
            //   //   icon: Icon(
            //   //     Icons.document_scanner,
            //   //     color: Colors.white,
            //   //     size: 30,
            //   //   ),
            //   //   onPressed: () async {
            //   //     Navigator.pop(context);
            //   //   },
            //   // ),
            //   // ],
            //   centerTitle: true,
            //   elevation: 2,
            // ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

            floatingActionButton: FloatingActionButton(
              onPressed: () async {
             widget.isDrawer?   await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ItemAddWidget(true,data: {}, id: '', isEdit: false),
                  ),
                ): context.read<AuthProvider>().setCurrentPage(ItemAddWidget(false,data: {}, id: '', isEdit: false));
              },
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child:  Icon(
              Icons.add,
              color: FlutterFlowTheme.of(context).primaryBtnText,
              size: 24,
            ),
            ),
            body: snapShot.connectionState == ConnectionState.waiting
                ? circleLoading(context)
                : snapShot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: Text("Something went wrong"),
                      )
                    :_itemListMain(context)
          ): snapShot.connectionState == ConnectionState.waiting
                ? circleLoading(context)
                : snapShot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: Text("Something went wrong"),
                      )
                    :_itemListMain(context);});
        
  }
  
  Widget _itemListMain(BuildContext context) {
    return  Consumer<ItemProvider>(
        builder: (context, itemData, child) => SingleChildScrollView(
          child: Column(
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
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(
                              4, 0, 4, 0),
                      child: TextFormField(
                        controller: textController,
                        obscureText: false,
                        onChanged: (value) {
                          itemData.searchItems(
                              value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Search items',
                          labelStyle: FlutterFlowTheme.of(
                                  context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.normal,
                              ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 0,
                            ),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 0,
                            ),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        ),
                        style: FlutterFlowTheme.of(
                                context)
                            .bodyText1
                            .override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF262D34),
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(
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
                                  fontFamily:
                                      'Lexend Deca',
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
                    labelColor:
                        FlutterFlowTheme.of(context)
                            .primaryColor,
                    unselectedLabelColor:
                        FlutterFlowTheme.of(context)
                            .secondaryColor,
                    labelStyle:
                        FlutterFlowTheme.of(context)
                            .bodyText1,
                    indicatorColor:
                        FlutterFlowTheme.of(context)
                            .secondaryColor,
                    tabs: [
                      Tab(
                        text: 'Products',
                      ),
                      Tab(
                        text: 'Services',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        itemData.products.isEmpty
                            ? Center(
                                child: Text(
                                    "no products added yet!"),
                              )
                            : itemData.searchProducts
                                    .isEmpty
                                ? Center(
                                    child: Text(
                                        "no products mathces your search!"),
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
                                          children: List
                                              .generate(
                                            itemData
                                                .searchProducts
                                                .length,
                                            (index) =>
                                                Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      8,
                                                      8,
                                                      8,
                                                      0),
                                              child:
                                                  GestureDetector(
                                                onTap:
                                                    () async {
                                                widget.isDrawer ?  Navigator
                                                      .push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ItemAddWidget(true,
                                                          data: itemData.searchProducts[index].data(),
                                                          isEdit: true,
                                                          id: itemData.searchProducts[index].id),
                                                    ),
                                                  ): context.read<AuthProvider>().setCurrentPage(ItemAddWidget(false,
                                                          data: itemData.searchProducts[index].data(),
                                                          isEdit: true,
                                                          id: itemData.searchProducts[index].id),);
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
                                                                  Text("${itemData.searchProducts[index].data()['item_name']}",
                                                                    textAlign: TextAlign.center,
                                                                    style: new TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.w700
                                                                    ),),),

                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                                    itemData.searchProducts[index].data()['stock'] <1 ?'Out of stock' :itemData.searchProducts[index].data()['stock'] <
                                                                                    itemData.searchProducts[index].data()['minimum_stock']
                                                                                    ? 'Low in stock\n${itemData.searchProducts[index].data()['stock']}':'In stock\n${itemData.searchProducts[index].data()['stock']}',
                                                                                      style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: itemData.searchProducts[index].data()['stock'] > itemData.searchProducts[index].data()['minimum_stock'] ? Colors.green : Colors.red,
                                                                                          ),
                                                                      )

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
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Align( alignment: Alignment.topCenter, child:
                                                                  Text("Sale Price",
                                                                    style: new TextStyle(
                                                                        fontWeight: FontWeight.w500),)),
                                                                  Text('₹ ${itemData.searchProducts[index].data()['sale_price'].toStringAsFixed(2)} / ${itemData.searchProducts[index].data()['primary_unit'].split("(")[1].split(")")[0]}',
                                                                      style: new TextStyle(
                                                                        fontWeight: FontWeight.w500,)),

                                                                ],
                                                              ),

                                                              SizedBox(height: 5),

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Align( alignment: Alignment.topCenter, child:
                                                                  Text("Purchase Price",
                                                                      style: new TextStyle(
                                                                        fontWeight: FontWeight.w500,) ),),
                                                                  Text("₹ ${itemData.searchProducts[index].data()['purchase_price'].toStringAsFixed(2)} / ${itemData.searchProducts[index].data()['primary_unit'].split("(")[1].split(")")[0]}",
                                                                      style: new TextStyle(

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
                                                // Container(
                                                //   width: MediaQuery.of(context)
                                                //       .size
                                                //       .width,
                                                //   height:
                                                //       120,
                                                //   decoration:
                                                //       BoxDecoration(
                                                //     color:
                                                //         Colors.white,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         blurRadius: 12,
                                                //         color: Color(0x34000000),
                                                //         offset: Offset(-2, 5),
                                                //       )
                                                //     ],
                                                //     borderRadius:
                                                //         BorderRadius.circular(8),
                                                //   ),
                                                //   child:
                                                //       Padding(
                                                //     padding: EdgeInsetsDirectional.fromSTEB(
                                                //         8,
                                                //         8,
                                                //         12,
                                                //         8),
                                                //     child:
                                                //         Row(
                                                //       mainAxisSize:
                                                //           MainAxisSize.max,
                                                //       children: [
                                                //         Container(
                                                //           width: 4,
                                                //           height: double.infinity,
                                                //           decoration: BoxDecoration(
                                                //             color: Color(0xFF4B39EF),
                                                //             borderRadius: BorderRadius.circular(4),
                                                //           ),
                                                //         ),
                                                //         Expanded(
                                                //           child: Padding(
                                                //             padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                //             child: Column(
                                                //               mainAxisSize: MainAxisSize.max,
                                                //               mainAxisAlignment: MainAxisAlignment.center,
                                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                                //               children: [
                                                //                 Text(
                                                //                   '${itemData.searchProducts[index].data()['item_name']}',
                                                //                   style: FlutterFlowTheme.of(context).bodyText1.override(
                                                //                         fontFamily: 'Lexend Deca',
                                                //                         color: Color(0xFF4B39EF),
                                                //                         fontSize: 14,
                                                //                         fontWeight: FontWeight.w500,
                                                //                       ),
                                                //                 ),
                                                //                 Text(
                                                //                   'Sale Price:  ₹ ${itemData.searchProducts[index].data()['sale_price'].toStringAsFixed(2)} / ${itemData.searchProducts[index].data()['primary_unit'].split("(")[1].split(")")[0]}',
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
                                                //                     'Purchase Price: ₹ ${itemData.searchProducts[index].data()['purchase_price'].toStringAsFixed(2)} / ${itemData.searchProducts[index].data()['primary_unit'].split("(")[1].split(")")[0]}',
                                                //                     style: FlutterFlowTheme.of(context).title1.override(
                                                //                           fontFamily: 'Lexend Deca',
                                                //                           color: Color(0xFF57636C),
                                                //                           fontSize: 14,
                                                //                           fontWeight: FontWeight.w600,
                                                //                         ),
                                                //                   ),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         Container(
                                                //           decoration: BoxDecoration(
                                                //             color: FlutterFlowTheme.of(context).primaryBtnText,
                                                //             borderRadius: BorderRadius.circular(12),
                                                //           ),
                                                //           child: Padding(
                                                //             padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                                //             child: Text(
                                                //             itemData.searchProducts[index].data()['stock'] <1 ?'Out of stock' :itemData.searchProducts[index].data()['stock'] <
                                                //             itemData.searchProducts[index].data()['minimum_stock']
                                                //             ? 'Low in stock\n${itemData.searchProducts[index].data()['stock']}':'In stock\n${itemData.searchProducts[index].data()['stock']}',
                                                //               style: FlutterFlowTheme.of(context).bodyText1.override(
                                                //                     fontFamily: 'Poppins',
                                                //                     color: itemData.searchProducts[index].data()['stock'] > itemData.searchProducts[index].data()['minimum_stock'] ? Colors.green : Colors.red,
                                                //                   ),
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
                        itemData.services.isEmpty
                            ? Center(
                                child: Text(
                                    "no services added yet!"),
                              )
                            : itemData.searchServices
                                    .isEmpty
                                ? Center(
                                    child: Text(
                                        "no service mathces your search!"),
                                  )
                                : SingleChildScrollView(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets
                                                  .only(
                                              bottom:
                                                  80.0),
                                      child: Column(
                                          mainAxisSize:
                                              MainAxisSize
                                                  .max,
                                          children: List
                                              .generate(
                                            itemData
                                                .searchServices
                                                .length,
                                            (index) =>
                                                Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      8,
                                                      8,
                                                      8,
                                                      0),
                                              child:
                                                  GestureDetector(
                                                onTap:
                                                    () async {
                                                 widget.isDrawer ? await Navigator
                                                      .push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ItemAddWidget(true,
                                                          data: itemData.searchServices[index].data(),
                                                          isEdit: true,
                                                          id: itemData.searchServices[index].id),
                                                    ),
                                                  ): context.read<AuthProvider>().setCurrentPage(ItemAddWidget(false,
                                                          data: itemData.searchServices[index].data(),
                                                          isEdit: true,
                                                          id: itemData.searchServices[index].id));
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
                                                                  Text("${itemData.searchServices[index].data()['item_name']}",
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
                                                                  Text("Price",
                                                                      style: new TextStyle(
                                                                        fontWeight: FontWeight.w500,) ),),
                                                                  Text("₹ ${itemData.searchServices[index].data()['mrp'].toStringAsFixed(2)} / ${itemData.searchProducts[index].data()['primary_unit'].split("(")[1].split(")")[0]}",
                                                                      style: new TextStyle(

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
                                                //   width: MediaQuery.of(context)
                                                //       .size
                                                //       .width,
                                                //   height:
                                                //       120,
                                                //   decoration:
                                                //       BoxDecoration(
                                                //     color:
                                                //         Colors.white,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         blurRadius: 12,
                                                //         color: Color(0x34000000),
                                                //         offset: Offset(-2, 5),
                                                //       )
                                                //     ],
                                                //     borderRadius:
                                                //         BorderRadius.circular(8),
                                                //   ),
                                                //   child:
                                                //       Padding(
                                                //     padding: EdgeInsetsDirectional.fromSTEB(
                                                //         8,
                                                //         8,
                                                //         12,
                                                //         8),
                                                //     child:
                                                //         Row(
                                                //       mainAxisSize:
                                                //           MainAxisSize.max,
                                                //       children: [
                                                //         Container(
                                                //           width: 4,
                                                //           height: double.infinity,
                                                //           decoration: BoxDecoration(
                                                //             color: Color(0xFF4B39EF),
                                                //             borderRadius: BorderRadius.circular(4),
                                                //           ),
                                                //         ),
                                                //         Expanded(
                                                //           child: Padding(
                                                //             padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                //             child: Column(
                                                //               mainAxisSize: MainAxisSize.max,
                                                //               mainAxisAlignment: MainAxisAlignment.center,
                                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                                //               children: [
                                                //                 Text(
                                                //                   '${itemData.searchServices[index].data()['item_name']}',
                                                //                   style: FlutterFlowTheme.of(context).bodyText1.override(
                                                //                         fontFamily: 'Lexend Deca',
                                                //                         color: Color(0xFF4B39EF),
                                                //                         fontSize: 14,
                                                //                         fontWeight: FontWeight.w500,
                                                //                       ),
                                                //                 ),
                                                //                 Text(
                                                //                   'Price:  ₹ ${itemData.searchServices[index].data()['mrp'].toStringAsFixed(2)}',
                                                //                   style: FlutterFlowTheme.of(context).bodyText1.override(
                                                //                         fontFamily: 'Lexend Deca',
                                                //                         color: Color(0xFF57636C),
                                                //                         fontSize: 14,
                                                //                         fontWeight: FontWeight.normal,
                                                //                       ),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         Container(
                                                //           decoration: BoxDecoration(
                                                //             color: FlutterFlowTheme.of(context).primaryBtnText,
                                                //             borderRadius: BorderRadius.circular(12),
                                                //           ),
                                                //           child: Padding(
                                                //             padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
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
        
  }
}
