import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'image_editor_screen.dart';

class TemplateListScreen extends StatefulWidget {
  final TemplateCategory templateCategory;

  const TemplateListScreen({Key? key, required this.templateCategory})
      : super(key: key);

  @override
  _TemplateListScreenState createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          TitleWithSeeAllButton(
              title: '${widget.templateCategory.title}'),
          GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            padding: EdgeInsets.all(4),
            itemCount: widget.templateCategory.templateList.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(()=>ImageEditorScreen(
                    layers: widget.templateCategory.templateList[index].data,
                  ));
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.templateCategory.templateList[index].preview,
                        fit: BoxFit.cover,
                      )),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
