import 'package:app/helpers/shared_preference.dart';
import 'package:bloc/bloc.dart';
import 'package:app/helpers/response_api.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future postRegister(FetchAPI request) async {
    emit(isLoading());
    final payload = await ResponseAPI().process(request);

    if (payload['status'] != '200') {
      emit(responseError(payload: payload));
    } else {
      await SharedPreferencesHelpers.setPrefs(
        'access_token',
        payload['data']['access_token'],
      );
      emit(responseData());
    }
  }
}
