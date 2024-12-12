import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';

import '../../../../ui_kit/app_button/app_button.dart';
import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';
import '../../../core/utils/size_utils.dart';
import '../bloc/candy_bloc.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  Widget _buildNotificationItem(BuildContext context, Candy candy, int count) {
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
                height: 82,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppButton(
                        radius: 6,
                        color: ButtonColors.white,
                        widget: SizedBox(
                          width: 51,
                          height: 43,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: AppIcon(
                                  width: 51,
                                  height: 43,
                                  fit: BoxFit.cover,
                                  asset: candy.imageUrl ??
                                      IconProvider.buildImageByName(
                                       candy.type.name,
                                      ),
                                ),
                              )),
                        ),
                      ),
                      Gap(3),
                      Text(
                        candy.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 61,
                child: SizedBox(
                  width: getWidth(1, context) - 142,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "count: $count",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyError) {
          return const Center(child: Text('Error'));
        }
        if (state is CandyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CandyLoaded) {
          final List<Candy> candyList = [];

          for (final element in state.pendingPeriodicUsage.keys) {
            candyList
                .add(state.candies.firstWhere((candy) => candy.id == element));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 16, bottom: 128),
              child: Column(
                children: [
                  Gap(16),
                  state.pendingPeriodicUsage.isNotEmpty
                      ? ListView.separated(
                          itemCount:candyList.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Gap(15),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildNotificationItem(
                                context,
                                candyList[index],
                                state.pendingPeriodicUsage[
                                    candyList[index].id]!);
                          },
                        )
                      : Center(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: getHeight(0.3, context)),
                            child: Text(
                              'No pending usage here!',
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
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
