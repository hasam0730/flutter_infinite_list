import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/post/post.dart';
import 'package:flutter_infinite_list/post/post_bloc.dart';
import 'package:flutter_infinite_list/post/post_event.dart';
import 'package:flutter_infinite_list/post/post_state.dart';



class HomePage extends StatefulWidget {



  @override
  _HomePageState createState() => _HomePageState();

}



class _HomePageState extends State<HomePage> {

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostBloc _postBloc;



  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
    _scrollController.addListener(_onScroll);
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostUnitialized) {
          return Center(child: CircularProgressIndicator(),);
        }

        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(child: Text('no posts'),);
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index < state.posts.length ? PostWidget(post: state.posts[index]) : BottomLoader();
              },
              itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
              controller: _scrollController,
            );
          }
        }

        if (state is PostError) {

          return Center(child: Text('error'),);
        }

        return Center(child: Text('no posts'),);
    },);
  }



 @override
 void dispose() {
   _scrollController.dispose();
   super.dispose();
 }



  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.add(Fetch());
    }
  }
}



class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          height: 33,
          width: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),  
    );
  }
}



class PostWidget extends StatelessWidget {

  final Post post;

  const PostWidget({Key key, @required this.post});



  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${post.id}',
        style: TextStyle(fontSize: 10.0),),
      title: Text('${post.title}}'),
      isThreeLine: true,
      subtitle: Text('${post.body}'),
      dense: true,
    );
  }
}