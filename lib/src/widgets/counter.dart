import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:provider/provider.dart';

class Counter extends StatefulWidget{
  final Item item;

  const Counter({
    super.key,
    required this.item
  });

  @override
  State<Counter> createState() {
    return CounterState();
  }

}

class CounterState extends State<Counter>{


  

  @override
  Widget build(BuildContext context){
    final pedidoController = Provider.of<PedidoController>(context);
    return Row(
      children: [

        InkWell(
          onTap: () {
            pedidoController.removeOneCounter(widget.item);
          },
          child: Container(
            height: 18,
            width: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              Icons.remove,
              size: 18,
              color: Colors.white
            )
          )
        ),

        SizedBox(width: 10),

        Text(
          "${widget.item.quantidade.toInt()}",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),

        SizedBox(width: 10),

        InkWell(
          onTap: () {
            pedidoController.addOneCounter(widget.item);
          },
          child:Container(
            height: 18,
            width: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              Icons.add,
              size: 18,
              color: Colors.white
            )
          ),
        ),
        SizedBox(width: 10),


      ],
    );
  }
}