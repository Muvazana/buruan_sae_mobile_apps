import 'package:buruan_sae_apps/screen/components/step_form/step_progress_indicator.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_rounded_button.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomStepFormLayout extends StatefulWidget {
  final List<Widget> pageList;
  final Function onCancel;
  final Function onPageChange;
  final Function onSaved;
  const CustomStepFormLayout({
    Key? key,
    required this.pageList,
    required this.onCancel,
    required this.onPageChange,
    required this.onSaved,
  }) : super(key: key);

  @override
  _CustomStepFormLayoutState createState() => _CustomStepFormLayoutState();
}

class _CustomStepFormLayoutState extends State<CustomStepFormLayout> {
  final _stepCircleRadius = 10.0;

  final _stepProgressViewHeight = 150.0;

  Color _activeColor = Colors.white;

  Color _inactiveColor = Colors.white;

  late Size _safeAreaSize;

  int _curPage = 1;

  StepProgressView _getStepProgress() {
    return StepProgressView(
      widget.pageList,
      _curPage,
      _stepProgressViewHeight,
      _safeAreaSize.width,
      _stepCircleRadius,
      _activeColor,
      _inactiveColor,
      decoration: BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(
        top: SizeConfig.getHeightSize(6.5),
        left: SizeConfig.getWidthSize(8),
        right: SizeConfig.getWidthSize(8),
      ),
    );
  }

  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.linear;

  bool isLastPage = false;
  bool isFirstPage = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _safeAreaSize = SizeConfig.size!;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: kPrimaryColor,
      child: Stack(
        children: <Widget>[
          Container(
            height: 150.0,
            width: double.infinity,
            child: _getStepProgress(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: SizeConfig.getHeightSize(85),
              decoration: BoxDecoration(
                color: kLight1Color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    width: double.infinity,
                    child: Text(
                      "Step ${_curPage} of ${widget.pageList.length}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.getWidthSize(6),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PageView(
                        controller: _controller,
                        physics: new NeverScrollableScrollPhysics(),
                        onPageChanged: (i) {
                          widget.onPageChange(i);
                          setState(() {
                            isFirstPage = (i == 0);
                            isLastPage = (i == widget.pageList.length - 1);
                            _curPage = i + 1;
                          });
                        },
                        children: widget.pageList,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: CustomRoundedButton(
                              text: isFirstPage ? "Cancel" : "Back",
                              prefixIcon: isFirstPage
                                  ? null
                                  : Icons.arrow_back_ios_new_rounded,
                              elevation: 0,
                              backgroundColor: kLight1Color,
                              color: txtSecondColor,
                              width: SizeConfig.getWidthSize(45),
                              borderRadius: 35,
                              onPressed: () {
                                if (_curPage == 1) {
                                  widget.onCancel();
                                }
                                _controller.previousPage(
                                    duration: _kDuration, curve: _kCurve);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CustomRoundedButton(
                              text: isLastPage ? "Done" : "Next",
                              suffixIcon: isLastPage
                                  ? null
                                  : Icons.arrow_forward_ios_rounded,
                              width: SizeConfig.getWidthSize(45),
                              borderRadius: 35,
                              onPressed: () {
                                if (_curPage == widget.pageList.length) {
                                  widget.onSaved();
                                }
                                _controller.nextPage(
                                    duration: _kDuration, curve: _kCurve);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
