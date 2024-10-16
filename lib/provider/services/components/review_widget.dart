import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;
  final bool showServiceName;

  ReviewWidget({required this.data, this.isCustomer = false, this.showServiceName = false});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('d MMM').format(DateTime.parse(data.createdAt ?? ''));
    return GestureDetector(
      onTap: () {
        if (showServiceName) {
          ServiceDetailScreen(serviceId: data.serviceId.validate().toInt()).launch(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBorder(src: data.profileImage.validate().isNotEmpty ? data.profileImage.validate() : (isCustomer ? data.customerProfileImage.validate() : data.handymanProfileImage.validate()), height: 50),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${data.customerName.validate()}', style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                        data.createdAt.validate().isNotEmpty ? Text(formattedDate, style: secondaryTextStyle()) : SizedBox(),
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(4, (int i) {
                          return Image.asset(ic_star_fill, height: 12, color: Color(0xFFFFBD00));
                        }),
                        4.width,
                        Text('${data.rating.validate().toStringAsFixed(1).toString()}', style: boldTextStyle(color: Color(0xFFFFBD00), size: 14)),
                      ],
                    ),
                    if (data.review != null)
                      ReadMoreText(
                        data.review.validate(),
                        style: secondaryTextStyle(),
                        trimLength: 100,
                        colorClickableText: context.primaryColor,
                      ).paddingTop(8),
                  ],
                ).flexible(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
