import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';

import '../../../../ui_kit/app_button/app_button.dart';
import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';
import '../../../core/utils/size_utils.dart';
import '../model/history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Карточка истории
  Widget _buildHistoryItem(BuildContext context, UsageHistoryRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AppButton(
          radius: 11,
          color: ButtonColors.white,
          widget: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: getWidth(1, context) - 36,
                height: 118,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppButton(
                        radius: 6,
                        color: ButtonColors.white,
                        widget: SizedBox(
                          width: 70,
                          height: 62,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: AppIcon(
                                  width: 70,
                                  height: 62,
                                  fit: BoxFit.cover,
                                  asset: record.image ??
                                      IconProvider.buildImageByName(
                                          record.category.name),
                                ),
                              )),
                        ),
                      ),
                      Gap(6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.sweetName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Text(
                            'count: ${record.usedQuantity}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Text(
                  '${record.date.month}.${record.date.day}.${record.date.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x82790AA3),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Экран истории использования
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyError) {
          return const Center(child: Text('Error'));
        }
        if (state is CandyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CandyLoaded) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 16, bottom: 128),
            child: SafeArea(
              child: state.historyList.isNotEmpty
                  ? ListView.separated(
                      itemCount: state.historyList.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Gap(15),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildHistoryItem(
                            context, state.historyList[index]);
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: getHeight(0.3, context)),
                        child: Text(
                          'History is empty',
                          style: TextStyle(
                            fontSize: 27,
                            fontFamily: 'Boleh',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
