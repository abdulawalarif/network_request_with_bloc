import 'package:flutter/foundation.dart' show immutable;
import 'package:network_request_with_bloc/models/user_model.dart';

import '../models/post_model.dart';

const loadAllUsers = 'https://jsonplaceholder.typicode.com/users';
const loadAllPosts = 'https://jsonplaceholder.typicode.com/posts';

typedef PersonLoader = Future<Iterable<UserModel>> Function(String url);
typedef PostsLoader = Future<Iterable<PostModel>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadUsersAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadUsersAction({
    required this.url,
    required this.loader,
  }) : super();
}

@immutable
class LoadPostsAction implements LoadAction {
  final String url;
  final PostsLoader loader;
  const LoadPostsAction({
    required this.url,
    required this.loader,
  }) : super();
}


