import 'package:flutter/material.dart';


class CustomAppbar extends StatelessWidget{
  final Widget? leading;
  final Widget? child;
  final Color? backgroundColor;
  final Widget? botNav;
  const CustomAppbar({
    super.key, this.leading, this.child, this.backgroundColor, this.botNav
  });
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: leading ?? Container(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: child ?? Container(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.08,
              child: botNav ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

}