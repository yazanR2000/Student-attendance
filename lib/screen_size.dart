
import 'package:flutter/material.dart';
class ScreenSize with ChangeNotifier{
  static Size? _screenSize;
  void init(Size? size){
    _screenSize = size;
    print(_screenSize!);
  }
  void set size(Size? value){
    _screenSize = value;
  }

  Size? get screenSize{
    return _screenSize;
  }
}