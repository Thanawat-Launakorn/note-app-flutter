import 'package:app/helpers/response_api.dart';
import 'package:app/shared/path.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<LoadNote>(_onLoadNote);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final payload = await ResponseAPI().process(event.req);

      if (payload['status'] != '200') {
        emit(NoteError(payload: payload));
      } else {
        emit(NoteSuccess(payload: payload));
      }
    } catch (err) {
      debugPrint('err => $err');
      emit(NoteError(payload: {'message': err.toString()}));
    } finally {}
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final payload = await ResponseAPI().process(event.req);

      if (payload['status'] != '200') {
        emit(NoteError(payload: payload));
      } else {
        emit(CreateNoteSuccess(payload: payload));
      }
    } catch (err) {
      debugPrint('err => $err');
      emit(NoteError(payload: {'message': err.toString()}));
    } finally {
      final getNotesReq = FetchAPI(
        methodAPI: METHOD.get,
        endpoint: '$localpath/notes/list-note',
        body: {},
      );
      add(LoadNote(getNotesReq));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final payload = await ResponseAPI().process(event.req);

      if (payload['status'] != '200') {
        emit(NoteError(payload: payload));
      } else {
        emit(CreateNoteSuccess(payload: payload));
      }
    } catch (err) {
      debugPrint('err => $err');
      emit(NoteError(payload: {'message': err.toString()}));
    } finally {
      final getNotesReq = FetchAPI(
        methodAPI: METHOD.get,
        endpoint: '$localpath/notes/list-note',
        body: {},
      );
      add(LoadNote(getNotesReq));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final payload = await ResponseAPI().process(event.req);

      if (payload['status'] != '200') {
        emit(NoteError(payload: payload));
      } else {
        emit(NoteSuccess(payload: payload));
      }
    } catch (err) {
      debugPrint('err => $err');
      emit(NoteError(payload: {'message': err.toString()}));
    } finally {
      final getNotesReq = FetchAPI(
        methodAPI: METHOD.get,
        endpoint: '$localpath/notes/list-note',
        body: {},
      );
      add(LoadNote(getNotesReq));
    }
  }
}
