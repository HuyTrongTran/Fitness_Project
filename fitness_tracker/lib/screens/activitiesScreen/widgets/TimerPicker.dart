import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TimerPicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay initialTime;

  const TimerPicker({
    Key? key,
    required this.onTimeSelected,
    required this.initialTime,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerPickerState createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  late ScrollController _hourController;
  late ScrollController _minuteController;
  late ScrollController _ampmController;

  int _selectedHour = 1;
  int _selectedMinute = 0;
  int _selectedAMPM = 0; // 0 for AM, 1 for PM  @override
  void initState() {
    super.initState();

    // Initialize with current time
    _selectedHour =
        widget.initialTime.hourOfPeriod == 0
            ? 12
            : widget.initialTime.hourOfPeriod;
    _selectedMinute = widget.initialTime.minute;
    _selectedAMPM = widget.initialTime.period == DayPeriod.am ? 0 : 1;

    // Initialize controllers without initial scroll offset
    _hourController = ScrollController();
    _minuteController = ScrollController();
    _ampmController = ScrollController();

    // Schedule scroll to initial positions after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialPositions();
    });
  }

  void _scrollToInitialPositions() {
    // Use a slightly longer delay to ensure controllers are fully initialized
    Future.delayed(Duration(milliseconds: 200), () {
      if (_hourController.hasClients &&
          _hourController.position.hasContentDimensions) {
        _hourController.animateTo(
          (_selectedHour - 1) * 50.0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOutQuint,
        );
      }

      // Stagger the animations slightly for a smoother visual effect
      Future.delayed(Duration(milliseconds: 50), () {
        if (_minuteController.hasClients &&
            _minuteController.position.hasContentDimensions) {
          _minuteController.animateTo(
            _selectedMinute * 50.0,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOutQuint,
          );
        }
      });

      Future.delayed(Duration(milliseconds: 100), () {
        if (_ampmController.hasClients &&
            _ampmController.position.hasContentDimensions) {
          _ampmController.animateTo(
            _selectedAMPM * 50.0,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOutQuint,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _ampmController.dispose();
    super.dispose();
  }

  void _onSave() {
    int hour = _selectedHour;
    if (_selectedAMPM == 1 && hour != 12) {
      // PM and not 12
      hour += 12;
    } else if (_selectedAMPM == 0 && hour == 12) {
      // AM and 12
      hour = 0;
    }

    final selectedTime = TimeOfDay(hour: hour, minute: _selectedMinute);
    widget.onTimeSelected(selectedTime);
  }

  Widget _buildScrollablePicker({
    required ScrollController controller,
    required List<String> items,
    required int selectedIndex,
    required Function(int) onChanged,
  }) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          // Selection indicator - visible border for selected item
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFBABABA), width: 1),
                  bottom: BorderSide(color: Color(0xFFBABABA), width: 1),
                ),
              ),
            ),
          ), // Scrollable list with notification listener
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                // Update selection during scroll for immediate visual feedback
                final offset = controller.offset;
                final index = (offset / 50.0).round().clamp(
                  0,
                  items.length - 1,
                );
                if (index != selectedIndex) {
                  Future.microtask(() => onChanged(index));
                }
              } else if (scrollNotification is ScrollEndNotification &&
                  controller.hasClients &&
                  controller.position.hasContentDimensions) {
                // Snap to nearest item when scroll ends
                final offset = controller.offset;
                final targetIndex = (offset / 50.0).round().clamp(
                  0,
                  items.length - 1,
                );
                final targetOffset = targetIndex * 50.0;

                if ((offset - targetOffset).abs() > 1.0) {
                  controller.animateTo(
                    targetOffset,
                    duration: Duration(milliseconds: 350),
                    curve: Curves.easeOutQuart,
                  );
                }
              }
              return true;
            },
            child: ListView.builder(
              controller: controller,
              itemExtent: 50,
              padding: EdgeInsets.symmetric(vertical: 100),
              itemCount: items.length,
              physics: BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ), // More responsive physics
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    controller.animateTo(
                      index * 50.0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
                    onChanged(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: 50,
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 1.0 : 0.5,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected ? TColors.primary : Colors.black,
                        ),
                        child: Text(items[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAMPMToggle() {
    final ampmItems = ['AM', 'PM'];

    return _buildScrollablePicker(
      controller: _ampmController,
      items: ampmItems,
      selectedIndex: _selectedAMPM,
      onChanged: (index) {
        setState(() {
          _selectedAMPM = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate lists for the pickers
    final hours = List.generate(12, (index) => (index + 1).toString());
    final minutes = List.generate(
      60,
      (index) => index.toString().padLeft(2, '0'),
    ); // 00, 01, 02, ..., 59

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 360,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with close button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFBABABA), width: 1),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Pick a time',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: -5,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), // Pickers container
            Container(
              height: 250,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Hour picker
                  Expanded(
                    flex: 3,
                    child: _buildScrollablePicker(
                      controller: _hourController,
                      items: hours,
                      selectedIndex: _selectedHour - 1,
                      onChanged: (index) {
                        setState(() {
                          _selectedHour = index + 1;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 8),
                  // Minutes picker
                  Expanded(
                    flex: 3,
                    child: _buildScrollablePicker(
                      controller: _minuteController,
                      items: minutes,
                      selectedIndex: _selectedMinute,
                      onChanged: (index) {
                        setState(() {
                          _selectedMinute = index;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 8),
                  // AM/PM scrollable picker
                  Expanded(flex: 2, child: _buildAMPMToggle()),
                ],
              ),
            ), // Save button
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D77FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the time picker
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              final clampedValue = value.clamp(0.0, 1.0);
              return Transform.scale(
                scale: (0.7 + (0.3 * clampedValue)).clamp(0.1, 1.0),
                child: Opacity(
                  opacity: clampedValue,
                  child: TimerPicker(
                    initialTime: initialTime,
                    onTimeSelected: (time) {
                      Navigator.pop(context, time);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
