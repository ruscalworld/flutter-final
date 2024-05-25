import 'package:mobx/mobx.dart';
import 'package:pr_final/api/places/manager.dart';
import 'package:pr_final/api/places/place.dart';

part 'place_store.g.dart';

class PlaceStore = _PlaceStore with _$PlaceStore;

abstract class _PlaceStore with Store {
  @observable
  Place? currentPlace;

  @observable
  bool placesLoaded = false;

  PlaceManager placeManager = PlaceManager();

  @action
  void setPlacesLoaded() {
    placesLoaded = true;
  }

  void loadPlaces() {
    if (placesLoaded) return;
    placeManager.load().then((value) => setPlacesLoaded());
  }

  @action
  void pickPlace(Place place) {
    currentPlace = place;
  }

  @action
  void saveAndPickPlace(Place place) {
    placeManager.addPlace(place);
    currentPlace = place;
    placeManager.save();
  }
}
