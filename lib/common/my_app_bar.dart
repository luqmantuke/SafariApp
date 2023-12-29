import 'package:flutter/material.dart';
import 'package:safaritop/utilities/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// you can add more fields that meet your needs
  final double height;
  final String? title;
  final Color color;
  final Color titlecolor;
  final List<Widget> action;
  const MyAppBar(
      {this.title = 'Safari Videos',
      this.action = const [],
      this.color = Colors.white,
      this.titlecolor = Colors.black,
      this.height = kToolbarHeight,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SizeConfig(context);
    return AppBar(
      // height: preferredSize.height,/
      actions: action,
      iconTheme: const IconThemeData(color: blueColor03),
      backgroundColor: color,
      title: Text(title.toString(),
          style: TextStyle(
            color: titlecolor,
          )),
      centerTitle: true,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
