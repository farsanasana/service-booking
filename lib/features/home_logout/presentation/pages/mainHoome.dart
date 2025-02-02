
// // UI
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:secondproject/features/home_logout/presentation/bloc/category/category_bloc.dart';
// import 'package:secondproject/features/home_logout/presentation/bloc/category/category_event.dart';
// import 'package:secondproject/features/home_logout/presentation/bloc/category/category_state.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ServiceBloc()..add(FetchServices()),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Home')),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search Services...',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.search),
//                 ),
//                 onChanged: (query) {
//                   context.read<ServiceBloc>().add(SearchService(query));
//                 },
//               ),
//             ),
//             Expanded(
//               child: BlocBuilder<ServiceBloc, ServiceState>(
//                 builder: (context, state) {
//                   if (state is ServiceLoading) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state is ServiceLoaded) {
//                     return ListView.builder(
//                       itemCount: state.services.length,
//                       itemBuilder: (context, index) {
//                         final service = state.services[index];
//                         return ListTile(
//                           title: Text(service['name']),
//                           subtitle: Text(service['category']),
//                         );
//                       },
//                     );
//                   }
//                   return Container();
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
