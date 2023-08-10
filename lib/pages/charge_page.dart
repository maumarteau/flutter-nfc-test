import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_nfc_card/widgets/nfc_read.dart';

import '../widgets/nfc_charge.dart';
import '../widgets/numeric_keyboard.dart';

class CashlessChargePage extends StatefulWidget {
  const CashlessChargePage({Key? key}) : super(key: key);
  static String id = 'cashless_charge';

  @override
  State<CashlessChargePage> createState() => _CashlessChargePageState();
}

class _CashlessChargePageState extends State<CashlessChargePage> {
  late SharedPreferences prefs;
  Map<String, dynamic> loggedUser = {};
  Map<String, dynamic> loggedEvent = {};
  bool isLoading = false;

  final List<int> predefinedValues = [
    500,
    1000,
    1500,
    2000,
    2500,
    3000,
    3500,
    4000
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo-dark.png',
                width: 180,
              ),
            ],
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon:
                  Icon(Icons.nfc), // Puedes utilizar cualquier icono que desees
              onPressed: () {
                // Lógica para leer la tarjeta NFC
                // Por ejemplo, podrías mostrar el modal que ya tienes
                showCupertinoModalBottomSheet(
                  bounce: true,
                  context: context,
                  enableDrag: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (context) => NFCRead(
                    onCancel: () {
                      print("Cancel");
                    },
                  ),
                );
              },
            )
          ],
        ),
        body: NumericKeyboard(
            predefinedValues: predefinedValues,
            onSubmit: (amount) {
              showCupertinoModalBottomSheet(
                bounce: true,
                context: context,
                enableDrag: true,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) => NFCCharge(
                  amount: amount,
                  onCancel: () {
                    print("Cancel");
                  },
                ),
              );
            }));
  }
}
