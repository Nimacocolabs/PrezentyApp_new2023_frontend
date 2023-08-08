import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KYCTextBoxWidget extends StatelessWidget {
  KYCTextBoxWidget(
      {this.field,
      this.labelText,
      this.control,
      this.keyboardInputType,
      this.suffixWid,
      this.validate,
      this.format,
      this.enabled = true});

  final String? field;
  final String? labelText;
  final TextEditingController? control;
  TextInputType? keyboardInputType = TextInputType.text;
  final Widget? suffixWid;
  final dynamic validate;
  final List<TextInputFormatter>? format;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field!,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          enabled: enabled,
          controller: control,
          keyboardType: keyboardInputType!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: format,
          textCapitalization: TextCapitalization.characters,
          validator: (value) => validate(value),
          cursorHeight: 24,
          //onEditingComplete: () => field == "City"?focus.unfocus(): focus.unfocus(),
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus!.unfocus(),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black54),
          decoration: InputDecoration(
            suffixIcon: suffixWid,
            hintText: labelText,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey)),
            border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey)),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
