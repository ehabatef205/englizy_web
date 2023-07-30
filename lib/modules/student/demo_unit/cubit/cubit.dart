import 'package:englizy_app/modules/student/demo_unit/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemoUnitCubit extends Cubit<DemoUnitStates> {
  DemoUnitCubit() : super(DemoUnitInitialState());

  static DemoUnitCubit get(context) => BlocProvider.of(context);

}