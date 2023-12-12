import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:flutter/material.dart';

class ComInputWidget extends StatefulWidget {
  final String title;
  final bool? hidetitle;
  final String hintText;
  final bool? isCountLength;
  final int? maxCount;
  final double heights;
  final String? errText;
  final TextEditingController cont;
  final TextInputType? inputType;
  final bool? isSecure;
  final bool? lengthValidator;
  final bool? notValidator;
  const ComInputWidget({super.key, required this.title, required this.hintText, this.isCountLength, this.maxCount, required this.heights, required this.cont, this.hidetitle = false, this.errText, this.inputType = TextInputType.text, this.isSecure = false, this.lengthValidator = false, this.notValidator = false});

  @override
  State<ComInputWidget> createState() => _ComInputWidgetState();
}

class _ComInputWidgetState extends State<ComInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.hidetitle! ? '' : widget.title,
                style: const TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Color.fromARGB(255, 41, 35, 35),
                  fontSize: 18,
                )
              ),
              if(widget.isCountLength ?? false)
                Text('${widget.cont.text.length}/${widget.maxCount.toString()}'),
            ],
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: widget.heights+20,
            child: 
            TextFormField (
                controller: widget.cont,
                obscureText: widget.isSecure!,
                maxLength: widget.maxCount,
                keyboardType: widget.inputType,
                
                validator: (value) {
                  if(widget.lengthValidator!){
                    // 길이 제한 오류
                    if(widget.cont.text.length != widget.maxCount){
                      return '${widget.maxCount}자리를 입력해주세요.';
                    }
                  }
                  if (value!.isEmpty && !widget.notValidator!) {
                    String valudatorText = widget.errText ?? widget.title;
                    return '$valudatorText을 입력해주세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  // border radius
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.heights * 0.2
                    ),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 41, 35, 35),
                    ),
                  ),
                  // labelText: 'example@google.com',
                  hintText: widget.hintText,
                ),
              ),              
          )
        ],
      )
    );
  }
}


double pageSerach(PageController cont){
  if(cont.positions.isEmpty){
    return 0;
  }
  return cont.page ?? 0;
}
  

Widget inputWidget(TextEditingController cont, String title, String hintText, bool? isCountLength, int? maxCount, double heights){
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'NotoSansKR',
                color: Color.fromARGB(255, 41, 35, 35),
                fontSize: 18,
              )
            ),
            if(isCountLength ?? false)
              Text('${cont.text.length}/${maxCount.toString()}'),
          ],
        ),
        const SizedBox(height: 10,),
        Container(
          constraints: BoxConstraints(
            minHeight: heights+20
          ),
          child: Column(
            children: [
              TextFormField (
                  controller: cont,
                  maxLength: maxCount,
                  validator: (value) {
                    if (value!.isEmpty ) {
                      return '$title을 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                  },
                  decoration: InputDecoration(
                    // border radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        heights * 0.2
                      ),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 41, 35, 35),
                      ),
                    ),
                    // labelText: 'example@google.com',
                    hintText: hintText,
                  ),
                ),

            ],
          )          
        )
      ],
    )
  );

}

Widget useRadioButton(
  {
  required dynamic idx,
  required String name,
  required int checked,
  required Function(int idx) onChanged,
  double? spacing = 3,
  required BuildContext context
  }
){
  return RadioListTile(
    title: AutoSizeText(
      name,
      style: const TextStyle(
        fontFamily: 'NotoSansKR',
        color: Color.fromARGB(255, 41, 35, 35),
        fontSize: 20,
      )
    ),
    value: idx, 
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    groupValue: checked, 
    activeColor: BaseColor.primaryColor,
    onChanged: (value) {
      onChanged(value);
    },
  );
  // return Container(
  //   height: MediaQuery.of(context).size.height * 0.08,
  //   padding: const EdgeInsets.symmetric(horizontal: 5),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       LayoutBuilder(
  //         builder: (context, constraints) {
  //           return Padding(
  //             padding: const EdgeInsets.only(right: 15),
  //             child: Transform.scale(
  //               scale: constraints.maxHeight / 30,
  //               child: Radio(
  //                 value: idx, 
  //                 groupValue: checked, 
  //                 onChanged: (value) {
  //                   onChanged(idx);
  //                 },
  //                 activeColor: BaseColor.primaryColor,
                  
  //                 visualDensity: VisualDensity(horizontal: -(4 - spacing!))
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           onChanged(idx);
  //         },
  //         child : AutoSizeText(
  //           name,
  //           style: const TextStyle(
  //             fontFamily: 'NotoSansKR',
  //             color: Color.fromARGB(255, 41, 35, 35),
  //             fontSize: 20,
  //           )
  //         ),
  //       ),
  //     ],
  //   )
  // );
}




bool apiStatusCheck(dynamic tmp){
  if(tmp['statusCode'] != 200){
    return false;
  }
  return true;
}