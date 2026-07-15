import 'package:flutter/material.dart';
import 'package:smart_school/features/notifications/views/notifications_view.dart';

class StudentNotificationsView extends StatelessWidget {
  const StudentNotificationsView({super.key});

  @override
  Widget build(BuildContext context) => const NotificationsView();
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:smart_school/core/theming/app_colors.dart';
// import 'package:smart_school/core/theming/app_style.dart';
// import 'package:smart_school/features/student/widgets/notification_tile.dart';

// class StudentNotificationsView extends StatefulWidget {
//   const StudentNotificationsView({super.key});

//   @override
//   State<StudentNotificationsView> createState() =>
//       _ParentNotificationsViewState();
// }

// class _ParentNotificationsViewState extends State<StudentNotificationsView> {
//   bool isAllSelected = true;

//   final List<Map<String, dynamic>> notificationsData = [

//     {
//       'title': 'Announcement',
//       'subtitle': 'New practice material has been sent to Ali',
//       'time': '30 min',
//       'icon': Icons.campaign,
//       'isRead': true,
//     },

//     {
//       'title': 'Mrs.mai',
//       'subtitle': "He is ready for the finals, Ali made great progress.",
//       'time': 'Just now',
//       'icon': Icons.person,
//       'isRead': false,
//     },
//     {
//       'title': 'Announcement',
//       'subtitle': 'New practice material has been sent to Ali',
//       'time': '30 min',
//       'icon': Icons.campaign,
//       'isRead': true,
//     },
//     {
//       'title': 'Announcement',
//       'subtitle': 'New practice material has been sent to Ali',
//       'time': '30 min',
//       'icon': Icons.campaign,
//       'isRead': false,
//     },
//     {
//       'title': 'Announcement',
//       'subtitle': 'New practice material has been sent to Ali',
//       'time': '30 min',
//       'icon': Icons.campaign,
//       'isRead': true,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final currentList = isAllSelected
//         ? notificationsData
//         : notificationsData.where((item) => item['isRead'] == false).toList();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.whiteColor,
//         scrolledUnderElevation: 0,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Icon(Icons.arrow_back, color: Colors.transparent),
//         title: Text('Notifications', style: AppStyle.font22BlackW500),
//       ),
//       body: Column(
//         children: [
//           Gap(10.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40.w),
//             child: Container(
//               height: 48.h,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.r),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isAllSelected = true;
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: isAllSelected
//                               ? AppColors.primaryColor
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Text(
//                           'All',
//                           style: isAllSelected
//                               ? AppStyle.font14WhiteBold.copyWith(
//                                   fontSize: 16.sp,
//                                 )
//                               : AppStyle.font16BlackBold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isAllSelected = false;
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: !isAllSelected
//                               ? AppColors.primaryColor
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Text(
//                           'UnRead',
//                           style: !isAllSelected
//                               ? AppStyle.font14WhiteBold.copyWith(
//                                   fontSize: 16.sp,
//                                 )
//                               : AppStyle.font16BlackBold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Gap(20.h),
//           Expanded(
//             child: ListView.builder(
//               itemCount: currentList.length,
//               itemBuilder: (context, index) {
//                 final item = currentList[index];
//                 return NotificationTile(
//                   title: item['title'],
//                   subtitle: item['subtitle'],
//                   time: item['time'],
//                   icon: item['icon'],
//                   iconColor: AppColors.primaryColor,
//                   isRead: item['isRead'],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }