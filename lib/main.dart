// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Local import
import 'helper/save_file_mobile.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

List<Employee> employees = [];

class MyHomePageState extends State<MyHomePage> {
  late EmployeeDataSource _employeeDataSource;

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  bool isMobilePlatform = false;
  @override
  void initState() {
    super.initState();
    employees = populateData();
    _employeeDataSource = EmployeeDataSource(employees);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    isMobilePlatform = themeData.platform == TargetPlatform.android;
    return Scaffold(
        appBar: AppBar(
          title: const Text('SfDatagrid Demo'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 50,
              width: 250,
              child: ElevatedButton(
                  onPressed: () async {
                    PdfDocument document = PdfDocument();
                    PdfPage pdfPage = document.pages.add();
                    PdfGrid pdfGrid = _key.currentState!.exportToPdfGrid(
                      // Set the text direction as PdfTextDirection.rightToLeft for the cell only for RTL languages.
                      cellExport: (details) {
                        details.pdfCell.stringFormat = PdfStringFormat(
                            textDirection: PdfTextDirection.rightToLeft,
                            alignment: PdfTextAlignment.right);
                      },
                    );
                    PdfTrueTypeFont pdfTrueTypeFont;
                    // Use 'seguiemj.ttf' instead 'ARIALUNI.ttf' to export both font and emoji characters.
                    const String webFileLocation = 'fonts/ARIALUNI.TTF';
                    const String androidFileLocation =
                        'assets/fonts/ARIALUNI.TTF';

                    if (kIsWeb || isMobilePlatform) {
                      ByteData byte = await rootBundle.load(isMobilePlatform
                          ? androidFileLocation
                          : webFileLocation);
                      pdfTrueTypeFont =
                          PdfTrueTypeFont(byte.buffer.asUint8List(), 14);
                    } else {
                      pdfTrueTypeFont = PdfTrueTypeFont(
                          File('assets/fonts/ARIALUNI.TTF').readAsBytesSync(),
                          14);
                    }

                    PdfGridStyle gridStyle = PdfGridStyle(
                      font: pdfTrueTypeFont,
                    );

                    pdfGrid.rows.applyStyle(gridStyle);
                    pdfGrid.draw(
                      page: pdfPage,
                      bounds: const Rect.fromLTWH(0, 0, 0, 0),
                    );
                    final List<int> bytes = document.saveSync();

                    helper.saveAndLaunchFile(bytes, 'datagrid_pdf.pdf');
                  },
                  child: const Text('Export DataGrid to PDF')),
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

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
          columnName: 'العيد',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text(
                'العيد',
              ))),
      GridColumn(
          columnName: 'اسم',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('اسم'))),
      GridColumn(
          columnName: 'تعيين',
          width: 110,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text(
                'تعيين',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'مرتب',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('مرتب'))),
    ];
  }

  List<Employee> populateData() {
    return [
      Employee(10001, 'محمد', 'مهندس برمجيات', 20000),
      Employee(10002, 'أحمد', 'مصمم ويب', 30000),
      Employee(10003, 'علي', 'مهندس برمجيات', 15000),
      Employee(10004, 'أمير', 'مهندس شبكات', 15000),
      Employee(10005, 'فاطمة', 'مهندس برمجيات', 15000),
      Employee(10006, 'سارة', 'مصمم ويب', 15000),
      Employee(10007, 'ياسمين', 'مهندس برمجيات', 15000),
      Employee(10008, 'عبد الله', 'مهندس شبكات', 15000),
      Employee(10009, 'ليلى', 'مصمم ويب', 15000),
      Employee(10010, 'طارق', 'مهندس شبكات', 15000)
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Employee> employees) {
    buildDataGridRow(employees);
  }

  void buildDataGridRow(List<Employee> employeeData) {
    dataGridRow = employeeData.map<DataGridRow>((employee) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'العيد', value: employee.id),
        DataGridCell<String>(columnName: 'اسم', value: employee.name),
        DataGridCell<String>(columnName: 'تعيين', value: employee.designation),
        DataGridCell<int>(columnName: 'مرتب', value: employee.salary),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            dataGridCell.value.toString(),
          ));
    }).toList());
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;
  final String name;
  final String designation;
  final int salary;
}
