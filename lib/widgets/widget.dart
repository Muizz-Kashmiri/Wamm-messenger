import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Chatroom',
        style: TextStyle(
            color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold)),
    backgroundColor: Colors.black87,
    elevation: 0.0,
  );
}


ScrollController _scrollController;
  // ignore: unused_element
  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
