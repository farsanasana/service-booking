import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/presentation/page/google.dart';
import 'package:uuid/uuid.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../data/model/booking_model.dart';
import 'locationconfirmation_screen.dart';

class BookingForm extends StatelessWidget {
  final String serviceId;
  final String serviceName;

  const BookingForm({Key? key, 
    required this.serviceId,
    required this.serviceName,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    int selectedHours = 2;
    int selectedProfessionals = 1;
    bool needMaterials = false;
    String instructions = '';

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking created successfully!')),
          );

          // Navigate to the next screen after booking is successful
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationConfirmationScreen(
            bookingId: state.bookingId,
              ),
            ),
          );
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Step 1 of 4'),
        ),
        body: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home Cleaning',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 24),

                      // Hours Selection
                      Text(
                        'How many hours do you need your professional to stay?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(7, (index) {
                            final hours = index + 1;
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => setState(() => selectedHours = hours),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: selectedHours == hours
                                      ? Colors.cyan
                                      : Colors.grey[200],
                                  child: Text(
                                    '$hours',
                                    style: TextStyle(
                                      color: selectedHours == hours
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Professionals Selection
                      Text(
                        'How many professionals do you need?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: List.generate(4, (index) {
                          final professionals = index + 1;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => setState(() => selectedProfessionals = professionals),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: selectedProfessionals == professionals
                                    ? Colors.cyan
                                    : Colors.grey[200],
                                child: Text(
                                  '$professionals',
                                  style: TextStyle(
                                    color: selectedProfessionals == professionals
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 24),

                      // Materials Selection
                      Text(
                        'Need cleaning materials?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => needMaterials = false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: !needMaterials
                                    ? Colors.cyan
                                    : Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'No, I have them',
                                style: TextStyle(
                                  color: !needMaterials ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => needMaterials = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: needMaterials
                                    ? Colors.cyan
                                    : Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Yes, please',
                                style: TextStyle(
                                  color: needMaterials ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Instructions
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Any specific instructions?',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Show dialog or navigate to instructions page
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add your instructions here...',
                              ),
                              onChanged: (value) => instructions = value,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Total and Next Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'AED ${calculateTotal(selectedHours, selectedProfessionals, needMaterials).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final booking = Booking(
                                  id: const Uuid().v4(),
                                  userId: 'current-user-id', // Replace with actual user ID
                                  serviceId: serviceId,
                                  serviceName: serviceName,
                                  totalAmount: calculateTotal(
                                    selectedHours,
                                    selectedProfessionals,
                                    needMaterials,
                                  ),
                                  hours: selectedHours,
                                  professionals: selectedProfessionals,
                                  needMaterials: needMaterials,
                                  instructions: instructions,
                                  bookingDate: DateTime.now(),
                                );

                                context.read<BookingBloc>().add(CreateBooking(booking));
                              }
                             
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              minimumSize: Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double calculateTotal(int hours, int professionals, bool needMaterials) {
    double baseRate = 39.0; // Base rate per hour
    double materialsRate = 20.0; // Additional cost for materials

    double total = baseRate * hours * professionals;
    if (needMaterials) total += materialsRate;

    return total;
  }
}
