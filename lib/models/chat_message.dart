class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String senderType; // 'user', 'doctor', 'system'
  final DateTime timestamp;
  final bool? isError; // 🆕 Optional field untuk menandai pesan error

  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.timestamp,
    this.isError,
  });

  // 🆕 Factory method untuk membuat pesan error
  factory ChatMessage.error({
    required String id,
    required String content,
    required DateTime timestamp,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      senderId: "system",
      senderName: "Sistem",
      senderType: "system",
      timestamp: timestamp,
      isError: true,
    );
  }

  // 🆕 Method untuk konversi ke JSON (untuk penyimpanan lokal)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
    };
  }

  // 🆕 Factory method untuk membuat dari JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderType: json['senderType'],
      timestamp: DateTime.parse(json['timestamp']),
      isError: json['isError'],
    );
  }
}
