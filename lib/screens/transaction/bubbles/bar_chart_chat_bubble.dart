/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of a stacked bar chart with three series, each rendered with
/// different fill colors.
class BarChartChatBubble extends StatelessWidget {
  List<charts.Series<DataPoint, String>> seriesList;
  bool animate = true;

  BarChartChatBubble(this.seriesList, this.animate, {Key? key})
      : super(key: key);

  factory BarChartChatBubble.withActualData(
      List<DataSeries> dataSeriesCollection) {
    return BarChartChatBubble(
      _prepareData(dataSeriesCollection),
      // Disable animations for image tests.
      true,
    );
  }

  factory BarChartChatBubble.withSampleData() {
    return BarChartChatBubble(
      _createSampleData(),
      // Disable animations for image tests.
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: .5,
              spreadRadius: 1.0,
              color: Colors.black.withOpacity(.12))
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
      child: charts.BarChart(seriesList,
          animate: animate,
          // Configure a stroke width to enable borders on the bars.
          defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped,
            strokeWidthPx: 2.0,
          ),
          behaviors: [charts.SeriesLegend()]),
    );
  }

  static List<charts.Series<DataPoint, String>> _prepareData(
      List<DataSeries> dataSeriesCollection) {
    return [
      // Blue bars with a lighter center color.
      charts.Series<DataPoint, String>(
        id: dataSeriesCollection[0].name,
        domainFn: (DataPoint sales, _) => sales.name,
        measureFn: (DataPoint sales, _) => sales.amount,
        data: dataSeriesCollection[0].data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      charts.Series<DataPoint, String>(
        id: dataSeriesCollection[1].name,
        measureFn: (DataPoint sales, _) => sales.amount,
        data: dataSeriesCollection[1].data,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DataPoint sales, _) => sales.name,
      )
    ];
  }

  /// Create series list with multiple series
  static List<charts.Series<DataPoint, String>> _createSampleData() {
    final budgetData = [
      DataPoint('2014', 5),
      DataPoint('2015', 25),
      DataPoint('2016', 100),
      DataPoint('2017', 75),
    ];

    final actualData = [
      DataPoint('2014', 10),
      DataPoint('2015', 50),
      DataPoint('2016', 10),
      DataPoint('2017', 20),
    ];

    return [
      // Blue bars with a lighter center color.
      charts.Series<DataPoint, String>(
        id: 'Budget',
        domainFn: (DataPoint sales, _) => sales.name,
        measureFn: (DataPoint sales, _) => sales.amount,
        data: budgetData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      charts.Series<DataPoint, String>(
        id: 'Actual',
        measureFn: (DataPoint sales, _) => sales.amount,
        data: actualData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DataPoint sales, _) => sales.name,
      )
    ];
  }
}

/// Sample ordinal data type.
class DataPoint {
  String name;
  double amount;

  DataPoint(this.name, this.amount);
}

class DataSeries {
  String name;
  List<DataPoint> data = [];

  DataSeries(this.name, this.data);
}
