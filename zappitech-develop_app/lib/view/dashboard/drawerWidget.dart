import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/view/dashboard/ledger_list.dart';
import 'package:ziptech/view/dashboard/support.dart';

import '../../flutter_flow/flutter_flow_util.dart';
import '../people/customers_list_widget.dart';
import '../expense/expense_list_widget.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../items/items_list_widget.dart';
import '../purchase/purchase_list_widget.dart';
import '../sales/sales_list_widget.dart';

class DrawerWidget extends StatefulWidget {
  final bool isDrawer;
  const DrawerWidget( this.isDrawer,{Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width:
       MediaQuery.of(context).size.width < 1000 &&
              MediaQuery.of(context).size.width > 660
          ? MediaQuery.of(context).size.width * 0.1
          :MediaQuery.of(context).size.width < 660?null: MediaQuery.of(context).size.width * 0.2,
      elevation: 16,
      child: SingleChildScrollView(
        child: Consumer<AuthProvider>(
                  builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 20,
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
              Container(
                //width: 1000,
                height: 100,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                ),
                child:Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        child: Container(
                            padding: EdgeInsets.all(
                                value.userData!["company_details"]["logo"] != '' &&
                                        value.userData!["company_details"]
                                                ["logo"] !=
                                            null
                                    ? 2
                                    : 12),
                            height: 100,
                            width: MediaQuery.of(context).size.width < 1000 &&
                                    MediaQuery.of(context).size.width > 660
                                ? 50
                                : 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]!)),
                            child: Center(
                              child: value.userData!["company_details"]["logo"] !=
                                          '' &&
                                      value.userData!["company_details"]["logo"] !=
                                          null
                                  ? CircleAvatar(
                                      foregroundColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      radius: MediaQuery.of(context).size.width <
                                                  1000 &&
                                              MediaQuery.of(context).size.width >
                                                  660
                                          ? 48
                                          : 98,
                                      backgroundImage: NetworkImage(value
                                          .userData!["company_details"]["logo"]))
                                  : Image(
                                      image: AssetImage(
                                          "assets/images/briefcase.png"),
                                      fit: BoxFit.contain,
                                    ),
                            )),
                      ),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ""
                            : value.userData!["company_details"]["company_name"] ??
                                "company",
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),

              ),
              Container(
                height: 20,
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   color:  value.currentPage==ItemsListWidget?FlutterFlowTheme.of(context).primaryColor:null,
              //   //width: 100,
              //   child: InkWell(
              //     onTap: () async {
              //       widget.isDrawer?await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ItemsListWidget(true),
              //         ),
              //       ):context.read<AuthProvider>().setCurrentPage(ItemsListWidget(false));
              //
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Icon(Icons.list, color:value.currentPage==ItemsListWidget?Colors.white54: Colors.black54),
              //         Text(
              //           MediaQuery.of(context).size.width < 1000 &&
              //                   MediaQuery.of(context).size.width > 660
              //               ? ''
              //               : 'Items',
              //           style: FlutterFlowTheme.of(context).title3.override(
              //                 fontFamily: 'Poppins',
              //                 color: value.currentPage==ItemsListWidget? Colors.white : Colors.black87,
              //                 fontSize: 14,
              //               ),
              //         ),
              //         MediaQuery.of(context).size.width < 1000 &&
              //                 MediaQuery.of(context).size.width > 660
              //             ? Container()
              //             : Icon(
              //                 Icons.arrow_forward_ios,
              //                 color:value.currentPage==ItemsListWidget?Colors.white54: Colors.black54,
              //                 size: 20,
              //               ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   color:  value.currentPage==PeopleListWidget?FlutterFlowTheme.of(context).primaryColor:null,
              //   //width: 100,
              //   child: InkWell(
              //     onTap: () async {
              //       widget.isDrawer? await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => PeopleListWidget(true),
              //         ),
              //       ):context.read<AuthProvider>().setCurrentPage(PeopleListWidget(false),);
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Icon(Icons.people, color:value.currentPage==PeopleListWidget?Colors.white54: Colors.black54),
              //         Text(
              //           MediaQuery.of(context).size.width < 1000 &&
              //                   MediaQuery.of(context).size.width > 660
              //               ? ''
              //               : 'Party',
              //           style: FlutterFlowTheme.of(context).title3.override(
              //                 fontFamily: 'Poppins',
              //                 color:value.currentPage==PeopleListWidget? Colors.white : Colors.black87,
              //                 fontSize: 14,
              //               ),
              //         ),
              //         MediaQuery.of(context).size.width < 1000 &&
              //                 MediaQuery.of(context).size.width > 660
              //             ? Container()
              //             : Icon(
              //                 Icons.arrow_forward_ios,
              //                 color:value.currentPage==PeopleListWidget?Colors.white54: Colors.black54,
              //                 size: 20,
              //               ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color:  value.currentPage==SalesListWidget?FlutterFlowTheme.of(context).primaryColor:null,
                //width: 100,
                child: InkWell(
                  onTap: () async {
                   widget.isDrawer?  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesListWidget(true),
                      ),
                    ):context.read<AuthProvider>().setCurrentPage(SalesListWidget(false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.assignment, color:value.currentPage==SalesListWidget?Colors.white54: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Sale',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color: value.currentPage==SalesListWidget? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color:value.currentPage==SalesListWidget?Colors.white54: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color:  value.currentPage==PurchaseListWidget?FlutterFlowTheme.of(context).primaryColor:null,
                //width: 100,
                child: InkWell(
                  onTap: () async {
                    widget.isDrawer? await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseListWidget(true),
                      ),
                    ):context.read<AuthProvider>().setCurrentPage(PurchaseListWidget(false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.shopping_cart, color:value.currentPage==PurchaseListWidget?Colors.white54: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Purchase',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color:value.currentPage==PurchaseListWidget?Colors.white: Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color:value.currentPage==PurchaseListWidget?Colors.white54: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color:  value.currentPage==ExpenseListWidget?FlutterFlowTheme.of(context).primaryColor:null,
                //width: 100,
                child: InkWell(
                  onTap: () async {
                 widget.isDrawer?    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseListWidget(true),
                      ),
                    ):context.read<AuthProvider>().setCurrentPage(ExpenseListWidget(false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.account_balance_wallet, color:value.currentPage==ExpenseListWidget?Colors.white54: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Expense',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color: value.currentPage==ExpenseListWidget? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color:value.currentPage==ExpenseListWidget?Colors.white54: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color:  value.currentPage==LedgerList?FlutterFlowTheme.of(context).primaryColor:null,
                //width: 100,
                child: InkWell(
                  onTap: () async {
                  widget.isDrawer?   await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LedgerList(true),
                      ),
                    ):context.read<AuthProvider>().setCurrentPage(LedgerList(false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.file_copy, color:value.currentPage==LedgerList?Colors.white54: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Ledgers',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color: value.currentPage==LedgerList? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color:value.currentPage==LedgerList?Colors.white54: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //width: 100,\
                color:  value.currentPage==Support?FlutterFlowTheme.of(context).primaryColor:null,
                child: InkWell(
                  onTap: () async {
                  widget.isDrawer?   await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Support(true),
                      ),
                    ):context.read<AuthProvider>().setCurrentPage(Support(false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.support_agent, color:value.currentPage==Support?Colors.white54: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Support',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color:value.currentPage==Support?Colors.white: Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color:value.currentPage==Support?Colors.white54: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //width: 100,
                child: InkWell(
                  onTap: () async {
                    await launchURL("");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.help_center, color: Colors.black54),
                      Text(
                        MediaQuery.of(context).size.width < 1000 &&
                                MediaQuery.of(context).size.width > 660
                            ? ''
                            : 'Tutorial',
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                      ),
                      MediaQuery.of(context).size.width < 1000 &&
                              MediaQuery.of(context).size.width > 660
                          ? Container()
                          : Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                              size: 20,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
