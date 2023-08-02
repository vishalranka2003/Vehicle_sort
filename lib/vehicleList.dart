import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_sort/newVehicle.dart';
import 'package:vehicle_sort/vehicle_class.dart';

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(Icons.add), // <-- Text
        backgroundColor: Colors.black,
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addVehicle()))
        },
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
                  id: doc.id,
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
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              Color color = Colors.red;

              if (vehicle!.fuelEfficiency >= 15) {
                if (DateTime.now().year - vehicle.manufactureYear <= 5 &&
                    DateTime.now().year - vehicle.manufactureYear >= 0) {
                  color = Colors.green;
                } else {
                  color = Colors.amber;
                }
              }

              return GestureDetector(
                  onTap: () {
                    // Show the details dialog when the ListTile is tapped
                    showDialog(
                      context: context,
                      builder: (context) =>
                          VehicleDetailsDialog(vehicle: vehicle),
                    );
                  },
                  child: ListTile(
                    tileColor: color,
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
                      backgroundImage:
                          AssetImage('lib/assets/images/ecocar.png'),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, vehicle);
                      },
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}

class VehicleDetailsDialog extends StatelessWidget {
  final Vehicle vehicle;

  VehicleDetailsDialog({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Vehicle Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Model: ${vehicle.model}'),
          Text('Fuel Efficiency: ${vehicle.fuelEfficiency} km/l'),
          Text('Manufacture Year: ${vehicle.manufactureYear}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, Vehicle vehicle) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this entry?'),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('Vehicles')
                .doc(vehicle.id)
                .delete();
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    ),
  );
}
