import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextBox extends StatefulWidget {
  final TextFieldControl? textFieldControl;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final Function(String)? onChanged;
  final TextAlign textAlign;

  final EdgeInsets padding;

  const AppTextBox(
      {Key? key,
      this.textFieldControl,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLines,
      this.textCapitalization,
      this.obscureText = false,
      this.enabled = true,
      this.onChanged, this.textAlign = TextAlign.start,  this.padding=const EdgeInsets.symmetric(vertical: 8)})
      : super(key: key);

  @override
  _AppTextBoxState createState() => _AppTextBoxState();
}

class _AppTextBoxState extends State<AppTextBox> {
  late TextFieldControl textFieldControl;
  late TextInputType keyboardType;
  late TextInputAction textInputAction;
  late String hintText;

  // Widget? prefixIcon;
  Widget? suffixIcon;
  late int maxLines;
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    textFieldControl = widget.textFieldControl ?? TextFieldControl();
    keyboardType = widget.keyboardType;
    textInputAction = widget.textInputAction;
    obscureText = widget.obscureText;
    hintText = widget.hintText ?? '';
    maxLines = widget.maxLines ?? 1;
    // if (widget.prefixIcon != null) {
    //   prefixIcon = Icon(
    //     widget.prefixIcon,
    //     // color: color1,
    //   );
    // }
    if (widget.suffixIcon != null) {
      suffixIcon = widget.suffixIcon;
    }
  }

  bool b = true;

  @override
  Widget build(BuildContext context) {
    if (widget.suffixIcon == null && obscureText) {
      suffixIcon = IconButton(
          icon: Icon(b ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              b = !b;
            });
          });
    }

    return Container(
        // decoration: BoxDecoration(
        // border: Border.all(color: widget.enabled ? Colors.black26 : Colors.black12),
        // borderRadius: const BorderRadius.all(Radius.circular(8)),
        // ),
        margin: widget.padding,
        child: TextField(
          textCapitalization: widget.textCapitalization??TextCapitalization.none,
          enabled: widget.enabled,
          textAlign: widget.textAlign,
          obscureText: obscureText ? b : false,
          scrollPhysics: BouncingScrollPhysics(),
          controller: textFieldControl.controller,
          focusNode: textFieldControl.focusNode,
          keyboardType: keyboardType,
          inputFormatters: keyboardType != TextInputType.number
              ? null
              : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          minLines: 1,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            // border: InputBorder.none,
            // disabledBorder: InputBorder.none,
            // enabledBorder: InputBorder.none,
            // errorBorder: InputBorder.none,
            // focusedBorder: InputBorder.none,
            // focusedErrorBorder: InputBorder.none,

            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.black12)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: primaryColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: primaryColor)),

            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
        ));
  }
}

class TextFieldControl {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
}
