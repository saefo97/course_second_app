import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants.dart';
import '../../models/transaction.dart';

class StatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإحصائيات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kTextDark,
        centerTitle: true,
      ),
      backgroundColor: kBackground,
      body: ValueListenableBuilder<List<Transaction>>(
        valueListenable: transactionsNotifier,
        builder: (context, transactions, child) {
          
          double totalIncome = 0;
          double totalExpense = 0;
          
          for (var tx in transactions) {
            if (tx.isIncome) {
              totalIncome += tx.amount;
            } else {
              totalExpense += tx.amount;
            }
          }

          // إذا لم يكن هناك أي بيانات، نعرض رسالة فارغة
          if (totalIncome == 0 && totalExpense == 0) {
            return Center(
              child: Text(
                'لا توجد بيانات لعرض الرسوم البيانية',
                style: TextStyle(color: kTextLight, fontSize: 16),
              ),
            );
          }

          // حساب النسبة المئوية للمصروف من الدخل لشريط التقدم
          double expensePercentage = 0;
          if (totalIncome > 0) {
            expensePercentage = totalExpense / totalIncome;
            if (expensePercentage > 1.0) expensePercentage = 1.0; // لكي لا يتجاوز شريط التقدم 100%
          } else if (totalExpense > 0) {
            expensePercentage = 1.0; // إذا لم يكن هناك دخل ولكن يوجد مصروف
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('إجمالي الدخل', totalIncome, kIncome, Icons.arrow_downward),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard('إجمالي المصروف', totalExpense, kExpense, Icons.arrow_upward),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text('تحليل المصاريف والدخل', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark)),
                SizedBox(height: 20),
                
                // ----------------------------------------------------
                // طريقة 1: الرسم البياني الدائري (Pie Chart)
                // ----------------------------------------------------
                Text('طريقة 1: الدائرة البيانية (Pie Chart)', style: TextStyle(color: kTextLight, fontSize: 14)),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 5,
                          centerSpaceRadius: 60,
                          sections: [
                            if (totalIncome > 0)
                              PieChartSectionData(
                                value: totalIncome,
                                color: kIncome,
                                title: 'دخل',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            if (totalExpense > 0)
                              PieChartSectionData(
                                value: totalExpense,
                                color: kExpense,
                                title: 'مصروف',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                      // الأيقونة في منتصف الرسم البياني
                      Icon(
                        totalExpense > totalIncome ? Icons.warning_amber_rounded : Icons.savings_outlined,
                        size: 40,
                        color: totalExpense > totalIncome ? Colors.orange : kPrimary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // ----------------------------------------------------
                // طريقة 2: الأعمدة البيانية (Bar Chart)
                // ----------------------------------------------------
                Text('طريقة 2: الأعمدة البيانية (Bar Chart)', style: TextStyle(color: kTextLight, fontSize: 14)),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (totalIncome > totalExpense ? totalIncome : totalExpense) + 500, // إضافة هامش علوي
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('الدخل', style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold)));
                              if (value == 1) return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('المصروف', style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold)));
                              return Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [BarChartRodData(toY: totalIncome, color: kIncome, width: 30, borderRadius: BorderRadius.circular(8))],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [BarChartRodData(toY: totalExpense, color: kExpense, width: 30, borderRadius: BorderRadius.circular(8))],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // ----------------------------------------------------
                // طريقة 3: شريط التقدم (Linear Progress Indicator)
                // ----------------------------------------------------
                Text('طريقة 3: شريط التقدم (Linear Progress Indicator)', style: TextStyle(color: kTextLight, fontSize: 14)),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('معدل الإنفاق من الدخل', style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
                          Text('${(expensePercentage * 100).toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, color: expensePercentage >= 1 ? Colors.red : kPrimary)),
                        ],
                      ),
                      SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: expensePercentage,
                          minHeight: 15,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            expensePercentage >= 1 ? Colors.red : kPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                
                // نص تحليلي إضافي
                Center(
                  child: Text(
                    totalExpense > totalIncome 
                        ? 'انتبه! مصاريفك تتجاوز دخلك ⚠️' 
                        : 'أنت تدير أموالك بشكل ممتاز 🌟',
                    style: TextStyle(fontSize: 16, color: kTextDark, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildStatCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 15),
          Text(title, style: TextStyle(color: kTextLight, fontSize: 14)),
          SizedBox(height: 5),
          Text('${amount.toStringAsFixed(1)}', style: TextStyle(color: kTextDark, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
