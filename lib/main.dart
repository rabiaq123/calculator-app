import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: BodyWidget(
          title: 'Lab 3 Part B',
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key, required this.title});

  final String title;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  bool _showOutput = true; // 0 will show by default on startup
  num _output = 0;
  var _userInput = '';
  var _expression = '';

  int _idx = 0; // counter
  int _buttonIndex = 0;

  bool _disableOperators = false;

  // Array of button text values
  final List<String> buttonText = [
    'Clear',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '=',
  ];

  @override
  void setState(VoidCallback fn) {
    _idx = 0;
    super.setState(fn);
  }

  void _setButtonIndex(int row, int col) {
    setState(() {
      _buttonIndex = (row * 4) + col + 2; // +2 to skip the CLEAR and / buttons
    });
  }

  void _updateInput(String input) {
    setState(() {
      _userInput = input;
      _expression += _userInput;

      // extra step to disable the operators after an operator is selected
      (_isOperator(input))
          ? _setDisableOperators(true)
          : _setDisableOperators(false);
    });
  }

  bool _isOperator(String input) {
    return (input == '/' || input == '*' || input == '-' || input == '+');
  }

  void _resetCalculator() {
    setState(() {
      _output = 0;
      _userInput = '';
      _expression = '';
      _setDisableOperators(false);
    });
  }

  void _setDisableOperators(bool disable) {
    setState(() {
      _disableOperators = disable;
    });
  }

  // show the output when CLEAR is pressed (output = 0) and when = is pressed
  void _setShowOutput(bool show) {
    setState(() {
      _showOutput = show;
    });
  }

  void _calculate() {
    _output = _expression.interpret();
    if (_output % 1 == 0) {
      _output = _output.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the BodyWidget object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      body: Center(
          child: Column(
        children: [
          // OUTPUT ROW
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    (_showOutput) ? "$_expression$_output" : _expression,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ROW 1
          Expanded(
            child: Row(
              children: [
                // CLEAR BUTTON
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: TextButton(
                        onPressed: () => {
                          _resetCalculator(),
                          _setShowOutput(true),
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          buttonText[_idx++],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // DIVIDE BUTTON
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: TextButton(
                        onPressed: _disableOperators
                            ? null
                            : () => {
                                  _updateInput(buttonText[
                                      1]), // using _idx gives RangeError idky
                                  _setShowOutput(false),
                                },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _disableOperators ? Colors.grey : Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          buttonText[_idx++],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ROWS 2-4
          for (int i = 0; i < 3; i++)
            Expanded(
              child: Row(
                children: [
                  for (int j = 0; j < 4; j++)
                    // 1-9 BUTTONS AND OPERATOR BUTTONS
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: TextButton(
                            onPressed: (j == 3 && _disableOperators)
                                ? null
                                : () => {
                                      _setButtonIndex(i, j),
                                      _updateInput(buttonText[_buttonIndex]),
                                      _setShowOutput(false),
                                    },
                            style: TextButton.styleFrom(
                              backgroundColor: (j == 3 && _disableOperators)
                                  ? Colors.grey
                                  : Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            child: Text(
                              buttonText[_idx++],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // ROW 5
          Expanded(
            child: Row(
              children: [
                // 0 BUTTON
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: TextButton(
                        onPressed: () => {
                          _updateInput(buttonText[14]),
                          _setShowOutput(false),
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          buttonText[_idx++],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // EQUAL BUTTON
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: TextButton(
                        onPressed: () => {
                          _updateInput(buttonText[15]),
                          _setShowOutput(true),
                          _setDisableOperators(false),
                          _calculate(),
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          buttonText[_idx++],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
