import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vehicle_sort/newVehicle.dart';
import 'package:vehicle_sort/vehicleList.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Sorting App'),
      ),
      body: Container(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 250,
              child: FloatingActionButton.extended(
                label: Text("Show Vehicle List"), // <-- Text
                backgroundColor: Colors.black54,
                icon: Icon(
                  // <-- Icon
                  Icons.list,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleListScreen()));
                },
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              width: 250,
              child: FloatingActionButton.extended(
                label: Text("Add New Vehicle"), // <-- Text
                backgroundColor: Colors.black54,
                icon: Icon(
                  // <-- Icon
                  Icons.add,
                  size: 24.0,
                ),
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addVehicle()))
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
