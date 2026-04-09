import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/appointment.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/news_feed_screen.dart';
import 'package:myapp/diagnostics_screen.dart';
import 'doctor_information_screen.dart';
import 'package:myapp/prescriptions_screen.dart';
import 'doctors_specialty_screen.dart';
import 'hospitals_screen.dart';
import 'package:myapp/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_appointment_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;

  final DatabaseService _databaseService = DatabaseService();

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? 'user123';
  String get _currentUserLabel =>
      FirebaseAuth.instance.currentUser?.email?.split('@').first ?? 'User';

  static const String _userAvatarAsset = 'assets/images/user_placeholder.png';

  Widget _sectionHeader(String title, {IconData? icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
        );

    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 8),
        ],
        Text(title, style: textStyle),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color background,
    required Color foreground,
  }) {
    return Card(
      elevation: 0,
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: foreground.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: foreground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: foreground.withAlpha(200)),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAppointmentTime(String timeRaw) {
    final trimmed = timeRaw.trim();
    if (trimmed.isEmpty) return '';

    final parsedIso = DateTime.tryParse(trimmed);
    if (parsedIso != null) {
      return DateFormat('hh:mm a').format(parsedIso);
    }

    try {
      final parsed24 = DateFormat.Hm().parseStrict(trimmed);
      return DateFormat('hh:mm a').format(parsed24);
    } catch (_) {}

    try {
      final parsed12 = DateFormat('hh:mm a').parseStrict(trimmed);
      return DateFormat('hh:mm a').format(parsed12);
    } catch (_) {}

    return trimmed;
  }

  Widget _upcomingSchedule(List<Appointment> appointments) {
    final colorScheme = Theme.of(context).colorScheme;

    if (appointments.isEmpty) {
      return _infoCard(
        icon: Icons.event_available,
        title: 'No upcoming appointments',
        subtitle: 'Book a visit to see it here.',
        background: colorScheme.surfaceContainerHighest,
        foreground: colorScheme.onSurface,
      );
    }

    final firstAppointment = appointments.first;
    final formattedDate = DateFormat('EEE, dd MMM').format(firstAppointment.date);
    final formattedTime = _formatAppointmentTime(firstAppointment.time);

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming appointment',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(Icons.chat_bubble_outline, color: colorScheme.onPrimaryContainer),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(_userAvatarAsset),
                  radius: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${firstAppointment.doctorId}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${firstAppointment.specialty}${firstAppointment.hospital.trim().isEmpty ? '' : ' • ${firstAppointment.hospital}'}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer.withAlpha(200),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: colorScheme.onPrimaryContainer.withAlpha(80)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 18, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                ),
                Icon(Icons.access_time, size: 18, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    final colorScheme = Theme.of(context).colorScheme;

    final services = <({IconData icon, String label, Widget page})>[
      (icon: Icons.calendar_month, label: 'Book Appointment', page: const BookAppointmentScreen()),
      (icon: Icons.info_outline, label: 'Doctor Information', page: DoctorInformationScreen()),
      (icon: Icons.local_hospital_outlined, label: 'Hospitals', page: const HospitalsScreen()),
      (icon: Icons.health_and_safety_outlined, label: 'Doctors Specialty', page: const DoctorsSpecialtyScreen()),
      (icon: Icons.contact_mail_outlined, label: 'Diagnostics', page: const DiagnosticsScreen()),
      (icon: Icons.local_pharmacy_outlined, label: 'Prescriptions', page: const PrescriptionsScreen()),
    ];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Make tiles a bit taller on smaller screens to avoid
                // "Bottom overflowed by ... pixels".
                childAspectRatio: constraints.maxWidth >= 600 ? 1.15 : 0.90,
              ),
              itemBuilder: (context, index) {
                final item = services[index];
                return Material(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item.page),
                    ).then((_) => setState(() {})),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(item.icon, size: 24, color: colorScheme.primary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _calendarSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    final formattedTime = DateFormat('hh:mm a').format(now);

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: colorScheme.onSecondaryContainer.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.today, color: colorScheme.onSecondaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(color: colorScheme.onSecondaryContainer.withAlpha(220)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle the navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;

      if (_selectedBottomIndex == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
        );
      } else if (_selectedBottomIndex == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      }
     });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userName = _currentUserLabel;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundImage: const AssetImage(_userAvatarAsset),
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to MediConnect',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              userName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(24),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.favorite_outline, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your health, connected',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Appointments, hospitals, diagnostics, and more.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: colorScheme.onSurface.withAlpha(200)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Appointment>>(
              stream: _databaseService.getUpcomingAppointments(_currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 110,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return _infoCard(
                    icon: Icons.cloud_off,
                    title: 'Appointments unavailable',
                    subtitle: kDebugMode ? '${snapshot.error}' : 'Please try again later.',
                    background: colorScheme.errorContainer,
                    foreground: colorScheme.onErrorContainer,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _upcomingSchedule([]);
                } else {
                  return _upcomingSchedule(snapshot.data!);
                }
              },
            ),
            const SizedBox(height: 16),
            _sectionHeader('Services', icon: Icons.grid_view_rounded),
            const SizedBox(height: 12),
            _buildServiceSection(),
            const SizedBox(height: 16),
            _sectionHeader('Today', icon: Icons.today_outlined),
            const SizedBox(height: 12),
            _calendarSection(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.newspaper_outlined), label: 'News'),
          NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
