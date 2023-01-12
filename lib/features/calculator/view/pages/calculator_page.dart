import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../data/calculator_repository.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // get list of buttons for calculator
  var numbersList = CalculatorRepo().calculator_numbers;
  String operation = "0";
  String result = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          // calculator screen with operation & result text
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade400,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    operation,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    result,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // grid buttons of calculator
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(10),
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(
                  numbersList.length,
                  (index) => TextButton(
                      onPressed: () => pressButton(index),
                      child: Text(
                        numbersList[index],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: getTextColor(index),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              getButtonColor(index)))),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Color getTextColor(int index) {
    return (index == 7 || index == 11 || index == 15 || index == 19)
        ? Colors.white
        : Colors.blue;
  }

  Color? getButtonColor(int index) {
    Color? color = Colors.grey.shade100;
    if (index >= 0 && index <= 3) {
      color = Colors.blue.shade100;
    } else if (index == 18) {
      color = Colors.amber.shade400;
    } else if (index == 3 ||
        index == 7 ||
        index == 11 ||
        index == 15 ||
        index == 19) {
      color = Colors.blue.shade800;
    }
    return color;
  }

  void pressButton(int index) {
    setState(() {
      // clear screen, C Button
      if (index == 0) {
        operation = "";
        result = "0";
      } else if (index == 1) {
        operation += "-";
      }
      // remove last number , DEL button
      else if (index == 3) {
        operation = operation.isNotEmpty
            ? operation.substring(0, operation.length - 1)
            : "";
      } else if (index == 18) {
        result = getResult(operation);
      } else {
        operation += numbersList[index];
      }
    });
  }

  String getResult(String operation) {
    String finaluserinput = operation;
    finaluserinput = operation.replaceAll('x', '*');

    // use math_expressions lib to simplfy the calculation
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print(eval.toString());
    var answer = eval.toString();
    return answer;
  }
}
