import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPickerDialog {
  static Future<DateTime?> show(BuildContext context, DateTime initialDate) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return _MonthYearPickerDialog(
          initialDate: initialDate,
        );
      },
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const _MonthYearPickerDialog({required this.initialDate});

  @override
  _MonthYearPickerDialogState createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> with SingleTickerProviderStateMixin {
  late int _selectedMonth;
  late int _selectedYear;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;

    // Khởi tạo AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Khởi tạo Fade Animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Chạy animation khi dialog mở
    _animationController.forward();
  }

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  // Hàm để đóng dialog với animation
  Future<void> _selectAndClose(BuildContext context) async {
    // Chạy animation ngược lại (fade out)
    await _animationController.reverse();
    // Đóng dialog và trả về giá trị
    Navigator.pop(
      context,
      DateTime(_selectedYear, _selectedMonth, 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(TSizes.defaultSpace),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Year Picker with Navigation Arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        _selectedYear--;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: _selectedYear,
                    items: List.generate(21, (index) {
                      int year = 2010 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        _selectedYear++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              // Month Grid
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: TSizes.sm,
                    crossAxisSpacing: TSizes.sm,
                    childAspectRatio: 2,
                  ),
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                    final month = _months[index];
                    final isSelected = (index + 1) == _selectedMonth;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMonth = index + 1;
                        });
                        // Đóng dialog với animation
                        _selectAndClose(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(TSizes.buttonSizeSm),
                        ),
                        child: Center(
                          child: Text(
                            month,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}