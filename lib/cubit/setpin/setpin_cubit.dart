import 'package:app/helpers/response_api.dart';
import 'package:bloc/bloc.dart';

part 'setpin_state.dart';

class SetpinCubit extends Cubit<SetpinState> {
  SetpinCubit() : super(SetpinInitial());

  postSetPin(FetchAPI request) async {
    emit(IsLoadingSetPin());

    final response = await ResponseAPI().process(request);

    if (response['status'] != '200') {
      emit(ResponseErrorSetPin(payload: response));
    } else {
      emit(ResponseDataSetPin());
    }
  }
}
