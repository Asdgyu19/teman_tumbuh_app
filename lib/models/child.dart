// lib/models/child.dart
class Child {
  final int id;
  final String nik;
  final String name;
  final String dob; // Date of Birth (misal: "10 September 2024")

  Child({
    required this.id,
    required this.nik,
    required this.name,
    required this.dob,
  });

  // Factory constructor untuk membuat objek Child dari JSON (response dari Go)
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      nik: json['nik'],
      name: json['name'],
      dob: json['dob'],
    );
  }

  // Method untuk mengubah objek Child menjadi JSON (untuk dikirim ke Go)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ID bisa null saat pertama kali membuat
      'nik': nik,
      'name': name,
      'dob': dob,
    };
  }
}