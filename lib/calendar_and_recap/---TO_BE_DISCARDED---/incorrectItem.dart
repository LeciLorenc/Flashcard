/*class IncorrectItem {
  final String subject;
  final String deck;
  final String question;
  final String answer;
  final String date;
  final String time;

  IncorrectItem({
    required this.subject,
    required this.deck,
    required this.question,
    required this.answer,
    required this.date,
    required this.time,
  });

  factory IncorrectItem.fromJson(Map<String, dynamic> json) {
    return IncorrectItem(
      deck: json['deck'],
      subject: json['subject'],
      question: json['question'],
      answer: json['answer'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'deck': deck,
      'question': question,
      'answer': answer,
      'date': date,
      'time': time,
    };
  }
}
*/