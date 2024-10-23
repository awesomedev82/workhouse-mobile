import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonComponent extends StatefulWidget {
  final bool loading;
  final dynamic child;

  const SkeletonComponent(
      {Key? key, required this.loading, required this.child})
      : super(key: key);

  @override
  _SkeletonComponentState createState() => _SkeletonComponentState();
}

class _SkeletonComponentState extends State<SkeletonComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.loading ? Skeletonizer(ignoreContainers: false, child: widget.child) : widget.child;
  }
}
