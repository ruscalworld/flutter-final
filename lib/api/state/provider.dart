import 'package:flutter/material.dart';
import 'package:pr_final/api/state/place_store.dart';

class StateProvider extends InheritedWidget {
  final PlaceStore placeStore;

  const StateProvider({super.key, required super.child, required this.placeStore});

  @override
  bool updateShouldNotify(covariant StateProvider oldWidget) {
    return oldWidget.placeStore != placeStore;
  }

  static StateProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateProvider>()!;
  }
}