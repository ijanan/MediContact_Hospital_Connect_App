// lib/models/doctor.dart
class Doctor {
   String? doctorId;
  final String name;
  final String specialty;
  final String hospital;
  final List<String> availability;
  final String imageUrl;

  Doctor({
    this.doctorId,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.availability,
    required this.imageUrl,
  });
    Map<String, dynamic> toFirestore() {
    return {
      'doctorId': doctorId,
      'name': name,
      'specialty': specialty,
      'hospital': hospital,
      'availability': availability,
      'imageUrl': imageUrl,
    };
  }
 factory Doctor.fromFirestore(Map<String, dynamic> firestoreData) {
    return Doctor(
      doctorId: firestoreData['doctorId'],
      name: firestoreData['name'],
      specialty: firestoreData['specialty'],
      hospital: firestoreData['hospital'],
      availability: firestoreData['availability'] != null ? List<String>.from(firestoreData['availability']) : [],
      imageUrl: firestoreData['imageUrl'] ?? '',
    );
  }

}
