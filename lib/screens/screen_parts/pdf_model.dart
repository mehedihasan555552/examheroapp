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
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled PDF',
      topic: json['topic'] ?? 'General',
      file: json['file'] ?? '',
      isFree: json['is_free'] ?? true,
      uploadedAt: json['uploaded_at'] != null 
          ? DateTime.tryParse(json['uploaded_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'topic': topic,
      'file': file,
      'is_free': isFree,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pdf && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Pdf{id: $id, title: $title, topic: $topic, isFree: $isFree}';
  }
}
