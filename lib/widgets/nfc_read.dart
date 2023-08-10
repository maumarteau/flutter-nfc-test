// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:cobraticket_dispatch_products/controllers/nfc_controller.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
// import 'package:nfc_manager/platform_tags.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:crypto/crypto.dart' show sha256;

import '../../../../controllers/nfc_controller.dart';
import 'icon_nfc_error.dart';
import 'icon_nfc_success.dart';
import 'icon_nfc_waiting.dart';
import 'icon_nfc_writing.dart';

class NFCRead extends StatefulWidget {
  final VoidCallback onCancel;

  const NFCRead({required this.onCancel, Key? key}) : super(key: key);

  @override
  NFCReadState createState() => NFCReadState();
}

class NFCReadState extends State<NFCRead> {
  NfcController nfcController = NfcController();

  String _nfcStatus = 'WAITING_CARD';
  String _nfcStatusMessage = '';

  Map<String, dynamic>? tagData;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() async {
    // Iniciando la escucha NFC

    tagData = await nfcController.readCardData();
    print(tagData);

    if (tagData != null) {
      setState(() {
        _nfcStatus = 'SUCCESS';
        // mensaje de que tiene un saldo de tagData.amount
        _nfcStatusMessage = "Tiene un saldo de ${tagData!['amount']}";
      });

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pop();
      });
    } else {
      setState(() {
        _nfcStatus = 'ERROR';
        _nfcStatusMessage = 'Error al leer la tarjeta';
      });
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: double.infinity,
              height: 380,
              color: _nfcStatus == 'WAITING_CARD'
                  ? Colors.white
                  : _nfcStatus == 'WRITING_CARD'
                      ? Colors.orange[500]
                      : _nfcStatus == 'SUCCESS'
                          ? Colors.green[500]
                          : _nfcStatus == 'ERROR'
                              ? Colors.red[500]
                              : Colors.blue[500],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_nfcStatus == 'WAITING_CARD') ...[
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'Esperando tarjeta',
                            style: TextStyle(
                                fontSize: 28, color: Colors.grey.shade900),
                          ),
                          IconNFCWaiting(message: _nfcStatusMessage),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Text(
                                'Coloca la tarjeta y manténla cerca del dispositivo hasta que se complete la lectura',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade900),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            elevation: 0,
                          ),
                          onPressed: () {
                            cancel();
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    )
                  ] else if (_nfcStatus == 'WRITING_CARD')
                    IconNFCWriting(message: _nfcStatusMessage)
                  else if (_nfcStatus == 'SUCCESS')
                    IconNFCSuccess(message: _nfcStatusMessage)
                  else
                    IconNFCError(message: _nfcStatusMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
