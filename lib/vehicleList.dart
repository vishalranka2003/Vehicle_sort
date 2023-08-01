import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String model;
  final int fuelEfficiency;
  final int manufactureYear;

  Vehicle(
      {required this.model,
      required this.fuelEfficiency,
      required this.manufactureYear});
}

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Vehicles').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final vehicles = snapshot.data!.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>?;

                if (data == null) {
                  return null;
                }

                return Vehicle(
                  model: data['name'] ??
                      'Vishal', // Provide default value for 'Vehicle name'
                  fuelEfficiency: data['Mileage'] ??
                      '0' ??
                      0, // Provide default value for 'Mileage'
                  manufactureYear: data['launchYear'] ??
                      '0' ??
                      0, // Provide default value for 'Launch year'
                );
              })
              .where((vehicle) => vehicle != null)
              .toList();
// Remove null vehicles
          return ListView.separated(
            itemCount: vehicles.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.red[400],
              height: 3,
            ),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              Color color = Colors.red;

              if (vehicle!.fuelEfficiency >= 15) {
                if (DateTime.now().year - vehicle.manufactureYear <= 5) {
                  color = Colors.green;
                } else {
                  color = Colors.amber;
                }
              }

              return ListTile(
                tileColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  vehicle.model,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Fuel Efficiency: ${vehicle.fuelEfficiency} km/l\n'
                  'Manufacture Year: ${vehicle.manufactureYear}',
                  style: TextStyle(fontSize: 16),
                ),
                leading: CircleAvatar(
                  backgroundColor: color,
                  backgroundImage: AssetImage('lib/assets/images/ecocar.png'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
