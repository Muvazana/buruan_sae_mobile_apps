import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  //height of the container
  final double _height;
//width of the container
  final double _width;
//container decoration
  final BoxDecoration? decoration;
//list of texts to be shown for each step
  final List<Widget> _pageList;
//cur step identifier
  final int _curStep;
//active color
  final Color _activeColor;
//in-active color
  final Color _inactiveColor;
//dot radius
  final double _dotRadius;
//container padding
  final EdgeInsets? padding;
//line height
  final double lineHeight;
  const StepProgressView(
    List<Widget> pageList,
    int curStep,
    double height,
    double width,
    double dotRadius,
    Color activeColor,
    Color inactiveColor, {
    Key? key,
    this.decoration,
    this.padding,
    this.lineHeight = 2.0,
  })  : _pageList = pageList,
        _curStep = curStep,
        _height = height,
        _width = width,
        _dotRadius = dotRadius,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor,
        assert(curStep > 0 == true && curStep <= pageList.length),
        assert(width > 0),
        assert(height >= 2 * dotRadius),
        assert(width >= dotRadius * 2 * pageList.length),
        super(key: key);

  List<Widget> _buildDots() {
    var wids = <Widget>[];
    _pageList.asMap().forEach(
      (i, text) {
        var circleColor =
            (i == 0 || _curStep > i) ? _activeColor : _inactiveColor;

        var lineColor = _curStep > i ? _activeColor : _inactiveColor;

        wids.add(
          CircleAvatar(
            radius: _dotRadius,
            backgroundColor: circleColor,
            child: CircleAvatar(
              radius: _dotRadius - 1,
              backgroundColor: (i == 0 || _curStep > i) ? circleColor : kPrimaryColor,
            ),
          ),
        );

        //add a line separator
        //0-------0--------0
        if (i != _pageList.length - 1) {
          wids.add(
            Expanded(
              child: Container(
                height: lineHeight,
                color: lineColor,
              ),
            ),
          );
        }
      },
    );

    return wids;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: this._height,
      width: this._width,
      decoration: this.decoration,
      child: Column(
        children: <Widget>[
          Row(
            children: _buildDots(),
          ),
        ],
      ),
    );
  }
}
