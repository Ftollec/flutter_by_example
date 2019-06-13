import 'dart:convert';
import 'package:common/common.dart';
import 'package:http/http.dart';

import 'package:common/src/models/post_configuration.dart';
import 'package:common/src/repositories/posts_repository_base.dart';

class FilesystemBrowserPostsRepository extends PostRepository {
  Client client;

  FilesystemBrowserPostsRepository() {
    client = new Client();
  }

  @override
  Future<List<PostConfiguration>> loadAllPosts() async {
    return [];
  }

  @override
  Future<PostConfiguration> loadMarkdownPostByPageId(String pageId) async {
    var reqUrl = "http://localhost:3000/content/$pageId.MD";
    var response = await client.get(reqUrl);
    var body = response.body;
    return new PostConfiguration.fromJson(json.decode(body));
  }

  @override
  Future<List<PostCategory>> loadAllPostsByCategory() async {
    List<PostCategory> allPosts = [];
    try {
      var reqUrl = "http://localhost:3000/toc";
      var response = await client.get(reqUrl);
      var body = response.body;
      List postsByCategory = json.decode(body);
      allPosts = postsByCategory
          .map((dynamic posts) => new PostCategory.fromJson(posts))
          .toList();
      allPosts.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      print("Respoitory.LoadAllPostsByCategory.error: $e");
    }
    return allPosts;
  }
}