import 'package:flutter/material.dart';
import 'package:myapp/book_appointment_screen.dart';
import 'package:myapp/models/doctor.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/news_feed_screen.dart';
import 'package:myapp/profile_screen.dart';

class DoctorInformationScreen extends StatefulWidget {
  @override
  State<DoctorInformationScreen> createState() =>
      _DoctorInformationScreenState();
}

class _DoctorInformationScreenState extends State<DoctorInformationScreen> {
  int _selectedBottomIndex = 0;
  int _selectedSegment = 0; // 0 for Doctor, 1 for Hospital
  final TextEditingController _searchController = TextEditingController();

  final List<Doctor> _doctors = [
    Doctor(
      doctorId: "1",
      name: "Dr. Mamun Mostafi",
      specialty: "Cardiologist",
      hospital: "Dhaka Medical Hospital",
      
      availability: ["9 AM - 5 PM"],
      imageUrl: "assets/images/user_placeholder.png",
    ),
    Doctor(
      doctorId: "2",
      name: "Dr. Md. Abdul Wahab Khan",
      specialty: "Neurologist",
      hospital: "Apollo Hospital",
      
      availability: ["10 AM-6 PM"],
      imageUrl: "assets/images/user_placeholder.png",
    ),
    Doctor(
      doctorId: "3",
      name: "Dr. Imtiaz Faruk",
      specialty: "Orthopedist",
      hospital: "Square Hospital",
      
      availability: ["8 AM - 4 PM"],
      imageUrl: "assets/images/user_placeholder.png",
    ),
    Doctor(
      doctorId: "4",
      name: "Dr. Md. Sahbub Alam",
      specialty: "Pediatrician",
      hospital: "United Hospital",
      
      availability: ["11 AM - 7 PM"],
      imageUrl: "assets/images/user_placeholder.png",
    ),
  ];

  final List<Map<String, dynamic>> _hospitals = [
    {
      'hospitalId': '1',
      'name': 'Ibn Sina Specialized Hospital',
      'imageUrl': 'assets/images/hospital_placeholder.png',
      'address': '1/A Dhanmondi, Dhaka',
      'hotline': "09610110110",
      'email': "info@ibnsinatrust.com",
    },
    {
      'hospitalId': '2',
      'name': 'United Hospital Limited',
      'address': 'Plot 15, Road 71, Gulshan, Dhaka',
      'imageUrl': 'assets/images/hospital_placeholder.png',
    },
    {
      'hospitalId': '3',
      'name': 'Square Hospitals Ltd',
      'address': '18/F, Bir Uttam Qazi Nuruzzaman Sarak, Dhaka',
      'imageUrl': 'assets/images/hospital_placeholder.png',
    },
  ];

  List<Doctor> _filteredDoctors = [];
  List<Map<String, dynamic>> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = List.from(_doctors);
    _filteredHospitals = List.from(_hospitals);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
      if (_selectedBottomIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (_selectedBottomIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
        );
      } else if (_selectedBottomIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  void _onSegmentChanged(int index) {
    setState(() {
      _selectedSegment = index;
    });
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _doctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(query.toLowerCase()) ||
              doctor.specialty.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterHospitals(String query) {
    setState(() {
      _filteredHospitals = _hospitals
          .where((hospital) => (hospital['name'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeroImage(),
          _buildSearchBar(),
          _buildSegmentedControl(),
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Information'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/post_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _selectedSegment == 0
              ? _filterDoctors(value)
              : _filterHospitals(value);
        },
        decoration: InputDecoration(
          hintText: 'Search Specialist',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onSegmentChanged(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedSegment == 0
                      ? const Color(0xFF9A75F9)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Doctor',
                    style: TextStyle(
                      color: _selectedSegment == 0
                          ? Colors.white
                          : const Color(0xFF9A75F9),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _onSegmentChanged(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedSegment == 1
                      ? const Color(0xFF9A75F9)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Hospital',
                    style: TextStyle(
                      color: _selectedSegment == 1
                          ? Colors.white
                          : const Color(0xFF9A75F9),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return _selectedSegment == 0 ? _buildDoctorList() : _buildHospitalList();
  }

  Widget _buildDoctorList() {
    return ListView.builder(
      itemCount: _filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = _filteredDoctors[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0D9F9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: doctor.imageUrl.isNotEmpty && doctor.imageUrl.startsWith('assets/images')
                    ? AssetImage(doctor.imageUrl) 

                    : const AssetImage('assets/images/user_placeholder.png'),
                  ),
                ),

                Expanded(
                  child: Text(doctor.name, style: const TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  BookAppointmentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF9A75F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Mor info'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHospitalList() {
    return ListView.builder(
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = _filteredHospitals[index];
        final hospitalName = hospital['name']?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0D9F9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/hospital_placeholder.png'),
                  ),
                ),
                Expanded(
                  child: Text(hospitalName, style: const TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add more details screen if needed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF9A75F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Mor info'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined), label: 'News Feed'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
      currentIndex: _selectedBottomIndex,
      selectedItemColor: const Color(0xFF9A75F9),
      onTap: _onItemTapped,
    );
  }
}
