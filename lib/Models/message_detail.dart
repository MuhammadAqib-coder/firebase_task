class MessageDetail {
  final String message;

  final String sender;
  final int time;

  MessageDetail({
    required this.message,
    required this.sender,
    required this.time,
  });

  factory MessageDetail.fromJson(message) {
    return MessageDetail(
        message: message['message'],
        sender: message['sender'],
        time: message['time']);
  }

  static toJson(json) {
    return {
      "message": json.message,
    };
  }
}
