// ignore_for_file: file_names, prefer_const_constructors
import 'package:chat_me/config/app_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText, label;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final int maxLines;
  final int ? maxLength;
  
  final double borderRadius;
  final Color borderColor, underlineColor;
  final Color color;
  final TextStyle? style;
  final double? width;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Color hintColor;
  final bool readOnly, underline;
  final bool autoFocus;
  const   CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.keyboard,
      this.maxLines = 1,
      this.maxLength ,
      this.borderRadius = 10,
      this.borderColor = Colors.transparent,
      this.underlineColor = Colors.transparent,
      this.color = Colors.transparent,
      this.style,
      this.readOnly = false,
      this.underline = false,
      this.obscure = false,
      this.suffixIcon,
      this.textAlign = TextAlign.justify,
      this.hintColor = Colors.grey,
      this.prefixIcon,
      this.onChanged,
      this.autoFocus = false,
      this.label, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      autofocus: autoFocus,
      obscureText: obscure,
      readOnly: readOnly,
      maxLines: maxLines ,
      maxLength: maxLength,
      onChanged: onChanged,
      keyboardType: keyboard,
      controller: controller,
      textAlign: textAlign,
      style: style,
      decoration: InputDecoration(
        filled: true,
        fillColor:color,
        hintText: hintText,
        labelText: label,
        labelStyle: style,
        counterText: '',
        hintStyle: TextStyle(color: hintColor),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(borderRadius ?? 15), 
        //   borderSide:BorderSide(color:borderColor,width:2)),
        focusedBorder:underline? UnderlineInputBorder(borderSide: BorderSide(color: underlineColor)):OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius  ), 
          borderSide:BorderSide(color:borderColor,width:1)),
        enabledBorder: underline?UnderlineInputBorder(borderSide: BorderSide(color: underlineColor)):
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius  ), 
          borderSide:BorderSide(color:borderColor,width:1)),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
      ),
    );
  }
}

class CustomDropDownList extends StatefulWidget {
  final String? hintText;
  final List<String>? listItems;
  final Color color;
  final Color borderColor;
  final TextStyle? style;

  const CustomDropDownList({
    Key? key,
    this.hintText,
    this.listItems,
    this.color = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.style,
  }) : super(key: key);

  @override
  State<CustomDropDownList> createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomDropDownList> {
  String? itemValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          color: widget.color,
          borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField(
        style: widget.style,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true),
        hint: Text(widget.hintText!),
        value: itemValue,
        onChanged: (dynamic newValue) {
          setState(() {
            itemValue = newValue;
          });
        },
        items: widget.listItems!.map((location) {
          return DropdownMenuItem(
            value: location,
            child: Text(location, maxLines: 2),
          );
        }).toList(),
      ),
    );
  }
}



class DateTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Color borderColor;
  final Color color;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color hintColor;
  const DateTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.borderColor = Colors.transparent,
      this.color = Colors.transparent,
      this.style,
      this.prefixIcon,
      this.suffixIcon,
      this.hintColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final fromDate = TextEditingController();
    final dateformat = DateFormat("yyyy-MM-dd");
    //final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        //width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            color: color,
            borderRadius: BorderRadius.circular(20)),
        child: Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.white,
            ),
          ),
          child: DateTimeField(
            style: style,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
            ),
            // validator: MultiValidator([
            //   RequiredValidator(
            //       errorText: "*field cannot be empty"),
            // ]),
            format: dateformat,
            controller: controller,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
        ),
      ),
    );
  }
}

class TimeTextField extends StatelessWidget {
  const TimeTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeformat = DateFormat("HH:mm");
   
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              accentColor: Colors.white,
            ),
          ),
          child: DateTimeField(
            style: bodyTextBlack,
            decoration: InputDecoration(
              hintText: "Time",
              prefixIcon: Icon(Icons.watch, color: Colors.black),
              border: InputBorder.none,
              hintStyle: bodyTextBlack,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
            ),
            // validator: MultiValidator([
            //   RequiredValidator(
            //       errorText: "*field cannot be empty"),
            // ]),
            format: timeformat,
            //controller: fromDate,
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.convert(time);
            },
          ),
        ),
      ),
    );
  }
}



