import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartBubble extends StatefulWidget {
  String text;
  Map<String, double> data;

  PieChartBubble(this.text, this.data, {Key? key}) : super(key: key);

  @override
  State<PieChartBubble> createState() => _PieChartBubbleState();
}

class _PieChartBubbleState extends State<PieChartBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: PieChart(
        dataMap: widget.data,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        centerText: widget.text,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      )
    );
  }
}
