class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String? profileImage;
  final String? specialization;
  final int? experience;
  final double? rating;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.profileImage,
    this.specialization,
    this.experience,
    this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      userType: json['user_type'] ?? 'patient',
      profileImage: json['profile_image'],
      specialization: json['specialization'],
      experience: json['experience'],
      rating: json['rating']?.toDouble(),
    );
  }
  
}
