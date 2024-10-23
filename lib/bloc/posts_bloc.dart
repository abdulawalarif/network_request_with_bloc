import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:network_request_with_bloc/bloc/users_bloc.dart';
import '../models/post_model.dart';
import 'bloc_actions.dart';

@immutable
class FetchPostsResult {
  final Iterable<PostModel> posts;
  final bool isRetrievedFromCache;

  const FetchPostsResult({
    required this.posts,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, posts = $posts)';

  @override
  bool operator ==(covariant FetchPostsResult other) =>
      posts.isEqualToIgnoringOrdering(other.posts) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(
        posts,
        isRetrievedFromCache,
      );
}

class PostsBloc extends Bloc<LoadAction, FetchPostsResult?> {
  final Map<String, Iterable<PostModel>> _cache = {};
  PostsBloc() : super(null) {
    on<LoadPostsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // we have the value in the cache
          final cachedPosts = _cache[url]!;
          final result = FetchPostsResult(
            posts: cachedPosts,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          final loader = event.loader;

          final posts = await loader(url);
          _cache[url] = posts;
          final result = FetchPostsResult(
            posts: posts,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
