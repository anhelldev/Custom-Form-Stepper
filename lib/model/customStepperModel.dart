import 'package:flutter/material.dart';

class CustomStepperModel extends ChangeNotifier {
 int currentIndex = 0;
  
  void changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void decreaseIndex(){
    currentIndex = currentIndex - 1;
    notifyListeners();
  }
}

class CustomStepItem {
  final Widget? step;
  final bool? valid;

  CustomStepItem({this.step, this.valid = false});
}
