import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ziptech/components/circleLoading.dart';
import 'package:ziptech/helpers/loadingStates.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/view/dashboard/drawerWidget.dart';

import '../flutter_flow/flutter_flow_credit_card_form.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../view/dashboard/dashboard_widget_main.dart';
import '../view/dashboard/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view/people/customers_list_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Razorpay? _razorpay;
  final creditCardFormKey = GlobalKey<FormState>();
  CreditCardModel creditCardInfo = emptyCreditCard();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();

    _razorpay?.clear();
  }

  void openCheckout({contact, email}) async {
    var options = {
      'key': 'rzp_live_VVXD8naLXtWhPB',
      'amount': 100,
      'name': 'joinbills',
      'description': 'Subscription',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
      Fluttertoast.showToast(
          msg: "Payment Failed", toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Fluttertoast.showToast(
        msg: "Successfully Subscribed!", toastLength: Toast.LENGTH_SHORT);
    Provider.of<AuthProvider>(context, listen: false)
        .editPayed(isPayed: true)
        .then((value) {
      Provider.of<AuthProvider>(context, listen: false).fetchUser();
      setState(() {});
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "Payment Failed", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);

    return FutureBuilder(
          future: Provider.of<AuthProvider>(context, listen: false).fetchUser(),
        builder: (context, snap) {
      print(
          "******* dimensions *******\nwidth : ${MediaQuery.of(context).size.width}\nheight : ${MediaQuery.of(context).size.height}\n******* dimensions *******");
      if (authData.loadingState == LoadingStates.loading) {
        return Scaffold(
          body: Center(child: circleLoading(context)),
        );
      } else {
        if (authData.userData == {} || authData.userData == null) {
          return SignUpWidget();
        }
        else if (authData.userData!["is_payed"] &&
            DateTime.now().isBefore(authData.userData!["expiry"].toDate())) {
          print("yayy");
          return Nav();
        } 
        else if (authData.userData!["created_at"] != null &&
            DateTime.now()
                    .difference(authData.userData!["created_at"].toDate())
                    .inDays <=
                60) {
          return Nav();
        }
         else {
          print("noop");

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              title: Text(
                'Subscribe',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 44, 16, 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x25090F13),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Checkout',
                                            style: FlutterFlowTheme.of(context)
                                                .title3
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Color(0xFF14181B),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 24,
                                thickness: 2,
                                color: Color(0xFFF1F4F8),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 16, 24, 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Price Breakdown',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Roboto Mono',
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 4, 24, 24),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹1999/yr',
                                          style: FlutterFlowTheme.of(context)
                                              .title1
                                              .override(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF14181B),
                                                fontSize: 34,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        openCheckout(
                                            contact: authData
                                                .userData!["phone_number"],
                                            email: authData.userData!["email"]);
                                      },
                                      text: 'SUBSCRIBE',
                                      options: FFButtonOptions(
                                        width: 270,
                                        height: 50,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryColor,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .subtitle2
                                            .override(
                                              fontFamily: 'Outfit',
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'By subcribing you are agreeing to our',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Roboto Mono',
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await launchURL(
                                                    "https://zappitech.com/terms_&_conditions.html");
                                              },
                                              child: Text(
                                                'Terms & Conditions',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                            fontFamily:
                                                                'Roboto Mono',
                                                            color: Colors.blue,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                              ),
                                            ),
                                            Text(
                                              'and',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText2
                                                  .override(
                                                    fontFamily: 'Roboto Mono',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await launchURL(
                                                    "https://zappitech.com/privacy-policy.html");
                                              },
                                              child: Text(
                                                'Privacy Policies',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                            fontFamily:
                                                                'Roboto Mono',
                                                            color: Colors.blue,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  //   child: FFButtonWidget(
                                  //     onPressed: () {
                                  //       print('Button pressed ...');
                                  //     },
                                  //     text: 'Apple Pay',
                                  //     icon: FaIcon(
                                  //       FontAwesomeIcons.apple,
                                  //       color: Colors.white,
                                  //     ),
                                  //     options: FFButtonOptions(
                                  //       width: 270,
                                  //       height: 50,
                                  //       color:
                                  //           FlutterFlowTheme.of(context).primaryColor,
                                  //       textStyle: FlutterFlowTheme.of(context)
                                  //           .subtitle2
                                  //           .override(
                                  //             fontFamily: 'Outfit',
                                  //             color: Colors.white,
                                  //             fontSize: 16,
                                  //             fontWeight: FontWeight.normal,
                                  //           ),
                                  //       elevation: 2,
                                  //       borderSide: BorderSide(
                                  //         color: Colors.transparent,
                                  //         width: 1,
                                  //       ),
                                  //       borderRadius: 12,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  //   child: FFButtonWidget(
                                  //     onPressed: () {
                                  //       print('Button pressed ...');
                                  //     },
                                  //     text: 'Pay w/Paypal',
                                  //     icon: FaIcon(
                                  //       FontAwesomeIcons.paypal,
                                  //       color: Colors.white,
                                  //     ),
                                  //     options: FFButtonOptions(
                                  //       width: 270,
                                  //       height: 50,
                                  //       color:
                                  //           FlutterFlowTheme.of(context).primaryColor,
                                  //       textStyle: FlutterFlowTheme.of(context)
                                  //           .subtitle2
                                  //           .override(
                                  //             fontFamily: 'Outfit',
                                  //             color: Colors.white,
                                  //             fontSize: 16,
                                  //             fontWeight: FontWeight.normal,
                                  //           ),
                                  //       elevation: 2,
                                  //       borderSide: BorderSide(
                                  //         color: Colors.transparent,
                                  //         width: 1,
                                  //       ),
                                  //       borderRadius: 12,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
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
    });
  }
}


class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  var title="Dashboard";
  List<Widget> _widgetOptions = <Widget>[

    HomeWidget(),
    ItemsListWidget(true),
    PeopleListWidget(true),
    ProfileWidget(true)
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void onItemTapped(int index){
    setState((){
      _selectedIndex = index;
      switch(index){
        case 0:
          title="Dashboard";
          break;
        case 1:
          title="Inventory";
          break;
        case 2:
          title="Party";
          break;
        case 3:
          title= "Profile";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: scaffoldKey,
      drawer:
      MediaQuery.of(context).size.width <660 ?
      DrawerWidget(true,)
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:Colors.white,
        title: Text(title,style: FlutterFlowTheme.of(context).title2.override(
      fontFamily: 'Poppins',
      color: FlutterFlowTheme.of(context).primaryColor,
      fontSize: 22,),),
        leading:
        MediaQuery.of(context).size.width < 660
            ?
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.menu,
            color: FlutterFlowTheme.of(context).primaryColor,
            size: 24,
          ),
          onPressed: () async {
            scaffoldKey.currentState!.openDrawer();
          },
        )
            : GestureDetector(
          onTap: () {
            context.read<AuthProvider>().setCurrentPage(DashboardWidgetMain(false));
          },
          child: Container(
              padding: EdgeInsets.only(left:16,top: 4,bottom: 4),
              child: Image(image: AssetImage("assets/images/join1.png"),)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor:FlutterFlowTheme.of(context).primaryColor ,
        selectedItemColor: FlutterFlowTheme.of(context).primaryColor,
        selectedLabelStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryColor,fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/join1.png")

            ),
            label:
              'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2_outlined,
            ),
            label:
              'Inventory',

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.party_mode_outlined,
            ),
            label:
            'Party',

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label:
              'Profile',

          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
