import 'package:englizy_app/modules/admin/view_student/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewStudentCubit extends Cubit<ViewStudentStates> {
  ViewStudentCubit() : super(InitialViewStudentState());

  static ViewStudentCubit get(context) => BlocProvider.of(context);

}