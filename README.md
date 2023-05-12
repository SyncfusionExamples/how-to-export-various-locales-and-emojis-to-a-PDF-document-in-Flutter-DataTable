# How to export various locales and emojis to a PDF document in Flutter DataTable (SfDataGrid)

In this article, you will learn how to properly display complex script languages such as Arabic, Hindi, Hebrew, Tamil, and more. This can be achieved by utilizing true type fonts that support the required characters, without relying on open type features like Arial Unicode MS.

## STEP 1:
Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. Create a global key and assign it to the [SfDataGrid.key](https://api.flutter.dev/flutter/widgets/Widget/key.html) property. The key is used to retrieve the current state object of the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget.

```dart
final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

Expanded(
        child: SfDataGrid(
        source: _employeeDataSource,
        key: _key,
        columnWidthMode: ColumnWidthMode.fill,
        columns: getColumns),
        )

```
## STEP 2:
 We can use  [PdfTrueTypeFont](https://pub.dev/documentation/syncfusion_flutter_pdf/latest/pdf/PdfTrueTypeFont-class.html) API to provide the necessary font file. To do this, use the exportToPdfGrid method instead of exportToPdfDocument when exporting the DataGrid. In the exportToPdfGrid method, set the [PdfTrueTypeFont](https://pub.dev/documentation/syncfusion_flutter_pdf/latest/pdf/PdfTrueTypeFont-class.html) to the [PdfGridStyle](https://pub.dev/documentation/syncfusion_flutter_pdf/latest/pdf/PdfGridStyle-class.html).

```dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'helper/save_file_mobile.dart';

@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SfDatagrid Demo'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {
                        PdfDocument document = PdfDocument();
                        PdfPage pdfPage = document.pages.add();
                        PdfGrid pdfGrid = _key.currentState!.exportToPdfGrid();
                        // Use 'seguiemj.ttf' instead 'ARIALUNI.ttf' to export both font and emoji characters.
                        PdfGridStyle gridStyle = PdfGridStyle(
                          font: PdfTrueTypeFont(
                              File('ARIALUNI.ttf').readAsBytesSync(), 14),
                        );

                        pdfGrid.rows.applyStyle(gridStyle);
                        pdfGrid.draw(
                          page: pdfPage,
                          bounds: const Rect.fromLTWH(0, 0, 0, 0),
                        );
                        final List<int> bytes = document.saveSync();

                        saveAndLaunchFile(bytes, 'datagrid-pdf.pdf');
                      },
                      child: const Text('Export DataGrid to PDF')),
                ),
              ],
            ),
            Expanded(
              child: SfDataGrid(
                  source: _employeeDataSource,
                  key: _key,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: getColumns),
            )
          ]);
        }));
  }

```