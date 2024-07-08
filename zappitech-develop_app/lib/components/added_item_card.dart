import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/item_add_bill_provider.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'item_add_to_bill_widget.dart';

Widget itemAddedCard(
    {required BuildContext ctx,
    String? itemName,
    double? quantity,
    String? units,
    double? pricePerUnit,
    double? discount,
    double? discountPercent,
    String? taxName,
    double? tax,
    double? total,
    bool isEdit = false,
    required int index}) {
  return  Column(
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
                    Text(itemName ?? "",
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
                    Text("Quantity",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500),)),
                    Text("$quantity $units",
                        style: new TextStyle(
                          fontWeight: FontWeight.w500,)),

                  ],
                ),

                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align( alignment: Alignment.topCenter, child:
                    Text("Price/$units",
                        style: new TextStyle(
                          fontWeight: FontWeight.w500,)),),
                    Text("₹ $pricePerUnit",
                        style: new TextStyle(
                          fontWeight: FontWeight.w500,) ),

                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align( alignment: Alignment.topCenter, child:
                    Text("Tax",
                        style: new TextStyle(
                          fontWeight: FontWeight.w500,) ),),
                    Text("$taxName",
                        style: new TextStyle(
                          fontWeight: FontWeight.w500,)  ),

                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align( alignment: Alignment.topCenter, child:
                    Text("Total Amount",
                        style: new TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,) ),),
                    Text("₹ ${total?.toStringAsFixed(2)}",
                        style: new TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,) ),


                  ],
                ),
                Divider(thickness: 1,),
                isEdit?Container(): IntrinsicHeight( //wrap Row with this, otherwise, vertical divider will not display
                    child:Consumer<ItemAddBill>(
                        builder: (context, itemsData, child)=>Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SaleInvoiceItemAddWidget(index: index, isEdit: true),),);
                            },
                            child: Center(child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SaleInvoiceItemAddWidget(index: index, isEdit: true),),);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,size: 20,color: Colors.black,),
                                  Text("   Edit",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15))
                                ],
                              ),
                            )),
                          )
                        ),


                        VerticalDivider(
                         //color of divider
                          //width space of divider
                          thickness: 1, //thickness of divier line
                          // indent: 10, //Spacing at the top of divider.
                          // endIndent: 10, //Spacing at the bottom of divider.
                        ),


                        Expanded(
                            child: InkWell(
                              onTap: (){
                                itemsData.deleteFromItem(index);
                              },
                              child: Center(child: TextButton(
                                onPressed: () {itemsData.deleteFromItem(index);  },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete,size: 20,color: Colors.black,),
                                    Text("   Delete",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15))
                                  ],
                                ),
                              )),
                            )
                        ),
                      ],
                    )
                )
                )
              ],
            ),
          ),
        ),


      ]
  );
  //   Container(
  //   width: MediaQuery.of(ctx).size.width,
  //   height: 120,
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     boxShadow: [
  //       BoxShadow(
  //         blurRadius: 12,
  //         color: Color(0x34000000),
  //         offset: Offset(-2, 5),
  //       )
  //     ],
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  //   child: Padding(
  //     padding: EdgeInsetsDirectional.fromSTEB(4, 4, 12, 4),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
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
  //                   itemName ?? "",
  //                   style: FlutterFlowTheme.of(ctx).bodyText1.override(
  //                         fontFamily: 'Lexend Deca',
  //                         color: Color(0xFF4B39EF),
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                 ),
  //                 Text(
  //                   'Quantity : $quantity $units',
  //                   style: FlutterFlowTheme.of(ctx).bodyText1.override(
  //                         fontFamily: 'Lexend Deca',
  //                         color: Color(0xFF57636C),
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                       ),
  //                 ),
  //                 Text(
  //                   'Price/$units : ₹ $pricePerUnit',
  //                   style: FlutterFlowTheme.of(ctx).bodyText1.override(
  //                         fontFamily: 'Lexend Deca',
  //                         color: Color(0xFF57636C),
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                       ),
  //                 ),
  //                 Text(
  //                   'Tax $taxName',
  //                   style: FlutterFlowTheme.of(ctx).bodyText1.override(
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
  //         Padding(
  //           padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Padding(
  //                 padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 8),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Column(
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
  //                           child: Text(
  //                             '₹${total.toStringAsFixed(2)}',
  //                             style: FlutterFlowTheme.of(ctx).title3.override(
  //                                   fontFamily: 'Lexend Deca',
  //                                   color: Color(0xFF1D2429),
  //                                   fontSize: 20,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                           ),
  //                         ),
  //                         isEdit?Container(): Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 4),
  //                           child: Consumer<ItemAddBill>(
  //                             builder: (context, itemsData, child) => Row(
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                IconButton(
  //                                     onPressed: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           builder: (context) =>
  //                                               SaleInvoiceItemAddWidget(
  //                                                   index: index, isEdit: true),
  //                                         ),
  //                                       );
  //                                     },
  //                                     icon: Icon(
  //                                       Icons.edit,
  //                                       color: Colors.orange,
  //                                     )),
  //                                 SizedBox(
  //                                   width: 4,
  //                                 ),
  //                                 IconButton(
  //                                     onPressed: () {
  //                                       itemsData.deleteFromItem(index);
  //                                     },
  //                                     icon: Icon(
  //                                       Icons.delete,
  //                                       color: Colors.red,
  //                                     ))
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}
