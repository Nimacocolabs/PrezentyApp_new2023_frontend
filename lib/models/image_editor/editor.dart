// import 'package:event_app/util/app_helper.dart';
// import 'package:flutter/material.dart';
//
// enum AudioPlayerState { stopped, playing, paused }
//
// enum BottomContent {
//   None,
//   ImageProperties,
//   TextProperties,
//   CanvasProperties,
//   Layers,
//   Music,
// }
//
// enum LayerType {
//   Canvas,
//   Image,
//   Text,
// }
//
// class Layer {
//   LayerType type;
//   dynamic properties;
//
//   Layer(this.type, this.properties);
// }
//
// class CanvasProperties {
//   bool isLocked = false;
//   Color color = Colors.white;
//   double width = screenWidth - 50;
//   double height = screenWidth - 50;
//
//   CanvasProperties();
//
//   CanvasProperties.canvas(
//       this.isLocked, this.color, double width, double height) {
//     this.height = screenHeight - height;
//     this.width = screenWidth - width;
//
//     debugPrint('h:${this.height}');
//     debugPrint('w:${this.width}');
//   }
//
//   CanvasProperties copy(CanvasProperties p) {
//     this.isLocked = p.isLocked;
//     this.color = p.color;
//     this.width = p.width;
//     this.height = p.height;
//     return this;
//   }
// }
//
// class ImageProperties {
//   bool isLocked = false;
//   Offset position = Offset(0, 0);
//   String imagePath = 'assets/images/ic_editor_placeholder.png';
//   bool isAsset = false;
//   double height = 100;
//   double width = 100;
//   double rotate = 0;
//
//   ImageProperties(this.imagePath);
//
//   ImageProperties.image(this.isLocked, this.position, this.imagePath,
//       this.isAsset, width, height, this.rotate) {
//     this.height = screenHeight - height;
//     this.width = screenWidth - width;
//   }
//
//   ImageProperties copy(ImageProperties p) {
//     this.isLocked = p.isLocked;
//     this.position = p.position;
//     this.imagePath = p.imagePath;
//     this.isAsset = p.isAsset;
//     this.height = p.height;
//     this.width = p.width;
//     this.rotate = p.rotate;
//     return this;
//   }
// }
//
// class TextProperties {
//   bool isLocked = false;
//   Offset position = Offset(0, 0);
//   String text = 'Tap to edit text';
//   double size = 20;
//   Color color = Colors.black;
//   Color backgroundColor = Colors.transparent;
//   String fontFamily = 'serif';
//   bool isItalic = false;
//   bool isBold = false;
//   bool hasUnderLine = false;
//   TextAlign alignment = TextAlign.start;
//   double rotate = 0;
//   double width = 200;
//
//   TextProperties();
//
//   TextProperties copy(TextProperties p) {
//     this.isLocked = p.isLocked;
//     this.position = p.position;
//     this.text = p.text;
//     this.size = p.size;
//     this.color = p.color;
//     this.backgroundColor = p.backgroundColor;
//     this.fontFamily = p.fontFamily;
//     this.isItalic = p.isItalic;
//     this.isBold = p.isBold;
//     this.hasUnderLine = p.hasUnderLine;
//     this.alignment = p.alignment;
//     this.rotate = p.rotate;
//     this.width = p.width;
//
//     return this;
//   }
//
//   TextProperties.text1(
//       this.isLocked,
//       this.position,
//       this.text,
//       this.size,
//       this.color,
//       this.backgroundColor,
//       this.fontFamily,
//       this.isItalic,
//       this.isBold,
//       this.hasUnderLine,
//       this.alignment,
//       this.rotate,
//       this.width);
//
//   TextProperties.text(
//       this.isLocked,
//       this.position,
//       this.text,
//       this.size,
//       this.color,
//       this.backgroundColor,
//       this.fontFamily,
//       this.isItalic,
//       this.isBold,
//       this.hasUnderLine,
//       this.alignment,
//       this.rotate,
//       width) {
//     this.width = screenWidth - width;
//   }
// }
//
// class Template {
//   final String preview;
//   final List<Layer> data;
//
//   Template(this.preview, this.data);
// }
//
// class TemplateCategory {
//   final String title;
//   final String icon;
//   final List<Template> templateList;
//
//   TemplateCategory(this.title, this.icon, this.templateList);
// }
