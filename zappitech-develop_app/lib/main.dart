import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/entry.dart';
import 'package:ziptech/providers/authProvider.dart';
import 'package:ziptech/providers/expense_provider/expense_provider.dart';
import 'package:ziptech/providers/item_add_bill_provider.dart';
import 'package:ziptech/providers/item_provider/item_provider.dart';
import 'package:ziptech/providers/people_provider/people_provider.dart';
import 'package:ziptech/providers/purchase_providers/paymentOut_provider.dart';
import 'package:ziptech/providers/purchase_providers/purchase_bill_provider.dart';
import 'package:ziptech/providers/purchase_providers/purchase_order_provider.dart';
import 'package:ziptech/providers/purchase_providers/purchase_return.dart';
import 'package:ziptech/providers/sales_providers/estimate_provider.dart';
import 'package:ziptech/providers/sales_providers/paymentIn_provider.dart';
import 'package:ziptech/providers/sales_providers/sale_order_provider.dart';
import 'package:ziptech/providers/sales_providers/sale_return_provider.dart';
import 'package:ziptech/providers/sales_providers/sales_invoice_provider.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterFlowTheme.initialize();
  
  await Firebase.initializeApp(
    //options: const FirebaseOptions( apiKey: "AIzaSyBRyRTaNTHysBNjKYd4GQ4tsdGmlIoxJ7k", appId: "1:521108154898:web:2fd788cad85f31a9e546cb", messagingSenderId: "521108154898", projectId: "zappitech-af34e",),
    );
 
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale ?_locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ItemAddBill>(create: (_) => ItemAddBill()),
        ChangeNotifierProxyProvider<AuthProvider, SalesInvoiceProvider>(
          create: (BuildContext context) => SalesInvoiceProvider(null),
        update: (_, token, __) => SalesInvoiceProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, ItemProvider>(
          create: (BuildContext context) => ItemProvider(null),
        update: (_, token, __) => ItemProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, PeopleProvider>(
          create: (BuildContext context) => PeopleProvider(null),
        update: (_, token, __) => PeopleProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, SalesReturnProvider>(
          create: (BuildContext context) => SalesReturnProvider(null),
        update: (_, token, __) => SalesReturnProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, SaleOrderProvider>(
          create: (BuildContext context) => SaleOrderProvider(null),
        update: (_, token, __) => SaleOrderProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, PaymentInProvider>(
          create: (BuildContext context) => PaymentInProvider(null),
        update: (_, token, __) => PaymentInProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, EstimateProvider>(
          create: (BuildContext context) => EstimateProvider(null),
        update: (_, token, __) => EstimateProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, PurchaseBillProvider>(
          create: (BuildContext context) => PurchaseBillProvider(null),
        update: (_, token, __) => PurchaseBillProvider(token.uid),
      ),ChangeNotifierProxyProvider<AuthProvider, PaymentOutProvider>(
          create: (BuildContext context) => PaymentOutProvider(null),
        update: (_, token, __) => PaymentOutProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, PurchaseReturnProvider>(
          create: (BuildContext context) => PurchaseReturnProvider(null),
        update: (_, token, __) => PurchaseReturnProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, PurchaseOederProvider>(
          create: (BuildContext context) => PurchaseOederProvider(null),
        update: (_, token, __) => PurchaseOederProvider(token.uid),
      ),
      ChangeNotifierProxyProvider<AuthProvider, ExpenseProvider>(
          create: (BuildContext context) => ExpenseProvider(null),
        update: (_, token, __) => ExpenseProvider(token.uid),
      ),

      ],
      child: MaterialApp(
        title: 'join bills',
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: true,
        locale: _locale,
        supportedLocales: const [Locale('en', '')],
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,
        home: Entry()
        
        
      ),
    );
  }
}
