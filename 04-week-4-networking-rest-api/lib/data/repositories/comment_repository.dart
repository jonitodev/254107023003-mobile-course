import 'package:dio/dio.dart';

import '../models/comment.dart';

/// Repository khusus komentar untuk memisahkan akses jaringan dari UI.
class CommentRepository {
  CommentRepository(this._dio);
  final Dio _dio;

  Future<List<Comment>> fetchComments(int postId) async {
    final response = await _dio.get<List<dynamic>>(
      '/comments',
      queryParameters: {'postId': postId},
    );
    final data = response.data ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList();
  }
}
