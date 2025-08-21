

import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/widgets/side_nav.dart';
import 'package:webview_all/webview_all.dart';

class LayoutWhatsapp extends StatelessWidget {
  const LayoutWhatsapp({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: SideNav(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SizedBox(
          width: 100,
          child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text('Janela Whatsapp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            backgroundColor: Color(0xFF006a71),
          ),
        )
      ),
      body: MyBrowserWhatsapp()
    );
  }
}

class MyBrowserWhatsapp extends StatefulWidget {
  const MyBrowserWhatsapp({super.key, this.title});
  final String? title;
  
  @override
  _MyBrowserState createState() => _MyBrowserState();
}

class _MyBrowserState extends State<MyBrowserWhatsapp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Webview(url: "https://web.whatsapp.com")
      )
    );
  }
}