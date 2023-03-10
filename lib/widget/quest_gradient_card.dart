import 'package:flutter/material.dart';

class GradientCard extends StatefulWidget {
  const GradientCard(
      {Key? key, required this.child, required this.isCompleted})
      : super(key: key);
  final Widget child;
  final bool isCompleted;

  @override
  _GradientCardState createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {


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
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          decoration: BoxDecoration(
              // color: Colors.indigo,
            color: widget.isCompleted ? Colors.grey.withOpacity(0.1) : Colors.white,
              // gradient: LinearGradient(
              //     colors: widget.isCompleted
              //         ? [Colors.amber, Colors.amber]
              //         : [Colors.white, Colors.white]),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: widget.child,
        ));
  }
}

