import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/index.dart';
import 'package:ziptech/providers/authProvider.dart';

import 'components/circleLoading.dart';
import 'view/dashboard/home_widget.dart';
import 'view/on_boarding/on_boarding_widget.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthProvider>(context, listen: false).autoLogin(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Image.asset(
                    '',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                circleLoading(context)
              ],
            ),
          );
        } else {
          return Consumer<AuthProvider>(builder: (context, authData, _) {
            print(authData.uid);
            print(authData.isAuth);
            return authData.isAuth ? DashboardWidget() : HomePageWidget();
          });
        }
      },
    );
  }
}
