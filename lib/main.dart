import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/home_page.dart';
import 'package:flutter_infinite_list/post/post_bloc.dart';
import 'package:flutter_infinite_list/post/post_event.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(App());
}



class App extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        body: BlocProvider(
          create: (context) {
            return PostBloc(httpClient: http.Client())
              ..add(Fetch());
          },
          child: HomePage(),
        ),
      ),
    );
  }

}