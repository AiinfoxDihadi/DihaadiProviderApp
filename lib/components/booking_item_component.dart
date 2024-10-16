import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/disabled_rating_bar_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/assign_handyman_screen.dart';
import 'package:handyman_provider_flutter/screens/booking_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/user_data.dart';

class BookingItemComponent extends StatefulWidget {
  final String? status;
  final BookingData bookingData;
  final int? index;
  final bool showDescription;

  BookingItemComponent(
      {this.status,
      required this.bookingData,
      this.index,
      this.showDescription = true});

  @override
  BookingItemComponentState createState() => BookingItemComponentState();
}

class BookingItemComponentState extends State<BookingItemComponent> {
  int page = 1;
  bool isLastPage = false;

  List<UserData> handymanList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  String buildTimeWidget({required BookingData bookingDetail}) {
    if (bookingDetail.bookingSlot == null) {
      return formatDate(bookingDetail.date.validate(), isTime: true);
    }
    return formatDate(
        getSlotWithDate(
            date: bookingDetail.date.validate(),
            slotTime: bookingDetail.bookingSlot.validate()),
        isTime: true);
  }

  Future<void> updateBooking(
      BookingData booking, String updatedStatus, int index) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: booking.id,
      BookingUpdateKeys.status: updatedStatus,
      BookingUpdateKeys.paymentStatus: booking.isAdvancePaymentDone
          ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID
          : booking.paymentStatus.validate(),
    };
    await bookingUpdate(request).then((res) async {
      setState(() {});
      // appStore.setLoading(false);
    }).catchError((e) {
      // appStore.setLoading(false);
    });
  }

  Future<void> confirmationRequestDialog(
      BuildContext context, int index, String status) async {
    showConfirmDialogCustom(
      context,
      title: languages.confirmationRequestTxt,
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      primaryColor: status == BookingStatusKeys.rejected
          ? Colors.redAccent
          : primaryColor,
      onAccept: (context) async {
        updateBooking(widget.bookingData, status, index);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.scaffoldBackgroundColor,
        border: Border.all(color: context.dividerColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            5.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          CachedImageWidget(
                        url: widget.bookingData.imageAttachments.validate().isNotEmpty
                            ? widget.bookingData.imageAttachments!.first.validate()
                            : '',
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        radius: defaultRadius,
                      ),
                20.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.bookingData.status
                              .validate()
                              .getPaymentStatusBackgroundColor,
                          borderRadius: radius(6),
                        ),
                        child: Text(
                          widget.bookingData.status.validate().toBookingStatus(),
                          style: boldTextStyle(color: white, size: 10),
                        )),
                    3.height,
                    Text(
                      widget.bookingData.isPackageBooking
                          ? '${widget.bookingData.bookingPackage!.name.validate()}'
                          : '${widget.bookingData.serviceName.validate()}',
                      style: boldTextStyle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    5.height,
                    DisabledRatingBarWidget(rating: 4,activeColor: Colors.amber,)
                  ],
                )
              ],
            ),
            10.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('${languages.address} : ',
                          style: secondaryTextStyle()),
                      Text(
                        widget.bookingData.address != null
                            ? widget.bookingData.address.validate()
                            : languages.notAvailable,
                        style: boldTextStyle(size: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ).flexible(),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('${'Date & Time'} : ',style: secondaryTextStyle()),
                      Text(
                        "${formatDate(widget.bookingData.date.validate(), format: DATE_FORMAT_2)} At ${buildTimeWidget(bookingDetail: widget.bookingData)}",
                        style: boldTextStyle(size: 12),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('${languages.phone} : ',style: secondaryTextStyle()),
                      Text(
                        (widget.bookingData.handyman?.isNotEmpty ?? false) ? (widget.bookingData.handyman?[0].handyman?.contactNumber) ?? '' : "Not Provided" ,
                        style: boldTextStyle(size: 12),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('${languages.serviceType} : ',style: secondaryTextStyle()),
                      Text(
                        "Part Time",
                        style: boldTextStyle(size: 12),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //           if (widget.bookingData.isPackageBooking &&
            //               widget.bookingData.bookingPackage != null)
            //             CachedImageWidget(
            //               url: widget.bookingData.bookingPackage!.imageAttachments
            //                       .validate()
            //                       .isNotEmpty
            //                   ? widget.bookingData.bookingPackage!.imageAttachments
            //                       .validate()
            //                       .first
            //                       .validate()
            //                   : "",
            //               height: 150,
            //               fit: BoxFit.cover,
            //               radius: defaultRadius,
            //             )
            //           else
            //             CachedImageWidget(
            //               url: widget.bookingData.imageAttachments.validate().isNotEmpty
            //                   ? widget.bookingData.imageAttachments!.first.validate()
            //                   : '',
            //               fit: BoxFit.cover,
            //               height: 80,
            //               width: 80,
            //               radius: defaultRadius,
            //             ),
            //           16.width,
            //
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           10.height,
            //           Text(
            //             widget.bookingData.isPackageBooking
            //                 ? '${widget.bookingData.bookingPackage!.name.validate()}'
            //                 : '${widget.bookingData.serviceName.validate()}',
            //             style: boldTextStyle(),
            //             overflow: TextOverflow.ellipsis,
            //             maxLines: 1,
            //           ).paddingOnly(left: 10,right: 10),
            //           4.height,
            // Text(
            //             widget.bookingData.address != null
            //                 ? widget.bookingData.address.validate()
            //                 : languages.notAvailable,
            //             style: boldTextStyle(size: 12),
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis,
            //             textAlign: TextAlign.start,
            //           ).flexible(),
            //         ],
            //       ),
            // if (widget.showDescription)
            //   Column(
            //     children: [
            //       Row(
            //         children: [
            //           Image.asset(ic_location,scale: 4),
            //           8.width,
            //           Text(
            //             widget.bookingData.address != null
            //                 ? widget.bookingData.address.validate()
            //                 : languages.notAvailable,
            //             style: boldTextStyle(size: 12),
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis,
            //             textAlign: TextAlign.start,
            //           ).flexible(),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Image.asset(ic_calender,scale: 4),
            //           8.width,
            //           Text(
            //             "${formatDate(widget.bookingData.date.validate(), format: DATE_FORMAT_2)} At ${buildTimeWidget(bookingDetail: widget.bookingData)}",
            //             style: boldTextStyle(size: 12),
            //             maxLines: 2,
            //             textAlign: TextAlign.right,
            //           ),
            //         ],
            //       ).paddingOnly(top: 10),
            //       if (widget.bookingData.customerName.validate().isNotEmpty)
            //         Column(
            //           children: [
            //             Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Image.asset(ic_person,scale: 4),
            //                 8.width,
            //                 Text(widget.bookingData.customerName.validate(),
            //                         style: boldTextStyle(size: 12),
            //                         textAlign: TextAlign.right)
            //                     .flexible(),
            //               ],
            //             ).paddingOnly(top: 10),
            //           ],
            //         ),
            //
            //       // if (widget.bookingData.paymentStatus != null &&
            //       //     widget.bookingData.status == BookingStatusKeys.complete)
            //       //   Column(
            //       //     children: [
            //       //       Divider(height: 0, color: context.dividerColor),
            //       //       Row(
            //       //         crossAxisAlignment: CrossAxisAlignment.start,
            //       //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       //         children: [
            //       //           Text(languages.paymentStatus,
            //       //                   style: secondaryTextStyle())
            //       //               .expand(),
            //       //           Text(
            //       //             buildPaymentStatusWithMethod(
            //       //                 widget.bookingData.paymentStatus.validate(),
            //       //                 widget.bookingData.paymentMethod
            //       //                     .validate()
            //       //                     .capitalizeFirstLetter()),
            //       //             style: boldTextStyle(
            //       //               size: 12,
            //       //               color: (widget.bookingData.paymentStatus
            //       //                               .validate() ==
            //       //                           PAID ||
            //       //                       widget.bookingData.paymentStatus
            //       //                               .validate() ==
            //       //                           PENDING_BY_ADMINS)
            //       //                   ? Colors.green
            //       //                   : Colors.red,
            //       //             ),
            //       //           ),
            //       //         ],
            //       //       ).paddingAll(8),
            //       //     ],
            //       //   ),
            //       widget.bookingData.status ==
            //           BookingStatusKeys.pending ?  10.height : SizedBox.shrink(),
            //       widget.bookingData.status ==
            //           BookingStatusKeys.pending ?  Divider() : SizedBox.shrink(),
            //       if (isUserTypeProvider &&
            //               widget.bookingData.status ==
            //                   BookingStatusKeys.pending ||
            //           (isUserTypeHandyman &&
            //               widget.bookingData.status ==
            //                   BookingStatusKeys.accept))
            //         Row(
            //           children: [
            //             if (isUserTypeProvider)
            //               AppButton(
            //                 child: Text(languages.accept,
            //                     style: boldTextStyle(color: white)),
            //                 width: context.width(),
            //                 color: primaryColor,
            //                 elevation: 0,
            //                 onTap: () async {
            //                   /// If Auto Assign is enabled, Assign to current Provider it self
            //                   if (appConfigurationStore.autoAssignStatus) {
            //                     showConfirmDialogCustom(
            //                       context,
            //                       title: languages
            //                           .lblAreYouSureYouWantToAssignToYourself,
            //                       primaryColor: context.primaryColor,
            //                       positiveText: languages.lblYes,
            //                       negativeText: languages.lblCancel,
            //                       onAccept: (c) async {
            //                         var request = {
            //                           CommonKeys.id:
            //                               widget.bookingData.id.validate(),
            //                           CommonKeys.handymanId: [
            //                             appStore.userId.validate()
            //                           ],
            //                         };
            //
            //                         appStore.setLoading(true);
            //
            //                         await assignBooking(request)
            //                             .then((res) async {
            //                           appStore.setLoading(false);
            //
            //                           setState(() {});
            //                           LiveStream()
            //                               .emit(LIVESTREAM_UPDATE_BOOKINGS);
            //
            //                           finish(context);
            //
            //                           toast(res.message);
            //                         }).catchError((e) {
            //                           appStore.setLoading(false);
            //
            //                           toast(e.toString());
            //                         });
            //                       },
            //                     );
            //                   } else {
            //                     await showConfirmDialogCustom(
            //                       context,
            //                       title:
            //                           languages.wouldYouLikeToAssignThisBooking,
            //                       primaryColor: primaryColor,
            //                       positiveText: languages.lblYes,
            //                       negativeText: languages.lblNo,
            //                       onAccept: (_) async {
            //                         var request = {
            //                           CommonKeys.id:
            //                               widget.bookingData.id.validate(),
            //                           BookingUpdateKeys.status:
            //                               BookingStatusKeys.accept,
            //                           BookingUpdateKeys.paymentStatus: widget
            //                                   .bookingData.isAdvancePaymentDone
            //                               ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID
            //                               : widget.bookingData.paymentStatus
            //                                   .validate(),
            //                         };
            //                         appStore.setLoading(true);
            //
            //                         bookingUpdate(request).then((res) async {
            //                           setState(() {});
            //                           LiveStream()
            //                               .emit(LIVESTREAM_UPDATE_BOOKINGS);
            //                         }).catchError((e) {
            //                           appStore.setLoading(false);
            //                           toast(e.toString());
            //                         });
            //
            //                         /*var request = {
            //                         CommonKeys.id: widget.bookingData.id.validate(),
            //                         BookingUpdateKeys.status: BookingStatusKeys.accept,
            //                         BookingUpdateKeys.paymentStatus: widget.bookingData.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : widget.bookingData.paymentStatus.validate(),
            //                       };
            //                       appStore.setLoading(true);
            //
            //                       bookingUpdate(request).then((res) async {
            //                         /// If Auto Assign Provider it self when Handyman List is Empty
            //                         if (appConfigurationStore.autoAssignStatus) {
            //                           if (appStore.totalHandyman >= 1) {
            //                             if (appStore.isLoading) return;
            //
            //                             showConfirmDialogCustom(
            //                               context,
            //                               title: languages.lblAreYouSureYouWantToAssignToYourself,
            //                               primaryColor: context.primaryColor,
            //                               positiveText: languages.lblYes,
            //                               negativeText: languages.lblCancel,
            //                               onAccept: (c) async {
            //                                 var request = {
            //                                   CommonKeys.id: widget.bookingData.id.validate(),
            //                                   CommonKeys.handymanId: [appStore.userId.validate()],
            //                                 };
            //
            //                                 appStore.setLoading(true);
            //
            //                                 await assignBooking(request).then((res) async {
            //                                   appStore.setLoading(false);
            //
            //                                   setState(() {});
            //                                   LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
            //
            //                                   finish(context);
            //
            //                                   toast(res.message);
            //                                 }).catchError((e) {
            //                                   appStore.setLoading(false);
            //
            //                                   toast(e.toString());
            //                                 });
            //                               },
            //                             );
            //                           } else {
            //                             appStore.setLoading(false);
            //                             finish(context, true);
            //                           }
            //                         } else {
            //                           appStore.setLoading(false);
            //                           finish(context, true);
            //                         }
            //                       }).catchError((e) {
            //                         if (mounted) {
            //                           finish(context);
            //                         }
            //                         appStore.setLoading(false);
            //                         toast(e.toString());
            //                       });*/
            //                       },
            //                     );
            //                   }
            //                 },
            //               ).expand(),
            //             12.width,
            //             AppButton(
            //               child:
            //                   Text(languages.decline, style: boldTextStyle()),
            //               width: context.width(),
            //               elevation: 0,
            //               color: appStore.isDarkMode
            //                   ? context.scaffoldBackgroundColor
            //                   : white,
            //               onTap: () {
            //                 if (isUserTypeProvider) {
            //                   confirmationRequestDialog(context, widget.index!,
            //                       BookingStatusKeys.rejected);
            //                 } else {
            //                   confirmationRequestDialog(context, widget.index!,
            //                       BookingStatusKeys.pending);
            //                 }
            //               },
            //             ).expand(),
            //           ],
            //         ).paddingOnly(bottom: 8, left: 8, right: 8, top: 16),
            //       if (isUserTypeProvider &&
            //           widget.bookingData.handyman!.isEmpty &&
            //           widget.bookingData.status == BookingStatusKeys.accept)
            //         Column(
            //           children: [
            //             8.height,
            //             AppButton(
            //               width: context.width(),
            //               child: Text(languages.lblAssign,
            //                   style: boldTextStyle(color: white)),
            //               color: primaryColor,
            //               elevation: 0,
            //               onTap: () {
            //                 AssignHandymanScreen(
            //                   bookingId: widget.bookingData.id,
            //                   serviceAddressId:
            //                       widget.bookingData.bookingAddressId,
            //                   onUpdate: () {
            //                     setState(() {});
            //                     LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
            //                   },
            //                 ).launch(context);
            //               },
            //             ),
            //           ],
            //         ).paddingAll(8),
            //     ],
            //   ).paddingAll(8),
          ],
        ),
      ), //booking card change
    ).onTap(
      () async {
        BookingDetailScreen(bookingId: widget.bookingData.id.validate())
            .launch(context);
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}

// Positioned(
// top: 10,
// left: 10,
// child: Container(
// padding:
// EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// decoration: BoxDecoration(
// color: widget.bookingData.status
//     .validate()
//     .getPaymentStatusBackgroundColor,
// borderRadius: radius(15),
// ),
// child: Text(
// widget.bookingData.status
//     .validate()
//     .toBookingStatus(),
// style: boldTextStyle(
// color: white,
// size: 12),
// ),
// ),
// )