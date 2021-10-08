
class Question {
  Question({
    this.id,
    this.question,
    this.answer,
    this.moduleType,
    this.status,
    this.createdAt,
  });

  int? id;
  String? question;
  String? answer;
  String? moduleType;
  String? status;
  DateTime? createdAt;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    moduleType: json["moduleType"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "moduleType": moduleType,
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
  };
}

