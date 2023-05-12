// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';

// External package imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'helper/save_file_mobile.dart';

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

  @override
  void initState() {
    super.initState();
    employees = populateData();
    _employeeDataSource = EmployeeDataSource(employees);
  }

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

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
          columnName: 'पहचान',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text(
                'पहचान',
              ))),
      GridColumn(
          columnName: 'नाम',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('नाम'))),
      GridColumn(
          columnName: 'पद',
          width: 110,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text(
                'पद',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'वेतन',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('वेतन'))),
    ];
  }

  List<Employee> populateData() {
    return [
      Employee(10001, 'जेम्स', 'प्रमुख', 20000),
      Employee(10002, 'कॅथ्रीन', 'प्रबंधक', 30000),
      Employee(10003, 'लारा', 'डेवलपर', 15000),
      Employee(10004, 'माइकल', 'डिजाइनर', 15000),
      Employee(10005, 'मार्टिन', 'डेवलपर', 15000),
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
        DataGridCell<int>(columnName: 'पहचान', value: employee.id),
        DataGridCell<String>(columnName: 'नाम', value: employee.name),
        DataGridCell<String>(columnName: 'पद', value: employee.designation),
        DataGridCell<int>(columnName: 'वेतन', value: employee.salary),
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
