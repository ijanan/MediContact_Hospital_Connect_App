import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class Appointment {
  String appointmentId;
  String doctorId;
  String userId;
  late DateTime date;
  String time;
  String specialty;
  String hospital;
  String status;

  Appointment({
    required this.appointmentId,
    required this.doctorId,
    required this.userId,
    required this.date,
    required this.time,
    required this.specialty,
    required this.hospital,
    required this.status,
  });

  // Convert Appointment object to Map
  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'userId': userId,
      'date': date.toIso8601String(),
      'time': time,
      'specialty': specialty,
      'hospital': hospital,
      'status': status,
    };
  }

  // Convert Appointment object to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'userId': userId,
      'date': Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'time': time,
      'specialty': specialty,
      'hospital': hospital,
      'status': status,
    };
  }

  // From Firestore to create an Appointment object
  factory Appointment.fromFirestore(Map<String, dynamic> firestoreData) {
    DateTime date = (firestoreData['date'] as Timestamp).toDate(); // Convert Firestore Timestamp to DateTime
    return Appointment(
      appointmentId: firestoreData['appointmentId'],
      doctorId: firestoreData['doctorId'],
      userId: firestoreData['userId'] ?? "",
      date: date,
      time: firestoreData['time'] ?? "",
      specialty: firestoreData['specialty'] ?? "",
      hospital: firestoreData['hospital'] ?? "",
      status: firestoreData['status'] ?? "",
    );
  }

  // From Map to create an Appointment object
  factory Appointment.fromMap(Map<String, dynamic> map) {
    DateTime date = DateTime.parse(map['date']);
    return Appointment(
      appointmentId: map['appointmentId'],
      doctorId: map['doctorId'],
      userId: map['userId'] ?? "",
      date: date,
      time: map['time'] ?? "",
      specialty: map['specialty'] ?? "",
      hospital: map['hospital'] ?? "",
      status: map['status'] ?? "",
    );
  }
  String getDate() {
    return "${date.day}/${date.month}/${date.year}"; // Format as desired
  }
}
