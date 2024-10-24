import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:network_request_with_bloc/bloc/bloc_actions.dart';
import 'package:network_request_with_bloc/models/user_model/user_model.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchUsersResult {
  final Iterable<UserModel> users;
  final bool isRetrievedFromCache;
  final bool loadinWait;
  const FetchUsersResult({
    required this.users,
    required this.isRetrievedFromCache,
    required this.loadinWait,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $users)';

  @override
  bool operator ==(covariant FetchUsersResult other) =>
      users.isEqualToIgnoringOrdering(other.users) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(
        users,
        isRetrievedFromCache,
      );
}

class UsersBloc extends Bloc<LoadAction, FetchUsersResult?> {
  final Map<String, Iterable<UserModel>> _cache = {};
  UsersBloc() : super(null) {
    on<LoadUsersAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // we have the value in the cache
          final cachedUsers = _cache[url]!;
          final result = FetchUsersResult(
            users: cachedUsers,
            loadinWait: false,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          emit(
            const FetchUsersResult(
              isRetrievedFromCache: true,
              loadinWait: true,
              users: [],
            ),
          );
          final loader = event.loader;
          final users = await loader(url);
          _cache[url] = users;
          final result = FetchUsersResult(
            users: users,
            isRetrievedFromCache: false,
            loadinWait: false,
          );
          emit(result);
        }
      },
    );
  }
}
