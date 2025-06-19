import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatDoctorPage extends StatefulWidget {
  final String doctorId; // 🆕 Tambahkan doctorId
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;

  const ChatDoctorPage({
    Key? key,
    required this.doctorId, // 🆕 Required doctorId
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
  }) : super(key: key);

  @override
  State<ChatDoctorPage> createState() => _ChatDoctorPageState();
}

class _ChatDoctorPageState extends State<ChatDoctorPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final uuid = Uuid();
  bool _isLoading = false;
  
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Tambahkan pesan sambutan dari dokter
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: uuid.v4(),
      content: "Halo, saya ${widget.doctorName}, ${widget.doctorSpecialty}. Ada yang bisa saya bantu terkait kesehatan anak Anda?",
      senderId: widget.doctorId, // 🔧 Gunakan doctorId yang sebenarnya
      senderName: widget.doctorName,
      senderType: "doctor",
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: uuid.v4(),
      content: _messageController.text,
      senderId: "user-1", // 🔧 TODO: Gunakan ID user yang sedang login
      senderName: "Anda",
      senderType: "user",
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    final messageText = _messageController.text;
    _messageController.clear();
    _scrollToBottom();

    try {
      // 🔧 Gunakan doctorId yang sebenarnya dari widget
      final doctorResponse = await _chatService.getDoctorResponse(
        widget.doctorId, // Gunakan doctorId dari parameter
        widget.doctorName,
        messageText, // Gunakan variabel yang sudah disimpan
      );

      setState(() {
        _messages.add(doctorResponse);
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      print('❌ Error sending message: $e'); // 🆕 Debug logging
      
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          id: uuid.v4(),
          content: "Maaf, terjadi kesalahan saat menghubungi dokter. Silakan coba lagi nanti.\n\nError: ${e.toString()}", // 🔧 Tampilkan error untuk debugging
          senderId: "system",
          senderName: "Sistem",
          senderType: "system",
          timestamp: DateTime.now(),
        ));
      });
      
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 🆕 Method untuk menampilkan info dokter
  void _showDoctorInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.doctorName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(widget.doctorImage),
                radius: 40,
              ),
              const SizedBox(height: 16),
              Text(
                'Spesialisasi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.doctorSpecialty),
              const SizedBox(height: 8),
              Text(
                'ID Dokter:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.doctorId),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.doctorImage),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded( // 🔧 Tambahkan Expanded untuk mencegah overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // 🔧 Handle text overflow
                  ),
                  Text(
                    widget.doctorSpecialty,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis, // 🔧 Handle text overflow
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blue),
            onPressed: _showDoctorInfo, // 🔧 Implementasi fungsi info dokter
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.senderType == 'user';
                final isSystem = message.senderType == 'system'; // 🆕 Deteksi pesan sistem
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? Colors.blue 
                          : isSystem 
                              ? Colors.red.shade100 // 🆕 Warna khusus untuk pesan sistem/error
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🆕 Tampilkan nama pengirim untuk pesan non-user
                        if (!isUser) ...[
                          Text(
                            message.senderName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isSystem ? Colors.red.shade700 : Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isUser 
                                ? Colors.white 
                                : isSystem 
                                    ? Colors.red.shade700
                                    : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: isUser 
                                ? Colors.white70 
                                : isSystem 
                                    ? Colors.red.shade400
                                    : Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.doctorImage),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text("Dokter sedang mengetik...", style: TextStyle(color: Colors.grey)), // 🔧 Pesan yang lebih jelas
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue, // 🔧 Warna yang lebih konsisten
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea( // 🆕 Tambahkan SafeArea untuk bottom area
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Ketik pesan...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isLoading, // 🆕 Disable input saat loading
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _isLoading ? null : _sendMessage, // 🔧 Disable button saat loading
                    backgroundColor: _isLoading ? Colors.grey : Colors.blue, // 🔧 Visual feedback
                    mini: true,
                    child: _isLoading 
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
