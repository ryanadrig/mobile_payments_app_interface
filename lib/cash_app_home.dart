import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cash_app_interface/ca_globals.dart';
import 'package:cash_app_interface/creditcard_lvi.dart';
import 'package:cash_app_interface/recent_benef_lvi.dart';
import 'package:cash_app_interface/recent_trans_lvi.dart';
import 'package:cash_app_interface/ca_state.dart';
import 'package:cash_app_interface/AppStateModel.dart';

class CashHomePage extends StatefulWidget {
  const CashHomePage({Key? key}) : super(key: key);

  @override
  _CashHomePageState createState() => _CashHomePageState();
}

class _CashHomePageState extends State<CashHomePage> {

  ScrollController card_scroll_controller = ScrollController();

  AppStateContainerState? asc ;
  AppState? state;

  @override
  Widget build(BuildContext context) {
    ss = MediaQuery.of(context).size;

    asc = AppStateContainer.of(context);
    state = asc!.state;

    return SafeArea(child: Scaffold(
      body: Stack(children:[
        Image.asset(
          "assets/images/bm_bg_op.png",
          width:ss.width,
          height:ss.height,
          fit: BoxFit.cover,) ,
        Container(
        height: ss.height,
        child:Column(children: [
          // toolbar
          Container(height: ss.height * .08,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
          Transform.rotate(
            angle: math.pi / 4,
            child:
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none)))
          ],)),

          //card row
          Container(height: ss.height * .28,
          child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state!.user_card_data.length,
              controller: card_scroll_controller,
              itemBuilder: (context,card_idx){
                    return CreditCardLVI(card_data: state!.user_card_data[card_idx],
                      card_idx: card_idx,
                      scroll_controller : card_scroll_controller,
                    );
          })),

          Container(height: ss.height * .13,
              child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: benef_data.length,
                  itemBuilder: (context, benef_idx){
                    if (benef_idx == 0){
                      return
                      Padding(
                              padding: EdgeInsets.symmetric(horizontal:ss.width*.04),
                          child:
                        Container(height: ss.height * .13,
                            child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                      height: ss.height * .09,
                                      width:ss.height * .09,
                                      decoration:
                                      BoxDecoration(
                                          border: Border.all(color:Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.circular(ss.height * .045)),
                                      child: Center(child: Icon(Icons.arrow_forward_outlined))
                                  ),

                                  Container(
                                      padding: EdgeInsets.only(top:ss.width*.01),
                                      height: ss.height * .025,
                                      child:Text("Send",
                                        style: TextStyle(fontSize: ss.height * .02),))

                                ])));
                    }
                    return RecentBFS_LVI(
                      benef: benef_data[benef_idx - 1]);
                  })),


          Container(
              padding: EdgeInsets.only(left:ss.width*.03),
              height: ss.height * .04,
                      child:Row(children:[ Text("Recent Transactions")])),
          // Container(height: ss.height * .4,
          Expanded(
                  child:
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state!.trans_data.length,
                      itemBuilder: (context, trans_idx){
                        return RecentTrans_LVI(
                            trans: state!.trans_data[trans_idx], trans_idx: trans_idx);
                      })),


        ],)
      )]),
    ));
  }
}








