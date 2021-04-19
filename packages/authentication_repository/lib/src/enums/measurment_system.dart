import 'package:flutter/foundation.dart';

enum MeasurmentSystem { imperial, metric, hybrid }

MeasurmentSystem stringToMeasurmentSystem(String val) {
  if (val == describeEnum(MeasurmentSystem.hybrid)) {
    return MeasurmentSystem.hybrid;
  } else if (val == describeEnum(MeasurmentSystem.imperial)) {
    return MeasurmentSystem.imperial;
  } else {
    return MeasurmentSystem.metric;
  }
}
