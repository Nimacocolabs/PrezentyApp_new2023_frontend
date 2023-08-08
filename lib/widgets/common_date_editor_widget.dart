import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonDateEditorWidget extends StatefulWidget {
 final String? field;
final    String? labelText;
   final TextEditingController? control;
    final Widget? suffixWid;
  const CommonDateEditorWidget({this.field,this.labelText,this.control,this.suffixWid});

  @override
  State<CommonDateEditorWidget> createState() => _CommonDateEditorWidgetState();
}

class _CommonDateEditorWidgetState extends State<CommonDateEditorWidget> {
 
  static final RegExp _dateRedExp =
      RegExp('^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])');
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(
              12)), // contentPadding: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(
        left: 12,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        controller: widget.control,
        keyboardType: TextInputType.datetime,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        validator: (value) {
          return value!.isEmpty ||
                  value.length > 10 ||
                  value.length < 8 ||
                  _dateRedExp.hasMatch(value)
              ? "YYYY-MM-DD"
              : null;
        },
        onEditingComplete: () => FocusManager.instance.primaryFocus!.unfocus(),
        style: TextStyle(fontSize: 14, color: Colors.black54),
        decoration: InputDecoration(
            suffix: widget.suffixWid,
            hintText: widget.labelText,
            label: Text(widget.field!),
            enabledBorder: InputBorder.none,
            border: InputBorder.none),
      ),
    );
  }
   _calenderDatePick(String? dateToString, DateTime? date, bool? isDateSelected,
      TextEditingController dateControl) {
    return IconButton(
        icon: Icon(Icons.event, color: primaryColor),
        onPressed: () async {
          final datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2100));
          if (datePick != null && datePick != date) {
            setState(() {
              date = datePick;
              isDateSelected = true;

              // put it here
              dateToString =
                  "${date!.year}-${date!.month}-${date!.day}"; // 08/14/2019
              dateControl.text = dateToString!;
            });
            FocusManager.instance.primaryFocus!.unfocus();
          }
        });
  }
}