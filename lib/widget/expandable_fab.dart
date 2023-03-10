import 'dart:math';

import 'package:bike_adventure/widget/action_button.dart';
import 'package:flutter/material.dart';

const Duration _duraion = Duration(milliseconds: 300);

class ExpandableFab extends StatefulWidget {
  const ExpandableFab(
      {Key? key, required this.distance, required this.children})
      : super(key: key);

  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  AnimationController? _controller;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      value: _isOpen ? 1.0 : 0.0,
      duration: _duraion,
    );
    _expandAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildTabToCloseFab(),
          _buildTabToOpenFab(),
        ]..insertAll(0, _buildExpandableActionButton()),
      ),
    );
  }

  List<_ExpandableActionButton> _buildExpandableActionButton() {
    List<_ExpandableActionButton> animChildren = [];
    final int count = widget.children.length;

    final double gap = 90.0 / (count +0.7);

    for (var i = 0, degree = 0.0; i < count; i++, degree += gap) {
      animChildren.add(_ExpandableActionButton(
        distance: widget.distance,
        progress: _expandAnimation!,
        child: widget.children[i],
        degree: degree,
      ));
    }

    return animChildren;
  }

  AnimatedContainer _buildTabToOpenFab() {
    return AnimatedContainer(
        duration: _duraion,
        transform: Matrix4.rotationZ(_isOpen ? 0 : pi / 4),
        transformAlignment: Alignment.center,
        child: AnimatedOpacity(
          duration: _duraion,
          opacity: _isOpen ? 0.0 : 1.0,
          child: FloatingActionButton(
            onPressed: toggle,
            backgroundColor: Colors.amber,
            child: Icon(Icons.close),
          ),
        ));
  }

  AnimatedContainer _buildTabToCloseFab() {
    return AnimatedContainer(
        duration: _duraion,
        transform: Matrix4.rotationZ(_isOpen ? 0 : pi / 4),
        transformAlignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          onPressed: toggle,
          child: Icon(
            Icons.close,
            color: Theme.of(context).primaryColor,
          ),
        ));
  }

  void toggle() {
    _isOpen = !_isOpen;
    setState(() {
      if (_isOpen) {
        _controller!.forward();
      } else {
        _controller!.reverse();
      }
    });
  }
}

class _ExpandableActionButton extends StatelessWidget {
  const _ExpandableActionButton({
    Key? key,
    required this.distance,
    required this.degree,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (_, child) {
        final Offset offset = Offset.fromDirection(
            degree * (pi / 100), progress.value * distance);
        return Positioned(right: offset.dx+4, bottom: offset.dy+4, child: child!);
      },
    );
  }
}
