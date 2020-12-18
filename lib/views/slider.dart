import 'package:flutter/material.dart';

class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() {
    return _SliderExampleState();
  }
}

class _SliderExampleState extends State {
  double _loanPeriod = 36.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Slider Tutorial',
      // home: Scaffold(
      //     appBar: AppBar(
      //       title: Text('Slider Tutorial'),
      //     ),
      //     body: Padding(
      //  padding: EdgeInsets.all(15.0),
      body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
            // Expanded(
            //   child: Icon(
            //     Icons.payment,
            //     size: 30,
            //   ),
            // ),
            new Expanded(
              // child: Slider(
              //     value: _value.toDouble(),
              //     min: 1.0,
              //     max: 10.0,
              //     divisions: 10,
              //     activeColor: Colors.red,
              //     inactiveColor: Colors.black,
              //     label: 'Set a value',
              //     onChanged: (double newValue) {
              //       setState(() {
              //         _value = newValue.round();
              //       });
              //     },
              //     semanticFormatterCallback: (double newValue) {
              //       return '${newValue.round()} dollars';
              //     }
              // )
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blue[700],
                  inactiveTrackColor: Colors.blue[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.blue[700],
                  inactiveTickMarkColor: Colors.blue[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.blueAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: _loanPeriod,
                  min: 1,
                  max: 36,
                  divisions: 36,
                  label: '${_loanPeriod.toStringAsFixed(0)} months',
                  onChanged: (value) {
                    setState(
                      () {
                        _loanPeriod = value;
                        print(_loanPeriod);
                      },
                    );
                  },
                ),
              ),
            ),
          ])),
    );
  }
}
