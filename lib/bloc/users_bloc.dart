import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:network_request_with_bloc/bloc/bloc_actions.dart';
import 'package:network_request_with_bloc/models/user_model.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchUsersResult {
  final Iterable<UserModel> persons;
  final bool isRetrievedFromCache;
  const FetchUsersResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchUsersResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(
        persons,
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
          final cachedPersons = _cache[url]!;
          final result = FetchUsersResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchUsersResult(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
