import 'package:equatable/equatable.dart';
import '../post/post.dart';



abstract class PostState extends Equatable {

  const PostState();



  @override
  List<Object> get props => [];

}



class PostUnitialized extends PostState {}



class PostError extends PostState {}



class PostLoaded extends PostState {

  final List<Post> posts;
  final bool hasReachedMax;



  const PostLoaded({
    this.posts, 
    this.hasReachedMax
  });



  PostLoaded copyWith({
    List<Object> props, 
    bool hasReachMax}) {

    return PostLoaded(
      posts: props ?? this.posts, 
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }



  @override
  List<Object> get props => [posts, hasReachedMax];



  @override
  String toString() => 'PostLoaded: { posts: ${posts.length} hasReachMax: $hasReachedMax }';

}