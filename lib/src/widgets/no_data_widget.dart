import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String text;

  NoDataWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
