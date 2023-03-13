class BookingResponse {
  bool? success;
  String? message;
  Data? data;

  BookingResponse({this.success, this.message, this.data});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalBooked;
  NewBooking? newBooking;
  OnGoingBooking? ongoingBooking;

  Data({this.totalBooked, this.newBooking, this.ongoingBooking});

  Data.fromJson(Map<String, dynamic> json) {
    totalBooked = json['total_booked'];
    newBooking = json['newBooking'] != null
        ? NewBooking.fromJson(json['newBooking'])
        : null;
    ongoingBooking = json['ongoingBooking']!= null
        ? OnGoingBooking.fromJson(json['ongoingBooking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_booked'] = totalBooked;
    if (newBooking != null) {
      data['newBooking'] = newBooking!.toJson();
    }
    data['ongoingBooking'] = ongoingBooking;
    return data;
  }
}

class NewBooking {
  int? id;
  dynamic taskId;
  String? tentativeAmount;
  dynamic bargainedAmount;
  String? status;
  String? title;
  String? description;
  dynamic rating;
  dynamic ratingReview;
  dynamic acceptedAt;
  dynamic rejectedAt;
  dynamic startedAt;
  dynamic arrivedAt;
  dynamic cancelledAt;
  dynamic completedAt;
  Listing? listing;

  NewBooking(
      {this.id,
        this.taskId,
        this.tentativeAmount,
        this.bargainedAmount,
        this.status,
        this.title,
        this.description,
        this.rating,
        this.ratingReview,
        this.acceptedAt,
        this.rejectedAt,
        this.startedAt,
        this.arrivedAt,
        this.cancelledAt,
        this.completedAt,
        this.listing});

  NewBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    tentativeAmount = json['tentative_amount'];
    bargainedAmount = json['bargained_amount'];
    status = json['status'];
    title = json['title'];
    description = json['description'];
    rating = json['rating'];
    ratingReview = json['rating_review'];
    acceptedAt = json['accepted_at'];
    rejectedAt = json['rejected_at'];
    startedAt = json['started_at'];
    arrivedAt = json['arrived_at'];
    cancelledAt = json['cancelled_at'];
    completedAt = json['completed_at'];
    listing =
    json['listing'] != null ? Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task_id'] = taskId;
    data['tentative_amount'] = tentativeAmount;
    data['bargained_amount'] = bargainedAmount;
    data['status'] = status;
    data['title'] = title;
    data['description'] = description;
    data['rating'] = rating;
    data['rating_review'] = ratingReview;
    data['accepted_at'] = acceptedAt;
    data['rejected_at'] = rejectedAt;
    data['started_at'] = startedAt;
    data['arrived_at'] = arrivedAt;
    data['cancelled_at'] = cancelledAt;
    data['completed_at'] = completedAt;
    if (listing != null) {
      data['listing'] = listing!.toJson();
    }
    return data;
  }
}

class OnGoingBooking {
  int? id;
  dynamic taskId;
  String? tentativeAmount;
  dynamic bargainedAmount;
  String? status;
  String? title;
  String? description;
  dynamic rating;
  dynamic ratingReview;
  dynamic acceptedAt;
  dynamic rejectedAt;
  dynamic startedAt;
  dynamic arrivedAt;
  dynamic cancelledAt;
  dynamic completedAt;
  Listing? listing;

  OnGoingBooking(
      {this.id,
        this.taskId,
        this.tentativeAmount,
        this.bargainedAmount,
        this.status,
        this.title,
        this.description,
        this.rating,
        this.ratingReview,
        this.acceptedAt,
        this.rejectedAt,
        this.startedAt,
        this.arrivedAt,
        this.cancelledAt,
        this.completedAt,
        this.listing});

  OnGoingBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    tentativeAmount = json['tentative_amount'];
    bargainedAmount = json['bargained_amount'];
    status = json['status'];
    title = json['title'];
    description = json['description'];
    rating = json['rating'];
    ratingReview = json['rating_review'];
    acceptedAt = json['accepted_at'];
    rejectedAt = json['rejected_at'];
    startedAt = json['started_at'];
    arrivedAt = json['arrived_at'];
    cancelledAt = json['cancelled_at'];
    completedAt = json['completed_at'];
    listing =
    json['listing'] != null ? Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task_id'] = taskId;
    data['tentative_amount'] = tentativeAmount;
    data['bargained_amount'] = bargainedAmount;
    data['status'] = status;
    data['title'] = title;
    data['description'] = description;
    data['rating'] = rating;
    data['rating_review'] = ratingReview;
    data['accepted_at'] = acceptedAt;
    data['rejected_at'] = rejectedAt;
    data['started_at'] = startedAt;
    data['arrived_at'] = arrivedAt;
    data['cancelled_at'] = cancelledAt;
    data['completed_at'] = completedAt;
    if (listing != null) {
      data['listing'] = listing!.toJson();
    }
    return data;
  }
}

class Listing {
  int? id;
  String? category;
  String? serviceOffering;
  String? title;
  String? description;
  String? profileImage;
  List<String>? listingImages;
  String? minimumOffer;
  String? slug;
  User? user;

  Listing(
      {this.id,
        this.category,
        this.serviceOffering,
        this.title,
        this.description,
        this.profileImage,
        this.listingImages,
        this.minimumOffer,
        this.slug,
        this.user});

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    serviceOffering = json['service_offering'];
    title = json['title'];
    description = json['description'];
    profileImage = json['profile_image'];
    listingImages = json['listing_images'].cast<String>();
    minimumOffer = json['minimum_offer'];
    slug = json['slug'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['service_offering'] = serviceOffering;
    data['title'] = title;
    data['description'] = description;
    data['profile_image'] = profileImage;
    data['listing_images'] = listingImages;
    data['minimum_offer'] = minimumOffer;
    data['slug'] = slug;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? phoneNumber;
  String? email;
  String? type;

  User({this.name, this.phoneNumber, this.email, this.type});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['type'] = type;
    return data;
  }
}
