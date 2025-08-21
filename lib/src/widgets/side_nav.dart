import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SideNav extends StatefulWidget{
  const SideNav({super.key});

  @override
  State<SideNav> createState(){
    return SideNavState();
  }
}

class SideNavState extends State<SideNav>{
  @override
  Widget build(BuildContext context){
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.balance_sharp, color: currentRoute == '/auto-weight' ? Colors.white : Colors.black),
              title: Text("Terminal Pesagem", style: TextStyle(color: currentRoute == '/auto-weight' ? Colors.white : Colors.black)),
              selected: currentRoute == '/auto-weight',
              selectedTileColor: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/auto-weight');
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: currentRoute == '/layout-pedeaqui' ? Colors.white : Colors.black),
              title: Text("Pedeaqui", style: TextStyle(color: currentRoute == '/layout-pedeaqui' ? Colors.white : Colors.black)),
              selected: currentRoute == '/layout-pedeaqui',
              selectedTileColor: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/layout-pedeaqui');
              },
            ),
            ListTile(
              leading: Icon(Icons.phone, color: currentRoute == '/layout-whatsapp' ? Colors.white : Colors.black),
              title: Text("Whatsapp", style: TextStyle(color: currentRoute == '/layout-whatsapp' ? Colors.white : Colors.black)),
              selected: currentRoute == '/layout-whatsapp',
              selectedTileColor: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/layout-whatsapp');
              },
            ),
            ListTile(
              leading: Icon(Icons.tablet, color: currentRoute == '/layout-toten' ? Colors.white : Colors.black),
              title: Text("Toten", style: TextStyle(color: currentRoute == '/layout-toten' ? Colors.white : Colors.black)),
              selected: currentRoute == '/layout-toten',
              selectedTileColor: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/layout-toten');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Fechar"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
      )
    );
  }
}