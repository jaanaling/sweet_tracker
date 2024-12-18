import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CandyBloc()
          ..add(LoadCandy())
       ,
        child: CupertinoApp.router(
          theme: const CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xFF540074),
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Color(0xFF790AA3),
                fontSize: 20,
              ),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: buildGoRouter,
          debugShowCheckedModeBanner: false,
        ));
  }
}
