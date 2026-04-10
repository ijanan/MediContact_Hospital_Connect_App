import 'package:flutter/material.dart';
import 'package:myapp/book_appointment_screen.dart';
import 'package:myapp/models/doctor.dart';

class DoctorInformationScreen extends StatefulWidget {
  const DoctorInformationScreen({super.key});

  @override
  State<DoctorInformationScreen> createState() =>
      _DoctorInformationScreenState();
}

class _DoctorInformationScreenState extends State<DoctorInformationScreen> {
  int _selectedSegment = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Doctor> _doctors = [
    Doctor(
      doctorId: '1',
      name: 'Dr. Tanvir Hossain',
      specialty: 'Cardiology',
      hospital: 'Square Hospitals Ltd, Dhaka',
      availability: ['10:00 AM - 1:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
    Doctor(
      doctorId: '2',
      name: 'Dr. Sharmin Akter',
      specialty: 'Gynecology & Obstetrics',
      hospital: 'Labaid Specialized Hospital, Dhanmondi',
      availability: ['5:00 PM - 8:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
    Doctor(
      doctorId: '3',
      name: 'Dr. Mahmudul Islam',
      specialty: 'Neurology',
      hospital: 'Evercare Hospital Dhaka',
      availability: ['9:00 AM - 12:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
    Doctor(
      doctorId: '4',
      name: 'Dr. Ayesha Siddika',
      specialty: 'Pediatrics',
      hospital: 'Dhaka Medical College Hospital',
      availability: ['4:00 PM - 7:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
  ];

  final List<Map<String, String>> _hospitals = [
    {
      'name': 'Square Hospitals Ltd',
      'address': 'West Panthapath, Dhaka',
      'hotline': '10616',
    },
    {
      'name': 'Evercare Hospital Dhaka',
      'address': 'Bashundhara R/A, Dhaka',
      'hotline': '10678',
    },
    {
      'name': 'Ibn Sina Specialized Hospital',
      'address': 'Dhanmondi, Dhaka',
      'hotline': '10615',
    },
  ];

  late List<Doctor> _filteredDoctors;
  late List<Map<String, String>> _filteredHospitals;

  @override
  void initState() {
    super.initState();
    _filteredDoctors = List.from(_doctors);
    _filteredHospitals = List.from(_hospitals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final keyword = query.toLowerCase();
    if (_selectedSegment == 0) {
      setState(() {
        _filteredDoctors = _doctors
            .where(
              (d) =>
                  d.name.toLowerCase().contains(keyword) ||
                  d.specialty.toLowerCase().contains(keyword) ||
                  d.hospital.toLowerCase().contains(keyword),
            )
            .toList();
      });
    } else {
      setState(() {
        _filteredHospitals = _hospitals
            .where(
              (h) =>
                  (h['name'] ?? '').toLowerCase().contains(keyword) ||
                  (h['address'] ?? '').toLowerCase().contains(keyword),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Information'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Bangladesh Specialist Directory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Find specialists and hospitals with practical appointment data',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search doctor, specialty or hospital',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(value: 0, label: Text('Doctors')),
                ButtonSegment<int>(value: 1, label: Text('Hospitals')),
              ],
              selected: {_selectedSegment},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedSegment = selection.first;
                  _searchController.clear();
                  _filteredDoctors = List.from(_doctors);
                  _filteredHospitals = List.from(_hospitals);
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedSegment == 0 ? _buildDoctors() : _buildHospitals(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctors() {
    if (_filteredDoctors.isEmpty) {
      return const Center(child: Text('No doctors found for this search.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = _filteredDoctors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: doctor.imageUrl.startsWith('assets/')
                      ? AssetImage(doctor.imageUrl) as ImageProvider
                      : NetworkImage(doctor.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(doctor.hospital),
                      Text('Chamber: ${doctor.availability.first}'),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BookAppointmentScreen(),
                              ),
                            );
                          },
                          child: const Text('Book Appointment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHospitals() {
    if (_filteredHospitals.isEmpty) {
      return const Center(child: Text('No hospitals found for this search.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = _filteredHospitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.local_hospital_outlined),
            ),
            title: Text(hospital['name'] ?? ''),
            subtitle: Text(
              '${hospital['address']} | Hotline ${hospital['hotline']}',
            ),
          ),
        );
      },
    );
  }
}
