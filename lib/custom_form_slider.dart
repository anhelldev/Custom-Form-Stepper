library custom_form_slider;

import 'package:custom_form_slider/model/customStepperModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:custom_form_slider/common/form_button.dart';

enum HeaderShape { vertical, horizontal }

class CustomStepper extends StatefulWidget {
  final Function? nextStep;
  final Function? onChangeStep;
  final Function? onSubmit;
  final List<CustomStepItem
  > steps;
  final HeaderShape headerShape;
  const CustomStepper(
      {this.nextStep,
      this.onSubmit,
      this.onChangeStep,
      this.headerShape = HeaderShape.vertical,
      this.steps = const <CustomStepItem>[],
      Key? key})
      : super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  bool isLoading = false;
  Future<bool> _onWillPop(CustomStepperModel customStepperModel) async {
    if (customStepperModel.currentIndex == 0) {
      return true;
    }
    customStepperModel.decreaseIndex();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => CustomStepperModel(),
      child: Consumer<CustomStepperModel>(
        builder: (_, CustomStepperModel model, __) {
          return WillPopScope(
            onWillPop: () {
              return _onWillPop(model);
            },
            child: Container(
              constraints: BoxConstraints(minHeight: screenSize.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                    child: widget.steps[model.currentIndex].step,
                  )),
                  Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 25),
                      decoration: const BoxDecoration(color: Color(0xff6D00C3)),
                      child: Column(
                        children: [
                          ...headerStepper(widget.headerShape, model),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: FormButton(
                              borderRadius: 4,
                              content: isLoading
                                  ? const SizedBox(
                                      height: 17,
                                      width: 17,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ))
                                  : null,
                              backgroundColor: const Color(0xff94D40B),
                              text:
                                  model.currentIndex == widget.steps.length - 1
                                      ? 'Finalizar'
                                      : 'Siguiente',
                              onTap: () {
                                if (isLoading) {
                                  return;
                                }
                                if (model.currentIndex ==
                                    widget.steps.length - 1) {
                                  // setState(() {
                                  //   isLoading = true;
                                  // });
                                  widget.onSubmit!();
                                  return;
                                }
                                model
                                    .changeCurrentIndex(model.currentIndex + 1);
                                if (widget.onChangeStep != null) {
                                  widget.onChangeStep!(model.currentIndex);
                                }
                              },
                              disabled:
                                  !widget.steps[model.currentIndex].valid!,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> headerStepper(
      HeaderShape headerShape, CustomStepperModel model) {
    return headerShape == HeaderShape.vertical
        ? [
            Text(
              'Paso ${model.currentIndex + 1} de ${widget.steps.length}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                for (int x = 0; x < widget.steps.length; x++) ...[
                  StepDot(isActive: x == model.currentIndex),
                  if (x < widget.steps.length - 1)
                    const SizedBox(
                      width: 10,
                    )
                  // you can add widget here as well
                ],
              ],
            ),
          ]
        : [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paso ${model.currentIndex + 1} de ${widget.steps.length}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      for (int x = 0; x < widget.steps.length; x++) ...[
                        StepDot(isActive: x == model.currentIndex, shouldGrow: false,),
                        if (x < widget.steps.length - 1)
                          const SizedBox(
                            width: 5,
                          )
                        // you can add widget here as well
                      ],
                    ],
                  ),
                ],
              ),
            )
          ];
  }
}

class StepDot extends StatelessWidget {
  final bool isActive;
  final bool shouldGrow;
  const StepDot({this.isActive = false, this.shouldGrow = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive && shouldGrow ? 25 : 10,
      width: isActive && shouldGrow ? 25 : 10,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Colors.white, width: 1)),
    );
  }
}
