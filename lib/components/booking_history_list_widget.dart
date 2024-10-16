import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/dashed_rect.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingHistoryListWidget extends StatelessWidget {
  const BookingHistoryListWidget({Key? key, required this.data, required this.index, required this.length}) : super(key: key);

  final BookingActivity data;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.datetime.toString().validate().isNotEmpty
                ? Text(
                    formatDate(data.datetime.toString().validate()),
                    style: secondaryTextStyle(),
                  )
                : SizedBox(),
            4.height,
            data.datetime.toString().validate().isNotEmpty
                ? Text(
                    formatDate(data.datetime.toString().validate(), isTime: true),
                    style: primaryTextStyle(size: 12),
                  )
                : SizedBox(),
          ],
        ).withWidth(55),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: data.activityType.validate().getBookingActivityStatusColor,
                borderRadius: radius(16),
              ),
            ),
            SizedBox(
              height: 70,
              child: DashedRect(
                gap: 3,
                color: data.activityType.validate().getBookingActivityStatusColor,
                strokeWidth: 1.5,
              ),
            ).visible(index != length - 1),
          ],
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextIcon(
              expandedText: true,
              edgeInsets: EdgeInsets.only(right: 4, left: 4, bottom: 4),
              text: data.activityType.validate().replaceAll('_', ' ').capitalizeFirstLetter(),
            ),
            Text(
              data.activityMessage.validate().replaceAll('_', ' '),
              style: secondaryTextStyle(),
            ).paddingOnly(left: 4),
          ],
        ).paddingOnly(bottom: 18).expand()
      ],
    );
  }
}
