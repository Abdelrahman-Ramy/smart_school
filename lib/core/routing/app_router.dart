import 'package:flutter/material.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/features/auth/views/forget_pass_view.dart';
import 'package:smart_school/features/auth/views/login_view.dart';
import 'package:smart_school/features/auth/views/register_view.dart';
import 'package:smart_school/features/auth/views/reset_pass_view.dart';
import 'package:smart_school/features/auth/views/verification_view.dart';
import 'package:smart_school/features/parent/views/parent_chat_view.dart';
import 'package:smart_school/features/parent/views/parent_home_view.dart';
import 'package:smart_school/features/parent/views/parent_notifications_view.dart';
import 'package:smart_school/features/parent/views/parent_profile_view.dart';
import 'package:smart_school/features/parent/views/parent_root.dart';
import 'package:smart_school/features/student/views/assignments_view.dart';
import 'package:smart_school/features/student/views/attendance_view.dart';
import 'package:smart_school/features/student/views/grades_view.dart';
import 'package:smart_school/features/student/views/quizzes_view.dart';
import 'package:smart_school/features/student/views/schedule_view.dart';
import 'package:smart_school/features/student/views/student_chat_bot_view.dart';
import 'package:smart_school/features/student/views/student_home_view.dart';
import 'package:smart_school/features/student/views/student_notifications_view.dart';
import 'package:smart_school/features/student/views/student_settings_view.dart';
import 'package:smart_school/features/student/views/student_root.dart';
import 'package:smart_school/features/student/views/student_profile_view.dart';
import 'package:smart_school/features/teacher/views/teacher_home_view.dart';
import 'package:smart_school/features/teacher/views/teacher_notifications_view.dart';
import 'package:smart_school/features/teacher/views/teacher_profile_view.dart';
import 'package:smart_school/features/teacher/views/teacher_root.dart';
import 'package:smart_school/features/teacher/views/teacher_settings_view.dart';
import 'package:smart_school/features/teacher/views/upload_attendance_view.dart';
import 'package:smart_school/features/teacher/views/upload_grades_view.dart';
import 'package:smart_school/features/teacher/views/upload_materials_view.dart';
import 'package:smart_school/features/teacher/views/upload_tasks_view.dart';
import 'package:smart_school/features/teacher/views/view_classes_view.dart';
import 'package:smart_school/shared/splash_view.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterView());
      case Routes.forgetPass:
        return MaterialPageRoute(builder: (context) => ForgetPassView());
      case Routes.resetPass:
        return MaterialPageRoute(builder: (context) => ResetPassView());
      case Routes.verification:
        return MaterialPageRoute(builder: (context) => VerificationView());
      case Routes.parentHome:
        return MaterialPageRoute(builder: (context) => const ParentHomeView());
      case Routes.studentHome:
        return MaterialPageRoute(builder: (context) => const StudentHomeView());
      case Routes.teacherHome:
        return MaterialPageRoute(builder: (context) => const TeacherHomeView());
      case Routes.studentAssignments:
        return MaterialPageRoute(builder: (context) => const AssignmentsView());
      case Routes.studentAttendance:
        return MaterialPageRoute(builder: (context) => const AttendanceView());
      case Routes.studentGrades:
        return MaterialPageRoute(builder: (context) => const GradesView());
      case Routes.studentQuizzes:
        return MaterialPageRoute(builder: (context) => const QuizzesView());
      case Routes.studentSchedule:
        return MaterialPageRoute(builder: (context) => const ScheduleView());
      case Routes.studentChatBot:
        return MaterialPageRoute(
          builder: (context) => const StudentChatBotView(),
        );
      case Routes.studentNotifications:
        return MaterialPageRoute(
          builder: (context) => const StudentNotificationsView(),
        );
      case Routes.studentProfile:
        return MaterialPageRoute(
          builder: (context) => const StudentProfileView(),
        );
      case Routes.studentRoot:
        return MaterialPageRoute(builder: (context) => const StudentRoot());
      case Routes.parentNotifications:
        return MaterialPageRoute(
          builder: (context) => const ParentNotificationsView(),
        );
      case Routes.parentRoot:
        return MaterialPageRoute(builder: (context) => const ParentRoot());
      case Routes.parentProfile:
        return MaterialPageRoute(
          builder: (context) => const ParentProfileView(),
        );
      case Routes.parentChat:
        return MaterialPageRoute(builder: (context) => const ParentChatView());
      case Routes.teacherRoot:
        return MaterialPageRoute(builder: (context) => const TeacherRoot());
      case Routes.teacherProfile:
        return MaterialPageRoute(
          builder: (context) => const TeacherProfileView(),
        );
      case Routes.teacherChat:
        return MaterialPageRoute(builder: (context) => const ParentChatView());
      case Routes.teacherNotifications:
        return MaterialPageRoute(
          builder: (context) => const TeacherNotificationsView(),
        );
      case Routes.studentSettings:
        return MaterialPageRoute(
          builder: (context) => const StudentSettingsView(),
        );
      case Routes.teacherSettings:
        return MaterialPageRoute(
          builder: (context) => const TeacherSettingsView(),
        );
      case Routes.teacherViewClasses:
        return MaterialPageRoute(
          builder: (context) => const ViewClassesView(),
        );
      case Routes.teacherUploadAttendance:
        return MaterialPageRoute(
          builder: (context) => const UploadAttendanceView(),
        );
      case Routes.teacherUploadGrades:
        return MaterialPageRoute(
          builder: (context) => const UploadGradesView(),
        );
      case Routes.teacherUploadTasks:
        return MaterialPageRoute(
          builder: (context) => const UploadTasksView(),
        );
      case Routes.teacherUploadMaterials:
        return MaterialPageRoute(
          builder: (context) => const UploadMaterialsView(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Center(child: Text('No Route Found ${settings.name}')),
            ),
          ),
        );
    }
  }
}
