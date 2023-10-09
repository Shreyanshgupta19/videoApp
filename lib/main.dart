import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_app/login.dart';
import 'package:video_player/video_player.dart';
import 'utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _videoUrl;
  VideoPlayerController? _controller;
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video App"),
      ),
      body: Center(
        child: _videoUrl != null
        ?_videoPreviewWidget()
        :const Text("No Video Selected"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.video_library_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  void _pickVideo() async {
    _videoUrl = pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoUrl!))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }
  Widget _videoPreviewWidget(){
    if(_controller != null){
      return AspectRatio(aspectRatio: _controller!.value.aspectRatio,
      child:  VideoPlayer(_controller!),
      );
    }
    else{
      return const CircularProgressIndicator();
    }
  }
}

