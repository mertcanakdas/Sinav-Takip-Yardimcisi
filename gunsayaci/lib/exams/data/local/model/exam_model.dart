class ExamModel {
  String id;
  String examName;
  int correctCount;
  int wrongCount;
  int emptyCount;

  ExamModel({
    required this.id,
    required this.examName,
    required this.correctCount,
    required this.wrongCount,
    required this.emptyCount,
  });

  /// Net hesabı: Doğru sayısı - (Yanlış sayısı / 4)
  double get net {
    return correctCount - (wrongCount / 4);
  }

  /// JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examName': examName,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
      'emptyCount': emptyCount,
    };
  }

  /// JSON'dan model oluşturma
  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      examName: json['examName'],
      correctCount: json['correctCount'],
      wrongCount: json['wrongCount'],
      emptyCount: json['emptyCount'],
    );
  }

  @override
  String toString() {
    return 'ExamModel{id: $id, examName: $examName, correctCount: $correctCount, '
        'wrongCount: $wrongCount, emptyCount: $emptyCount, net: $net}';
  }
}
