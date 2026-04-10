import 'package:flutter/material.dart';

class Hospital {
  final String name;
  final String location;
  final String specialty;
  final String contact;
  final String workingHours;
  final String imageUrl;
  final String about;

  Hospital({
    required this.name,
    required this.location,
    required this.specialty,
    required this.contact,
    required this.workingHours,
    required this.imageUrl,
    required this.about,
  });
}

class HospitalDetailPage extends StatelessWidget {
  final Hospital hospital;
  const HospitalDetailPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(hospital.name), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              hospital.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: colors.primaryContainer,
                alignment: Alignment.center,
                child: Icon(
                  Icons.local_hospital,
                  size: 64,
                  color: colors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _item(Icons.location_on_outlined, hospital.location),
                  _item(Icons.monitor_heart_outlined, hospital.specialty),
                  _item(Icons.phone_outlined, hospital.contact),
                  _item(Icons.access_time_outlined, hospital.workingHours),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(hospital.about, style: const TextStyle(height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Hospital> _hospitals = [
    Hospital(
      name: 'Square Hospitals Ltd',
      location: 'West Panthapath, Dhaka 1205',
      specialty: 'Cardiology, Neurology, Oncology, ICU',
      contact: 'Hotline: 10616',
      workingHours: '24/7 Emergency and OPD',
      imageUrl:
          'https://images.unsplash.com/photo-1538108149393-fbbd81895907?q=80&w=1200&auto=format&fit=crop',
      about:
          'Square Hospitals is one of the most reputed tertiary hospitals in Bangladesh with advanced diagnostics, emergency care and specialist consultations.',
    ),
    Hospital(
      name: 'Evercare Hospital Dhaka',
      location: 'Bashundhara R/A, Dhaka 1229',
      specialty: 'Multidisciplinary, ICU, Cardiac Surgery',
      contact: 'Hotline: 10678',
      workingHours: '24/7',
      imageUrl:
          'https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=1200&auto=format&fit=crop',
      about:
          'Evercare Hospital Dhaka is known for international standard protocols, critical care units and experienced consultants across specialties.',
    ),
    Hospital(
      name: 'Ibn Sina Specialized Hospital',
      location: 'Dhanmondi, Dhaka',
      specialty: 'Medicine, Surgery, Diagnostics',
      contact: 'Hotline: 10615',
      workingHours: '24/7 Emergency',
      imageUrl:
          'https://images.unsplash.com/photo-1504813184591-01572f98c85f?q=80&w=1200&auto=format&fit=crop',
      about:
          'Ibn Sina Specialized Hospital provides affordable healthcare services for middle income families with strong diagnostics and specialist departments.',
    ),
    Hospital(
      name: 'Chittagong Medical College Hospital',
      location: 'Panchlaish, Chattogram',
      specialty: 'Government Tertiary Care',
      contact: 'Information Desk: +880-31-630774',
      workingHours: '24/7',
      imageUrl:
          'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=1200&auto=format&fit=crop',
      about:
          'CMCH is one of the largest government medical centers in Chattogram serving emergency, trauma and referral patients from the region.',
    ),
  ];

  late List<Hospital> _filteredHospitals;

  @override
  void initState() {
    super.initState();
    _filteredHospitals = List.from(_hospitals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterHospitals(String query) {
    final keyword = query.toLowerCase();
    setState(() {
      _filteredHospitals = _hospitals
          .where(
            (h) =>
                h.name.toLowerCase().contains(keyword) ||
                h.location.toLowerCase().contains(keyword) ||
                h.specialty.toLowerCase().contains(keyword),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hospitals'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
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
                  'Bangladesh Hospital Directory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: _filterHospitals,
                  decoration: InputDecoration(
                    hintText: 'Search by hospital, city or department',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HospitalDetailPage(hospital: hospital),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          hospital.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 160,
                            color: colors.primaryContainer,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.local_hospital,
                              color: colors.primary,
                              size: 48,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hospital.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(hospital.location),
                              const SizedBox(height: 6),
                              Text(
                                'Specialties: ${hospital.specialty}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
