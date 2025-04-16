import 'package:flutter/material.dart';
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

import 'book_appointment_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;

  final DatabaseService _databaseService = DatabaseService();

  // Placeholder for current user ID (replace with actual user ID)
  final String currentUserId = "user123"; 

  Widget _upcomingSchedule(List<Appointment> appointments) {
        
    if (appointments.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9A75F9),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: Text(
            'No upcoming appointments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );    
    }

    // Assuming there's at least one appointment to display
    Appointment firstAppointment = appointments.first;
    DateFormat dateFormat = DateFormat('EEEE, dd MMMM');
    String formattedDate = dateFormat.format(firstAppointment.date);
    DateFormat timeFormat = DateFormat('hh:mm a');
    DateTime parsedTime = DateTime.parse(firstAppointment.time);
    String formattedTime = timeFormat.format(parsedTime);

    return  Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9A75F9),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                const Text(
                  'Upcoming schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,                   
                  ),
                ),
            const SizedBox(height: 10),
            const CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              radius: 30,
            ),
             Text(
              'Dr. ${firstAppointment.doctorId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,              
              ),
            ),
             Text(
              firstAppointment.specialty,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,              
              ),
            ),
            
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.message, color: Colors.white),
            ),
            const Divider(color: Colors.white, thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                     formattedDate,                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],), Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white),
                  const SizedBox(width: 8),
                Text(
                  formattedTime,
                   style: const TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
            
            ],
          ),
        ],
      )
      );
    }

  Widget _buildServiceBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.5),
           spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(// Wrap for responsive layout
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildServiceCard(Icons.calendar_month, "Book Appointment"),
            _buildServiceCard(Icons.info_outline, "Doctor Information"),
            _buildServiceCard(Icons.local_hospital_outlined, "Hospitals"),
            _buildServiceCard(Icons.health_and_safety_outlined, "Doctors Specialty"),
            _buildServiceCard(Icons.contact_mail_outlined, "Diagnostics"),
            _buildServiceCard(Icons.receipt_long_outlined, "Prescriptions"),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String text) {
    if (text == "Prescriptions") {
      icon = Icons.local_pharmacy_outlined;
    }
      

   final Map<String, Widget> serviceRoutes = {
    "Book Appointment": const BookAppointmentScreen(),
    "Doctor Information":  DoctorInformationScreen(),
      "Hospitals": const HospitalsScreen(),
      "Doctors Specialty": const DoctorsSpecialtyScreen(),
      "Diagnostics": const DiagnosticsScreen(),
      "Prescriptions":  const PrescriptionsScreen(),


    };
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => serviceRoutes[text]!,
        ),
      ).then((_) => setState(() {})),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: const Color(0xFF9A75F9)),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarSection() {
    String formattedTime;
    DateTime now = DateTime.now();
     String formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
     formattedTime = DateFormat('hh:mm a').format(now);
    return Container(
     width: double.infinity,
     padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF9A75F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              formattedDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
           ),
          ), 
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
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
    const String userName = "User Name";
    const String userImageUrl = 'lib/images/boy.png';    
    return Scaffold(
          backgroundColor:  const Color.fromARGB(255, 247, 243, 243),
          appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 247, 243, 243),
                Color.fromARGB(255, 247, 243, 243),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
       iconTheme: const IconThemeData(
          color: Color(0xFF9A75F9),
       ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child:  CircleAvatar(
            backgroundImage:  AssetImage(userImageUrl),
            radius: 30,
          ),
        ),
       actions: const [
            Padding(padding: EdgeInsets.only(right: 16),child: Icon(Icons.notifications_none, color: Color(0xFF9A75F9))),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
             const Text(  
                  'Welcome To MediConnect',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    
                  ),
                ),
            Text(
              userName, 
              style:   TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold 
              ),
            ),
          ],
        ),
      ),
          body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
                   StreamBuilder<List<Appointment>>(
                    stream: _databaseService.getUpcomingAppointments(currentUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _upcomingSchedule([]); // Show empty state
                      } else {
                        return _upcomingSchedule(snapshot.data!);
                      }
                    },
                  ),
                 const SizedBox(height: 20),
                  _buildServiceBox(),
              const SizedBox(height: 20),
              _calendarSection(),
              Container()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_outlined), label: 'News Feed'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
          currentIndex: _selectedBottomIndex,
          selectedItemColor:  const Color(0xFF9A75F9),
          onTap: _onItemTapped,
    ));
  }
}
