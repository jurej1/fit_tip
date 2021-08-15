part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeAccentColorUpdated extends ThemeEvent {
  final Color value;

  const ThemeAccentColorUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class ThemeThemeModeUpdated extends ThemeEvent {
  final ThemeMode? value;

  const ThemeThemeModeUpdated(this.value);
  @override
  List<Object?> get props => [value];
}
