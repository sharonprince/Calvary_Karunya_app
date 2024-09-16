import 'package:flutter/material.dart';
import 'package:volume_control/volume_control.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SwipeControlScreen extends StatefulWidget {
  @override
  _SwipeControlScreenState createState() => _SwipeControlScreenState();
}

class _SwipeControlScreenState extends State<SwipeControlScreen> {
  double _currentBrightness = 0.5; // Initial brightness level
  double _currentVolume = 0.5; // Initial volume level

  @override
  void initState() {
    super.initState();
    _initAudioAndBrightness();
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
    setState(() {});
  }

  // Adjust the volume by increasing/decreasing the current value
  void _adjustVolume(double delta) async {
    _currentVolume += delta;
    if (_currentVolume > 1.0) _currentVolume = 1.0;
    if (_currentVolume < 0.0) _currentVolume = 0.0;

    await VolumeControl.setVolume(_currentVolume);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe to Control"),
      ),
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
            child: Container(
              color: Colors.transparent, // Invisible, full-screen gesture detector
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Swipe up/down on the right to control Volume"),
                    Text("Swipe up/down on the left to control Brightness"),
                    SizedBox(height: 20),
                    Text("Current Volume: ${(_currentVolume * 100).toInt()}%"),
                    Text("Current Brightness: ${(_currentBrightness * 100).toInt()}%"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
