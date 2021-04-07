import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final String url;

  PreviewVideo({Key key, @required this.url}) : super(key: key);

  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  _getVideo() {
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
  }

  @override
  void initState() {
    _getVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.done){
                    return AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    );
                  }
                  else{
                    return SpinKitWave(
                      color: Colors.black,
                      size: 15.0,
                    );
                  }
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: (){
            setState(() {
              if (_videoPlayerController.value.isPlaying){
                _videoPlayerController.pause();
              }
              else{
                _videoPlayerController.play();
              }
            });
          },
          child: (_videoPlayerController.value.isPlaying?Icon(Icons.pause):Icon(Icons.play_arrow)),
        ),
      ),
    );
  }
}
