import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/news_feed_screen.dart';
import 'profile_screen.dart';
import 'package:myapp/models/hospital.dart';
import 'package:myapp/models/doctor.dart';

List<Doctor> placeholderDoctors = [
  Doctor(doctorId: 'd1', name: 'Dr. Mamun Mostafi', specialty: 'Cardiology', hospital: 'City Hospital', availability: ['9am-5pm'], imageUrl: 'assets/images/user_placeholder.png'),
  Doctor(doctorId: 'd2', name: 'Dr. Md. Abdul Wahab Khan', specialty: 'Neurology', hospital: 'General Hospital', availability: ['10am-6pm'], imageUrl: 'assets/images/user_placeholder.png'),
  Doctor(doctorId: 'd3', name: 'Dr. Imtiaz Faruk', specialty: 'Orthopedics', hospital: 'Specialized Hospital', availability: ['8am-4pm'], imageUrl: 'assets/images/user_placeholder.png'),
  Doctor(doctorId: 'd4', name: 'Dr. Md. Sahbub Alam', specialty: 'Dermatology', hospital: 'Skin Care Clinic', availability: ['11am-7pm'], imageUrl: 'assets/images/user_placeholder.png'),
];

// Hospital Detail Screen
class HospitalDetailsScreen extends StatefulWidget {
  final Hospital hospital;
  const HospitalDetailsScreen({Key? key, required this.hospital}) : super(key: key);

  @override
  HospitalDetailsScreenState createState() => HospitalDetailsScreenState();
}

class HospitalDetailsScreenState extends State<HospitalDetailsScreen> {
  int _selectedBottomIndex = 0;
  String _selectedSegment = 'Hospital';
  String _searchQuery = "";
  List<Hospital> placeholderHospitals = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsFeedScreen()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          break;
      }
    });
  }

  void _onSegmentChanged(String segment) {
    setState(() {
      _selectedSegment = segment;
      _searchQuery = ''; // Clear search when segment changes
    });
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: ['Doctor', 'Hospital'].map((segment) {
          return Expanded(
            child: GestureDetector(
              onTap: () => _onSegmentChanged(segment),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: _selectedSegment == segment ? const Color(0xFF9A75F9) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    segment,
                    style: TextStyle(
                      color: _selectedSegment == segment ? Colors.white : const Color(0xFF9A75F9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: _selectedSegment == "Doctor" ? "Search Specialist" : "Search Hospital",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  List<dynamic> _getFilteredList() {
    if (_selectedSegment == 'Hospital') {
      return placeholderHospitals.where((hospital) =>
          hospital.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    } else {
      return placeholderDoctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  Widget _buildListItem(dynamic item) {
    if (item is Doctor) {
      return _buildDoctorItem(item);
    } else if (item is Hospital) {
      return _buildHospitalItem(item);
    }
    return const SizedBox.shrink();
  }

  Widget _buildHospitalItem(Hospital hospital) {
    return Card(
      color: Colors.purple.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              hospital.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(hospital.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(
              onPressed: () {
                // Implement navigation to hospital details screen
              },
              child: const Text('More info', style: TextStyle(color: Color(0xFF9A75F9))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorItem(Doctor doctor) {
    return Card(
      color: Colors.purple.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              doctor.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(doctor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(
              onPressed: () {
                // Implement navigation to doctor details screen
              },
              child: const Text('More info', style: TextStyle(color: Color(0xFF9A75F9))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information', style: TextStyle(color: Color(0xFF9A75F9))),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9A75F9)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          Image.asset(
            'assets/images/hospital_placeholder.png',
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          _buildSearchBar(),
          _buildSegmentedControl(),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredList().length,
              itemBuilder: (context, index) {
                return _buildListItem(_getFilteredList()[index]);
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News Feed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: const Color(0xFF9A75F9),
        onTap: _onItemTapped,
      ),
    );
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Invalid Month';
    }
  }
}
