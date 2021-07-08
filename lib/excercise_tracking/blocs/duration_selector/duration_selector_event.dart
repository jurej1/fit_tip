
part of 'duration_selector_bloc.dart';

abstract class DurationSelectorEvent extends Equatable {
  const DurationSelectorEvent(
{    required this.controller,
    required this.itemWidth,}
  );
    final ScrollController controller;
  final double itemWidth;

  @override
  List<Object> get props => [controller, itemWidth];

}

class DurationSelectorScrollUpdated extends DurationSelectorEvent {
  DurationSelectorScrollUpdated({required double itemWidth, required ScrollController scrollController}) : super(controller: scrollController, itemWidth: itemWidth);
  

}


class DurationSelectorScrollEnd extends DurationSelectorEvent{
  DurationSelectorScrollEnd({required double itemWidth, required ScrollController scrollController}) : super(controller: scrollController, itemWidth: itemWidth);
}