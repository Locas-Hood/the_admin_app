import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_file.dart';

class GithubApiService {
  final String owner;
  final String repo;
  final String token;
  final String branch;

  GithubApiService({
    required this.owner,
    required this.repo,
    required this.token,
    this.branch = 'main',
  });

  Map<String, String> get _headers {
    final headers = {
      'Accept': 'application/vnd.github+json',
      'User-Agent': 'div_admin_flutter',
    };
    if (token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }
    return headers;
  }

  Future<GithubFile> fetchFile(String path) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/contents/$path',
      {'ref': branch},
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch $path (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final rawContent = json['content'] as String? ?? '';
    final cleaned = rawContent.replaceAll('\n', '');
    final decoded = utf8.decode(base64Decode(cleaned));
    final sha = json['sha'] as String? ?? '';
    return GithubFile(content: decoded, sha: sha);
  }

  Future<GithubFile> updateFile({
    required String path,
    required String content,
    required String sha,
    String commitMessage = 'Update from admin panel',
  }) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/contents/$path',
    );
    final encodedContent = base64Encode(utf8.encode(content));
    final body = jsonEncode({
      'message': commitMessage,
      'content': encodedContent,
      'sha': sha,
      'branch': branch,
    });

    final response = await http.put(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update $path (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final contentNode = json['content'] as Map<String, dynamic>?;
    final updatedSha = contentNode?['sha'] as String? ?? sha;
    return GithubFile(content: content, sha: updatedSha);
  }
}
