import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/doctor.dart';
import 'package:myapp/models/appointment.dart'; // Import Appointment model
import 'package:myapp/models/hospital.dart'; // Import Hospital model

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save appointment to Firestore
  Future<String?> saveAppointment(
    String doctorId,
    String userId,
    DateTime date,
    String time,
    String specialty,
    String hospital,
  ) async {
    try {
      // Generate a unique appointment ID
      var uuid = Uuid();
      String appointmentId = uuid.v4();

      // Create an appointment object
      Appointment appointment = Appointment(
        appointmentId: appointmentId,
        doctorId: doctorId,
        userId: userId,
        date: date,
        time: time,
        specialty: specialty,
        hospital: hospital,
        status: 'pending', // Default status is 'pending'
      );

      // Save the appointment to Firestore
      await _firestore.collection('appointments').doc(appointmentId).set(appointment.toFirestore());

      return appointmentId; // Return the generated appointmentId
    } catch (e) {
      print("Error saving appointment: $e");
      return null;
    }
  }

  // Get a list of appointments for a specific user
  Future<List<Appointment>> getAppointmentsForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      List<Appointment> appointments = snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data() as Map<String, dynamic>))
          .toList(); // No need to cast to List<Appointment>

      return appointments;
    } catch (e) {
      print("Error fetching appointments: $e");
      return [];
    }
  }

  // Save hospital to Firestore
  Future<void> saveHospital(Hospital hospital) async {
    try {
      await _firestore.collection('hospitals').doc(hospital.hospitalId).set(hospital.toFirestore());
    } catch (e) {
      print("Error saving hospital: $e");
    }
  }

  // Get a list of all hospitals
  Future<List<Hospital>> getHospitals() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('hospitals').get();
      List<Hospital> hospitals = snapshot.docs
          .map((doc) => Hospital.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      return hospitals;
    } catch (e) {
      print("Error fetching hospitals: $e");
      return [];
    }
  }

  // Fetch doctors from Firestore
  Future<List<Doctor>> fetchDoctors() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('doctors').get();
      List<Doctor> doctors = snapshot.docs.map((doc) => Doctor.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      return doctors;
    } catch (e) {
      print("Error fetching doctors: $e");
      return [];
    }
  }

  // Fetch upcoming appointments for a specific user
  Stream<List<Appointment>> getUpcomingAppointments(String userId) {
    if (userId.trim().isEmpty) {
      return const Stream<List<Appointment>>.empty();
    }

    // Note: We intentionally avoid a compound Firestore query like:
    //   where(userId == ...) + where(date >= now) + orderBy(date)
    // because it requires a composite index in many Firestore projects.
    // Instead, we fetch the user's appointments and filter/sort in Dart.
    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();

      final upcoming = <Appointment>[];
      for (final doc in snapshot.docs) {
        try {
          final appointment = Appointment.fromFirestore(doc.data());
          if (!appointment.date.isBefore(now)) {
            upcoming.add(appointment);
          }
        } catch (e) {
          // Skip malformed documents instead of breaking the whole stream.
          print('Error mapping appointment doc ${doc.id}: $e');
        }
      }

      upcoming.sort((a, b) => a.date.compareTo(b.date));
      return upcoming;
    });
  }
}
