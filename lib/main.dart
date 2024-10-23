import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_request_with_bloc/bloc/bloc_actions.dart';
import 'dart:developer' as devtools show log;
import 'package:network_request_with_bloc/bloc/users_bloc.dart';
import 'bloc/posts_bloc.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UsersBloc>(
          create: (context) => UsersBloc(),
        ),
        BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(),
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: HomePage(),
        ),
      ),
    ),
  );
}

Future<Iterable<UserModel>> getUsers(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => UserModel.fromJson(e)));

Future<Iterable<PostModel>> getPosts(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => PostModel.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Column(
        children: [
          const TabBar(
            tabs: [
                Tab(
                icon: Icon(Icons.person_2_outlined),
                text: 'Users list',
              ),
                Tab(
                icon: Icon(Icons.event_note_sharp),
                text: 'Posts list',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                BlocBuilder<UsersBloc, FetchUsersResult?>(
                  buildWhen: (previousResult, currentResult) {
                    return previousResult?.users != currentResult?.users;
                  },
                  builder: (context, fetchResult) {
                    fetchResult?.log();
                    final users = fetchResult?.users;

                    if (users == null) {
                      return Center(
                        child: TextButton(
                          onPressed: () {
                            context.read<UsersBloc>().add(
                                  const LoadUsersAction(
                                    url: loadAllUsers,
                                    loader: getUsers,
                                  ),
                                );
                          },
                          child: const Text('Load users from network'),
                        ),
                      );
                    }
                    if (fetchResult!.loadinWait) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final person = users[index]!;

                          return ListTile(
                            title: Text(person.name.toString()),
                            subtitle: Text(person.email.toString()),
                          );
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<PostsBloc, FetchPostsResult?>(
                  buildWhen: (previousResult, currentResult) {
                    return previousResult?.posts != currentResult?.posts;
                  },
                  builder: (context, fetchResult) {
                    fetchResult?.log();
                    final posts = fetchResult?.posts;

                    if (posts == null) {
                      return Center(
                        child: TextButton(
                          onPressed: () {
                            context.read<PostsBloc>().add(
                                  const LoadPostsAction(
                                    url: loadAllPosts,
                                    loader: getPosts,
                                  ),
                                );
                          },
                          child: const Text('Load posts from network'),
                        ),
                      );
                    }

                    if (fetchResult!.loadinWait) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index]!;

                          return ListTile(
                            title: Text(post.title.toString()),
                            subtitle: Text(post.body.toString()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


