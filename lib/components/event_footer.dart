import 'package:flutter/material.dart';

class EventFooter extends StatelessWidget {
  final dynamic eventData;
  final dynamic selectedItems;
  final VoidCallback onConfirm;
  final BuildContext context;

  const EventFooter({
    Key? key,
    required this.eventData,
    required this.selectedItems,
    required this.onConfirm,
    required this.context,
  }) : super(key: key);

  num calculateTotal() {
    num total = 0;
    for (var item in selectedItems) {
      total += item['quantity'] * item['price'];
    }
    return total;
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'El monto a cobrar es:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${calculateTotal()}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      foregroundColor: Colors.black45),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    onConfirm();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 12),
                    shadowColor: Colors.black,
                    elevation: 5,
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: const Text(
                    'Emitir entradas',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                // const SizedBox(width: 16),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: eventData.isEmpty
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0,
                        2), // Cambia el desplazamiento en el eje y según tus necesidades
                  ),
                ],
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Text('\$ ${calculateTotal()}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 12),
                      shadowColor: Colors.black, // Add this line
                      elevation: 5, // Add this line
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
