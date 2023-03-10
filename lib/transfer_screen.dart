import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cash_app_interface/ca_globals.dart';
import 'package:cash_app_interface/numkeypad.dart';
import 'package:cash_app_interface/transfer_success_screen.dart';
import 'package:cash_app_interface/ca_state.dart';
import 'package:cash_app_interface/AppStateModel.dart';

class TransferScreen extends StatefulWidget {
   TransferScreen({Key? key, required this.benef, required this.user_card}) : super(key: key);

  Map benef;
  Map user_card;

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {

  AppStateContainerState? asc;
  AppState? state;

  int entered_amount = 0;

  update_entered() {
    if (entered_amount == 0 && g_numkey_val != 100) {
      setState(() {
        entered_amount = g_numkey_val;
      });
    }
    else if (g_numkey_val == 100){
      String ea_str = entered_amount.toString();
      if (ea_str.length >1) {
        setState(() {
          entered_amount =
              int.parse(ea_str.substring(0, ea_str.length - 1));
          // entered_amount = g_test;
        });
      }
      else{
        setState(() {
          entered_amount = 0;
        });
      }
    }
    else if (g_numkey_val != 100){
      setState(() {
        entered_amount =
            int.parse(entered_amount.toString() + g_numkey_val.toString());
        // entered_amount = g_test;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    asc = AppStateContainer.of(context);
    state = asc!.state;

    return SafeArea(child: Scaffold(
      body:
      Stack(children:[
        Image.asset(
        "assets/images/bm_bg_op.png",
        width:ss.width,
        height:ss.height,
        fit: BoxFit.cover,) ,
      Container(height: ss.height,
      // child:Column(children: [
        child:ListView(children:[
        Container(height: ss.height * .06,
        child:Stack(children:[
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children:[Text("Transferring")] ,),
          Row(mainAxisAlignment: MainAxisAlignment.start,
            children:[IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back))] ,)
        ])),

        Container(
          height: ss.height * .3,
              child:Column(children: [
                Container(
                    height: ss.height * .16,
                    width: ss.height * .16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ss.height * .08),
                      border: Border.all(color: Colors.grey[400]!,
                        width: ss.height * .02)),
                        child:  ClipRRect(
                            borderRadius: BorderRadius.circular(ss.height * .08),
                            child:Image.asset(widget.benef["pp_path"],
                          height: ss.height * .16,
                          width: ss.height * .16,
                        fit: BoxFit.contain,))
                  ),
                Container(
                      padding:EdgeInsets.only(top:ss.width*.02),
                    child:Text(widget.benef["name"])
                ),
                Container(
                  child: Text("**** **** ****" + widget.benef["last_four"],
                                style: TextStyle(fontSize: ss.width*.03,
                                )             ,)
                ),

                Container(
                  padding:EdgeInsets.only(top:ss.width*.02),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  border: Border(bottom:BorderSide(
                      color: Colors.white,width:1.0))
                  ),
                    child: Text("\$" + entered_amount.toString(),
                              style: TextStyle(fontSize: ss.width*.06),)
                ),


          ],),

        ),

        Expanded(child:
        Container(
                  width: ss.width*.7,
        // child:ListView(children:[
child: Column(children:[
        OnScreenNumericKeypad(refresh: update_entered,),

            Container(height: ss.width*.02,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Padding(
              padding:EdgeInsets.all(ss.width*.03),
          child:
          GestureDetector(
              onTap: (){
                DateTime today = new DateTime.now();
                String dateSlug ="${months[today.month]} ${today.day.toString().padLeft(2,'0')}, ${today.year.toString()}";
                print(dateSlug);

                state!.trans_data.insert(0,
                {"trans_user": widget.benef["name"],
                "date": dateSlug,
                "amount": entered_amount.toString() + ".00",
                "cod": "debit"
                });

                String oldBalance = widget.user_card["balance"];

                String balance_deci = "00";
                if (widget.user_card["balance"].contains(".")) {
                   balance_deci = widget.user_card["balance"].split(
                      ".")[1];
                }
                    print("pre parse balance balance:: " + widget.user_card["balance"]);

                String newBalance = (int.parse(widget.user_card["balance"].replaceAll(",","").split(".")[0]) - entered_amount).toString();
                    print("new palance post parse ::: " + newBalance);

                String newBalanceFormat =
                    formatAmount(newBalance);
                  if (balance_deci == "00"){
                    state!.user_card_data[state!.card_chosen_idx]["balance"] =
                        newBalanceFormat;
                  }else {
                    state!.user_card_data[state!.card_chosen_idx]["balance"] =
                        newBalanceFormat + "." + balance_deci;
                  }
                    asc!.updateState();


                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return TransferSuccessScreen(benef:widget.benef, amount: entered_amount, user_card: widget.user_card, old_balance: oldBalance);
                }));
              },
              child:Container(
            width:ss.width*.6,
              height: ss.width*.18,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(ss.width*.08),
                color: Colors.white,
              ),
              child:Center(child:Text("Transfer",
                                      style: TextStyle(color:Colors.black),)))))])

        ])))

      ],)
      )])
    ));
  }
}




