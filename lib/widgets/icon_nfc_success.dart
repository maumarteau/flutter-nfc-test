import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class IconNFCSuccess extends StatelessWidget {
  final String message;

  const IconNFCSuccess({Key? key, required this.message}) : super(key: key);

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
              duration: const Duration(milliseconds: 500),
              repeat: false,
              animate: true,
              repeatPauseDuration: const Duration(milliseconds: 1000),
              startDelay: const Duration(milliseconds: 100),
              child: Material(
                elevation: 0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.green[300],
                  radius: 55.0,
                  child: Icon(
                    Icons.nfc,
                    size: 10,
                    color: Colors.green[500],
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/images/scan-nfc-success.png',
              height: 200,
            ),
          ],
        ),
      ],
    );
  }
}
