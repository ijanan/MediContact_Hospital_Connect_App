import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/models/doctor.dart';
import 'profile_screen.dart';

import 'doctor_information_screen.dart';

class DoctorsSpecialtyScreen extends StatefulWidget { 
  const DoctorsSpecialtyScreen({Key? key}) : super(key: key);

  @override
  DoctorsSpecialtyScreenState createState() => DoctorsSpecialtyScreenState();
}

class DoctorsSpecialtyScreenState extends State<DoctorsSpecialtyScreen> {
  int _selectedBottomIndex = 0;
  final List<Doctor> _doctors = [
    Doctor(
      doctorId: '1',
      name: 'Dr. John Doe',
      specialty: 'Dentist',
      imageUrl: 'https://via.placeholder.com/150',
      hospital: 'Hospital A',
      availability: ['Monday - Friday'],
    ),
    Doctor(
      doctorId: '2',
      name: 'Dr. Jane Smith',
      specialty: 'Cardiologist',
      hospital: 'Hospital B',
      imageUrl: 'https://via.placeholder.com/150',
      availability: ['Tuesday - Saturday'],
    ),
    Doctor(
      doctorId: '3',
      name: 'Dr. David Lee',
      specialty: 'Orthopaedist',
      hospital: 'Hospital C',
      imageUrl: 'https://via.placeholder.com/150',
      availability: ['Wednesday - Sunday'],
    ),
    Doctor(
      doctorId: '4',
      name: 'Dr. Sarah Chen',
      specialty: 'Neurologist',
      hospital: 'Hospital A',
      imageUrl: 'https://via.placeholder.com/150',
      availability: ['Monday - Thursday'],
    ),
  ];
  final List<String> specialties = [
    'Dentist',
    'Cardiologist',
    'Orthopaedist',
    'Neurologist',
    'Pediatrician',
    'Dermatologist',
    'Gynecologist'
  ];
  String? _selectedSpecialtyItem; // selected item rename

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
        if (_selectedBottomIndex == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (_selectedBottomIndex == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    });
  }

  Widget SpecialtyIcon({
    required IconData iconData,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _selectedSpecialtyItem == label ? const Color(0xFF9A75F9): Colors.grey[200],
              child: Icon(iconData, size: 30, color: _selectedSpecialtyItem == label ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }


  void _onSpecialtySelected(String? specialty) {
    setState(() {
      _selectedSpecialtyItem = specialty;
    });
  }

  List<Doctor> _getFilteredDoctors() {
    if (_selectedSpecialtyItem == null) {
      return [];
    } else {
      return _doctors.where((doctor) => doctor.specialty == _selectedSpecialtyItem).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors Specialty'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: specialties
                    .map(
                      (specialty) => SpecialtyIcon(
                        iconData: getIconForSpecialty(specialty),
                        label: specialty,
                        onPressed: () => _onSpecialtySelected(specialty),
                      ),
                    )
                    .toList()),
          ),
          _selectedSpecialtyItem == null ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text("Please select a specialty")),
          ) :  Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _getFilteredDoctors().length,
                itemBuilder: (context, index) {
                  final doctor = _getFilteredDoctors()[index];
                  return _buildDoctorCard(doctor);
                },
              ),
            ),
          ),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News Feed',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),

              label: 'Profile',
            ),
          ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: const Color(0xFF9A75F9),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(doctor.imageUrl),
        ),
        title: Text(doctor.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialty: ${doctor.specialty}'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorInformationScreen()),
          );
        },
      ),
    );
  }

  IconData getIconForSpecialty(String specialty) {
    switch (specialty) {
      case 'Dentist':
        return Icons.local_hospital;
      case 'Cardiologist':
        return Icons.monitor_heart;
      case 'Orthopaedist':
        return Icons.accessibility_new;
      case 'Neurologist':
        return Icons.psychology;
      case 'Pediatrician':
        return Icons.child_care;
      case 'Dermatologist':
        return Icons.face_retouching_natural;
      case 'Gynecologist':
        return Icons.woman;
      default:
        return Icons.medical_services;
    }
  }
}
