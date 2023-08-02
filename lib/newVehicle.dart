import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_sort/components/my_textfield.dart';
import 'package:vehicle_sort/vehicleList.dart';
import 'package:vehicle_sort/vehicle_class.dart';

class addVehicle extends StatefulWidget {
  @override
  State<addVehicle> createState() => _addVehicleState();
}

class _addVehicleState extends State<addVehicle> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController launchYearController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mileageController.dispose();
    launchYearController.dispose();
  }

  Future addNewVehicle() async {
    await FirebaseFirestore.instance.collection('Vehicles').add({
      'name': nameController.text,
      'Mileage': int.parse(mileageController.text),
      'launchYear': int.parse(launchYearController.text),
    });
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text("Vehicle Succesfully addded"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VehicleListScreen())); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add new Vehicle'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    // keyboardType: TextInputType.number,
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: nameController,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Vehicle Name",
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
                const SizedBox(height: 10),
                // password textfield
                MyTextField(
                  controller: mileageController,
                  hintText: 'Mileage',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // password textfield
                MyTextField(
                  controller: launchYearController,
                  hintText: 'Launch Year',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 25),
                ElevatedButton(onPressed: addNewVehicle, child: Text("Enter"))
              ],
            ),
          ),
        ));
  }
}
