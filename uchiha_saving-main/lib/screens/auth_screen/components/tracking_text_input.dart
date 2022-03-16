import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uchiha_saving/screens/auth_screen/components/input_helper.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  TrackingTextInput(
      {Key? key,
      this.onCaretMoved,
      this.onTextChanged,
      this.hint,
      required this.icon,
      this.validator,
      this.isObscured = false})
      : super(key: key);
  final CaretMoved? onCaretMoved;
  final TextChanged? onTextChanged;
  final String? hint;
  final bool? isObscured;
  final Function(String val)? validator;
  final IconData icon;
  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  Timer? _debounceTimer;
  @override
  initState() {
    _textController.addListener(() {
      // We debounce the listener as sometimes the caret position is updated after the listener
      // this assures us we get an accurate caret position.
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          // Find the render editable in the field.
          final RenderBox fieldBox =
              _fieldKey.currentContext!.findRenderObject()! as RenderBox;
          Offset caretPosition = getCaretPosition(fieldBox);

          if (widget.onCaretMoved != null) {
            widget.onCaretMoved!(caretPosition);
          }
        }
      });
      if (widget.onTextChanged != null) {
        widget.onTextChanged!(_textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.hint,
          icon: Icon(widget.icon),
        ),
        key: _fieldKey,
        controller: _textController,
        obscureText: widget.isObscured!,
        validator: (val) => widget.validator!(val!),
      ),
    );
  }
}
