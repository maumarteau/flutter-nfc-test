import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class IconNFCWriting extends StatelessWidget {
  final String message;

  const IconNFCWriting({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AvatarGlow(
              endRadius: 90.0,
              duration: const Duration(milliseconds: 200),
              repeat: true,
              repeatPauseDuration: const Duration(milliseconds: 50),
              startDelay: const Duration(milliseconds: 0),
              child: Material(
                elevation: 0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.orange[300],
                  radius: 55.0,
                  child: Icon(
                    Icons.nfc,
                    size: 10,
                    color: Colors.orange[500],
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/images/scan-nfc.png',
              height: 200,
            ),
          ],
        ),
      ],
    );
  }
}
