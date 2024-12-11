import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sweet_planner/routes/go_router_config.dart';
import 'package:sweet_planner/routes/route_value.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/shopping_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

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
                        pw.Text(item.candy.category.toString().split('.').last),
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
          "${item.candy.name} - ${item.candy.category.toString().split('.').last}");
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
    return Container(
      margin: const EdgeInsets.all(8.0),
      // Пример простого контейнера
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка или изображение (плейсхолдер)
          Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          Text(shoppingItem.candy.name),
          const Text('Subtitle or multiple lines'),
          // Редактировать иконка
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          // Удалить иконка
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Экран с gridView
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
          return Scaffold(
            appBar: AppBar(
              title: const Text('Shopping List'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
            ),
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // два столбца
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: shoppingItems.length,
              itemBuilder: (context, index) {
                return _buildShoppingItem(context, shoppingItems[index]);
              },
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Кнопка экспорта в PDF
                FloatingActionButton(
                  heroTag: 'pdf',
                  onPressed: () async {
                    Uint8List pdfData = await generatePdf(shoppingItems);
                    await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => pdfData,
                    );
                  },
                  child: const Icon(Icons.picture_as_pdf),
                ),
                const SizedBox(height: 16),
                // Кнопка отправки
                FloatingActionButton(
                  key: shareButtonKey,
                  heroTag: 'share',
                  onPressed: () {
                    share(shareButtonKey, shoppingItems);
                  },
                  child: const Icon(Icons.share),
                ),
                const SizedBox(height: 16),
                // Кнопка добавления
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    context.push(
                        "${RouteValue.shopping.path}/${RouteValue.add.path}");
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
