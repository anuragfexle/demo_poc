import 'package:demo_poc/bloc/expense/expense_bloc.dart';
import 'package:demo_poc/bloc/expense/expense_event.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/utils/date_formatter.dart';
import 'package:demo_poc/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateExpense extends StatefulWidget {
  final Expense expense;

  const UpdateExpense({super.key, required this.expense});

  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    // Initialize with existing date if available
    selectedDate = widget.expense.date;
    if (selectedDate != null) {
      selectedTime = TimeOfDay(
        hour: selectedDate!.hour,
        minute: selectedDate!.minute,
      );
    }
    selectedType = widget.expense.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validate that date is selected
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date and time'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final name = _nameController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      final updatedExpense = widget.expense.copyWith(
        name: name,
        amount: amount,
        date: selectedDate,
        type: selectedType,
      );

      // Update event to BLoC
      context.read<ExpenseBloc>().add(UpdateExpenseEvent(updatedExpense));

      // Go back to previous screen
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );

      setState(() {
        selectedDate = pickedDate;
        if (pickedTime != null) {
          selectedTime = pickedTime;
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                  filled: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Expense Type',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                items: ExpenseType.map((type) {
                  return DropdownMenuItem(
                    value: type.value,
                    child: Text(type.label),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select expense type';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? 'No date & time selected'
                        : DateFormatter.format(selectedDate!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select Date & Time'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitForm,
                  child: const Text('Update Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
