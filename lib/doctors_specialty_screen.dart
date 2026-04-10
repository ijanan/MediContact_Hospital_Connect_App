import 'package:flutter/material.dart';
import 'package:myapp/doctor_information_screen.dart';

class DoctorsSpecialtyScreen extends StatefulWidget {
  const DoctorsSpecialtyScreen({super.key});

  @override
  State<DoctorsSpecialtyScreen> createState() => _DoctorsSpecialtyScreenState();
}

class _DoctorsSpecialtyScreenState extends State<DoctorsSpecialtyScreen> {
  final List<Map<String, dynamic>> _specialties = const [
    {'name': 'Cardiology', 'count': '120+ Doctors', 'icon': Icons.favorite},
    {'name': 'Neurology', 'count': '85+ Doctors', 'icon': Icons.psychology},
    {'name': 'Pediatrics', 'count': '160+ Doctors', 'icon': Icons.child_care},
    {
      'name': 'Gynecology',
      'count': '140+ Doctors',
      'icon': Icons.pregnant_woman,
    },
    {
      'name': 'Orthopedics',
      'count': '95+ Doctors',
      'icon': Icons.accessibility_new,
    },
    {'name': 'Dermatology', 'count': '70+ Doctors', 'icon': Icons.spa},
    {'name': 'Urology', 'count': '45+ Doctors', 'icon': Icons.water_drop},
    {'name': 'ENT', 'count': '65+ Doctors', 'icon': Icons.medical_information},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Specialties'),
        centerTitle: true,
      ),
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
            child: const Column(
              children: [
                Text(
                  'Choose Specialty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Discover specialist doctors from Dhaka, Chattogram, Sylhet and more.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _specialties.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.06,
              ),
              itemBuilder: (context, index) {
                final spec = _specialties[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorInformationScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            child: Icon(spec['icon'], size: 28),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            spec['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            spec['count'],
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
