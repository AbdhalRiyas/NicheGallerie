import 'dart:developer';

import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class CategoryRepository {
  Future<Result> getCategories() async {
    final res = await ApiService().get(ApiContants().categories);
    log(res.toString());

    List<Category> categories = [];

    for (var cat in res) {
      categories.add(Category.fromJson(cat));
    }

    return Result(data: categories, message: 'Categories fetched successfully');
  }

  Future<Result> getFeaturedBrands() async {
    final res = await ApiService().get("${ApiContants().brands}?featured=true");
    log("brands: $res");

    List<Brand> featuredBrands = [];

    for (var brand in res) {
      featuredBrands.add(Brand.fromJson(brand));
    }

    return Result(
        data: featuredBrands, message: 'Featured brands fetched successfully');
  }

  Future<Result> getFeaturedAccords() async {
    final res =
        await ApiService().get("${ApiContants().accords}?featured=true");
    log("accords: $res");

    List<Accord> featuredAccords = [];

    for (var accord in res) {
      featuredAccords.add(Accord.fromJson(accord));
    }

    return Result(
        data: featuredAccords,
        message: 'Featured accords fetched successfully');
  }

  Future<Result> getFeaturedNotes() async {
    final res = await ApiService().get("${ApiContants().notes}?featured=true");
    log("notes: $res");

    List<Note> featuredNotes = [];

    for (var note in res) {
      featuredNotes.add(Note.fromJson(note));
    }

    return Result(
        data: featuredNotes, message: 'Featured notes fetched successfully');
  }
}
