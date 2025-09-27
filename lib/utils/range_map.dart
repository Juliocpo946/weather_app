double rangeMap(double value, double inMin, double inMax, double outMin, double outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}
