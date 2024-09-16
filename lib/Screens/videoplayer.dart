import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {


  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
     String rtmpUrl="rtmp://62.72.43.50/live/jaden";
  late VlcPlayerController _vlcPlayerController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Lock the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _vlcPlayerController = VlcPlayerController.network(
      rtmpUrl,
      hwAcc: HwAcc.full,
      autoPlay: true,
    );

    // Listen for buffering events and errors
    _vlcPlayerController.addListener(() {
      if (_vlcPlayerController.value.hasError) {
        setState(() {
          _hasError = true;
        });
        _showServerDownDialog();
      } else if (_vlcPlayerController.value.isBuffering) {
        setState(() {
          _isLoading = true;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Reset the orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _vlcPlayerController.dispose();
    super.dispose();
  }

  // Show dialog when server is down or an error occurs
  void _showServerDownDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('The server is down or the stream is unavailable.'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
          // Show loading indicator when the video is buffering
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
