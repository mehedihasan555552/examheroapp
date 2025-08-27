
// PDF Model Class
class Pdf {
  final int id;
  final String title;
  final String topic;
  final String file;
  final bool isFree;
  final DateTime uploadedAt;

  Pdf({
    required this.id,
    required this.title,
    required this.topic,
    required this.file,
    required this.isFree,
    required this.uploadedAt,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      id: json['id'],
      title: json['title'],
      topic: json['topic'],
      file: json['file'],
      isFree: json['is_free'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }
}