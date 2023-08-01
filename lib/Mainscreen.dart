import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vehicle_sort/vehicleList.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ElevatedButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VehicleListScreen()))
          },
          child: Text("Show Vehicle List"),
        )
      ]),
    );
  }
}
