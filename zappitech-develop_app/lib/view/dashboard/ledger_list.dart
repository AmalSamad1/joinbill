import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/view/dashboard/dashboard_widget_main.dart';
import 'package:ziptech/view/items/item_ledger.dart';
import 'package:ziptech/view/people/party_ledger.dart';
import 'package:ziptech/view/sales/estimate_list.dart';
import 'package:ziptech/widget/salesestimate_widget.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/authProvider.dart';

class LedgerList extends StatefulWidget {
  final bool isDrawer;
  const LedgerList(this.isDrawer, {Key? key}) : super(key: key);

  @override
  _LedgerListState createState() => _LedgerListState();
}

class _LedgerListState extends State<LedgerList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                  Icons.arrow_back_rounded,
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
                'Ledgers',
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
            body: SafeArea(
              child: _ledgerListWidget(),
            ),
          )
        : _ledgerListWidget();
  }

  Widget _ledgerListWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    color: Color(0x2F1D2429),
                    offset: Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 8),
                                    child: InkWell(
                                      onTap: () async {
                                      widget.isDrawer ?  await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ItemLedger(true),
                                          ),
                                        ): context.read<AuthProvider>().setCurrentPage(ItemLedger(false));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Items ledger',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .subtitle2
                                                                .override(
                                                                  fontFamily:
                                                                      'Lexend Deca',
                                                                  color: Color(
                                                                      0xFF262D34),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 8),
                                    child: InkWell(
                                      onTap: () async {
                                       widget.isDrawer ? await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PartyLedger(true),
                                          ),
                                        ):context.read<AuthProvider>().setCurrentPage(PartyLedger(false));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Party summary',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .subtitle2
                                                                .override(
                                                                  fontFamily:
                                                                      'Lexend Deca',
                                                                  color: Color(
                                                                      0xFF262D34),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsetsDirectional.fromSTEB(
                                  //           0, 0, 0, 8),
                                  //   child: InkWell(
                                  //     onTap: () async {
                                  //       // await Navigator.push(
                                  //       //   context,
                                  //       //   MaterialPageRoute(
                                  //       //     builder: (context) =>
                                  //       //         SaleReturnListWidget(),
                                  //       //   ),
                                  //       // );
                                  //     },
                                  //     child: Container(
                                  //       width: double.infinity,
                                  //       height: 60,
                                  //       decoration: BoxDecoration(
                                  //         color: Color(0xFFF4F4F4),
                                  //         borderRadius:
                                  //             BorderRadius.circular(8),
                                  //       ),
                                  //       child: Padding(
                                  //         padding: EdgeInsetsDirectional
                                  //             .fromSTEB(12, 8, 12, 8),
                                  //         child: Row(
                                  //           mainAxisSize:
                                  //               MainAxisSize.max,
                                  //           children: [
                                  //             Expanded(
                                  //               child: Padding(
                                  //                 padding:
                                  //                     EdgeInsetsDirectional
                                  //                         .fromSTEB(12, 0,
                                  //                             0, 0),
                                  //                 child: Column(
                                  //                   mainAxisSize:
                                  //                       MainAxisSize.max,
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .center,
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Text(
                                  //                       'Stock summary',
                                  //                       style: FlutterFlowTheme
                                  //                               .of(context)
                                  //                           .subtitle2
                                  //                           .override(
                                  //                             fontFamily:
                                  //                                 'Lexend Deca',
                                  //                             color: Color(
                                  //                                 0xFF262D34),
                                  //                             fontSize:
                                  //                                 16,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .normal,
                                  //                           ),
                                  //                     ),

                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




