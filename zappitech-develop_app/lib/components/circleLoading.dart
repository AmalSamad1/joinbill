import 'package:flutter/material.dart';
import 'package:ziptech/flutter_flow/flutter_flow_theme.dart';

Widget circleLoading(BuildContext ctx,{Color? clr }) {
 return Center(
    child: CircularProgressIndicator(color:clr == null? FlutterFlowTheme.of(ctx).primaryColor:clr),
  );
}
