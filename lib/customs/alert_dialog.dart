import 'package:flutter/material.dart';
import 'package:get/get.dart';

showAlertDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          width: 10,
        ),
        Container(
            margin: const EdgeInsets.only(left: 5), child: Text(text)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertDialogWidgetYesOrNo(String s, {height}) {
  return SizedBox(
    height: height ?? 120,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(s),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: InkWell(
                onTap: () {
                  Get.back(result: true);
                },
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                    ],
                    borderRadius:
                    const BorderRadius.all(Radius.circular(3.0)),

                  ),
                  child: const Center(child: Text('예')),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            Flexible(
              child: InkWell(
                onTap: () {
                  Get.back(result: false);
                },
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(3.0)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                    ],
                  ),
                  child: const Center(child: Text('아니오')),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

alertDialogWidgetWrite() {
  return Container(
    height: 150,
    // decoration: BoxDecoration(
    //     // color: Colors.white,
    //     gradient: LinearGradient(
    //         colors: [Colors.amber, Colors.amber]),
    //     boxShadow: const [
    //       BoxShadow(
    //           color: Colors.black26,
    //           offset: Offset(0, 4),
    //           blurRadius: 5.0)
    //     ],
    //     borderRadius: const BorderRadius.all(Radius.circular(8.0))),


    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: InkWell(
            onTap: () {
              Get.back(result: true);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                // color: Colors.black,
                    gradient: const LinearGradient(
                        colors: [Colors.black, Colors.white]),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                ],
                borderRadius:
                const BorderRadius.all(Radius.circular(3.0)),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ImageIcon(AssetImage('assets/icons/quest3.png'), size: 40, color: Colors.white),
                  Text('Quest 추가', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20,),
        Flexible(
          child: InkWell(
            onTap: () {
              Get.back(result: false);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                // color:Colors.white,
                gradient: const LinearGradient(
                    colors: [Colors.white, Colors.black]),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius:
                const BorderRadius.all(Radius.circular(3.0)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ImageIcon(AssetImage('assets/icons/box4.png'), size: 40, color: Colors.white),
                  Text('NPC 추가', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

alertDialogWidgetCircularProgressIndicator(String s) {
  return Row(
    children: [
      const CircularProgressIndicator(),
      const SizedBox(
        width: 10,
      ),
      Container(
          margin: const EdgeInsets.only(left: 5), child: Text(s)),
    ],
  );
}
