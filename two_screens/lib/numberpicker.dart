import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'globals.dart' as globals;

class NumberTextField extends StatefulWidget {
  TextEditingController? controller;
  FocusNode? focusNode;
  int min;
  int max;
  int step;
  double arrowsWidth;
  double arrowsHeight;
  EdgeInsets contentPadding;
  double borderWidth;
  ValueChanged<int?>? onChanged;

  NumberTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.arrowsWidth = 24,
    this.arrowsHeight = kMinInteractiveDimension,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.borderWidth = 2,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _canGoUp = false;
  bool _canGoDown = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = globals.intValue.toString();
    _focusNode = widget.focusNode ?? FocusNode();
    _updateArrows(int.tryParse(_controller.text));
  }

  @override
  void didUpdateWidget(covariant NumberTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = widget.controller ?? _controller;
    _focusNode = widget.focusNode ?? _focusNode;
    _updateArrows(int.tryParse(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        showCursor: false,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Colors.white),
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        maxLength:
            widget.max.toString().length + (widget.min.isNegative ? 1 : 0),
        decoration: InputDecoration(
            counterText: '',
            isDense: true,
            filled: true,
            fillColor: Color.fromRGBO(51, 51, 255, 1),
            contentPadding: widget.contentPadding.copyWith(right: 0),
            suffixIconConstraints: BoxConstraints(
                maxHeight: widget.arrowsHeight,
                maxWidth: widget.arrowsWidth + widget.contentPadding.right),
            suffixIcon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widget.borderWidth),
                        bottomRight: Radius.circular(widget.borderWidth))),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.centerRight,
                /* margin: EdgeInsets.only(
                top: widget.borderWidth,
                right: widget.borderWidth,
                bottom: widget.borderWidth,
                left: widget.contentPadding.right,
              ),*/
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                  child: Opacity(
                                      opacity: _canGoUp ? 1 : .5,
                                      child: const Icon(
                                        Icons.arrow_drop_up,
                                        color: Colors.white,
                                      )),
                                  onTap:
                                      _canGoUp ? () => _update(true) : null))),
                      Expanded(
                          child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                  child: Opacity(
                                      opacity: _canGoDown ? 1 : .5,
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      )),
                                  onTap: _canGoDown
                                      ? () => _update(false)
                                      : null))),
                    ]))),
        maxLines: 1,
        onChanged: (value) {
          globals.intValue = int.tryParse(value);
          widget.onChanged?.call(globals.intValue);
          _updateArrows(globals.intValue);
        },
        inputFormatters: [_NumberTextInputFormatter(widget.min, widget.max)]);
  }

  void _update(bool up) {
    //nb step globals.int Value mil number picker
    globals.intValue = int.tryParse(_controller.text);
    globals.intValue == null
        ? globals.intValue = 0
        : globals.intValue =
            globals.intValue! + (up ? widget.step : -widget.step);
    _controller.text = globals.intValue.toString();
    _updateArrows(globals.intValue);
    _focusNode.requestFocus();

    //print("int value : ${globals.intValue}");
    // print("controller value : ${_controller.text}");
  }

  void _updateArrows(int? value) {
    var canGoUp = value == null || value < widget.max;
    var canGoDown = value == null || value > widget.min;
    if (_canGoUp != canGoUp || _canGoDown != canGoDown)
      setState(() {
        _canGoUp = canGoUp;
        _canGoDown = canGoDown;
      });
  }
}

class _NumberTextInputFormatter extends TextInputFormatter {
  int min;
  int max;

  _NumberTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (const ['-', ''].contains(newValue.text)) return newValue;
    globals.intValue = int.tryParse(newValue.text);
    if (globals.intValue == null) return oldValue;
    if (globals.intValue! < min) return newValue.copyWith(text: min.toString());
    if (globals.intValue! > max) return newValue.copyWith(text: max.toString());
    return newValue.copyWith(text: globals.intValue.toString());
  }
}
