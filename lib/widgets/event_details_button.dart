import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class EventDetailsButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const EventDetailsButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: secondaryColor,
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/event_tile_bg/bg_1.png',
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
