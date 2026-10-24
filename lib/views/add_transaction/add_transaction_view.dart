import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/transaction.dart';
import '../../core/database_helper.dart';

class AddTransactionView extends StatefulWidget {
  final Transaction? transactionToEdit;

  const AddTransactionView({super.key, this.transactionToEdit});

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  bool _isIncome = false; // الافتراضي: مصروف
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // إذا كان هناك عملية ممررة للتعديل، نقوم بتعبئة الحقول ببياناتها
    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _titleController.text = tx.title;
      _amountController.text = tx.amount.toString();
      _isIncome = tx.isIncome;
      _selectedDate = tx.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      // إظهار رسالة خطأ إذا كانت الحقول فارغة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء إدخال اسم العملية والمبلغ')),
      );
      return;
    }

    final isEditing = widget.transactionToEdit != null;

    final newTx = Transaction(
      // إذا كنا في حالة تعديل، نحافظ على نفس الـ ID القديم، وإلا ننشئ ID جديد
      id: isEditing ? widget.transactionToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(), 
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      isIncome: _isIncome,
      date: _selectedDate,
      icon: _isIncome ? Icons.attach_money : Icons.shopping_bag,
    );

    if (isEditing) {
      // 1. تحديث في قاعدة البيانات SQLite
      await DatabaseHelper.instance.updateTransaction(newTx);

      // 2. تحديث الواجهة (State)
      final currentList = List<Transaction>.from(transactionsNotifier.value);
      final index = currentList.indexWhere((tx) => tx.id == newTx.id);
      if (index != -1) {
        currentList[index] = newTx;
        transactionsNotifier.value = currentList;
      }
    } else {
      // 1. الحفظ في قاعدة البيانات SQLite
      await DatabaseHelper.instance.insertTransaction(newTx);

      // 2. تحديث الواجهة (State)
      final currentList = transactionsNotifier.value;
      transactionsNotifier.value = List.from(currentList)..add(newTx);
    }

    // العودة للشاشة السابقة
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(
          widget.transactionToEdit != null ? 'تعديل العملية' : 'إضافة عملية جديدة', 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. أزرار الاختيار (Buttons - التصميم الأجمل)
            Text('طريقة 1: أزرار الاختيار (Buttons)', style: TextStyle(color: kTextLight, fontSize: 12)),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isIncome = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _isIncome ? kIncome : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: _isIncome ? kIncome : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          'دخل', 
                          style: TextStyle(color: _isIncome ? Colors.white : kTextDark, fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isIncome = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: !_isIncome ? kExpense : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: !_isIncome ? kExpense : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          'مصروف', 
                          style: TextStyle(color: !_isIncome ? Colors.white : kTextDark, fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 2. أزرار الراديو (Radio Buttons - طريقة كلاسيكية)
            Text('طريقة 2: أزرار الراديو (Radio Buttons)', style: TextStyle(color: kTextLight, fontSize: 12)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('دخل'),
                    value: true,
                    groupValue: _isIncome,
                    activeColor: kIncome,
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('مصروف'),
                    value: false,
                    groupValue: _isIncome,
                    activeColor: kExpense,
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // 3. مربع الاختيار (Checkbox - طريقة بديلة)
            Text('طريقة 3: مربع الاختيار (Checkbox)', style: TextStyle(color: kTextLight, fontSize: 12)),
            CheckboxListTile(
              title: Text(_isIncome ? 'العملية الحالية: دخل (أزل الصح لتغييرها إلى مصروف)' : 'العملية الحالية: مصروف (ضع صح لتغييرها إلى دخل)'),
              value: _isIncome,
              activeColor: kIncome,
              onChanged: (value) {
                setState(() {
                  _isIncome = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // 4. مفتاح التبديل (Switch - طريقة حديثة وسريعة)
            Text('طريقة 4: مفتاح التبديل (Switch)', style: TextStyle(color: kTextLight, fontSize: 12)),
            SwitchListTile(
              title: Text('تحويل العملية إلى: ${_isIncome ? "دخل" : "مصروف"}', style: TextStyle(fontWeight: FontWeight.bold, color: _isIncome ? kIncome : kExpense)),
              value: _isIncome,
              activeColor: kIncome,
              inactiveThumbColor: kExpense,
              inactiveTrackColor: kExpense.withOpacity(0.3),
              onChanged: (value) {
                setState(() {
                  _isIncome = value;
                });
              },
            ),
            SizedBox(height: 30),

            // حقول الإدخال والتاريخ
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'اسم العملية (مثال: راتب، غداء)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.edit, color: kPrimary),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'المبلغ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.attach_money, color: kPrimary),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // اختيار التاريخ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التاريخ: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', 
                        style: TextStyle(fontSize: 16, color: kTextDark)
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() => _selectedDate = pickedDate);
                          }
                        },
                        icon: Icon(Icons.calendar_today, color: kPrimary),
                        label: Text('تغيير', style: TextStyle(color: kPrimary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            
            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                onPressed: _saveTransaction,
                child: Text(
                  widget.transactionToEdit != null ? 'تحديث العملية' : 'حفظ العملية', 
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
