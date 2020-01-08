import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_infinite_list/bloc/bloc.dart';
import 'package:flutter_infinite_list/post/post.dart';



class PostBloc extends Bloc<PostEvent, PostState> {

  final http.Client httpClient;



  PostBloc({this.httpClient});



  @override
  PostState get initialState => PostUnitialized();



  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUnitialized) {

          final posts = await _fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is PostLoaded) {

          final posts = await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty 
          ? currentState.copyWith(hasReachMax: true) 
          : PostLoaded(posts: currentState.posts + posts, hasReachedMax: false);
        }
      } catch (error) {
        yield PostError();
      }
    }
  }



  bool _hasReachedMax(PostState state) {
    return state is PostLoaded && state.hasReachedMax;
  }



  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get('https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    print(response.request.url.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        print(rawPost["id"]);
        return Post(
          id: rawPost["id"],
          title: rawPost["title"],
          body: rawPost["body"]);
      });
    } else {
      throw Exception('error fetching error');
    }
  }

}