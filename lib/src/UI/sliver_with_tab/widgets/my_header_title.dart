import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sample_jpv/src/UI/sliver_with_tab/controller/controller.dart';

import 'get_box_offset.dart';

const headerTitle = 80.0;
typedef OnHeaderChange = void Function(bool visible);

class MyHeaderTitle extends SliverPersistentHeaderDelegate {
  MyHeaderTitle(
    this.title,
    this.onHeaderChange,
    this.categoryOffset,
  );
  final OnHeaderChange onHeaderChange;
  final String title;
  final ValueChanged<Offset> categoryOffset;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print(shrinkOffset);
    if (shrinkOffset > 0) {
      onHeaderChange(true);
    } else {
      onHeaderChange(false);
    }
    return GetBoxOffset(
      offset: (offSet) {
        categoryOffset(offSet);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => headerTitle;

  @override
  double get minExtent => headerTitle;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
