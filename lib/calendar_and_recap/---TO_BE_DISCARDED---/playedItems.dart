class PlayedDeck {
  final String subject;
  final String deck;
  final String date;
  final String time;
  final String length;

  PlayedDeck({
    required this.subject,
    required this.deck,
    required this.date,
    required this.time,
    required this.length
  });

  factory PlayedDeck.fromJson(Map<String, dynamic> json) {
    return PlayedDeck(
      deck: json['deck'],
      subject: json['subject'],
      date: json['date'],
      time: json['time'],
      length: json['length'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'deck': deck,
      'date': date,
      'time': time,
      'length': length,
    };
  }
}
