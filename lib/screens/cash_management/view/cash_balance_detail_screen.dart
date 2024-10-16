import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/screens/cash_management/cash_repository.dart';
import 'package:handyman_provider_flutter/screens/cash_management/component/cash_info_widget.dart';
import 'package:handyman_provider_flutter/screens/cash_management/component/cash_list_widget.dart';
import 'package:handyman_provider_flutter/screens/cash_management/component/status_widget.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/cash_filter_model.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/payment_history_model.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CashBalanceDetailScreen extends StatefulWidget {
  const CashBalanceDetailScreen({Key? key}) : super(key: key);

  @override
  State<CashBalanceDetailScreen> createState() => _CashBalanceDetailScreenState();
}

class _CashBalanceDetailScreenState extends State<CashBalanceDetailScreen> {
  Future<(num, num, List<PaymentHistoryData>)>? future;

  List<CashFilterModel> cashFilterList = getCashFilterList();
  List<CashFilterModel> cashStatusFilterList = currentStatusList;
  List<PaymentHistoryData> paymentHistoryList = [];

  int page = 1;
  bool isLastPage = false;

  int currentFilterIndex = 0;
  int currentFilterStatusIndex = 0;
  DateTimeRange? filterDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool disableLoader = false}) async {
    future = getCashDetails(
      list: paymentHistoryList,
      page: page,
      disableLoader: disableLoader,
      toDate: formatBookingDate(filterDate!.end.toString(), format: DATE_FORMAT_7),
      statusType: cashStatusFilterList[currentFilterStatusIndex].type,
      fromDate: formatBookingDate(filterDate!.end.toString(), format: DATE_FORMAT_7),
      lastPageCallback: (p0) => isLastPage = p0,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildTodayCashWidget({required num todayCash, required num totalCash}) {
    return Container(
      height: 120,
      color: context.primaryColor,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(languages.totalCash, style: primaryTextStyle(color: Colors.white)),
              2.height,
              PriceWidget(price: totalCash, size: 18, color: Colors.white),
              16.height,
            ],
          ),
          Positioned(
            bottom: -50,
            child: Container(
              padding: EdgeInsets.all(16),
              width: context.width() * 0.86,
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
              child: Column(
                children: [
                  Text("${getDateInString(dateTime: filterDate!, format: DATE_FORMAT_2)} ${languages.cash}", style: secondaryTextStyle()),
                  4.height,
                  PriceWidget(price: todayCash, size: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFilterWidget() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(languages.cashList, style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingSymmetric(horizontal: 16).expand(),
              InkWell(
                onTap: () async {
                  if (currentFilterIndex == 2) {
                    filterDate = await _handleDateRange(context);
                    if (filterDate != null) {
                      updateList();
                    } else {
                      filterDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                      currentFilterIndex = 0;
                      setState(() {});
                      updateList();
                    }
                    //finish(context);
                  }
                },
                child: Text('${cashFilterList[currentFilterIndex].name.validate()}', style: secondaryTextStyle()),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        width: context.width(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            16.height,
                            Text(languages.sortBy, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
                            16.height,
                            ...List.generate(
                              cashFilterList.length,
                              (index) {
                                return RadioListTile<int>(
                                  value: index,
                                  title: Text(cashFilterList[index].name.validate(), style: primaryTextStyle()),
                                  groupValue: currentFilterIndex,
                                  onChanged: (index) async {
                                    currentFilterIndex = index.validate();
                                    if (currentFilterIndex == 2) {
                                      filterDate = await _handleDateRange(context);
                                      if (filterDate != null) {
                                        updateList();
                                      } else {
                                        filterDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                                        currentFilterIndex = 0;
                                        setState(() {});
                                        updateList();
                                      }
                                      finish(context);
                                    } else if (currentFilterIndex == 1) {
                                      finish(context);

                                      filterDate = DateTimeRange(start: DateTime.now().subtract(1.days), end: DateTime.now().subtract(1.days));
                                      updateList();
                                    } else if (currentFilterIndex == 0) {
                                      finish(context);
                                      filterDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                                      updateList();
                                    }
                                  },
                                );
                              },
                            ),
                            16.height,
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.sort),
              ),
              8.width,
            ],
          ),
          8.height,
          HorizontalList(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: cashStatusFilterList.length,
            itemBuilder: (context, index) {
              CashFilterModel data = cashStatusFilterList[index];
              bool isSelected = currentFilterStatusIndex == index;
              return GestureDetector(
                onTap: () {
                  currentFilterStatusIndex = index;
                  updateList();
                },
                child: StatusWidget(data: data, isSelected: isSelected),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<DateTimeRange?> _handleDateRange(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      initialDateRange: filterDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: appStore.isDarkMode
              ? ThemeData.dark(useMaterial3: true)
              : ThemeData(
                  primaryColor: primaryColor,
                  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor, onSurface: Colors.black),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: context.width(),
                  maxHeight: context.height(),
                ),
                child: child.cornerRadiusWithClipRRect(defaultRadius),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildCashListWidget({required List<PaymentHistoryData> list}) {
    if (list.isEmpty)
      return NoDataWidget(
        title: languages.noPaymentsFounds,
        imageWidget: ErrorStateWidget(),
        retryText: languages.reload,
        onRetry: () {
          page = 1;
          updateList();
        },
      ).paddingTop(100);
    return AnimatedListView(
      itemCount: list.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => CashListWidget(
        data: list[index],
        onRefresh: () async {
          updateList();
        },
      ),
    );
  }

  void updateList() {
    init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.cashBalance,
      actions: [
        IconButton(
          onPressed: () {
            showInDialog(
              context,
              contentPadding: EdgeInsets.all(0),
              builder: (p0) {
                return CashInfoWidget();
              },
            );
          },
          icon: Icon(Icons.info_outline, color: Colors.white),
        ).paddingRight(16),
      ],
      body: SnapHelperWidget<(num, num, List<PaymentHistoryData>)>(
        future: future,
        loadingWidget: LoaderWidget(),
        errorBuilder: (p0) {
          return NoDataWidget(
            title: p0,
            imageWidget: ErrorStateWidget(),
            retryText: languages.reload,
            onRetry: () {
              page = 1;
              updateList();
            },
          );
        },
        onSuccess: (snap) {
          return AnimatedScrollView(
            onSwipeRefresh: () async {
              updateList();
              return await 2.seconds.delay;
            },
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 60),
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              buildTodayCashWidget(todayCash: snap.$2, totalCash: snap.$1),
              buildFilterWidget(),
              16.height,
              // Text('${snap.$3.validate().where((element) => element.status == APPROVED_BY_HANDYMAN || element.status == SEND_TO_PROVIDER).sumByDouble((p0) => p0.totalAmount.validate())}', style: boldTextStyle()).paddingAll(16),
              buildCashListWidget(list: snap.$3.validate()),
            ],
          );
        },
      ),
    );
  }
}
