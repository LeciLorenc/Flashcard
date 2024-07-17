class pastErrorsObject {
  final String user_id;
  final String subject;
  final String deck;
  final String date;
  final String time;
  final String numberOfTotalFlashcards;
  final List<String> wrongQuestions;
  final List<String> wrongAnswers;

  pastErrorsObject({
    required this.user_id,
    required this.subject,
    required this.deck,
    required this.date,
    required this.time,
    required this.numberOfTotalFlashcards,
    required this.wrongQuestions,
    required this.wrongAnswers,
  });

  factory pastErrorsObject.fromJson(Map<String, dynamic> json) {
    List<String> questionList = List<String>.from(json['questions']);
    List<String> answerList = List<String>.from(json['answers']);

    return pastErrorsObject(
      user_id: json['user_id'],
      deck: json['deck'],
      subject: json['subject'],
      date: json['date'],
      time: json['time'],
      numberOfTotalFlashcards: json['length'],
      wrongQuestions: questionList,
      wrongAnswers: answerList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'subject': subject,
      'deck': deck,
      'date': date,
      'time': time,
      'length': numberOfTotalFlashcards,
      'questions': wrongQuestions,
      'answers': wrongAnswers,
    };
  }
}