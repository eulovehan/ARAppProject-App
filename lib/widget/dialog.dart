import 'dart:ui';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PopupAlertDialog extends StatefulWidget {
  final PopupdialogType type;
  final String title;
  final String? subtitle;
  final List<Widget> content;
  const PopupAlertDialog({
    super.key, 
    required this.type,
    required this.title, 
    this.subtitle, 
    required this.content,
  });

  @override
  State<PopupAlertDialog> createState() => _PopupAlertDialogState();
}

class _PopupAlertDialogState extends State<PopupAlertDialog> {
  @override
  Widget build(BuildContext context) {

    alertColor(){
      switch (widget.type) {
        case PopupdialogType.error:
          return Colors.red;
        case PopupdialogType.success:
          return Colors.green;
        case PopupdialogType.warning:
          return Colors.orange;
        case PopupdialogType.info:
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    alertSubColor(){
      switch (widget.type) {
        case PopupdialogType.error:
          return Colors.red[200];
        default:
          return Colors.grey;
      }
    }

    Widget titleArea(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title, 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: alertColor()
            ),
          ),
          if(widget.subtitle != null)
            Text(
              widget.subtitle!, 
              style: TextStyle(
                fontSize: 12,
                color: alertSubColor()
              ),
            ),
        ],
      );
    }
    
    Widget contentArea(){
      return ListBody(
        children: widget.content
      );
    }    

    Widget actionArea(){
      return SizedBox(
        height: double.infinity,
        child: TextButton(
            onPressed: () => Navigator.of(context).pop('close'),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              backgroundColor: alertColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ), 
            child: const Text('닫기', style: TextStyle(color: Colors.white),)
          ),
      );
    }
    

    return PopBaseDialog(type: widget.type, title: titleArea(), content: contentArea(), action: actionArea(),);

  }
}


class PopupConfirmDialog extends StatefulWidget {
  final Widget title;
  final String subtitle;
  final List<Widget> content;
  final EdgeInsets? contentPadding;
  final List? action;

  const PopupConfirmDialog({
    super.key, 
    required this.title, 
    required this.subtitle, 
    required this.content, 
    this.contentPadding,
    this.action = const [
      DialogActionInfo(
        index: 1, 
        text: '확인',
        textColor: Colors.white,
        backgroundColor: BaseColor.primaryColor
      ),
      DialogActionInfo(
        index: 0, 
        text: '닫기',
        backgroundColor: BaseColor.primaryColor
      ),
    ]
  });

  @override
  State<PopupConfirmDialog> createState() => PopupConfirmDialogState();
}

class PopupConfirmDialogState extends State<PopupConfirmDialog> {


  @override
  Widget build(BuildContext context) {


    Widget titleArea(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title,
          if(widget.subtitle != null)
            Text(
              widget.subtitle, 
              style: TextStyle(
                fontSize: 12,
                color: BaseColor.backgroundColor
              ),
            ),
        ],
      );
    }
    
    Widget contentArea(){
      return ListBody(
        children: widget.content
      );
    }
    
    Widget actionArea(){
      final actionSort = List.from(widget.action!);
      actionSort.sort((a, b) => a.index.compareTo(b.index));

      return Row(
          children: actionSort.map((e) => Expanded(
            child: Container(
              height: double.infinity,
              child: TextButton(
                onPressed: () async{
                  if(e.onPressed != null){
                    if(await e.onPressed!() != null) return;
                  }
                  Navigator.of(context).pop(e.index);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  backgroundColor: e.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ), 
                child: Text(
                  e.text,
                  style: TextStyle(
                    color: e.textColor,
                    fontWeight: e.fontWeight,
                  ),
                )
              ),
            )
          )).toList()
        );
    }
    
    

    return PopBaseDialog(title: titleArea(), content: contentArea(), contentPadding: widget.contentPadding, action: actionArea(), type: PopupdialogType.confirm,);

  }

}


class PopBaseDialog extends StatefulWidget {
  final PopupdialogType type;
  final Widget title;
  final Widget content;
  final EdgeInsets? contentPadding;
  final Widget? action;
  const PopBaseDialog({
    this.type = PopupdialogType.none,
    super.key, 
    required this.title, 
    required this.content,
    this.contentPadding,
    this.action, 
    });

  @override
  State<PopBaseDialog> createState() => _PopBaseDialogState();
}

class _PopBaseDialogState extends State<PopBaseDialog> {

  


  @override
  Widget build(BuildContext context) {

    
    final ThemeData theme = Theme.of(context);
    double _paddingScaleFactor(double textScaleFactor) {
      final double clampedTextScaleFactor = clampDouble(textScaleFactor, 1.0, 2.0);
      // The final padding scale factor is clamped between 1/3 and 1. For example,
      // a non-scaled padding of 24 will produce a padding between 24 and 8.
      return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
    }

    
    String? label = MaterialLocalizations.of(context).dialogLabel;
    switch (theme.platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
    }
    final double paddingScaleFactor = _paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

      

    Widget titleArea(){
        const EdgeInsets defaultTitlePadding = EdgeInsets.only(
          left: 24.0,
          top:  24.0,
          right: 24.0,
          bottom: 20.0,
        );
        const EdgeInsets effectiveTitlePadding = defaultTitlePadding;

        return Padding(
          padding: EdgeInsets.only(
            left: effectiveTitlePadding.left * paddingScaleFactor,
            right: effectiveTitlePadding.right * paddingScaleFactor,
            top: effectiveTitlePadding.top * paddingScaleFactor,
            bottom: effectiveTitlePadding.bottom,
          ),
          child: DefaultTextStyle(
            style: DialogTheme.of(context).titleTextStyle ?? theme.textTheme.headline6!,
            child: Semantics(
              namesRoute: label == null && theme.platform != TargetPlatform.iOS,
              container: true,
              //child: widget.title
            ),
          ),
        );
    }


    Widget contentArea(){
      final EdgeInsets effectiveContentPadding = widget.contentPadding == null
        ? const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0).resolve(textDirection)
        : widget.contentPadding!.resolve(textDirection);

      return Flexible(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: effectiveContentPadding.left * paddingScaleFactor,
            right: effectiveContentPadding.right * paddingScaleFactor,
            top: effectiveContentPadding.top,
            bottom: effectiveContentPadding.bottom * paddingScaleFactor,
          ),
          child: widget.content
        ),
      );
    }


    Widget actionArea(){
      return Container(
        margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        height: 40,
        child : widget.action
          ?? SizedBox(
            height: double.infinity,
            child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ), 
                child: const Text('닫기', style: TextStyle(color: Colors.black),)
              ),
          )
      );
    }

    Widget lineArea(){
      Widget lines = Container();

      if(widget.type == PopupdialogType.none){
        lines = Container(height: 5, width: double.infinity, color: Colors.grey);
        return lines;
      }

      if(widget.type == PopupdialogType.error){
        lines = Container(height: 5, width: double.infinity, color: Colors.red);
        return lines;
      }

      if(widget.type == PopupdialogType.warning){
        lines = Container(height: 5, width: double.infinity, color: Colors.orange);
        return lines;
      }

      if(widget.type == PopupdialogType.info){
        lines = Container(height: 5, width: double.infinity, color: Colors.blue);
        return lines;
      }

      if(widget.type == PopupdialogType.success){
        lines = Container(height: 5, width: double.infinity, color: Colors.green);
      }

      if(widget.type == PopupdialogType.confirm){
        lines = Container(height: 5, width: double.infinity, color: Colors.grey);
      }

      return lines;
    }









    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //lineArea(),
              titleArea(),
              contentArea(),
              actionArea()
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(), 
              icon: Icon(Icons.close, color: Colors.grey,)
            )
          )
        ],
      )
    );
  }
}



Future<DateTime> popupDatePicker(BuildContext context, DateTime currentdate) async{
  DateTime selectDate = currentdate;
  selectDate = await showDatePicker(
      context: context,
      initialDate: currentdate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('ko', 'KR'),
    ) ?? currentdate;

  return selectDate;
}