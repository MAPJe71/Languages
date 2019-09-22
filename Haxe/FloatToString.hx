  // Good enough, but not quite!
  static public function floatToString(float:Float):String {
    inline function abs(float:Float):Float return Math.abs(float);
    inline function frac(float:Float):Float return (float % 1.);
    inline function trunc(float:Float):Float return float - frac(float);
    
    var fractionalPart:Float = abs(frac(float));
    var signStr = float < 0. ? "-" : "";
    var hasFractionalPart = fractionalPart > 0.;
    
    var digit = 0.;
    var integralPartStr = "";
    float = abs(trunc(float));
    
    if (float == 0.) integralPartStr = "0";
    
    while (float > 0) {
      digit = float % 10.;
      float = abs(trunc(float / 10.));
      integralPartStr = digit + integralPartStr;
    }
    
    var repr = signStr + integralPartStr;
    if (hasFractionalPart) repr += Std.string(fractionalPart).substr(1); // add fractional part, but remove leading 0
    
    return repr;
  }
