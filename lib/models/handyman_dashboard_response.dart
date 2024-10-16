import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/revenue_chart_data.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class HandymanDashBoardResponse {
  Commission? commission;
  List<RatingData>? handymanReviews;
  bool? status;
  num? todayBooking;
  num? totalBooking;
  num? totalRevenue;
  num? todayCashAmount;
  List<BookingData>? upcomingBookings;
  int? isHandymanAvailable;
  int? completedBooking;
  num? notificationUnreadCount;
  int? isEmailVerified;

  HandymanDashBoardResponse({
    this.isEmailVerified,
    this.commission,
    this.handymanReviews,
    this.status,
    this.todayBooking,
    this.totalBooking,
    this.totalRevenue,
    this.upcomingBookings,
    this.todayCashAmount,
    this.isHandymanAvailable,
    this.completedBooking,
    this.notificationUnreadCount,
  });

  HandymanDashBoardResponse.fromJson(Map<String, dynamic> json) {
    commission = json['commission'] != null ? Commission.fromJson(json['commission']) : null;
    handymanReviews = json['handyman_reviews'] != null ? (json['handyman_reviews'] as List).map((i) => RatingData.fromJson(i)).toList() : null;
    status = json['status'];
    todayBooking = json['today_booking'];
    todayCashAmount = json['today_cash'];
    totalBooking = json['total_booking'];
    totalRevenue = json['total_revenue'];
    upcomingBookings = json['upcomming_booking'] != null ? (json['upcomming_booking'] as List).map((i) => BookingData.fromJson(i)).toList() : null;

    isHandymanAvailable = json['isHandymanAvailable'];
    completedBooking = json['completed_booking'];

    Iterable it = json['monthly_revenue']['revenueData'];

    it.forEachIndexed((element, index) {
      if ((element as Map).containsKey('${index + 1}')) {
        chartData.add(RevenueChartData(month: months[index], revenue: element[(index + 1).toString()].toString().toDouble()));
      } else {
        chartData.add(RevenueChartData(month: months[index], revenue: 0));
      }
    });
    notificationUnreadCount = json['notification_unread_count'];

    isEmailVerified = json['is_email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_email_verified'] = this.isEmailVerified;
    data['today_booking'] = this.todayBooking;
    data['total_booking'] = this.totalBooking;
    data['total_booking'] = this.totalBooking;
    data['completed_booking'] = this.completedBooking;
    if (this.upcomingBookings != null) {
      data['upcomming_booking'] = this.upcomingBookings!.map((v) => v.toJson()).toList();
    }
    if (this.commission != null) {
      data['commission'] = this.commission!.toJson();
    }

    if (this.handymanReviews != null) {
      data['handyman_reviews'] = this.handymanReviews!.map((v) => v.toJson()).toList();
    }

    data['isHandymanAvailable'] = this.isHandymanAvailable;
    data['notification_unread_count'] = this.notificationUnreadCount;

    data['today_cash'] = this.todayCashAmount;

    return data;
  }
}

class Commission {
  int? commission;
  String? createdAt;
  String? deletedAt;
  int? id;
  String? name;
  int? status;
  String? type;
  String? updatedAt;

  Commission({this.commission, this.createdAt, this.deletedAt, this.id, this.name, this.status, this.type, this.updatedAt});

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      commission: json['commission'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
