import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:collection';

class ConsultationData extends ChangeNotifier {
  List<User> _firstAiders = [];
  List<User> _firstAidersFiltered = [];
  User? selectedFirstAider = null;
  User? tempFirstAider = null;
  String selectedPlatform = '';
  bool all_fa = true;
  String firstAider = '';

  int get firstAiderCount {
    return _firstAidersFiltered.length;
  }

  UnmodifiableListView<User> get firstAiders {
    return UnmodifiableListView(_firstAiders);
  }

  UnmodifiableListView<User> get firstAidersFiltered {
    return UnmodifiableListView(_firstAidersFiltered);
  }

  void addFirstAider(String userName, String? userImageUrl, String id) {
    User newUser;
    if (userImageUrl == null) {
      newUser = User(name: userName, id: id);
    } else {
      newUser = User(name: userName, imageUrl: userImageUrl, id: id);
    }

    _firstAiders.add(newUser);

    notifyListeners();
  }

  void selectFirstAider(User? selectedUser) {
    tempFirstAider = selectedUser;
    notifyListeners();
  }

  void tempToSelectedFirstAider() {
    selectedFirstAider = tempFirstAider;
    firstAider = selectedFirstAider!.id;
    all_fa = false;
    notifyListeners();
  }

  void selectPlatform(String platform) {
    selectedPlatform = platform;
    notifyListeners();
  }

  void removeSelectedPlatform() {
    selectedPlatform = '';
  }

  void removeSelectedFirstAider() {
    selectedFirstAider = null;
    tempFirstAider = null;
    all_fa = true;
    firstAider = '';
  }

  void filterFirstAider(String searchText) {
    _firstAidersFiltered = _firstAiders
        .where((firstAider) =>
            firstAider.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void removeFilter() {
    _firstAidersFiltered = _firstAiders;
    notifyListeners();
  }
}
