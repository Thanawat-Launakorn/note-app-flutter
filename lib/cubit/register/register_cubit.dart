import 'package:bloc/bloc.dart';
import 'package:app/helpers/response_api.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future postRegister({
    required dynamic endpoint,
    required dynamic body,
  }) async {
    emit(isLoading());
    final payload = await ResponseAPI().process(endpoint: endpoint, body: body);

    if (payload['data'] != '200') {
      emit(responseError());
    } else {
      emit(responseData());
    }
  }
}
