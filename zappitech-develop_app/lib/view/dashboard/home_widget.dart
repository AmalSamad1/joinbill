import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/components/circleLoading.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/providers/sales_providers/sales_invoice_provider.dart';
import 'package:ziptech/view/dashboard/dashboard_widget_main.dart';

import '../../components/shortcut_widget.dart';
import '../items/item_ledger.dart';
import '../people/customers_list_widget.dart';
import '../expense/expense_list_widget.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../items/items_list_widget.dart';
import '../people/party_ledger.dart';
import '../profile/profile_widget.dart';
import '../purchase/purchase_list_widget.dart';
import '../sales/sale_invoice_add_widget.dart';
import '../sales/sales_invoice_widget.dart';
import '../sales/sales_list_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'drawerWidget.dart';
// import 'dart:html' as html;

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String? dropDownValue1;
  String? dropDownValue2;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    initLoading();
    super.initState();
    
    //,

    context.read<AuthProvider>().fetchUser().then((value) {
      setState(() {

      });
    });
  }

  Future<void> initLoading() async{
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
       future: Provider.of<AuthProvider>(context, listen: false).fetchUser(),
      builder: (context, snapShot) {
        return Scaffold(
          // key: scaffoldKey,
          // appBar: AppBar(
          //   backgroundColor:Colors.white,
          //   automaticallyImplyLeading: false,
          //   leading:
          //    MediaQuery.of(context).size.width < 660
          //       ?
          //       FlutterFlowIconButton(
          //           borderColor: Colors.transparent,
          //           borderRadius: 30,
          //           borderWidth: 1,
          //           buttonSize: 60,
          //           icon: Icon(
          //             Icons.menu,
          //             color: FlutterFlowTheme.of(context).primaryBtnText,
          //             size: 24,
          //           ),
          //           onPressed: () async {
          //             scaffoldKey.currentState!.openDrawer();
          //           },
          //         )
          //       : GestureDetector(
          //         onTap: () {
          //           context.read<AuthProvider>().setCurrentPage(DashboardWidgetMain(false));
          //         },
          //          child: Container(
          //           padding: EdgeInsets.only(left:16,top: 4,bottom: 4),
          //           child: Image(image: AssetImage("assets/images/join1.png"),)),
          //       ),
          //
          //   title: Text(
          //     'Dashboard',
          //     style: FlutterFlowTheme.of(context).title2.override(
          //           fontFamily: 'Poppins',
          //           color: FlutterFlowTheme.of(context).primaryColor,
          //           fontSize: 22,
          //         ),
          //   ),
          //
          //   actions: [
          //     FlutterFlowIconButton(
          //       borderColor: Colors.transparent,
          //       borderRadius: 30,
          //       borderWidth: 1,
          //       buttonSize: 60,
          //       icon: Icon(
          //         Icons.person,
          //         color: FlutterFlowTheme.of(context).primaryBtnText,
          //         size: 30,
          //       ),
          //       onPressed: () async {
          //        MediaQuery.of(context).size.width < 660
          //       ?
          //        await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => ProfileWidget(true),
          //           ),
          //         ):context.read<AuthProvider>().setCurrentPage(ProfileWidget(false));
          //       },
          //     ),
          //   ],
          //   centerTitle: true,
          //   elevation: 2,
          // ),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child:  Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).primaryBtnText,
            size: 24,
          ),
              // isExtended: true,
              onPressed: () async {
                // await showModalBottomSheet(
                //   isScrollControlled: true,
                //   backgroundColor: Colors.transparent,
                //   context: context,
                //   builder: (context) {
                //     return Padding(
                //       padding: MediaQuery.of(context).viewInsets,
                //       child: ShortcutWidget(),
                //     );
                //   },
                // );
               MediaQuery.of(context).size.width < 660
                ?   await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaleInvoiceAddWidget(true,
                        data: {}, id: '', isEdit: false, quickAdd: true),
                  ),
                ):context.read<AuthProvider>().setCurrentPage(SaleInvoiceAddWidget(false,
                        data: {}, id: '', isEdit: false, quickAdd: true));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              elevation: 8,
              // icon: Padding(
              //   padding: const EdgeInsets.only(left: 60.0),
              //   child: Icon(
              //     Icons.add,
              //     color: FlutterFlowTheme.of(context).primaryBtnText,
              //     size: 24,
              //   ),
              // ),
              // label: Padding(
              //   padding: const EdgeInsets.only(right: 60.0),
              //   child: Text("Sale"),
              // )
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              return await Future.delayed(Duration(seconds: 0));
            },
            child: snapShot.connectionState == ConnectionState.waiting
                ? circleLoading(context)
                : snapShot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: Text("Something went wrong"),
                      )
                    : SafeArea(
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Row(
                            children: [
                             MediaQuery.of(context).size.width <660
                                 ? 
                                  Container()
                                  :  DrawerWidget(false),
            
                                      
                              Consumer<AuthProvider>(
                builder: (context, value, child) =>  Container(
                                  height:  MediaQuery.of(context).size.height,
                                   width:
                                  MediaQuery.of(context).size.width < 1000
                                            
                                        
                                      ? MediaQuery.of(context).size.width > 660?
                                      MediaQuery.of(context).size.width * 0.9:MediaQuery.of(context).size.width
                                      : MediaQuery.of(context).size.width * 0.8
                                      ,
                                  child:
                                  MediaQuery.of(context).size.width <660?DashboardWidgetMain(true)
                                  :
                                  value.currentPage!=null
                                  ?
                                  value.currentPage
                                  :DashboardWidgetMain(false)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        );
      },
    );
  }
}
