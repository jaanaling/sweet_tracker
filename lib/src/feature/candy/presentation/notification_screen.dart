import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sweet_planner/routes/go_router_config.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_notification.dart';
import 'package:sweet_planner/ui_kit/app_button/app_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  // Каждый элемент - это карточка уведомления
  Widget _buildNotificationItem(
      BuildContext context, SweetNotification notification) {
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
                          )),
                      Gap(3),
                      Text(
                        notification.sweetName,
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
              SizedBox(
                width: getWidth(1, context) - 142,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    notification.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 6,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context
                          .read<CandyBloc>()
                          .add(DeleteNotification(notification));
                    },
                    iconSize: 25,
                    icon: Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: Color(0xFF9B043B),
                    )),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple Scaffold with Back button and title "Notifications"
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyError) {
          return const Center(child: Text('Error'));
        }
        if (state is CandyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CandyLoaded) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 16, bottom: 128),
              child: Column(
                children: [
                  Row(
                    children: [
                      Gap(4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.pop();
                        },
                        icon: Ink.image(
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          image: AssetImage(
                            IconProvider.back.buildImageUrl(),
                          ),
                        ),
                      ),
                      Gap(4),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: Color(0xFF540073),
                          fontSize: 29,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Gap(16),
                  ListView.separated(
                    itemCount: state.notifications.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Gap(15),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(
                          context, state.notifications[index]);
                    },
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
