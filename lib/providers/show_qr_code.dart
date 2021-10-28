import 'package:flutter/cupertino.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:window_manager/window_manager.dart';
import '../screen_size.dart';
class ShowQrCode with ChangeNotifier {

  bool _show = false;

  bool get show{
    return _show;
  }

  Map<String,String>? _qrInfo;


  Future testWindowFunctions() async {
    _show = true;
    Size windowSize = await WindowManager.instance.getSize();
    print(windowSize);
    //print(await WindowManager.instance.getPosition());
    notifyListeners();
    final isMini = await WindowManager.instance.isMinimized();
    if(isMini){
      WindowManager.instance.maximize();
    };
    await WindowManager.instance.setMinimumSize(Size(200,200));
    await WindowManager.instance.setMaximumSize(Size(250,250));
    await WindowManager.instance.setSize(Size(200, 200));
    await WindowManager.instance.setPosition(Offset(0,0));

    WindowManager.instance.setAlwaysOnTop(true);
    Future.delayed(Duration(minutes: 1)).then((value) async {
      final Size? _size = ScreenSize().screenSize;
      print(_size);
      WindowManager.instance.minimize();
      await WindowManager.instance.setMinimumSize(Size(540.0,_size!.height * 0.95));
      await WindowManager.instance.setMaximumSize(_size);
      await WindowManager.instance.setSize(windowSize);
      WindowManager.instance.setAlwaysOnTop(false);
      _show = false;
      notifyListeners();
    });
  }

}