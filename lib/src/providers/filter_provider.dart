import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  RangeValues currentRangeValues = const RangeValues(99, 10000);
  Set<String> selectedCategories = {};
  String selectedSort = '';

  void updateRangeValues(RangeValues newRangeValues) {
    currentRangeValues = newRangeValues;
    notifyListeners();
  }

  void updateSelectedCategories(Set<String> newSelectedCategories) {
    selectedCategories = newSelectedCategories;
    notifyListeners();
  }

  void updateSelectedSort(String newSelectedSort) {
    selectedSort = newSelectedSort;
    notifyListeners();
  }

  void clearFilters() {
    currentRangeValues = const RangeValues(99, 10000);
    selectedCategories.clear();
    selectedSort = '';
    notifyListeners();
  }

  void applyFilters() {
    // Logic to apply filters can be added here
    notifyListeners();
  }

  void resetFilters() {
    currentRangeValues = const RangeValues(99, 10000);
    selectedCategories.clear();
    selectedSort = '';
    notifyListeners();
  }

  void setSelectedSort(String value) {
    selectedSort = value;
    notifyListeners();
  }

  void setSelectedCategories(Set<String> value) {
    selectedCategories = value;
    notifyListeners();
  }

  void setCurrentRangeValues(RangeValues value) {
    currentRangeValues = value;
    notifyListeners();
  }

  void setSelectedCategory(String value) {
    if (selectedCategories.contains(value)) {
      selectedCategories.remove(value);
    } else {
      selectedCategories.add(value);
    }
    notifyListeners();
  }

  void setSelectedCategoryAll() {
    selectedCategories.clear();
    notifyListeners();
  }

  void setSelectedCategoryNone() {
    selectedCategories.clear();
    notifyListeners();
  }

  void setSelectedCategoryToggle(String value) {
    if (selectedCategories.contains(value)) {
      selectedCategories.remove(value);
    } else {
      selectedCategories.add(value);
    }
    notifyListeners();
  }
}
