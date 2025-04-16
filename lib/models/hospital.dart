class Hospital {
  String hospitalId;
  String name;
  String imageUrl;
  String hotline;
  String email;
  String address;
  List<String> review;

  Hospital({
    required this.hospitalId,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.hotline,
    required this.review,
    required this.email,
  });

  // Method to convert Hospital instance to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'hospitalId': hospitalId,
      'name': name,
      'imageUrl': imageUrl,
      'hotline': hotline,
      'email': email,
      'address': address,
      'review': review,
    };
  }

  // Method to create a Hospital object from Firestore data (Map)
  factory Hospital.fromFirestore(Map<String, dynamic> data) {
    return Hospital(
      hospitalId: data['hospitalId'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      hotline: data['hotline'] ?? '',
      email: data['email'] ?? '',
      review: List<String>.from(data['review'] ?? []),
    );
  }

  // Optional: You can also keep this if you prefer
  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      hospitalId: map['hospitalId'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      hotline: map['hotline'] ?? '',
      email: map['email'] ?? '',
      review: List<String>.from(map['review'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => toMap();
}
