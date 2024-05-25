// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaceStore on _PlaceStore, Store {
  late final _$currentPlaceAtom =
      Atom(name: '_PlaceStore.currentPlace', context: context);

  @override
  Place? get currentPlace {
    _$currentPlaceAtom.reportRead();
    return super.currentPlace;
  }

  @override
  set currentPlace(Place? value) {
    _$currentPlaceAtom.reportWrite(value, super.currentPlace, () {
      super.currentPlace = value;
    });
  }

  late final _$placesLoadedAtom =
      Atom(name: '_PlaceStore.placesLoaded', context: context);

  @override
  bool get placesLoaded {
    _$placesLoadedAtom.reportRead();
    return super.placesLoaded;
  }

  @override
  set placesLoaded(bool value) {
    _$placesLoadedAtom.reportWrite(value, super.placesLoaded, () {
      super.placesLoaded = value;
    });
  }

  late final _$_PlaceStoreActionController =
      ActionController(name: '_PlaceStore', context: context);

  @override
  void setPlacesLoaded() {
    final _$actionInfo = _$_PlaceStoreActionController.startAction(
        name: '_PlaceStore.setPlacesLoaded');
    try {
      return super.setPlacesLoaded();
    } finally {
      _$_PlaceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pickPlace(Place place) {
    final _$actionInfo = _$_PlaceStoreActionController.startAction(
        name: '_PlaceStore.pickPlace');
    try {
      return super.pickPlace(place);
    } finally {
      _$_PlaceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveAndPickPlace(Place place) {
    final _$actionInfo = _$_PlaceStoreActionController.startAction(
        name: '_PlaceStore.saveAndPickPlace');
    try {
      return super.saveAndPickPlace(place);
    } finally {
      _$_PlaceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPlace: ${currentPlace},
placesLoaded: ${placesLoaded}
    ''';
  }
}
