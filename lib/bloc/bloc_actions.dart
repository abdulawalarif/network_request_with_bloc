import 'package:flutter/foundation.dart' show immutable;
import 'package:network_request_with_bloc/models/user_model.dart';
 
const loadAllUsers = 'https://jsonplaceholder.typicode.com/users';
const loadAllPosts = 'https://jsonplaceholder.typicode.com/posts';

typedef PersonLoader = Future<Iterable<UserModel>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}




