import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:uuid/uuid.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/booking/booking_state.dart';
import '../../data/model/booking_model.dart';
import 'locationconfirmation_screen.dart';

class BookingForm extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const BookingForm({
    Key? key,
    required this.serviceId,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  double calculateTotal(int hours, int professionals, bool needMaterials) {
    double baseRate = 39.0;
    double materialsRate = 20.0;
    double total = baseRate * hours * professionals;
    if (needMaterials) total += materialsRate;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationConfirmationScreen(
                      tempBookingId: state.bookingId,
                      totalAmount: state.totalAmount.toString(),
                      serviceName: widget.serviceName,
                    ),
                  ),
                );
              } else if (state is BookingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                int selectedHours = state is BookingInitial ? state.selectedHours : 2;
                int selectedProfessionals = state is BookingInitial ? state.selectedProfessionals : 1;
                bool needMaterials = state is BookingInitial ? state.needMaterials : false;
                String instructions = state is BookingInitial ? state.instructions : '';

                // Update the controller only when state changes
                _instructionsController.text = instructions;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home Cleaning', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 24),

                        // Hours Selection (1-7 hours)
                        Text('How many hours do you need?', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(7, (index) {
                              final hours = index + 1;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => context.read<BookingBloc>().add(UpdateBookingSelection(selectedHours: hours)),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: selectedHours == hours ? ColorSys.secoundry : Colors.grey[200],
                                    child: Text('$hours', style: TextStyle(color: selectedHours == hours ? Colors.white : Colors.black)),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Need Materials
                        Text('Need cleaning materials?', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.read<BookingBloc>().add(UpdateBookingSelection(needMaterials: false)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !needMaterials ? ColorSys.secoundry : Colors.grey[200],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                ),
                                child: Text('No, I have them', style: TextStyle(color: !needMaterials ? Colors.white : Colors.black)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.read<BookingBloc>().add(UpdateBookingSelection(needMaterials: true)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: needMaterials ? ColorSys.secoundry : Colors.grey[200],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                ),
                                child: Text('Yes, please', style: TextStyle(color: needMaterials ? Colors.white : Colors.black)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Instructions Field
                        TextField(
                          controller: _instructionsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add your instructions here...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => context.read<BookingBloc>().add(UpdateBookingSelection(instructions: value)),
                        ),

                        const SizedBox(height: 24),

                        // Total and Next Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total', style: TextStyle(color: Colors.grey)),
                                Text(
                                  'AED ${calculateTotal(selectedHours, selectedProfessionals, needMaterials).toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final totalAmount = calculateTotal(selectedHours, selectedProfessionals, needMaterials);
                                  final user = FirebaseAuth.instance.currentUser;

                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error: User not authenticated')),
                                    );
                                    return;
                                  }

                                  final bookingData = {
                                    'userId': user.uid,
                                    'serviceId': widget.serviceId,
                                    'serviceName': widget.serviceName,
                                    'totalAmount': totalAmount,
                                    'hours': selectedHours,
                                    'professionals': selectedProfessionals,
                                    'needMaterials': needMaterials,
                                    'instructions': _instructionsController.text,
                                  };

                                  final tempBookingId = const Uuid().v4();
                                  context.read<BookingBloc>().add(StoreBookingData(bookingData, tempBookingId));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationConfirmationScreen(
                                        tempBookingId: tempBookingId,
                                        totalAmount: totalAmount.toString(),
                                        serviceName: widget.serviceName,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Next'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}