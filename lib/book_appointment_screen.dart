// lib/screens/book_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/models/doctor.dart';
import 'package:myapp/services/database_service.dart';
import 'package:myapp/profile_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String _currentUserId = 'user123'; // Placeholder user ID
  final DatabaseService _databaseService = DatabaseService();

  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  String _selectedSpecialty = 'All';
  final List<String> _specialties = [
    'All',
    'Cardiology',
    'Orthopedics',
    'Dermatology',
    'Neurology',
    // Add more specialties as needed
  ];

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      List<Doctor> doctors =
          await _databaseService.fetchDoctors(); // Fetch doctors
      setState(() {
        _doctors = doctors;
        _filteredDoctors = _doctors;
      });
    } catch (e) {
      // Handle error (show a snackbar or message)
    }
  }

  void _filterDoctors(String specialty) {
    setState(() {
      _selectedSpecialty = specialty;
      if (specialty == 'All') {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors =
            _doctors.where((doctor) => doctor.specialty == specialty).toList();
      }
    });
  }

  void _searchDoctors(String query) {
    setState(() {
      _filteredDoctors =
          _doctors.where((doctor) {
            final nameLower = doctor.name.toLowerCase();
            final specialtyLower = doctor.specialty.toLowerCase();
            final queryLower = query.toLowerCase();
            return nameLower.contains(queryLower) ||
                specialtyLower.contains(queryLower);
          }).toList();
    });
  }

  void _navigateToDoctorDetailScreen(BuildContext context, Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                DoctorDetailScreen(doctor: doctor, userId: _currentUserId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'News Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _searchDoctors,
                  decoration: InputDecoration(
                    hintText: 'Search Doctor...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _specialties.length,
                  itemBuilder: (BuildContext context, int index) {
                    final specialty = _specialties[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _filterDoctors(specialty),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _selectedSpecialty == specialty
                                  ? Colors.deepPurple
                                  : Colors.grey[300],
                          foregroundColor:
                              _selectedSpecialty == specialty
                                  ? Colors.white
                                  : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(specialty),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildDoctorList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList(BuildContext context) {
    return _filteredDoctors.isEmpty
        ? const Center(child: Text('No doctors found.'))
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredDoctors.length,
          itemBuilder: (context, index) {
            final doctor = _filteredDoctors[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(doctor.imageUrl),
                  radius: 30,
                ),
                title: Text(doctor.name, style: const TextStyle(fontSize: 18)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(doctor.specialty), Text(doctor.hospital)],
                ),
                trailing: ElevatedButton(
                  onPressed:
                      () => _navigateToDoctorDetailScreen(context, doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Book Now'),
                ),
              ),
            );
          },
        );
  }
}

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({
    super.key,
    required this.doctor,
    required this.userId,
  });
  final Doctor doctor;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Doctor Detail')));
  }
}
