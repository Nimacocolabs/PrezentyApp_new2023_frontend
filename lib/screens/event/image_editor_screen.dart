import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:event_app/screens/event/image_editor_preview_screen.dart';

import 'create_event_preview_screen.dart';
import 'create_event_progress_dialog_screen.dart';
import 'pick_recommended_music_screen.dart';

class ImageEditorScreen extends StatefulWidget {
  final bool isEdit;
  final List<Layer>? layers;

  const ImageEditorScreen({Key? key, this.layers, this.isEdit = false})
      : super(key: key);

  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  GlobalKey _canvasKey = GlobalKey();

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _playerPosition = Duration(seconds: 0);
  File? _musicFile;

  BottomContent _currentBottomContent = BottomContent.None;
  TextEditingController _textEditingController = TextEditingController();
  ScreenshotController _screenshotController = ScreenshotController();
  int _currentLayerIndex = 0;
  List<Layer> layerList = [Layer(LayerType.Canvas, CanvasProperties())];
  List fontList = [
    'serif',
    'Helvetica',
    'Akronim',
    'BungeeHairline',
    'Codystar',
    'Cookie',
    'DancingScript',
    'GreatVibes',
    'KaushanScript',
    'MontserratSubrayada',
    'Pacifico',
    'Parisienne',
    'Play',
    'RobotoMono',
    'Satisfy',
    'Tangerine',
    'Ubuntu',
    'ZenTokyoZoo'
  ];

  // double maxScreenWidth = 0;
  // double maxScreenHeight = 0;

  double canvasSize =0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);

      // maxScreenWidth = screenWidth *.88;
      // maxScreenHeight = screenHeight *.88;

      canvasSize = screenWidth *.88;

      if (widget.layers == null) {
        layerList = [Layer(LayerType.Canvas, CanvasProperties())];
      } else {
        layerList = [];
        widget.layers!.forEach((element) {
          if (element.type == LayerType.Text) {
            layerList.add(Layer(
                LayerType.Text, TextProperties().copy(element.properties)));
          } else if (element.type == LayerType.Image) {
            layerList.add(Layer(
                LayerType.Image, ImageProperties('').copy(element.properties)));
          } else if (element.type == LayerType.Canvas) {
            layerList.add(Layer(
                LayerType.Canvas, CanvasProperties().copy(element.properties)));
          }
        });
        // layerList = List.from(widget.layers!);
      }

      if (EventData.templateType == TemplateType.IMAGE_FILE) {
        File file = File(EventData.templateFilePath);
        await FileImage(file).evict();
      }

      if (widget.isEdit && EventData.eventAudioFilePath != null) {
        _musicFile = File(EventData.eventAudioFilePath!);
      }

      initPlayer();

      // if (!await Permission.storage.request().isGranted) {
      //   debugPrint('no permission');
      //   Navigator.pop(context);
      // }
      setState(() {});
    });
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    layerList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBack();
        return false;
      },
      child: screenWidth == 0
          ? Container()
          : Scaffold(
        appBar: AppBar(
          leading:
          IconButton(icon: Icon(Icons.clear), onPressed: _onBack),
          actions: <Widget>[
            // IconButton(icon: Icon(Icons.system_update_alt),onPressed: _logData),

            GestureDetector(
                onTap: _logData,
                child: Container(
                    height: 50, width: 50, color: Colors.transparent)),

            // IconButton(
            //   icon: Icon(Icons.info_outline),
            //   onPressed: (){
            //     Get.to(()=>InfoScreen(videoId: 'create_event'));
            //   },
            // ),
            VerticalDivider(
              color: Colors.white70,
              indent: 12,
              endIndent: 12,
              width: 1,
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Preview',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                _save(true);
              },
            ),
            VerticalDivider(
              color: Colors.white70,
              indent: 12,
              endIndent: 12,
              width: 1,
            ),
            widget.isEdit
                ? TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white30),
              ),
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _update();
              },
            )
                : TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white30),
              ),
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _save(false);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200,
                    child: _canvas(),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                LayoutBuilder(
                  builder: (_, __) {
                    switch (_currentBottomContent) {
                      case BottomContent.ImageProperties:
                        return _bottomWidgetEditImageProperties();

                      case BottomContent.TextProperties:
                        return _bottomWidgetEditTextProperties();

                      case BottomContent.CanvasProperties:
                        return _bottomWidgetEditCanvasProperties();

                      case BottomContent.Layers:
                        return _bottomWidgetLayerList();

                      case BottomContent.Music:
                        return _bottomWidgetMusic();

                      default:
                        return _bottomWidgetNavigation();
                    }
                  },
                ),
              ]),
        ),
      ),
    );
  }

  Widget _canvas() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: (layerList[0].properties as CanvasProperties).size,
        width: (layerList[0].properties as CanvasProperties).size,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentBottomContent = BottomContent.CanvasProperties;
              _currentLayerIndex = 0;
            });
          },
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              key: _canvasKey,
              decoration: BoxDecoration(
                color: (layerList[0].properties as CanvasProperties).color,
              ),
              child: Stack(
                children: _buildLayersOverCanvas(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomWidgetNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _setBottomWidget(null);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          layerList[_currentLayerIndex].type == LayerType.Canvas
                              ? Icons.pages
                              : layerList[_currentLayerIndex].type == LayerType.Image
                              ? Icons.image_outlined
                              : layerList[_currentLayerIndex].type == LayerType.Text
                              ? Icons.text_fields
                              : Icons.error_outline,
                          color: primaryColor,
                        ),
                        TextButton(onPressed: null, child: Text('Edit',style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w400),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 1,),
            Expanded(
              child: InkWell(
                onTap: () {
                    setState(() {
                      _currentBottomContent = BottomContent.Layers;
                    });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.layers,
                          color: primaryColor,
                        ),
                        // SizedBox(width: 12,),
                        TextButton(onPressed: null, child: Text('Layers',style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w400),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 1,),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_musicFile == null) {
                    _pickAMusic();
                  } else {
                    setState(() {
                      _currentBottomContent = BottomContent.Music;
                    });
                  }
                },
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            VerticalDivider(width: 1,),
            SizedBox(width: 8,),
            FloatingActionButton(
                mini: true,
                child: Icon(Icons.add_rounded),
                onPressed: () async {
                  await _pickALayer();
                  setState(() {});
                })
          ],
        ),
      ),
    );
  }

  Widget _bottomWidgetLayerList() {
    return Container(
      height: screenHeight * .28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.clear,
                  color: Colors.blueGrey,
                ),
              ),
              onTap: _onBack,
            ),
            Text(
              'Layers',
              style: TextStyle(color: primaryColor),
            ),
            SizedBox(
              width: 22,
            ),
          ],
        ),
        Divider(
          height: 1,
        ),
        Flexible(
          child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              reverse: true,
              onReorder: (oldIndex, newIndex) {
                _currentLayerIndex = 0;
                if (oldIndex == 0 || newIndex == 0) {
                  return;
                }

                layerList.insert(newIndex, layerList[oldIndex]);
                layerList
                    .removeAt(oldIndex > newIndex ? oldIndex + 1 : oldIndex);
                setState(() {});
              },
              itemCount: layerList.length,
              itemBuilder: (context, index) {
                IconData icon = Icons.error_outline;
                Widget preview = Text('');
                String type = '';

                if (layerList[index].type == LayerType.Canvas) {
                  icon = Icons.pages;
                  type = 'Canvas';
                } else if (layerList[index].type == LayerType.Text) {
                  icon = Icons.text_fields;
                  type = 'Text';
                  preview = Text(
                    '${layerList[index].properties.text}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  );
                } else if (layerList[index].type == LayerType.Image) {
                  icon = Icons.image_outlined;
                  type = 'Image';
                  preview = Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: 40,
                    width: 40,
                    child: layerList[index].properties.isAsset
                        ? Image.asset(
                      '${layerList[index].properties.imagePath}',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    )
                        : Image.file(
                      File('${layerList[index].properties.imagePath}'),
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                  );
                } else {}

                return ListTile(
                  key: ValueKey(layerList[index]),
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(type),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: preview,
                        ),
                      )
                    ],
                  ),
                  leading: Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  trailing: index == 0
                      ? SizedBox()
                      : Icon(
                    Icons.reorder,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _setBottomWidget(index);
                  },
                );
              }),
        ),
      ]),
    );
  }

  Widget _bottomWidgetEditTextProperties() {
    _textEditingController.text = layerList[_currentLayerIndex].properties.text;
    _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length));
    TextProperties properties = (layerList[_currentLayerIndex].properties as TextProperties);

    return Container(
        height: screenHeight * .28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: _onBack,
                ),
                Text(
                  'Text Properties',
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      properties.isLocked ? Icons.lock : Icons.lock_open,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      layerList[_currentLayerIndex].properties.isLocked =
                      !properties.isLocked;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 8),
                      CupertinoTextField(
                        controller: _textEditingController,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          ),
                        ),
                        placeholder: 'Text',
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (val) {
                          (layerList[_currentLayerIndex].properties
                          as TextProperties)
                              .text = val;
                        },
                        onSubmitted: (v){
                          setState(() {});
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Color'),
                        trailing: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: properties.color,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          Color color = await _pickAColor(properties.color);
                          setState(() {
                            (layerList[_currentLayerIndex].properties
                            as TextProperties)
                                .color = color;
                          });
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Background Color'),
                        trailing: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: properties.backgroundColor,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          Color color =
                          await _pickAColor(properties.backgroundColor);
                          setState(() {
                            (layerList[_currentLayerIndex].properties
                            as TextProperties)
                                .backgroundColor = color;
                          });
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Font'),
                        trailing: Text(
                          properties.fontFamily,
                          style: TextStyle(fontFamily: properties.fontFamily),
                        ),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          (layerList[_currentLayerIndex].properties
                          as TextProperties)
                              .fontFamily =
                          await _pickAFont(
                              properties.fontFamily, properties.text);
                          setState(() {});
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Style'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_italic,
                                  color: properties.isItalic
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .isItalic = !properties.isItalic;
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_bold,
                                  color: properties.isBold
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .isBold = !properties.isBold;
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_underline,
                                  color: properties.hasUnderLine
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .hasUnderLine = !properties.hasUnderLine;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Alignment'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_align_left,
                                  color: properties.alignment == TextAlign.start
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .alignment = TextAlign.start;
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_align_center,
                                  color:
                                  properties.alignment == TextAlign.center
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .alignment = TextAlign.center;
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_align_right,
                                  color: properties.alignment == TextAlign.end
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .alignment = TextAlign.end;
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.format_align_justify,
                                  color:
                                  properties.alignment == TextAlign.justify
                                      ? primaryColor
                                      : Colors.black26,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  (layerList[_currentLayerIndex].properties
                                  as TextProperties)
                                      .alignment = TextAlign.justify;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Font size'),
                        trailing: Text('${properties.size.floor()}'),
                        title: CupertinoSlider(
                          min: 8,
                          max: canvasSize,
                          divisions: (canvasSize - 14).floor(),
                          value: properties.size,
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as TextProperties)
                                  .size = val;
                            });
                          },
                        ),
                      ),
                      // Divider(
                      //   height: 1,
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   contentPadding: EdgeInsets.zero,
                      //   leading: Text('Width'),
                      //   trailing: Text('${properties.width.floor()}'),
                      //   title: CupertinoSlider(
                      //     min: 50,
                      //     max: maxScreenWidth,
                      //     divisions: (maxScreenWidth - 50).floor(),
                      //     onChanged: (val) {
                      //       setState(() {
                      //         (layerList[_currentLayerIndex].properties
                      //                 as TextProperties)
                      //             .width = val;
                      //       });
                      //     },
                      //     value: properties.width,
                      //   ),
                      // ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Rotate'),
                        trailing:
                        Text('${(properties.rotate * 180).floor()}\u00b0'),
                        title: CupertinoSlider(
                          min: 0,
                          max: 2,
                          divisions: 360,
                          value: properties.rotate,
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as TextProperties)
                                  .rotate = val;
                            });
                          },
                        ),
                      ),
                      Divider(height: 1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: secondaryColor.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Reset position',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onTap: () {
                                layerList[_currentLayerIndex]
                                    .properties
                                    .position = Offset(0, 0);
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onTap: () {
                                _confirmDeleteLayer('text');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _layerLockedOverlay(properties.isLocked,  (){setState(() {
                    layerList[_currentLayerIndex].properties.isLocked = false;
                  });}),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _bottomWidgetEditImageProperties() {
    ImageProperties properties =
    (layerList[_currentLayerIndex].properties as ImageProperties);

    return Container(
        height: screenHeight * .28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: _onBack,
                ),
                Text(
                  'Image Properties',
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      properties.isLocked ? Icons.lock : Icons.lock_open,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      layerList[_currentLayerIndex].properties.isLocked =
                      !properties.isLocked;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('File'),
                        trailing: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: properties.isAsset
                              ? Image.asset(
                            '${properties.imagePath}',
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                          )
                              : Image.file(
                            File('${properties.imagePath}'),
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                        onTap: () async {
                          XFile? pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            (layerList[_currentLayerIndex].properties
                            as ImageProperties)
                                .imagePath = pickedFile.path;
                            (layerList[_currentLayerIndex].properties
                            as ImageProperties)
                                .isAsset = false;
                            setState(() {});
                          }
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Height'),
                        title: CupertinoSlider(
                          min: 20,
                          max: canvasSize,
                          divisions: (canvasSize - 20).floor(),
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as ImageProperties)
                                  .height = val;
                            });
                          },
                          value: properties.height,
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Width'),
                        title: CupertinoSlider(
                          min: 20,
                          max: canvasSize,
                          divisions: (canvasSize-20).floor(),
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as ImageProperties)
                                  .width = val;
                            });
                          },
                          value: properties.width,
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Rotate'),
                        trailing:
                        Text('${(properties.rotate * 180).floor()}\u00b0'),
                        title: CupertinoSlider(
                          min: 0,
                          max: 2,
                          divisions: 360,
                          value: properties.rotate,
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as ImageProperties)
                                  .rotate = val;
                            });
                          },
                        ),
                      ),
                      Divider(height: 1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: secondaryColor.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Reset position',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onTap: () {
                                layerList[_currentLayerIndex]
                                    .properties
                                    .position = Offset(0, 0);
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onTap: () {
                                _confirmDeleteLayer('image');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _layerLockedOverlay(properties.isLocked, (){setState(() {
    layerList[_currentLayerIndex].properties.isLocked = false;
    });}),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _bottomWidgetEditCanvasProperties() {
    CanvasProperties properties =
    (layerList[_currentLayerIndex].properties as CanvasProperties);

    return Container(
        height: screenHeight * .28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: _onBack,
                ),
                Text(
                  'Canvas Properties',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      properties.isLocked ? Icons.lock : Icons.lock_open,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      layerList[_currentLayerIndex].properties.isLocked =
                      !properties.isLocked;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Background Color'),
                        trailing: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: properties.color,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        onTap: () async {
                          Color color = await _pickAColor(properties.color);
                          setState(() {
                            (layerList[_currentLayerIndex].properties
                            as CanvasProperties)
                                .color = color;
                          });
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Size'),
                        title: CupertinoSlider(
                          min: 20,
                          max: canvasSize,
                          divisions: (canvasSize - 20).floor(),
                          onChanged: (val) {
                            setState(() {
                              (layerList[_currentLayerIndex].properties
                              as CanvasProperties)
                                  .size = val;
                            });
                          },
                          value: properties.size,
                        ),
                      ),

                      // ListTile(
                      //   dense: true,
                      //   contentPadding: EdgeInsets.zero,
                      //   leading: Text('Height'),
                      //   title: CupertinoSlider(
                      //     min: 20,
                      //     max: canvasSize,
                      //     divisions: (canvasSize - 20).floor(),
                      //     onChanged: (val) {
                      //       setState(() {
                      //         (layerList[_currentLayerIndex].properties
                      //                 as CanvasProperties)
                      //             .height = val;
                      //       });
                      //     },
                      //     value: properties.height,
                      //   ),
                      // ),
                      // Divider(
                      //   height: 1,
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   contentPadding: EdgeInsets.zero,
                      //   leading: Text('Width'),
                      //   title: CupertinoSlider(
                      //     min: 20,
                      //     max: canvasSize,
                      //     divisions: (canvasSize - 20).floor(),
                      //     onChanged: (val) {
                      //       setState(() {
                      //         (layerList[_currentLayerIndex].properties
                      //                 as CanvasProperties)
                      //             .width = val;
                      //       });
                      //     },
                      //     value: properties.width,
                      //   ),
                      // ),
                    ],
                  ),
                  _layerLockedOverlay(properties.isLocked, (){setState(() {
                    layerList[_currentLayerIndex].properties.isLocked = false;
                  });}),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _layerLockedOverlay(bool isLocked, VoidCallback? onTap) {
    return isLocked
        ? Positioned.fill(
      child: Container(
        alignment: Alignment.center,
        color: Colors.black26,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.blueGrey,
                ),
                SizedBox(height: 8),
                Text('Locked'),
              ],
            ),
          ),
        ),
      ),
    )
        : Container();
  }

  _confirmDeleteLayer(String type) async {
    await showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return Container(
            height: screenHeight * .28,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you sure to remove the $type?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(primary: Colors.redAccent),
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentBottomContent = BottomContent.None;
                          layerList.removeAt(_currentLayerIndex);
                          _currentLayerIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  Widget _layerItem(int index, {bool isDraggable = false}) {
    LayerType type = layerList[index].type;
    var properties = layerList[index].properties;

    Widget child = SizedBox(
      height: 0,
      width: 0,
    );
    Function onTap = () {};

    if (type == LayerType.Text) {
      onTap = () {
        setState(() {
          _currentBottomContent = BottomContent.TextProperties;
          _currentLayerIndex = index;
        });
      };
      child = Container(
        // width: properties.width,
        child: Text(
          '${properties.text}',
          textAlign: properties.alignment,
          style: TextStyle(
            color: properties.color,
            backgroundColor: properties.backgroundColor,
            fontWeight: properties.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle:
            properties.isItalic ? FontStyle.italic : FontStyle.normal,
            decoration:
            properties.hasUnderLine ? TextDecoration.underline : null,
            fontSize: properties.size,
            fontFamily: properties.fontFamily,
          ),
        ),
      );
    } else if (type == LayerType.Image) {
      onTap = () {
        setState(() {
          _currentBottomContent = BottomContent.ImageProperties;
          _currentLayerIndex = index;
        });
      };
      child = Container(
        child: properties.isAsset
            ? Image.asset('${properties.imagePath}',
            fit: BoxFit.fill,
            height: properties.height,
            width: properties.width)
            : Image.file(File('${properties.imagePath}'),
            fit: BoxFit.fill,
            height: properties.height,
            width: properties.width),
      );
    } else {
      return child;
    }

    if (isDraggable) {
      return Transform.rotate(
          angle: 3.14 * properties.rotate,
          child: Opacity(
              opacity: 0.6,
              child: Material(color: Colors.transparent, child: child)));
    }

    if (_currentLayerIndex == index) {
      Widget dragFeedback = Transform.rotate(
          angle: 3.14 * properties.rotate,
          child: Material(color: Colors.transparent, child: child));

      child = GestureDetector(
        child: child,
        onTap: () {
          onTap();
        },
      );

      child = DottedBorder(
          dashPattern: [30, 0],
          padding: EdgeInsets.zero,
          strokeWidth: 2,
          color:
          _currentLayerIndex == index ? Colors.green : Colors.transparent,
          child: DottedBorder(
            dashPattern: [8, 5],
            padding: EdgeInsets.zero,
            strokeWidth: 2,
            color: _currentLayerIndex == index
                ? (properties.isLocked ? Colors.grey : Colors.red)
                : Colors.transparent,
            child: Container(
                decoration: _currentLayerIndex != index
                    ? null
                    : BoxDecoration(
                    border: Border.all(color: Colors.transparent)),
                child: child),
          ));
      if (!properties.isLocked) {
        child = Draggable(
          feedback: Opacity(opacity: 0.6, child: dragFeedback),
          onDraggableCanceled: (velocity, offset) {
            _updateLayerDraggingPosition(index, offset);
          },
          child: child,
        );
      }
    } else {
      child = GestureDetector(
        child: child,
        onTap: () {
          onTap();
        },
      );
      if (!layerList[_currentLayerIndex].properties.isLocked) {
        child = Draggable(
            feedback: _layerItem(_currentLayerIndex, isDraggable: true),
            onDraggableCanceled: (velocity, offset) {
              _updateLayerDraggingPosition(index, offset);
            },
            child: child);
      }
    }

    return Positioned(
        left: _percentageToVal(canvasSize, properties.position.dx) -
            (_currentLayerIndex == index ? 1 : 0),
        top: _percentageToVal(canvasSize, properties.position.dy) -
            (_currentLayerIndex == index ? 1 : 0),
        child: Transform.rotate(angle: 3.14 * properties.rotate, child: child));
  }

  List<Widget> _buildLayersOverCanvas() {
    List<Widget> list = [];

    for (int i = 1; i < layerList.length; i++) {
      list.add(_layerItem(i));
    }
    return list;
  }

  _updateLayerDraggingPosition(int index, Offset position) {
    Offset? offset =
    (_canvasKey.currentContext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);

    layerList[_currentLayerIndex].properties.position =
    // Offset(position.dx - offset.dx, position.dy - offset.dy);
    Offset(_valToPercentage(canvasSize, position.dx - offset.dx),
        _valToPercentage(canvasSize, position.dy - offset.dy));

    setState(() {});
  }

  _setBottomWidget(int? index) {
    _currentLayerIndex = index ?? _currentLayerIndex;

    switch (layerList[_currentLayerIndex].type) {
      case LayerType.Canvas:
        _currentBottomContent = BottomContent.CanvasProperties;
        break;
      case LayerType.Image:
        _currentBottomContent = BottomContent.ImageProperties;
        break;
      case LayerType.Text:
        _currentBottomContent = BottomContent.TextProperties;
        break;
      default:
        _currentBottomContent = BottomContent.None;
        return;
    }
    setState(() {});
  }

  Future<String> _pickAFont(String font, String text) async {
    String tempFont = font;

    await showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: screenHeight * .28,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: tempFont,
                              fontSize: 20,
                              color: primaryColor),
                        ),
                      ),
                      Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: fontList.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                selected: tempFont == fontList[index],
                                trailing: tempFont == fontList[index]
                                    ? Icon(Icons.check_circle_outline)
                                    : SizedBox(),
                                title: Text(
                                  fontList[index],
                                  style: TextStyle(fontFamily: fontList[index]),
                                ),
                                onTap: () {
                                  setState(() {
                                    tempFont = fontList[index];
                                  });
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                );
              });
        });

    return tempFont;
  }

  Future<Color> _pickAColor(Color current) async {
    Color pickerColor = current;
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.5,
              ),
            ],
          );
        });
    return pickerColor;
  }

  Future _pickALayer() async {
    await showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: screenHeight * .28,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'New Layer',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      Divider(height: 1),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                child: Container(
                                  width: screenWidth * .35,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Image'),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    _addNewLayer(
                                        Layer(LayerType.Image,
                                            ImageProperties(pickedFile.path)),
                                        BottomContent.ImageProperties);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                child: Container(
                                  width: screenWidth * .35,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.text_fields),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Text'),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  _addNewLayer(
                                      Layer(LayerType.Text, TextProperties()),
                                      BottomContent.TextProperties);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  _addNewLayer(Layer layer, BottomContent content) {
    layerList.add(layer);
    _currentLayerIndex = layerList.length - 1;
    _currentBottomContent = content;
    setState(() {});
  }

  Future<String?> _saveImage() async {
    setState(() {
      _currentBottomContent = BottomContent.None;
      _currentLayerIndex = 0;
    });

    // if (!await Permission.storage.request().isGranted) {
    //   debugPrint('no permission');
    //   return null;
    // }

    String folder;
    if (Platform.isAndroid) {
      // folder = '/storage/emulated/0/Event/temp/';
      folder = (await getExternalStorageDirectory())!.path +
          '/Event/temp/'; // OR return "/storage/emulated/0/";
    } else {
      folder = (await getApplicationDocumentsDirectory()).path + '/Event/temp/';
    }

    // if(await Directory('$folder').exists()) await Directory(folder).delete(recursive: true);

    await Directory('$folder').create(recursive: true);
    File file = File('${folder}image.png');
    if (file.existsSync()) await file.delete(recursive: true);
    // if(await file.exists()) await file.delete();
    file = await file.create();

    double ratio = 1080 / canvasSize;
    Uint8List? binaryIntList =
    await _screenshotController.capture(pixelRatio: ratio);

    file.writeAsBytesSync(binaryIntList!);

    print(file.path);
    return file.path;
  }

//   Future<String?> _saveAudio() async {
//     if (_musicFile == null) return null;
//     if (!await Permission.storage.request().isGranted) {
//       debugPrint('no permission');
//       return null;
//     }
//
//     // String outputPath = '/storage/emulated/0/Event/temp/audio.mp3';
//     String outputPath = '${(await getExternalStorageDirectory())!.path}/Event/temp/audio.mp3';
//
//     await _musicFile!.copy(outputPath);
//
// // File file = File(outputPath);
// // if(file.existsSync()){
// //   await file.delete();
// // }
//
//     return outputPath;
//   }

  _onBack() async {
    if (_currentBottomContent != BottomContent.None) {
      audioPlayer.pause();
      setState(() {
        _currentBottomContent = BottomContent.None;
      });
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'Are you sure to go back? Any changes made will be lost.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Yes')),
              ],
            );
          });
    }
  }

  Future _pickAMusic() async {
    await showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: screenHeight * .28,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Music',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      Divider(height: 1),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                child: Container(
                                  width: screenWidth * .35,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.recommend),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Recommended'),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickRecommendedMusicScreen()));
                                  if ((EventData.eventAudioFilePath ?? '')
                                      .isNotEmpty) {
                                    _musicFile =
                                        File(EventData.eventAudioFilePath!);
                                    setState(() {});
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                child: Container(
                                  width: screenWidth * .35,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_android),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('From Device'),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  _pickAMusicFile();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future _pickAMusicFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      try {
        await File(result.files.single.path!)
            .copy('${EventData.tempEventPath}/audio.mp3');
        EventData.eventAudioFilePath = '${EventData.tempEventPath}/audio.mp3';
      } catch (e) {
        EventData.eventAudioFilePath = result.files.single.path!;
      }
      _musicFile = File(EventData.eventAudioFilePath!);
      _playerPosition = Duration(seconds: 0);
      setState(() {
        _currentBottomContent = BottomContent.Music;
      });
    }
  }

  Widget _bottomWidgetMusic() {
    return Container(
      height: screenHeight * .28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: _onBack,
                ),
                Text(
                  'Music',
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                  onTap: () {
                    audioPlayer.stop();
                    setState(() {
                      _currentBottomContent = BottomContent.None;
                      _musicFile = null;
                      EventData.eventAudioFilePath = null;
                      EventData.eventAudioId = null;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black12, width: 2),
                      ),
                      child: audioPlayer.state == PlayerState.PLAYING
                          ? Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(),
                          IconButton(
                              onPressed: _playButtonToggle,
                              icon:
                              Icon(Icons.pause, color: primaryColor)),
                        ],
                      )
                          : IconButton(
                          onPressed: _playButtonToggle,
                          icon:
                          Icon(Icons.play_arrow, color: primaryColor))),
                  SizedBox(height: 8),
                  Text(
                      '${_playerPosition.inMinutes.floor().toString().padLeft(2, '0')}:${(_playerPosition.inSeconds % 60).floor().toString().padLeft(2, '0')}'),
                ],
              ),
            ),
          ]),
    );
  }

  initPlayer() {
    audioPlayer.onAudioPositionChanged.listen((p) {
      _playerPosition = p;
      setState(() {});
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _playerPosition = Duration(seconds: 0);
      });
    });
  }

  _playButtonToggle() async {
    if (audioPlayer.state == PlayerState.PLAYING) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(_musicFile!.path,
          isLocal: true, position: _playerPosition);
    }

    setState(() {});
  }

  _save(bool isPreview) async {
    audioPlayer.stop();
    AppDialogs.loading(isDismissible: false);

    String? imagePath = await _saveImage();
    if (imagePath == null) {
      toastMessage('Unable to save image');
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);
    if (isPreview) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageEditorPreviewScreen(
            imagePath: imagePath,
            hasAudio: _musicFile != null,
          )));
    } else {
      EventData.templateFilePath = imagePath;
      // Navigator.of(context).push( MaterialPageRoute(builder: (context) => ChooseGiftOrVouchers()));
      // Get.to(()=>CreateDummyScreen());

      //todo check type on update
      EventData.templateType = TemplateType.IMAGE_FILE;
      if(widget.layers!=null){
        //from template list screen
        Get.back();
      }
      Get.back();
    }
  }

  _update() async {
    if (EventData.dateTime!.isBefore(DateTime.now())) {
      toastMessage('Past event cannot be edited');
      return;
    }

    AppDialogs.loading(isDismissible: false);

    try {
      audioPlayer.stop();
      String? imagePath = await _saveImage();
      if (imagePath == null) {
        toastMessage('Unable to save image');
        Navigator.pop(context);
        return;
      }

      // EventBloc _eventBloc = EventBloc();

      dio.FormData formData = dio.FormData.fromMap({
        'event_id': EventData.eventId,
        'image': await dio.MultipartFile.fromFile('$imagePath'),
        'music_file_id': EventData.eventAudioId,
        'music_file': (EventData.eventAudioId ?? 0) != 0 ||
            (EventData.eventAudioFilePath ?? '').isEmpty
            ? null
            : await dio.MultipartFile.fromFile(
            '${EventData.eventAudioFilePath}'),
      });


      // CommonResponse response = await _eventBloc.updateEvent(body);

      CommonResponse? response = await Get.to(()=>CreateEventProgressDialogScreen(formData: formData,isUpdate: true,),opaque: false);

      print('$response');

      if(response==null) return;

      if (response.success!) {
        //copy files to event

        File file = File(EventData.templateFilePath);
        if (file.existsSync()) await file.delete(recursive: true);

        await File(imagePath).copy(EventData.templateFilePath);
        EventData.templateType = TemplateType.IMAGE_FILE;

        toastMessage('Successfully updated');
        Get.back();
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e) {
      toastMessage('Something went wrong. Please try again');
    } finally {
      Get.back();
    }
  }

  _logData() {
    String data = '';

    for (int i = 0; i < layerList.length; i++) {
      if (layerList[i].type == LayerType.Canvas) {
        data +=
        "\nLayer(LayerType.Canvas,CanvasProperties.canvas("
            "${layerList[i].properties.isLocked},"
            "${layerList[i].properties.color}, "
            "${_valToPercentage(canvasSize, layerList[i].properties.size)} "
            ")),";
      } else if (layerList[i].type == LayerType.Image) {
        data += "\nLayer(LayerType.Image,ImageProperties. image("
            "${layerList[i].properties.isLocked},"
            "Offset(${_valToPercentage(canvasSize, layerList[i].properties.position.dx)}, ${_valToPercentage(canvasSize, layerList[i].properties.position.dy)}), "
            "'${layerList[i].properties.imagePath}', "
            "true, "
            "${_valToPercentage(canvasSize, layerList[i].properties.width)}, "
            "${_valToPercentage(canvasSize, layerList[i].properties.height)}, "
            "${layerList[i].properties.rotate}"
            ")),";
      } else if (layerList[i].type == LayerType.Text) {
        data += "\nLayer(LayerType.Text,TextProperties.text("
            "${layerList[i].properties.isLocked},"
            "Offset(${layerList[i].properties.position.dx}, ${layerList[i].properties.position.dy}),"
        // "Offset(${_valToPercentage(canvasSize, layerList[i].properties.position.dx)}, ${_valToPercentage(canvasSize, layerList[i].properties.position.dy)}),"
            "'''${layerList[i].properties.text}''', "
            "${_valToPercentage(canvasSize, layerList[i].properties.size)}, "
            "${layerList[i].properties.color}, "
            "${layerList[i].properties.backgroundColor}, "
            "'${layerList[i].properties.fontFamily}', "
            "${layerList[i].properties.isItalic},"
            " ${layerList[i].properties.isBold}, "
            "${layerList[i].properties.hasUnderLine}, "
            "${layerList[i].properties.alignment}, "
            "${layerList[i].properties.rotate}"
            ")),";
      } else {}
    }

    log('[\n'
        '$data'
        '\n]');
  }
}

double _valToPercentage(double max, double val) {
  return (val / max) * 100;
}

double _percentageToVal(double max, double val) {
  return max * (val / 100);
}

enum AudioPlayerState { stopped, playing, paused }

enum BottomContent {
  None,
  ImageProperties,
  TextProperties,
  CanvasProperties,
  Layers,
  Music,
}

enum LayerType {
  Canvas,
  Image,
  Text,
}

class Layer {
  LayerType type;
  dynamic properties;

  Layer(this.type, this.properties);
}

class CanvasProperties {
  bool isLocked = false;
  Color color = Colors.white;
  double size = screenWidth * .88;

  CanvasProperties();

  CanvasProperties.canvas(
      this.isLocked, this.color, double size) {
    this.size = _percentageToVal(screenWidth * .88, size);
  }

  CanvasProperties copy(CanvasProperties p) {
    this.isLocked = p.isLocked;
    this.color = p.color;
    this.size = p.size;
    return this;
  }
}

class ImageProperties {
  bool isLocked = false;
  Offset position = Offset(0, 0);
  String imagePath = 'assets/images/ic_editor_placeholder.png';
  bool isAsset = false;
  double height = 100;
  double width = 100;
  double rotate = 0;

  ImageProperties(this.imagePath);

  ImageProperties.image(this.isLocked, this.position, this.imagePath,
      this.isAsset, double width, double height, this.rotate) {
    this.height = _percentageToVal((screenWidth *.88), height);
    this.width = _percentageToVal((screenWidth *.88), width);
  }

  ImageProperties copy(ImageProperties p) {
    this.isLocked = p.isLocked;
    this.position = Offset(p.position.dx, p.position.dy);
    this.imagePath = p.imagePath;
    this.isAsset = p.isAsset;
    // this. height = _percentageToVal((screenWidth *.88), p. height);
    // this. width =  _percentageToVal(screenWidth *.88, p.width);
    this.height = p.height;
    this.width = p.width;
    this.rotate = p.rotate;

    return this;
  }
}

class TextProperties {
  bool isLocked = false;
  Offset position = Offset(0, 0);
  String text = 'Tap to edit text';
  double size = 20;
  Color color = Colors.black;
  Color backgroundColor = Colors.transparent;
  String fontFamily = 'serif';
  bool isItalic = false;
  bool isBold = false;
  bool hasUnderLine = false;
  TextAlign alignment = TextAlign.start;
  double rotate = 0;

  TextProperties();

  TextProperties copy(TextProperties p) {
    this.isLocked = p.isLocked;
    this.position = Offset(p.position.dx, p.position.dy);
    this.text = p.text;
    this.size = p.size;
    this.color = p.color;
    this.backgroundColor = p.backgroundColor;
    this.fontFamily = p.fontFamily;
    this.isItalic = p.isItalic;
    this.isBold = p.isBold;
    this.hasUnderLine = p.hasUnderLine;
    this.alignment = p.alignment;
    this.rotate = p.rotate;

    return this;
  }

  // TextProperties.text1(
  //     this.isLocked,
  //     this.position,
  //     this.text,
  //     this.size,
  //     this.color,
  //     this.backgroundColor,
  //     this.fontFamily,
  //     this.isItalic,
  //     this.isBold,
  //     this.hasUnderLine,
  //     this.alignment,
  //     this.rotate );

  TextProperties.text(
      this.isLocked,
      this.position,
      this.text,
      double size,
      this.color,
      this.backgroundColor,
      this.fontFamily,
      this.isItalic,
      this.isBold,
      this.hasUnderLine,
      this.alignment,
      this.rotate ){
    this.size=_percentageToVal((screenWidth *.88), size);
  }
}

class Template {
  final String preview;
  final List<Layer> data;

  Template(this.preview, this.data);
}

class TemplateCategory {
  final String title;
  final String icon;
  final List<Template> templateList;

  TemplateCategory(this.title, this.icon, this.templateList);
}
