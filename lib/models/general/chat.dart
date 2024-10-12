class Chat{
  final String message;
  final String sender;
  final DateTime timeStamp;
  Chat({
    required this.message,
    required this.sender,
    required this.timeStamp
  });

  static Chat fromMap(Map<String, dynamic> data){
    return Chat(
      message: data['message'] ?? '',
      sender: data['sender'] ?? '',
      timeStamp: DateTime.tryParse(data['timeStamp']) ?? DateTime.now()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'message': message,
      'sender': sender,
      'timeStamp': timeStamp.toIso8601String()
    };
  }
}