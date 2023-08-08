
import 'dart:io';

import 'package:event_app/screens/event/choose_event_video_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/templates.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_dummy_screen.dart';
import 'image_editor_preview_screen.dart';
import 'image_editor_screen.dart';
import 'template_list_screen.dart';

class TemplateCategoryListScreen extends StatefulWidget {
  const TemplateCategoryListScreen({Key? key}) : super(key: key);

  @override
  _TemplateCategoryListScreenState createState() =>
      _TemplateCategoryListScreenState();
}

class _TemplateCategoryListScreenState
    extends State<TemplateCategoryListScreen> {
  late String selectedTemplate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if(EventData.templateFilePath.isNotEmpty)
            TextButton(
              style:ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.white30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Next', style: TextStyle(color: Colors.white),),
              ),
              onPressed: (){
                print(selectedTemplate);
               if (selectedTemplate != 'Charity'){
                Get.to(()=>CreateDummyScreen());
              }else{
                 Get.to(()=>CreateDummyScreen(isCharity: true));
               }
              },
            ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          if(EventData.templateFilePath.isNotEmpty)
          Column(
            children: [
              TitleWithSeeAllButton(title: 'Selected event template'),
              Padding(
                padding: const EdgeInsets. fromLTRB(8, 0, 8, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    color: primaryColor,
                    child:
                        EventData.templateType == TemplateType.VIDEO_FILE
                            ? InkWell(
                      onTap: _selectVideo,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 80,width: 80,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor,
                              ),
                              child: Icon(
                                Icons.play_circle_filled_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Text(
                                'Video',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            _deleteButton(),
                          ],
                        ),
                      ),
                    )
                        :InkWell(
                      onTap: () {
                        Get.to(()=>ImageEditorPreviewScreen(imagePath: EventData.templateFilePath,hasAudio: EventData.eventAudioFilePath != null,));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 80,width: 80,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(EventData.templateFilePath))),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Text(
                                'Image',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            _deleteButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),

          TitleWithSeeAllButton(title: 'Select your Event'),
          GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
            padding: EdgeInsets.all(4),
            itemCount: templateList.length + 2,
            itemBuilder: (_, i) {
              if (i == 0) {
                return GestureDetector(
                  onTap: () async {
                    selectedTemplate = "Empty Canvas";
                    if((await _promptRemoveSelection())){
                      await Get.to(() => ImageEditorScreen());

                     await EventData.evictImage();
                      setState(() { });
                    }
                  },
                  child: Card(
                    color: secondaryColor.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(
                            Icons.pages,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Empty Canvas',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                );
              }
              else if (i == 1) {
                return GestureDetector(
                  onTap: () async {
                    selectedTemplate = "Video";
                    if((await _promptRemoveSelection())){
                      _selectVideo();
                    }
                  },
                  child: Card(
                    color: secondaryColor.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(
                            Icons.ondemand_video_rounded,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Video File',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              int index = i - 2;
              return GestureDetector(
                onTap: () async {
                  if((await _promptRemoveSelection())){
                    selectedTemplate =  templateList[index].title;
                   await  Get.to(() => TemplateListScreen(
                    templateCategory: templateList[index]));

                  await EventData.evictImage();
                   setState(() { });
                  }
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/event_tile_bg/bg_${index}.png',
                            fit: BoxFit.cover,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //todo check why charity image shouldn't be displayed
                              templateList[index].title == "Charity"? Container():
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child:Image.asset(templateList[index].icon),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                templateList[index].title == "Charity"? "":templateList[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  _selectVideo() async {
    bool? b = await Get.to(()=>ChooseEventVideoScreen(selectedVideoFilePath:EventData.templateFilePath),opaque: false);

    if(b??false){
    }

      setState(() { });
  }

  Future<bool> _promptRemoveSelection() async {
    if(EventData.templateFilePath.isEmpty) return true;

    bool? b = await Get.dialog(
      Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                    child: Text(
                      EventData.templateType ==TemplateType.VIDEO_FILE ?
                      'You are currently selected a video template. Do you want to remove your selection?'
                      : 'You are currently selected an image template. Do you want to remove your selection?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back(result: false);
                          },
                          child: Text('No'),
                        ),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            EventData.templateType = null;
                            EventData.templateFilePath ='';
                            Get.back(result: true);
                          },
                          child: Text('Yes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.black54,
    );

    return b??false;
  }

  Widget _deleteButton() {
    return IconButton(
        onPressed: ()async {
          bool b = await _promptRemoveSelection();
          if(b) {
            setState(() {});
          }
        },
        icon: Icon(Icons.delete_rounded,color: Colors.white,));
  }
}
