part of 'height_form_bloc.dart';

abstract class HeightFormEvent extends Equatable {
  const HeightFormEvent();

  @override
  List<Object> get props => [];
}

class HeightFormHeightUpdated extends HeightFormEvent {
  final int val;

  const HeightFormHeightUpdated(this.val);

  @override
  List<Object> get props => [val];
}
