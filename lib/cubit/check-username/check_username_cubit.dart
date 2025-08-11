import 'package:app/helpers/response_api.dart';
import 'package:bloc/bloc.dart';

part 'check_username_state.dart';

class CheckUsernameCubit extends Cubit<CheckUsernameState> {
  CheckUsernameCubit() : super(CheckUsernameInitial());

  postCheckUsername(FetchAPI request) async {
    emit(IsLoadingCheckUsername());

    final payload = await ResponseAPI().process(request);
    if (payload['status'] != '200') {
      emit(ResponseErrorCheckUsername(payload: payload));
    } else {
      emit(ResponseDataCheckUsername());
    }
  }
}
