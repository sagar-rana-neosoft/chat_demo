import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String id;
  final String displayName;
  final String photoUrl;

  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.photoUrl,
  });

  factory ProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileModel(
      id: doc.id,
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
