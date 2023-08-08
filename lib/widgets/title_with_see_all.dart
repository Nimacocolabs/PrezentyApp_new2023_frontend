import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class TitleWithSeeAllButton extends StatelessWidget {
  final String title;
  final Function? seeAllOnTap;
  final EdgeInsets? margin;

  const TitleWithSeeAllButton(
      {Key? key, required this.title, this.seeAllOnTap, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          (seeAllOnTap == null
              ? EdgeInsets.fromLTRB(12, 14, 12, 14)
              : EdgeInsets.fromLTRB(12, 0, 8, 0)),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                // color: color2,
                fontWeight: FontWeight.w500),
          ),
          seeAllOnTap == null
              ? Container()
              : GestureDetector(
                  onTap: seeAllOnTap == null
                      ? null
                      : () {
                          seeAllOnTap!();
                        },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'See All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
