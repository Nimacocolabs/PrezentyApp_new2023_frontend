import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/util/event_data.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageEditorPreviewScreen extends StatefulWidget {
  final String imagePath;
  final bool hasAudio;

  const ImageEditorPreviewScreen({Key? key,required this.imagePath, this.hasAudio=false}) : super(key: key);

  @override
  _ImageEditorPreviewScreenState createState() => _ImageEditorPreviewScreenState();
}

class _ImageEditorPreviewScreenState extends State<ImageEditorPreviewScreen> {

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  File? file;
  FileImage? provider;

  @override
  void initState() {
    super.initState();

WidgetsBinding.instance.addPostFrameCallback((_) async {
  file = File(widget.imagePath);
  await FileImage(file!).evict();
  setState(() { });

  initPlayer();
});
  }
@override
  void dispose() {
  assetsAudioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon:Icon(Icons. arrow_back_rounded, color: Colors.white,), onPressed: () { Navigator.pop(context); },),
        elevation: 0,
        actions: !widget.hasAudio
            ?null
            : [
                StreamBuilder<bool>(
                    stream: assetsAudioPlayer.isPlaying,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!)
                        return IconButton(
                            onPressed: () {
                              assetsAudioPlayer.pause();
                            },
                            icon: Icon(Icons.volume_up,
                                color: Colors.white));
                      else
                        return IconButton(
                            onPressed: () {
                              assetsAudioPlayer.play();
                            },
                            icon: Icon(Icons.volume_off, color: Colors.white));
                    }),
              ],
      ),
      body: SafeArea(
        child: file==null?
            CircularProgressIndicator()
        : Center(
              child: PhotoView(
                tightMode: true,
                imageProvider: FileImage(file!),
                maxScale: PhotoViewComputedScale.covered * 1.0,
                minScale: PhotoViewComputedScale.contained,
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: BoxDecoration(color: Colors.black),
                loadingBuilder: (context, event) {
                  return Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        // color: Colors.white,
                        child: CircularProgressIndicator(),
                      ));
                },
              ),
            ),
      ),
    );
  }

  initPlayer() async {
    if(!widget.hasAudio) return;

    assetsAudioPlayer.open(
      Audio.file('${EventData.eventAudioFilePath}'),
      loopMode: LoopMode.single,
      autoStart: true,
    );
  }
}


class PreviewScreen extends StatefulWidget {
  final String imageUrl;
  final String? audioUrl;
  const PreviewScreen({Key? key, required this.imageUrl, required this.audioUrl}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log('audioUrl:${widget.audioUrl}');
      if(widget.audioUrl!=null){
       await  assetsAudioPlayer.open(
          Audio.network(widget.audioUrl!),
          autoStart: true,
          loopMode: LoopMode.single,
        );
        setState(() { });
      }
    });
  }

  @override
  Future<void> dispose() async {
    try {
      await assetsAudioPlayer.stop();
      await assetsAudioPlayer.dispose();
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon:Icon(Icons. arrow_back_rounded, color: Colors.white,), onPressed: () { Navigator.pop(context); },),
        elevation: 0,
        actions: widget.audioUrl==null
            ?null
            : [
          StreamBuilder<bool>(
              stream: assetsAudioPlayer.isPlaying,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!)
                  return IconButton(
                      onPressed: () {
                        assetsAudioPlayer.pause();
                      },
                      icon: Icon(Icons.volume_up,
                          color: Colors.white));
                else
                  return IconButton(
                      onPressed: () {
                        assetsAudioPlayer.play();
                      },
                      icon: Icon(Icons.volume_off, color: Colors.white));
              }),
        ],
      ),
      body: CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        imageUrl: widget.imageUrl,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(
          color: Colors.black12.withOpacity(0.02),
          child: Image(
            image: AssetImage('assets/images/no_image.png'),
            height: double.infinity,
            width: double.infinity,
          ),
          padding: EdgeInsets.all(5),
        ),
      ),
    );
  }
}
