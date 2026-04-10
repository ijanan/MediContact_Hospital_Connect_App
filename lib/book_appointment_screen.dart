import 'package:flutter/material.dart';
import 'package:myapp/models/doctor.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Doctor> _doctors = [
    Doctor(
      doctorId: '1',
      name: 'Dr. Tanvir Hossain',
      specialty: 'Cardiology',
      hospital: 'Square Hospitals Ltd, Dhaka',
      availability: ['Sat - Thu | 10:00 AM - 1:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
    Doctor(
      doctorId: '2',
      name: 'Dr. Sharmin Akter',
      specialty: 'Gynecology & Obstetrics',
      hospital: 'Labaid Specialized Hospital',
      availability: ['Sun - Thu | 5:00 PM - 8:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
    Doctor(
      doctorId: '3',
      name: 'Dr. Mahmudul Islam',
      specialty: 'Neurology',
      hospital: 'Evercare Hospital Dhaka',
      availability: ['Mon - Thu | 9:00 AM - 12:00 PM'],
      imageUrl: 'assets/images/ff.jpg',
    ),
  ];

  String _selectedSpecialty = 'All';
  late List<Doctor> _filteredDoctors;

  final List<String> _specialties = const [
    'All',
    'Cardiology',
    'Neurology',
    'Gynecology & Obstetrics',
  ];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = List.from(_doctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        final matchesQuery =
            doctor.name.toLowerCase().contains(query) ||
            doctor.hospital.toLowerCase().contains(query);
        final matchesSpecialty =
            _selectedSpecialty == 'All' ||
            doctor.specialty == _selectedSpecialty;
        return matchesQuery && matchesSpecialty;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment'), centerTitle: true),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Appointment Booking in Bangladesh',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    hintText: 'Search doctor or hospital',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specialties.map((specialty) {
                    final selected = specialty == _selectedSpecialty;
                    return ChoiceChip(
                      label: Text(specialty),
                      selected: selected,
                      onSelected: (_) {
                        _selectedSpecialty = specialty;
                        _applyFilters();
                      },
                      selectedColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected ? colors.primary : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.22),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? const Center(
                    child: Text('No doctors found for these filters.'),
                  )
                : ListView.builder(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    doctor.imageUrl.startsWith('assets/')
                                    ? AssetImage(doctor.imageUrl)
                                          as ImageProvider
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
                                        color: colors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(doctor.hospital),
                                    Text(
                                      'Available: ${doctor.availability.first}',
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Appointment request sent for ${doctor.name}',
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Confirm Appointment',
                                        ),
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
                  ),
          ),
        ],
      ),
    );
  }
}
