import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:volume_control/volume_control.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SwipeControlScreen2 extends StatefulWidget {
  @override
  _SwipeControlScreenState createState() => _SwipeControlScreenState();
}

class _SwipeControlScreenState extends State<SwipeControlScreen2> {
  double _currentBrightness = 0.5; // Initial brightness level
  double _currentVolume = 0.5; // Initial volume level
  bool _showBrightnessIndicator = false; // To show brightness indicator
  bool _showVolumeIndicator = false; // To show volume indicator
      //  String rtmpUrl="rtmp://62.72.43.50/live/jaden";

       String rtmpUrl ="http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4";
  late VlcPlayerController _vlcPlayerController;
  bool _isLoading = true;
  bool _hasError = false;
  

  @override
  void initState() {
    super.initState();
    _initAudioAndBrightness();

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

  // Initialize the volume and brightness settings
  Future<void> _initAudioAndBrightness() async {
    double volume = await VolumeControl.volume;
    double brightness = await ScreenBrightness().current;

    setState(() {
      _currentVolume = volume;
      _currentBrightness = brightness;
    });
  }

  // Adjust the brightness by increasing/decreasing the current value
  void _adjustBrightness(double delta) async {
    _currentBrightness += delta;
    if (_currentBrightness > 1.0) _currentBrightness = 1.0;
    if (_currentBrightness < 0.0) _currentBrightness = 0.0;

    await ScreenBrightness().setScreenBrightness(_currentBrightness);
    
    setState(() {
      _showBrightnessIndicator = true;
    });

    // Hide indicator after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _showBrightnessIndicator = false;
      });
    });
  }

  // Adjust the volume by increasing/decreasing the current value
  void _adjustVolume(double delta) async {
    _currentVolume += delta;
    if (_currentVolume > 1.0) _currentVolume = 1.0;
    if (_currentVolume < 0.0) _currentVolume = 0.0;

    await VolumeControl.setVolume(_currentVolume);

    setState(() {
      _showVolumeIndicator = true;
    });

    // Hide indicator after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _showVolumeIndicator = false;
      });
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
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
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
      backgroundColor: Colors.grey,

      body: Stack(
        children: [
          // Full-screen Gesture Detector
          GestureDetector(
            onVerticalDragUpdate: (details) {
              // Determine swipe direction and location
              if (details.delta.dy < 0) {
                // Swiping up
                if (details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
                  // Left side: Adjust Brightness
                  _adjustBrightness(0.05);
                } else {
                  // Right side: Adjust Volume
                  _adjustVolume(0.05);
                }
              } else if (details.delta.dy > 0) {
                // Swiping down
                if (details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
                  // Left side: Adjust Brightness
                  _adjustBrightness(-0.05);
                } else {
                  // Right side: Adjust Volume
                  _adjustVolume(-0.05);
                }
              }
            },
 
            child: VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9,
              // aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
          // Brightness Indicator (on the left)
          if (_showBrightnessIndicator)
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: 20,
              child: _buildIndicator(
                "Brightness",
                _currentBrightness,
                Icons.brightness_6,
              ),
            ),
          // Volume Indicator (on the right)
          if (_showVolumeIndicator)
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              right: 20,
              child: _buildIndicator(
                "Volume",
                _currentVolume,
                Icons.volume_up,
              ),
            ),
        ],
      ),
    );
  }

  // Method to build the visual indicator widget
  Widget _buildIndicator(String label, double value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 50, color: Colors.white),
        Text(
          "$label: ${(value * 100).toInt()}%",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 10),
        Container(
          width: 30,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 150 * value,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



