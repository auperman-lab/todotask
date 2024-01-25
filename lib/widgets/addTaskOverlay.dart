import 'package:flutter/material.dart';

class BottomSlideInput extends StatefulWidget {
  final Function(String, String, DateTime) onSubmit;

  const BottomSlideInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _BottomSlideInputState createState() => _BottomSlideInputState();
}

class _BottomSlideInputState extends State<BottomSlideInput> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  void _toggleAnimation() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    )) ?? _selectedDate;

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Positioned(
            bottom: _animation.value * -MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, -2.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'ADD TASK',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill out the details below to add a new task.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task description (optional)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date: ${_selectedDate.toLocal()}'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _toggleAnimation();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onSubmit(
                            _nameController.text,
                            _descriptionController.text,
                            _selectedDate,
                          );
                          _nameController.clear();
                          _descriptionController.clear();
                          _toggleAnimation();
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
