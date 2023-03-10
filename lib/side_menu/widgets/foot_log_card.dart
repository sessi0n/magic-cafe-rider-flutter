
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FootLogCard extends StatelessWidget {
  const FootLogCard({Key? key, required this.footLog}) : super(key: key);
  final FootPrintLog footLog;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: ListTile(
            leading: getFootIcon(footLog.type),
            title: Text(
                footLog.name,
                style: const TextStyle(fontSize: 14)
            ),
            subtitle: Text(
                '${footLog.date}',
                style: const TextStyle(fontSize: 10)
            ),
            trailing: Text('+${getFootScore(footLog.type)}', style: const TextStyle(fontSize: 14, color: Colors.blue))
        ));
  }

}

getFootScore(type) {
  if (type == eFootType.COMPLETED) {
    return '15';
  }
  else if (type == eFootType.EVENT) {
    return '3';
  }
  else {
    return '1';
  }
}

getFootIcon(eFootType type) {
  if (type == eFootType.COMPLETED) {
    return const FaIcon(FontAwesomeIcons.checkDouble,
        color: Colors.green, size: 35);
  }
  else if (type == eFootType.EVENT) {
    return const FaIcon(FontAwesomeIcons.stamp,
        color: Colors.amber, size: 30);
  }
  else {
    return const FaIcon(FontAwesomeIcons.motorcycle,
        color: Colors.teal, size: 30);
  }
}

