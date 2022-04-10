import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sample_jpv/src/UI/sliver_with_tab/data/data.dart';
import 'package:flutter_sample_jpv/src/UI/sliver_with_tab/models/models.dart';

import '../widgets/my_header_title.dart';

class SliverScrollController {
  //List of products - Lista de productos
  late List<ProductCategory> listCategory;

  //list of offSet values - Lista de valores offSet de los item
  List<double> listOffSetItemHeader = [];
  // list offsets of categories inside the SliverList
  List<double> listOffsetCategoryGroup = [];

  //Header notifier - Notificaciones de cabereca
  final headerNotifier = ValueNotifier<MyHeader?>(null);

  //Global Offset Value - Valor actual de scroll
  final globalOffsetValue = ValueNotifier<double>(0);

  //Indicador si estamos bajando o subiendo en el app
  //Indicator if we are going down or up in the application
  final goingDown = ValueNotifier<bool>(false);

  // Valor para hacer la validaciones de los iconos superiores
  final valueScroll = ValueNotifier<double>(0);

  // Para mover los items superiores en sliver - To move the top category bar
  late ScrollController scrollControllerItemHeader;

  // To have overall control of scrolling - To have overall control of scrolling
  late ScrollController scrollControllerGlobally;

  // Valor que indica si el encabezado es visible
  // Value that indicates if the header is visible
  final visibleHeader = ValueNotifier(false);

  final shouldListenToTouchScroll = ValueNotifier<bool>(true);

  void loadDataRandom() {
    final productsTwo = [...products];
    final productsThree = [...products];
    final productsFour = [...products];

    productsTwo.shuffle();
    productsThree.shuffle();
    productsFour.shuffle();

    listCategory = [
      ProductCategory(
        category: 'Picked For You',
        products: [
          Product(
            name: 'Pepsi',
            image: 'assets/sliver_with_scrollable_tabs/sandiwch.png',
            description:
                'Trim bread from all sides and apply butter on one breast, then apply the green chutney all over.',
            price: '\$4',
          ),
          Product(
            name: 'Coke 1',
            image: 'assets/sliver_with_scrollable_tabs/sandiwch.png',
            description:
                'Trim bread from all sides and apply butter on one breast, then apply the green chutney all over.',
            price: '\$4',
          ),
        ],
      ),
      ProductCategory(
        category: 'Pizza',
        products: [
          Product(
            name: 'Pizza',
            image: 'assets/sliver_with_scrollable_tabs/pizza.jpg',
            description:
                'Pizza is a savory dish of Italian origin consisting of a usually round, flattened base of leavened wheat-based dough to bake.',
            price: '\$39',
          ),
        ],
      ),
      ProductCategory(
        category: 'Cheese Cake',
        products: productsFour,
      ),
      ProductCategory(
        category: 'Order Again',
        products: products,
      ),
      ProductCategory(
        category: 'Startes',
        products: productsThree,
      ),
      ProductCategory(
        category: 'Gimpub Sushi',
        products: productsFour,
      ),
      ProductCategory(
        category: 'Fast Food',
        products: [
          Product(
            name: 'Chapati',
            image: 'assets/sliver_with_scrollable_tabs/sandiwch.png',
            description:
                'Trim bread from all sides and apply butter on one breast, then apply the green chutney all over.',
            price: '\$4',
          ),
          Product(
            name: 'Chapati2',
            image: 'assets/sliver_with_scrollable_tabs/sandiwch.png',
            description:
                'Trim bread from all sides and apply butter on one breast, then apply the green chutney all over.',
            price: '\$4',
          ),
        ],
      ),
    ];
  }

  void init() {
    loadDataRandom();
    listOffSetItemHeader =
        List.generate(listCategory.length, (index) => index.toDouble());
    listOffsetCategoryGroup =
        List.generate(listCategory.length, (index) => index.toDouble());
    scrollControllerGlobally = ScrollController();
    scrollControllerItemHeader = ScrollController();

    headerNotifier.addListener(_listenHeaderNotifier);
    scrollControllerGlobally.addListener(_listenToScrollChange);
    visibleHeader.addListener(_listenVisibleHeader);
  }

  void _listenVisibleHeader() {
    if (visibleHeader.value) {
      headerNotifier.value = const MyHeader(visible: false, index: 0);
    }
  }

  void dispose() {
    scrollControllerItemHeader.dispose();
    scrollControllerGlobally.dispose();
  }

  void _listenHeaderNotifier() {
    if (visibleHeader.value) {
      for (var i = 0; i < listCategory.length; i++) {
        scrollAnimationHorizontal(index: i);
      }
    }
  }

  void _listenToScrollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
    if (scrollControllerGlobally.position.userScrollDirection ==
        ScrollDirection.reverse) {
      goingDown.value = true;
    } else {
      goingDown.value = false;
    }
  }

  void scrollAnimationHorizontal({required int index}) {
    if (headerNotifier.value?.index == index && headerNotifier.value!.visible) {
      scrollControllerItemHeader.animateTo(
        listOffSetItemHeader[headerNotifier.value!.index] - 16,
        duration: const Duration(milliseconds: 500),
        curve: goingDown.value ? Curves.bounceOut : Curves.fastOutSlowIn,
      );
    }
  }

  refreshHeader(
    int index,
    bool visible, {
    int? lastIndex,
  }) {
    final headerValue = headerNotifier.value;
    final headerTitle = headerValue?.index ?? index;
    final headerVisible = headerValue?.visible ?? false;
    if (headerTitle != index || lastIndex != null || headerVisible != visible) {
      Future.microtask(
        () {
          if (!visible && lastIndex != null) {
            headerNotifier.value = MyHeader(
              visible: true,
              index: lastIndex,
            );
          } else {
            headerNotifier.value = MyHeader(
              visible: visible,
              index: index,
            );
          }
        },
      );
    }
  }

  onHeaderPressed(int index) async {
    shouldListenToTouchScroll.value = false;
    refreshHeader(index, true);
    if (listOffsetCategoryGroup[index] >
        scrollControllerGlobally.position.maxScrollExtent)
      await scrollControllerGlobally.animateTo(
        scrollControllerGlobally.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    else if (index == 0)
      await scrollControllerGlobally.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
      );
    else {
      await scrollControllerGlobally.animateTo(
        (listOffsetCategoryGroup[index] - headerTitle - 20),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
      print(scrollControllerGlobally.offset);
    }
    shouldListenToTouchScroll.value = true;
  }
}
