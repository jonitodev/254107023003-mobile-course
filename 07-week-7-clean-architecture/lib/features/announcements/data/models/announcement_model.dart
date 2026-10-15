import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.publishedAt,
  });

  factory AnnouncementModel.fromMap(Map<String, Object?> map) {
    return AnnouncementModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      publishedAt:
          DateTime.tryParse(map['published_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Announcement toEntity() => Announcement(
    id: id,
    title: title,
    summary: summary,
    publishedAt: publishedAt,
  );
}
