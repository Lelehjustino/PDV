

import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/views/products_page.dart';
import 'package:nubi_pdv/src/widgets/side_nav.dart';
import 'package:nubi_pdv/src/views/side_bar.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

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
            title: Text('Nubi PDV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            backgroundColor: Color(0xFF006a71),
          ),
        )
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {

                  bool isMobile = constraints.maxWidth < 800;

                  return Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    children: [
                      Expanded(
                        child: ProductsPage()
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? double.infinity : 500,
                          maxHeight: isMobile ? 300 : double.infinity,
                          minWidth: isMobile ? double.infinity : 400
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          // child: SideBar(),
                        ) ,
                      ),
                    ],
                  );
                }
              ) 
            ),
          ],
        ),
      ),
    );
  }
}