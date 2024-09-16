import 'package:calvary_karunya_app/Screens/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  "Enter RTMP Link",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(179, 233, 226, 226),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: TextField(
                        controller: Controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the RTMP Link"),
                      ),
                     
                    ),
                  ),
                 

                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(rtmpUrl:Controller.text,),));
                  },
                  child: Container(
                                 padding: EdgeInsets.only(left: 20,right: 20),
                    decoration: BoxDecoration( 
                      color: const Color.fromARGB(255, 142, 96, 222),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Play",
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
