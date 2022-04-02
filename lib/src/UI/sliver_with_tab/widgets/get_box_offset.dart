import 'package:flutter/material.dart';
import 'package:flutter_sample_jpv/src/UI/sliver_with_tab/controller/controller.dart';

class GetBoxOffset extends StatefulWidget {
  final Widget child;
  final Function(Offset offset) offset;
  final Function(Dimension dimension)? dimension;

  const GetBoxOffset({
    Key? key,
    required this.child,
    required this.offset,
    this.dimension,
  }) : super(key: key);

  @override
  _GetBoxOffsetState createState() => _GetBoxOffsetState();
}

class _GetBoxOffsetState extends State<GetBoxOffset> {
  GlobalKey widgetKey = GlobalKey();

  late Offset offset;
  late Size size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final box = widgetKey.currentContext?.findRenderObject() as RenderBox;
      offset = box.localToGlobal(Offset.zero);
      size = box.size;
      widget.offset(offset);
      if (widget.dimension != null)
        widget.dimension!(Dimension(offset: offset, size: size));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: widgetKey,
      child: widget.child,
    );
  }
}
