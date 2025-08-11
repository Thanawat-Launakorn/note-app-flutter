part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteSuccess extends NoteState {
  final dynamic payload;
  NoteSuccess({required this.payload});
}

final class CreateNoteSuccess extends NoteState {
  final dynamic payload;
  CreateNoteSuccess({required this.payload});
}

final class UpdateNoteSuccess extends NoteState {
  final dynamic payload;
  UpdateNoteSuccess({required this.payload});
}

final class DeleteNoteSuccess extends NoteState {
  final dynamic payload;
  DeleteNoteSuccess({required this.payload});
}

final class NoteError extends NoteState {
  final dynamic payload;
  NoteError({required this.payload});
}

final class SelectNotesState extends NoteState {
  final List<bool> selectNotes;
  SelectNotesState({required this.selectNotes});
}
