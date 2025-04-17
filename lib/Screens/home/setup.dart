// import 'package:flutter/material.dart';
// import '/constants.dart';
// import '/responsive.dart';
// import '../../components/background.dart';
// import 'setup_components/school_info_form.dart';

// class SetUp extends StatelessWidget {
//   const SetUp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Background(
//       child: SingleChildScrollView(
//         child: Responsive(
//           mobile: MobileSetupScreen(),
//           desktop: Row(
//             children: [
//               // Expanded(
//               //   child: SignUpScreenTopImage(),
//               // ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 450,
//                       child: SchoolInfoForm(),
//                     ),
//                     SizedBox(height: defaultPadding / 2),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MobileSetupScreen extends StatelessWidget {
//   const MobileSetupScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//        // SignUpScreenTopImage(),
//         Row(
//           children: [
//             Spacer(),
//             Expanded(
//               flex: 8,
//               child: SchoolInfoForm(),
//             ),
//             Spacer(),
//           ],
//         ),
//         // const SocalSignUp()
//       ],
//     );
//   }
// }