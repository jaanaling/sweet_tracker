import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sweet_planner/routes/go_router_config.dart';
import 'package:sweet_planner/routes/route_value.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/shopping_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../ui_kit/app_button/app_button.dart';
import '../../../core/utils/size_utils.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final GlobalKey shareButtonKey = GlobalKey();

  Future<Uint8List> generatePdf(List<ShoppingItem> shoppingItems) async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Shopping List',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Candy Name',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Category',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Quantity',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Expiration Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...shoppingItems.map((item) {
                    return pw.TableRow(
                      children: [
                        pw.Text(item.candy.name),
                        pw.Text(item.candy.category.name),
                        pw.Text(item.candy.quantity.toString()),
                        pw.Text(item.candy.expirationDate?.toString() ?? 'N/A'),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Get the directory to save the PDF
    return pdf.save();
  }

  Future<void> share(
      GlobalKey shareButtonKey, List<ShoppingItem> shoppingItems) async {
    StringBuffer shareText = StringBuffer();
    shareText.writeln("🎉 Here's my Shopping List for you! 🛒");
    shareText.writeln("====================================");

    for (var item in shoppingItems) {
      shareText.writeln(
          "${item.candy.name} - ${item.candy.category.name}");
      shareText.writeln("Quantity: ${item.candy.quantity}");
      shareText.writeln(
          "Expiration Date: ${item.candy.expirationDate?.toLocal().toString() ?? 'N/A'}");
      shareText.writeln("------------------------------------");
    }

    shareText.writeln("\nHope you find this helpful! 😊");
    await Share.share(
      shareText.toString(),
      sharePositionOrigin: shareButtonRect(shareButtonKey),
    );
  }

  Rect? shareButtonRect(GlobalKey shareButtonKey) {
    RenderBox? renderBox =
        shareButtonKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  // Карточка элемента в списке покупок
  Widget _buildShoppingItem(BuildContext context, ShoppingItem shoppingItem) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 9, right: 6),
          child: AppButton(
            color: ButtonColors.white,
            radius: 11,
            widget: Padding(
              padding: const EdgeInsets.only( right: 4, bottom: 4),
              child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Colors.white, Color(0xFFCDDAE8)],
                    ),
                  ),
                  child: SizedBox(
                    width: 155,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(50.50),
                                bottomRight: Radius.circular(50.50),
                              ),
                              child: AppIcon(
                                width: 128,
                                height: 72,
                                fit: BoxFit.cover,
                                asset: shoppingItem.candy.imageUrl ??
                                    IconProvider.buildImageByName(
                                      shoppingItem.candy.type.name,
                                    ),
                              ),
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            width: 139,
                            child: Center(
                              child: Text(
                                shoppingItem.candy.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            width: 139,
                            child: Center(
                              child: Text(
                                'location: ${shoppingItem.candy.location.name}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            width: 139,
                            child: Center(
                              child: Text(
                                shoppingItem.candy.category.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            width: 139,
                            child: Center(
                              child: Text(
                                shoppingItem.candy.type.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            width: 139,
                            child: Center(
                              child: Text(
                                'count: ${shoppingItem.candy.quantity}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Gap(7),
                          Row(
                            children: [
                              const Spacer(),
                              AppButton(
                                radius: 10,
                                onPressed: () {
                                  context.read<CandyBloc>().add(
                                      BuyFromShoppingList(shoppingItem));
                                },
                                color: ButtonColors.pink,
                                widget: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'buy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.read<CandyBloc>().add(
                                      RemoveFromShoppingList(shoppingItem));
                                },
                                icon: AppIcon(
                                  asset: IconProvider.delete.buildImageUrl(),
                                  width: 20,
                                  fit: BoxFit.fitWidth,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],
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
          final shoppingItems = state.shoppingList;
          return Stack(
            children: [
             shoppingItems.isNotEmpty? SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 16,
                    bottom: 256 + MediaQuery.of(context).padding.bottom, left: 16, right: 16),
                child: SafeArea(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: shoppingItems.map((candy) {
                      return _buildShoppingItem(context, candy);
                    }).toList(),
                  ),
                ),
              ):Center(
                child: Text('No candies here!',
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
                        ),),
              ),
              Positioned(
                bottom: 128 + MediaQuery.of(context).padding.bottom,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                        onPressed: () async {
                          Uint8List pdfData = await generatePdf(shoppingItems);
                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async => pdfData,
                          );
                        },
                        color: ButtonColors.pink,
                        radius: 10,
                        widget: SizedBox(
                            width: 89,
                            height: 49,
                            child: Center(
                              child: AppIcon(
                                asset: IconProvider.export.buildImageUrl(),
                                width: 29,
                                height: 33,
                              ),
                            ))),
                    Gap(14),
                    Row(
                      children: [
                        AppButton(
                          key: shareButtonKey,
                            onPressed: () {
                              share(shareButtonKey, shoppingItems);
                            },
                            color: ButtonColors.purple,
                            radius: 10,
                            widget: SizedBox(
                                width: 89,
                                height: 49,
                                child: Center(
                                  child: AppIcon(
                                    asset: IconProvider.share.buildImageUrl(),
                                    width: 32,
                                    height: 30,
                                  ),
                                ))),
                        Gap(getWidth(1, context)-210),
                        AppButton(
                            onPressed: () {
                              context.push(
                                  "${RouteValue.shopping.path}/${RouteValue.add.path}");
                            },
                            color: ButtonColors.pink,
                            radius: 10,
                            widget: SizedBox(
                                width: 89,
                                height: 49,
                                child: Center(
                                  child: AppIcon(
                                    asset: IconProvider.add.buildImageUrl(),
                                    width: 29,
                                    height: 29,
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
