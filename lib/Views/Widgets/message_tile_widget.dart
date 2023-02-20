import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTileWidget extends StatefulWidget {
  const MessageTileWidget(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.showName});
  final String message;
  final String sender;
  final bool sentByMe;
  final bool showName;

  @override
  State<MessageTileWidget> createState() => _MessageTileWidgetState();
}

class _MessageTileWidgetState extends State<MessageTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4.h,
          bottom: 4,
          left: widget.sentByMe ? 0 : 10.w,
          right: widget.sentByMe ? 10.w : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? EdgeInsets.only(left: 30.w)
            : EdgeInsets.only(right: 30.w),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
            color: widget.sentByMe
                ? const Color.fromARGB(255, 58, 74, 82)
                : const Color.fromARGB(181, 40, 41, 3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.showName
                ? Text(
                    widget.sender.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
            SizedBox(
              height: 8.h,
            ),
            Text(widget.message,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.sp, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
