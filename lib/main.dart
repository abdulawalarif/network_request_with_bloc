import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_request_with_bloc/bloc/bloc_actions.dart';
//import 'package:network_request_with_bloc/bloc/person.dart';
import 'dart:developer' as devtools show log;

import 'package:network_request_with_bloc/bloc/persons_bloc.dart';

import 'models/post_model.dart';
import 'models/user_model.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}


void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage(),
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
          Row(
            children: [
              TextButton(
                onPressed: () {
                  
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                          url: loadAllUsers,
                          loader: getUsers,
                        ),
                      );
                },
                child: const Text(
                  'Load Users',
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     context.read<PersonsBloc>().add(
              //           const LoadPersonsAction(
              //             url: loadAllPosts,
              //             loader: getPosts,
              //           ),
              //         );
              //   },
              //   child: const Text(
              //     'Load Posts',
              //   ),
              // ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons != currentResult?.persons;
            },
            builder: (context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;

              if (persons == null) {
                return const SizedBox();
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;

                    return ListTile(
                      title: Text(person.name.toString()),
                      subtitle: Text(person.email.toString()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
