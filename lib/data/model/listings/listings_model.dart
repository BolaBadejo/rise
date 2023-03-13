import 'package:rise/business_logic/artisan/get_auth_user/get_auth_user_bloc.dart';

class ListingsModel {
  bool? success;
  String? message;
  Data? data;

  ListingsModel({this.success, this.message, this.data});

  ListingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<DataModel>? data;
  String? firstPageUrl;
  int? from;
  String? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    return data;
  }
}

class DataModel {
  int? id;
  String? category;
  String? serviceOffering;
  String? title;
  String? description;
  List<String>? listingImages;
  String? minimumOffer;
  String? slug;
  String? topListing;
  var user;

  DataModel(
      {this.id,
      this.category,
      this.serviceOffering,
      this.title,
      this.description,
      this.listingImages,
      this.minimumOffer,
      this.slug,
      this.topListing,
      this.user});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    serviceOffering = json['service_offering'];
    title = json['title'];
    description = json['description'];
    listingImages = json['listing_images'].cast<String>();
    minimumOffer = json['minimum_offer'];
    slug = json['slug'];
    topListing = json['top_listings'];
    user = json['user'];
  }

  static List<DataModel> dataFromSnapshot(List dataSnapshot) {
    return dataSnapshot.map((data) {
      return DataModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['category'] = category;
    data['service_offering'] = serviceOffering;
    data['title'] = title;
    data['description'] = description;
    data['listing_images'] = listingImages;
    data['minimum_offer'] = minimumOffer;
    data['slug'] = slug;
    data['top_listings'] = topListing;
    data['user'] = user;
    return data;
  }
}
