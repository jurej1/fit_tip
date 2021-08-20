import 'package:flutter/foundation.dart';

enum MeasurmentSystem { imperial, metric, hybrid }

extension MeasurmentSystemX on MeasurmentSystem {
  bool get isImperial => this == MeasurmentSystem.imperial;
  bool get isMetric => this == MeasurmentSystem.metric;
  bool get isHybrid => this == MeasurmentSystem.hybrid;
}

MeasurmentSystem stringToMeasurmentSystem(String? val) {
  if (val == null) return MeasurmentSystem.metric;

  if (val == describeEnum(MeasurmentSystem.hybrid)) {
    return MeasurmentSystem.hybrid;
  } else if (val == describeEnum(MeasurmentSystem.imperial)) {
    return MeasurmentSystem.imperial;
  } else {
    return MeasurmentSystem.metric;
  }
}
