import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/pick_music_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/download_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PickRecommendedMusicScreen extends StatefulWidget {
  const PickRecommendedMusicScreen({Key? key}) : super(key: key);

  @override
  _PickRecommendedMusicScreenState createState() => _PickRecommendedMusicScreenState();
}

class _PickRecommendedMusicScreenState extends State<PickRecommendedMusicScreen> with LoadMoreListener{

  late ScrollController _itemsScrollController;
  late EventBloc _bloc;
  bool isLoadingMore = false;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = EventBloc(this);
    _bloc.getPickMusicList(false);
  }

  @override
  void dispose() async {
    await assetsAudioPlayer.stop();
    _itemsScrollController.dispose();
    _bloc.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        _bloc.getPickMusicList(true);
      }
    }
    if (_itemsScrollController.offset <=
        _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _bloc.pickMusicListStream,
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator(),);
                    case Status.COMPLETED:
                      PickMusicResponse resp=snapshot.data!.data;
                      return _buildList(resp.baseUrl!,_bloc.pickMusicList);
                    case Status.ERROR:
                      return Text('${snapshot.data!.message!}');
                  }
                }
                return Container();
              }
            ),
          ),
          Visibility(
              visible:isLoadingMore,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }

  int index = -1;
  String url='';
  ListItem? item;

  Widget _buildList(String baseUrl,List itemsList) {
    if(itemsList.isEmpty){
      return CommonApiResultsEmptyWidget('No music found');
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView.separated(
              controller: _itemsScrollController,
              itemCount: itemsList.length,
              separatorBuilder: (context,index) => Divider(height: 1,),
              itemBuilder: (context,index) {
                ListItem item = itemsList[index];
                return ListTile(
                  selected: this.index == index,
                  trailing:  (this.index == index) ?
                  ElevatedButton(
                    child: Text('Choose'),
                    onPressed: () async {
                      await assetsAudioPlayer.stop();

                      File file = File('${EventData.tempEventPath}/audio.mp3');
                      if(file.existsSync()) await file.delete(recursive: true);

                      bool b = await DownloadHelper.load(context, url,
                          EventData.tempEventPath, 'audio.mp3');
                      if (b) {
                        EventData.eventAudioFilePath =
                        '${EventData.tempEventPath}/audio.mp3';
                        EventData.eventAudioId = item.id;
                        Get.close(1);
                      }
                    },
                  ):SizedBox(width: 0,),
                  leading:
                   (this.index == index) ?
                   SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        StreamBuilder<bool>(
                            stream: assetsAudioPlayer.isPlaying,
                            builder: (context, snapshot) {
                              if (snapshot.data != null && snapshot.data!)
                                return Material(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black12,
                                  child: InkWell(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      onTap: () {
                                        assetsAudioPlayer.pause();
                                      },
                                      child: Icon(
                                          Icons.pause,size: 30,
                                          color:
                                          primaryColor)),
                                );
                              else
                                return Material(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black12,
                                  child: InkWell(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      onTap: () {
                                        assetsAudioPlayer.play();
                                      },
                                      child: Icon(
                                          Icons.play_arrow,size: 30,
                                          color:
                                          primaryColor)),
                                );
                            }),

                        StreamBuilder<bool>(
                            stream: assetsAudioPlayer.isBuffering,
                            builder: (context, snapshot) {

                              if (snapshot.data != null && snapshot.data!)
                                return Material(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  child: Center(child: CupertinoActivityIndicator()
                                    // Text('Buffering')
                                  ),
                                );
                              // return Stack(
                              //     fit: StackFit.expand,
                              //     children: [
                              //       CircularProgressIndicator(),
                              //       IconButton(
                              //           onPressed: () {
                              //             assetsAudioPlayer.pause();
                              //           },
                              //           icon: Icon(Icons.pause,
                              //               color: primaryColor)),
                              //     ],
                              //   );
                              else
                                return SizedBox(height: 0,width: 0,);
                              // return IconButton(
                              //     onPressed: () {
                              //       assetsAudioPlayer.play();
                              //     },
                              //     icon: Icon(Icons.play_arrow,
                              //         color: primaryColor));
                            }),
                      ],
                    ),)
                  : Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.play_arrow_rounded,size: 30,color: Colors.white,),
                    decoration: BoxDecoration(
                      color: secondaryColor.shade400,//Colors.grey.shade400,
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                 subtitle: Text(item.musicFileUrl!),
                  // trailing:  Icon(Icons.play_arrow),
                    onTap: () {
                    if(this.index == index) return;
                      // _openPlayer(baseUrl,index);
                      this.index = index;
                      item = _bloc.pickMusicList[index];
                      url = '$baseUrl${item.musicFileUrl!}';
                      // String url = 'https://download.samplelib.com/mp3/sample-9s.mp3';

                      setState(() { });

                      log(url);
                      assetsAudioPlayer.open(
                        Audio.network(url),
                        autoStart: true,
                        loopMode: LoopMode.single,
                      );
                    }
                );
              }),
        ),

       // if(index >= 0)
       //  Container(
       //    height: screenHeight * .28,
       //    child: Column(
       //      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
       //      mainAxisSize: MainAxisSize.max,
       //      children: [
       //        Divider(height: 1,),
       //        Expanded(
       //          child:Padding(
       //            padding: const EdgeInsets.all(8.0),
       //            child: Column(
       //              children: [
       //                // SizedBox(
       //                //   height: 60,
       //                //   width: 60,
       //                //   child: StreamBuilder<bool>(
       //                //       stream: assetsAudioPlayer.isPlaying,
       //                //       builder: (context, snapshot) {
       //                //         return Material(
       //                //             borderRadius: BorderRadius.circular(12),
       //                //             color: Colors.grey.shade300,
       //                //             child: (snapshot.data != null && snapshot.data!)
       //                //                 ? InkWell(
       //                //                 borderRadius:
       //                //                 BorderRadius.circular(12),
       //                //                 onTap: () {
       //                //                   assetsAudioPlayer.pause();
       //                //                 },
       //                //                 child: Container(
       //                //                   child: Icon(Icons.pause,
       //                //                       color: primaryColor),
       //                //                 ))
       //                //                 : InkWell(
       //                //                 borderRadius:
       //                //                 BorderRadius.circular(12),
       //                //                 onTap: () {
       //                //                   assetsAudioPlayer.play();
       //                //                 },
       //                //                 child: Container(
       //                //                     child: Icon(
       //                //                         Icons.play_arrow,
       //                //                         color:
       //                //                         primaryColor))));
       //                //       }),),
       //                SizedBox(height: 12,),
       //
       //                SizedBox(
       //                  height: screenHeight * .11,
       //                  width: screenHeight * .11,
       //                  child: Stack(
       //                    fit: StackFit.expand,
       //                    children: [
       //                      StreamBuilder<bool>(
       //                          stream: assetsAudioPlayer.isPlaying,
       //                          builder: (context, snapshot) {
       //                            if (snapshot.data != null && snapshot.data!)
       //                              return Material(
       //                                borderRadius: BorderRadius.circular(12),
       //                                color: Colors.black12,
       //                                child: InkWell(
       //                                    borderRadius:
       //                                    BorderRadius.circular(12),
       //                                    onTap: () {
       //                                      assetsAudioPlayer.pause();
       //                                    },
       //                                    child: Icon(
       //                                        Icons.pause,size: 30,
       //                                        color:
       //                                        primaryColor)),
       //                              );
       //                            else
       //                              return Material(
       //                                borderRadius: BorderRadius.circular(12),
       //                                color: Colors.black12,
       //                                child: InkWell(
       //                                    borderRadius:
       //                                    BorderRadius.circular(12),
       //                                    onTap: () {
       //                                      assetsAudioPlayer.play();
       //                                    },
       //                                    child: Icon(
       //                                        Icons.play_arrow,size: 30,
       //                                        color:
       //                                        primaryColor)),
       //                              );
       //                          }),
       //
       //                      StreamBuilder<bool>(
       //                          stream: assetsAudioPlayer.isBuffering,
       //                          builder: (context, snapshot) {
       //
       //                            if (snapshot.data != null && snapshot.data!)
       //                              return Material(
       //                                borderRadius: BorderRadius.circular(12),
       //                                color: Colors.white,
       //                                child: Center(child: CupertinoActivityIndicator()
       //                                  // Text('Buffering')
       //                                ),
       //                              );
       //                            // return Stack(
       //                            //     fit: StackFit.expand,
       //                            //     children: [
       //                            //       CircularProgressIndicator(),
       //                            //       IconButton(
       //                            //           onPressed: () {
       //                            //             assetsAudioPlayer.pause();
       //                            //           },
       //                            //           icon: Icon(Icons.pause,
       //                            //               color: primaryColor)),
       //                            //     ],
       //                            //   );
       //                            else
       //                              return SizedBox(height: 0,width: 0,);
       //                            // return IconButton(
       //                            //     onPressed: () {
       //                            //       assetsAudioPlayer.play();
       //                            //     },
       //                            //     icon: Icon(Icons.play_arrow,
       //                            //         color: primaryColor));
       //                          }),
       //                    ],
       //                  ),),
       //
       //
       //
       //                SizedBox(height: 12,),
       //                Text(
       //                  _bloc.itemsList[index].musicFileUrl!,
       //                  textAlign: TextAlign.center,
       //                  maxLines: 2,
       //                  overflow: TextOverflow.ellipsis,
       //                  style: TextStyle(color: primaryColor),
       //                ),
       //              ],
       //            ),
       //          ),
       //        ),
       //
       //        // Container(
       //        //   padding: const EdgeInsets.all(8.0),
       //        //   child: Text(
       //        //     _bloc.itemsList[index].musicFileUrl!,
       //        //     textAlign: TextAlign.center,
       //        //     maxLines: 1,
       //        //     overflow: TextOverflow.ellipsis,
       //        //     style: TextStyle(color: primaryColor),
       //        //   ),
       //        // ),
       //
       //        // Container(
       //        //   height: 60,
       //        //   width: 60,
       //        //   decoration: BoxDecoration(
       //        //     borderRadius: BorderRadius.circular(30),
       //        //     border: Border.all(color: Colors.black12, width: 2),
       //        //   ),
       //        //   child: Stack(
       //        //     children: [
       //        //       StreamBuilder<bool>(
       //        //           stream: assetsAudioPlayer.isPlaying,
       //        //           builder: (context, snapshot) {
       //        //             if (snapshot.data != null && snapshot.data!)
       //        //               return Stack(
       //        //                 fit: StackFit.expand,
       //        //                 children: [
       //        //                   CircularProgressIndicator(),
       //        //                   IconButton(
       //        //                       onPressed: () {
       //        //                         assetsAudioPlayer.pause();
       //        //                       },
       //        //                       icon: Icon(Icons.pause,
       //        //                           color: primaryColor)),
       //        //                 ],
       //        //               );
       //        //             else
       //        //               return IconButton(
       //        //                   onPressed: () {
       //        //                     assetsAudioPlayer.play();
       //        //                   },
       //        //                   icon: Icon(Icons.play_arrow,
       //        //                       color: primaryColor));
       //        //           }),
       //        //
       //        //
       //        //     ],
       //        //   ),
       //        // ),
       //
       //        Row(
       //          mainAxisAlignment: MainAxisAlignment.spaceAround,
       //          children: [
       //            OutlinedButton(
       //              child: Text('Cancel'),
       //              onPressed: () {
       //                Get.back();
       //              },
       //            ),
       //            ElevatedButton(
       //              child: Text('Choose'),
       //              onPressed: () async {
       //                await assetsAudioPlayer.stop();
       //
       //                File file = File('${EventData.tempEventPath}/audio.mp3');
       //                if(file.existsSync()) await file.delete(recursive: true);
       //
       //                bool b = await DownloadHelper.load(context, url,
       //                    EventData.tempEventPath, 'audio.mp3');
       //                if (b) {
       //                  EventData.eventAudioFilePath =
       //                  '${EventData.tempEventPath}/audio.mp3';
       //                  EventData.eventAudioId = item!.id;
       //                  Get.close(2);
       //                }
       //              },
       //            ),
       //          ],
       //        ),
       //      ],
       //    ),
       //  ),
      ],
    );
  }

  // _openPlayer(String baseUrl, int index) async {
  //   try {
  //     ListItem item = _bloc.itemsList[index];
  //     String url = '$baseUrl${item.musicFileUrl!}';
  //     // String url = 'https://download.samplelib.com/mp3/sample-9s.mp3';
  //
  //     log(url);
  //     assetsAudioPlayer.open(
  //       Audio.network(url),
  //       autoStart: true,
  //       loopMode: LoopMode.single,
  //     );
  //
  //     await showModalBottomSheet(
  //         context: context,
  //         enableDrag: false,
  //         isDismissible: false,
  //         builder: (builder) {
  //           return WillPopScope(
  //             onWillPop:()async{
  //               return false;
  //             },
  //             child: StatefulBuilder(
  //                 builder: (BuildContext context, StateSetter setState) {
  //               return Container(
  //                 height: screenHeight * .28,
  //                 child: Column(
  //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //
  //                     Expanded(
  //                       child:Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             // SizedBox(
  //                             //   height: 60,
  //                             //   width: 60,
  //                             //   child: StreamBuilder<bool>(
  //                             //       stream: assetsAudioPlayer.isPlaying,
  //                             //       builder: (context, snapshot) {
  //                             //         return Material(
  //                             //             borderRadius: BorderRadius.circular(12),
  //                             //             color: Colors.grey.shade300,
  //                             //             child: (snapshot.data != null && snapshot.data!)
  //                             //                 ? InkWell(
  //                             //                 borderRadius:
  //                             //                 BorderRadius.circular(12),
  //                             //                 onTap: () {
  //                             //                   assetsAudioPlayer.pause();
  //                             //                 },
  //                             //                 child: Container(
  //                             //                   child: Icon(Icons.pause,
  //                             //                       color: primaryColor),
  //                             //                 ))
  //                             //                 : InkWell(
  //                             //                 borderRadius:
  //                             //                 BorderRadius.circular(12),
  //                             //                 onTap: () {
  //                             //                   assetsAudioPlayer.play();
  //                             //                 },
  //                             //                 child: Container(
  //                             //                     child: Icon(
  //                             //                         Icons.play_arrow,
  //                             //                         color:
  //                             //                         primaryColor))));
  //                             //       }),),
  //                             SizedBox(height: 12,),
  //
  //                             SizedBox(
  //                             height: screenHeight * .11,
  //                             width: screenHeight * .11,
  //                               child: Stack(
  //                                 fit: StackFit.expand,
  //                                 children: [
  //                                   StreamBuilder<bool>(
  //                                     stream: assetsAudioPlayer.isPlaying,
  //                                     builder: (context, snapshot) {
  //                                       if (snapshot.data != null && snapshot.data!)
  //                                         return Material(
  //                                                       borderRadius: BorderRadius.circular(12),
  //                                                       color: Colors.black12,
  //                                                       child: InkWell(
  //                                                           borderRadius:
  //                                                           BorderRadius.circular(12),
  //                                                           onTap: () {
  //                                                             assetsAudioPlayer.pause();
  //                                                           },
  //                                                           child: Icon(
  //                                                               Icons.pause,size: 30,
  //                                                               color:
  //                                                               primaryColor)),
  //                                         );
  //                                       else
  //                                         return Material(
  //                                           borderRadius: BorderRadius.circular(12),
  //                                       color: Colors.black12,
  //                                       child: InkWell(
  //                                           borderRadius:
  //                                           BorderRadius.circular(12),
  //                                           onTap: () {
  //                                             assetsAudioPlayer.play();
  //                                           },
  //                                           child: Icon(
  //                                               Icons.play_arrow,size: 30,
  //                                               color:
  //                                               primaryColor)),
  //                                         );
  //                                     }),
  //
  //                                   StreamBuilder<bool>(
  //                                       stream: assetsAudioPlayer.isBuffering,
  //                                       builder: (context, snapshot) {
  //
  //                                         if (snapshot.data != null && snapshot.data!)
  //                                           return Material(
  //                                             borderRadius: BorderRadius.circular(12),
  //                                             color: Colors.white,
  //                                             child: Center(child: CupertinoActivityIndicator()
  //                                                 // Text('Buffering')
  //                                           ),
  //                                           );
  //                                         // return Stack(
  //                                         //     fit: StackFit.expand,
  //                                         //     children: [
  //                                         //       CircularProgressIndicator(),
  //                                         //       IconButton(
  //                                         //           onPressed: () {
  //                                         //             assetsAudioPlayer.pause();
  //                                         //           },
  //                                         //           icon: Icon(Icons.pause,
  //                                         //               color: primaryColor)),
  //                                         //     ],
  //                                         //   );
  //                                         else
  //                                           return SizedBox(height: 0,width: 0,);
  //                                         // return IconButton(
  //                                         //     onPressed: () {
  //                                         //       assetsAudioPlayer.play();
  //                                         //     },
  //                                         //     icon: Icon(Icons.play_arrow,
  //                                         //         color: primaryColor));
  //                                       }),
  //                                 ],
  //                               ),),
  //
  //
  //
  //                             SizedBox(height: 12,),
  //                             Text(
  //                               _bloc.itemsList[index].musicFileUrl!,
  //                               textAlign: TextAlign.center,
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(color: primaryColor),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                     // Container(
  //                     //   padding: const EdgeInsets.all(8.0),
  //                     //   child: Text(
  //                     //     _bloc.itemsList[index].musicFileUrl!,
  //                     //     textAlign: TextAlign.center,
  //                     //     maxLines: 1,
  //                     //     overflow: TextOverflow.ellipsis,
  //                     //     style: TextStyle(color: primaryColor),
  //                     //   ),
  //                     // ),
  //
  //                     // Container(
  //                     //   height: 60,
  //                     //   width: 60,
  //                     //   decoration: BoxDecoration(
  //                     //     borderRadius: BorderRadius.circular(30),
  //                     //     border: Border.all(color: Colors.black12, width: 2),
  //                     //   ),
  //                     //   child: Stack(
  //                     //     children: [
  //                     //       StreamBuilder<bool>(
  //                     //           stream: assetsAudioPlayer.isPlaying,
  //                     //           builder: (context, snapshot) {
  //                     //             if (snapshot.data != null && snapshot.data!)
  //                     //               return Stack(
  //                     //                 fit: StackFit.expand,
  //                     //                 children: [
  //                     //                   CircularProgressIndicator(),
  //                     //                   IconButton(
  //                     //                       onPressed: () {
  //                     //                         assetsAudioPlayer.pause();
  //                     //                       },
  //                     //                       icon: Icon(Icons.pause,
  //                     //                           color: primaryColor)),
  //                     //                 ],
  //                     //               );
  //                     //             else
  //                     //               return IconButton(
  //                     //                   onPressed: () {
  //                     //                     assetsAudioPlayer.play();
  //                     //                   },
  //                     //                   icon: Icon(Icons.play_arrow,
  //                     //                       color: primaryColor));
  //                     //           }),
  //                     //
  //                     //
  //                     //     ],
  //                     //   ),
  //                     // ),
  //
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         OutlinedButton(
  //                           child: Text('Cancel'),
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                         ),
  //                         ElevatedButton(
  //                           child: Text('Choose'),
  //                           onPressed: () async {
  //                             await assetsAudioPlayer.stop();
  //
  //                             File file = File('${EventData.tempEventPath}/audio.mp3');
  //                             if(file.existsSync()) await file.delete(recursive: true);
  //
  //                             bool b = await DownloadHelper.load(context, url,
  //                                 EventData.tempEventPath, 'audio.mp3');
  //                             if (b) {
  //                               EventData.eventAudioFilePath =
  //                                   '${EventData.tempEventPath}/audio.mp3';
  //                               EventData.eventAudioId = item.id;
  //                               Get.close(2);
  //                             }
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           );
  //         });
  //     await assetsAudioPlayer.stop();
  //   } catch (e, s) {
  //     Completer().completeError(e, s);
  //     toastMessage('Unable to play audio');
  //   }
  // }
}
