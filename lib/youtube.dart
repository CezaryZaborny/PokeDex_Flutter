import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Youtube extends StatefulWidget {
  const Youtube({Key? key}) : super(key: key);

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'NJwacipEYX8',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),



    );
  }
}
