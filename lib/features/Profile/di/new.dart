// import 'package:firebase_auth/firebase_auth.dart';
//  import 'package:flutter/material.dart'; 
//  import 'package:secondproject/core/constand/ColorsSys.dart';
//    class ProfilePage extends StatelessWidget { 
//       const ProfilePage({super.key});   
//        @override  
//         Widget build(BuildContext context) {     
//           final user = FirebaseAuth.instance.currentUser;   
       
//            String displayName = user?.displayName ?? 'Not Available'; 
//                print(user?.displayName);    
//                 return Scaffold(         
                  
//                  body: Padding(      
//                 padding: const EdgeInsets.all(20),       
//                 child: user != null           
//                 ? Column(         
//                 crossAxisAlignment: CrossAxisAlignment.start,       
//                 children: [                  
//                 const SizedBox(height: 20),
//                 itemProfile('Name', user.displayName ?? 'Not Available', Icons.person),
//                 const SizedBox(height: 10),               
//                 itemProfile('Email', user.email ?? 'Not Available', Icons.email),     
//                 const SizedBox(height: 20),            
//                 Center(
//                 child: ElevatedButton( 
//                onPressed: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacementNamed(context, '/login');  
//                 },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorSys.secoundry,
//                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                  ),  child: const Text('Logout'),
//                  ),
//                  ), 
//                  ], ) 
//                   : const Center(  child: Text('No user logged in.', style: TextStyle(fontSize: 16)),),),);}
//                   Widget itemProfile(String title, String subtitle, IconData iconData) {
//                     return Container(
//                       decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                         offset: const Offset(0, 5),
//                         color: ColorSys.secoundry,
//                         spreadRadius: 2,
//                         blurRadius: 10,
//                         ),
//                         ],
//                         ),
//                         child: ListTile(
//                           leading: Icon(iconData, color: ColorSys.primary),
//                           title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
//                           trailing: const Icon(Icons.edit, color: Colors.grey),
//                           ),
//                           );
//                           } } 