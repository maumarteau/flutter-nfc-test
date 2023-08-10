import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcController {
  bool _ignoreReads = false;

  // Método para iniciar la sesión NFC y escuchar las tarjetas.
  Future<NfcTag?> startNfcListener() async {
    final completer = Completer<NfcTag>();

    bool isAvailable = await NfcManager.instance.isAvailable();
    print("NFC isAvailable: $isAvailable");
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null) {
            print('Tag is not compatible with NDEF');
            return;
          }
          print('Tag is compatible with NDEF');
        } catch (e) {
          print("Error leyendo datos: $e");
        } finally {
          NfcManager.instance.stopSession();
          completer.complete(tag);
        }
      },
    );

    // String data;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   data = await NfcReadWritePlugin.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // print("platformVersion: $platformVersion");

    // Iniciar la sesión NFC.
    // print('Iniciando sesión NFC...');
    // await NfcManager.instance.startSession(
    //   onDiscovered: (NfcTag tag) async {
    //     if (_ignoreReads) return;
    //     _ignoreReads = true;

    //     String identifierHex = "";
    //     Uint8List? identifier;

    //     if (NfcA.from(tag) != null) {
    //       final NfcA nfcA = NfcA.from(tag)!;
    //       identifier = nfcA.identifier;
    //     } else if (NfcB.from(tag) != null) {
    //       final NfcB nfcB = NfcB.from(tag)!;
    //       identifier = nfcB.applicationData;
    //     } else if (NfcF.from(tag) != null) {
    //       final NfcF nfcF = NfcF.from(tag)!;
    //       identifier = nfcF.manufacturer;
    //     } else if (NfcV.from(tag) != null) {
    //       final NfcV nfcV = NfcV.from(tag)!;
    //       identifier = nfcV.identifier;
    //     } else if (IsoDep.from(tag) != null) {
    //       final IsoDep isoDep = IsoDep.from(tag)!;
    //       identifier = isoDep.historicalBytes;
    //     } else if (MiFare.from(tag) != null) {
    //       final MiFare miFare = MiFare.from(tag)!;
    //       identifier = miFare.identifier;
    //     }

    //     try {
    //       if (identifier != null) {
    //         identifierHex = identifier.map((byte) {
    //           return byte.toRadixString(16).padLeft(2, '0');
    //         }).join();
    //         print('NFC ID: $identifierHex');
    //       }

    //       var ndef = Ndef.from(tag);

    //       if (ndef == null || !ndef.isWritable) {
    //         print('Tag is not ndef writable');
    //         NfcManager.instance
    //             .stopSession(errorMessage: 'Tag is not ndef writable');
    //         return;
    //       }
    //       completer.complete(tag);
    //     } catch (e) {
    //       print("Error leyendo datos: $e");
    //       Future.delayed(const Duration(seconds: 5), () {
    //         NfcManager.instance.stopSession();
    //         _ignoreReads = false;
    //       });
    //       return;
    //     }
    //   },
    // );

    return completer.future;
  }

  Future<Map<String, dynamic>?> readCardData() async {
    print("readCardData");
    final completer = Completer<Map<String, dynamic>?>();

    bool isAvailable = await NfcManager.instance.isAvailable();
    print("NFC isAvailable: $isAvailable");

    if (!isAvailable) {
      completer.complete(null);
    } else {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            Map<String, dynamic>? result;

            Ndef? ndef = Ndef.from(tag);
            if (ndef == null) {
              print('Tag is not compatible with NDEF');
              completer.complete(null);
              return;
            }
            final cardId = getCardId(tag);
            print('NFC ID: $cardId');

            /*****  Read data from records *****/
            NdefMessage readMessage = await ndef.read();
            for (final record in readMessage.records) {
              try {
                String decodedPayload = utf8.decode(record.payload);
                result = jsonDecode(decodedPayload);
              } catch (e) {
                print("Error decrypting data: $e");
              }
            }
            /*****  Read data from records *******/

            /*****  Try to read data from a protected or specific block ********/
            // NfcA? nfcA = NfcA.from(tag);
            // if (nfcA == null) {
            //   print('Tag is not compatible with NfcA');
            //   completer.complete(null);
            //   return;
            // }

            // int blockNumber = 4;
            // Uint8List readCommand = Uint8List.fromList([0x30, blockNumber]);
            // Uint8List response = await nfcA.transceive(data: readCommand);
            // print(response);

            /*****  Try to read data from a protected or specific block ********/
            print("readCardData DONE!");
            completer.complete(result);
          } catch (e) {
            print("Error leyendo datos: $e");
            completer.completeError(e);
          } finally {
            Future.delayed(const Duration(seconds: 2), () {
              NfcManager.instance.stopSession();
            });
          }
        },
      );
    }

    return completer.future;
  }

  Future<Map<String, dynamic>?> writeCardData(Map<String, dynamic> data) async {
    print("writeCardData");
    final completer = Completer<Map<String, dynamic>?>();

    bool isAvailable = await NfcManager.instance.isAvailable();
    print("NFC isAvailable: $isAvailable");

    List<int> payloadList = utf8.encode(jsonEncode(data));
    Uint8List payload = Uint8List.fromList(payloadList);

    if (!isAvailable) {
      completer.complete(null);
    } else {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            Map<String, dynamic>? result;

            Ndef? ndef = Ndef.from(tag);
            if (ndef == null) {
              print('Tag is not compatible with NDEF');
              completer.complete(null);
              return;
            }
            final cardId = getCardId(tag);
            print('NFC ID: $cardId');

            // NdefMessage readMessage = await ndef.read();
            // for (final record in readMessage.records) {
            //   try {
            //     print("record.payload: ${record.payload}");

            //     // result = jsonDecode(base64.encode(record.payload));
            //     result = jsonDecode(base64.encode(record.payload));
            //   } catch (e) {
            //     print("Error decrypting data: $e");
            //   }
            // }

            /*****  write data  ********/
            NfcA? nfcA = NfcA.from(tag);
            if (nfcA == null) {
              print('Tag is not compatible with NfcA');
              completer.complete(null);
              return;
            }
            NdefMessage message = NdefMessage([
              NdefRecord(
                typeNameFormat: NdefTypeNameFormat.media,
                type: Uint8List.fromList('text/plain'.codeUnits),
                identifier: Uint8List(0),
                payload: payload,
              ),
            ]);

            await ndef.write(message);
            /*****  write data  ********/

            /*****  Try to write data to a protected or specific block ********/
            // int blockNumber = 4;
            // Uint8List dataToWrite = Uint8List.fromList([
            //   0x01,
            //   0x02,
            //   0x03,
            //   0x04,
            //   0x05,
            //   0x06,
            //   0x07,
            //   0x08,
            //   0x09,
            //   0x0A,
            //   0x0B,
            //   0x0C,
            //   0x0D,
            //   0x0E,
            //   0x0F,
            //   0x10
            // ]);

            // Uint8List writeCommand = Uint8List(2 + dataToWrite.length);
            // writeCommand[0] = 0xA0;
            // writeCommand[1] = blockNumber;
            // writeCommand.setRange(2, 2 + dataToWrite.length, dataToWrite);

            // Uint8List response = await nfcA.transceive(data: writeCommand);
            // print("response tranceive: $response");

            /*****  Try to write data to a protected or specific block ********/
            print("writeCardData DONE!");
            completer.complete(data);
          } catch (e) {
            print("Error leyendo datos: $e");
            completer.completeError(e);
          } finally {
            Future.delayed(const Duration(seconds: 2), () {
              NfcManager.instance.stopSession();
            });
          }
        },
      );
    }

    return completer.future;
  }

  String? getCardId(tag) {
    String identifierHex = "";
    Uint8List? identifier;

    if (NfcA.from(tag) != null) {
      final NfcA nfcA = NfcA.from(tag)!;
      identifier = nfcA.identifier;
      print("NfcA: ");
    } else if (NfcB.from(tag) != null) {
      final NfcB nfcB = NfcB.from(tag)!;
      identifier = nfcB.applicationData;
      print("NfcB: ");
    } else if (NfcF.from(tag) != null) {
      final NfcF nfcF = NfcF.from(tag)!;
      identifier = nfcF.manufacturer;
      print("NfcF: ");
    } else if (NfcV.from(tag) != null) {
      final NfcV nfcV = NfcV.from(tag)!;
      identifier = nfcV.identifier;
      print("NfcV: ");
    } else if (IsoDep.from(tag) != null) {
      final IsoDep isoDep = IsoDep.from(tag)!;
      identifier = isoDep.historicalBytes;
      print("IsoDep: ");
    } else if (MiFare.from(tag) != null) {
      final MiFare miFare = MiFare.from(tag)!;
      identifier = miFare.identifier;
      print("MiFare: ");
    }

    if (identifier != null) {
      identifierHex = identifier.map((byte) {
        return byte.toRadixString(16).padLeft(2, '0');
      }).join();
    }

    return identifierHex;
  }

  Uint8List buildAuthenticationCommand(
      int sector, bool useKeyA, Uint8List key) {
    // La autenticación en MIFARE Classic se realiza a nivel de sector, no de bloque.
    // Necesitas determinar el bloque que quieres autenticar dentro del sector.
    int block = sector * 4; // Asumiendo 4 bloques por sector

    // El comando de autenticación requiere el tipo de clave (A o B) y el número de bloque
    List<int> command = [
      useKeyA ? 0x60 : 0x61, // 0x60 para clave A, 0x61 para clave B
      block, // Número de bloque
      // Aquí puedes necesitar más datos, dependiendo de la biblioteca y la tarjeta
    ];

    // Puedes necesitar incluir la clave en sí en el comando, o puede que la clave
    // tenga que ser enviada en un comando separado.

    return Uint8List.fromList(command);
  }
}
