// import 'package:flutter/material.dart';
//
// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }
//
// class _CategoriesScreenState extends State<CategoriesScreen> {
//   late Future<List<Category>> _future;
//   List<Category> _categories = <Category>[];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _future = UserApiController().getCategories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories'),
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.pushNamed(context, '/users_screen'),
//             icon: const Icon(Icons.person),
//           ),
//           IconButton(
//             onPressed: () => Navigator.pushNamed(context, '/images_screen'),
//             icon: const Icon(Icons.image),
//           ),
//           IconButton(
//             onPressed: () async => await logout(context),
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Category>>(
//         future: _future,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             _categories = snapshot.data!;
//             return GridView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               itemCount: _categories.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//               ),
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 45,
//                         backgroundImage: NetworkImage(_categories[index].image),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         _categories[index].title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(
//               child: Column(
//                 children: [
//                   Icon(Icons.warning),
//                   Text(
//                     'NO DATA!',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<void> logout(BuildContext context) async {
//     bool loggedOut = await AuthApiController().logout();
//     if (loggedOut && context.mounted) {
//       Navigator.pushReplacementNamed(context, '/login_screen');
//     }
//   }
// }
