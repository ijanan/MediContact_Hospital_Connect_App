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

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'user123';
  String get _currentUserLabel =>
      FirebaseAuth.instance.currentUser?.email?.split('@').first ?? 'User';

  static const String _userAvatarAsset = 'assets/images/user_placeholder.png';
  static const String _animeAvatarUrl =
      'https://i.pinimg.com/1200x/c1/4d/c6/c14dc680373ab26a0b1683ec2de820cc.jpg'; // Fixed high quality anime avatar

  Widget _sectionHeader(String title, {IconData? icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800);

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
                  ],
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
    final formattedDate = DateFormat(
      'EEE, dd MMM',
    ).format(firstAppointment.date);
    final formattedTime = _formatAppointmentTime(firstAppointment.time);

    return Card(
      elevation: 6,
      shadowColor: colorScheme.primary.withAlpha(40),
      color: colorScheme.primaryContainer,
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.primary.withAlpha(30), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                Icon(
                  Icons.chat_bubble_outline,
                  color: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(_animeAvatarUrl),
                  radius: 24,
                ),
                const SizedBox(width: 14),
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
                Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                ),
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
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
      (
        icon: Icons.calendar_month,
        label: 'Book Appointment',
        page: const BookAppointmentScreen(),
      ),
      (
        icon: Icons.info_outline,
        label: 'Doctor Information',
        page: DoctorInformationScreen(),
      ),
      (
        icon: Icons.local_hospital_outlined,
        label: 'Hospitals',
        page: const HospitalsScreen(),
      ),
      (
        icon: Icons.health_and_safety_outlined,
        label: 'Doctors Specialty',
        page: const DoctorsSpecialtyScreen(),
      ),
      (
        icon: Icons.contact_mail_outlined,
        label: 'Diagnostics',
        page: const DiagnosticsScreen(),
      ),
      (
        icon: Icons.local_pharmacy_outlined,
        label: 'Prescriptions',
        page: const PrescriptionsScreen(),
      ),
    ];

    return Card(
      elevation: 0,
      color: Colors.transparent,
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
              childAspectRatio: constraints.maxWidth >= 600 ? 1.15 : 0.85,
            ),
            itemBuilder: (context, index) {
              final item = services[index];
              return Material(
                color: colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  hoverColor: colorScheme.primary.withAlpha(20),
                  highlightColor: colorScheme.primary.withAlpha(40),
                  splashColor: colorScheme.primary.withAlpha(50),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.page),
                  ).then((_) => setState(() {})),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surface,
                          colorScheme.surfaceContainerLowest,
                        ],
                      ),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withAlpha(200),
                                colorScheme.primary.withAlpha(120),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withAlpha(220),
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
    );
  }

  Widget _calendarSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    final formattedTime = DateFormat('hh:mm a').format(now);

    return Card(
      elevation: 4,
      shadowColor: colorScheme.secondary.withAlpha(20),
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.secondaryContainer, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.secondary.withAlpha(40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.today_rounded,
                color: colorScheme.onSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: colorScheme.onSurface.withAlpha(160),
                      fontWeight: FontWeight.w600,
                    ),
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
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
            backgroundImage: const NetworkImage(_animeAvatarUrl),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
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
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer.withAlpha(220),
                    colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.primary.withAlpha(50),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.healing_rounded,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your health, connected',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Appointments, hospitals, diagnostics, and more.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurface.withAlpha(200),
                              ),
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
                  return _upcomingSchedule(
                    [],
                  ); // Fallback to empty state on error instead of breaking the UI
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _upcomingSchedule([]);
                } else {
                  return _upcomingSchedule(snapshot.data!);
                }
              },
            ),
            const SizedBox(height: 16),
            _sectionHeader('Your Services', icon: Icons.apps_rounded),
            const SizedBox(height: 16),
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
        animationDuration: const Duration(milliseconds: 400),
        indicatorColor: colorScheme.primary.withAlpha(40),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper_rounded),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
