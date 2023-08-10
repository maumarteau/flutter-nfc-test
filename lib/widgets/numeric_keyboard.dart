import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericKeyboard extends StatefulWidget {
  final Function(String) onSubmit;
  final List<int> predefinedValues;

  const NumericKeyboard(
      {Key? key, required this.predefinedValues, required this.onSubmit})
      : super(key: key);

  @override
  NumericKeyboardState createState() => NumericKeyboardState();
}

class NumericKeyboardState extends State<NumericKeyboard> {
  int amount = 0;
  int maxAmount = 100000;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'es_ES');

    return Column(
      children: [
        Expanded(
          // El resto de tu código
          child: Column(
            // Cambia este widget Row a Column para poner elementos verticalmente
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "\$ ",
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    formatter.format(amount),
                    style: const TextStyle(
                        fontSize: 60.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              // Añade el mensaje de error
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Puede acreditar máximo \$ $maxAmount",
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.predefinedValues.map((value) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            foregroundColor:
                                const Color.fromARGB(255, 203, 203, 203),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                          ),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              amount = value;
                              showError = false;
                            });
                          },
                          child: Text(
                            "\$ ${formatter.format(value)}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: <Widget>[
                  numberButton('1'),
                  numberButton('2'),
                  numberButton('3'),
                  numberButton('4'),
                  numberButton('5'),
                  numberButton('6'),
                  numberButton('7'),
                  numberButton('8'),
                  numberButton('9'),
                  numberButton(''),
                  numberButton('0'),
                  numberButton('delete'),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10), // Agrega un margen de 10
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          widget.onSubmit(amount.toString());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Border redondeado
                          ),
                        ),
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget numberButton(String number) {
    if (number == '') {
      return Container(
        color: Colors.transparent,
      );
    } else if (number == 'delete') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.all(22),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 203, 203, 203)),
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black,
          size: 32,
        ),
        onPressed: () {
          HapticFeedback.heavyImpact();
          setState(() {
            amount = (amount / 10).floor();
            showError = false;
          });
        },
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.all(22),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 203, 203, 203)),
        child: Text(
          number,
          style: const TextStyle(fontSize: 32, color: Colors.black),
        ),
        onPressed: () {
          HapticFeedback.heavyImpact();
          setState(() {
            int potentialAmount = amount * 10 +
                int.parse(
                    number); // la cantidad potencial si se añade el nuevo número
            if (potentialAmount <= maxAmount) {
              // si no supera el límite máximo, se añade el número
              amount = potentialAmount;
              showError = false; // resetea el estado de error
            } else {
              // si supera el límite, muestra el mensaje de error
              showError = true;
            }
          });
        },
      );
    }
  }
}
