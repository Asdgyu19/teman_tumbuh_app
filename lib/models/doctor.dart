class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int price;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      rating: json['rating'].toDouble(),
      price: json['price'],
      imageUrl: json['image_url'],
    );
  }
}
