import 'package:flutter/material.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class ModalService {
  static void showImportantMessage(String title, String message, List<Widget> actions){
    final context = navigatorKey.currentContext;

    if(context == null) return;

    showDialog(context: context, builder: (context)=>AlertDialog(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
      title: Text(title),
      content: Text(message),
      actions: actions,
    ));
  }
}