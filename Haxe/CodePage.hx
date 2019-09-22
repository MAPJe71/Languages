package;

import unifill.CodePoint;

using StringTools;
using unifill.Unifill;


typedef CodePageValue = Int;


/**
 * ...
 * @author azrafe7
 */
@:forward
@:expose
@:native("CodePage")
abstract CodePage(CodePageData) {
  
  inline public function new(name:String = "codepage") {
    this = new CodePageData(name);
  }
  
  @:arrayAccess public function get(codePageValue:CodePageValue):CodePoint {
    return this.codeMap.get(codePageValue);
  }
}


@:allow(CodePage)
@:access(OrderedMap)
class CodePageData {
  
  public var name(default, null):String;
  
  var codeMap:OrderedMap<CodePageValue, CodePoint>;
  var codePointNames:OrderedMap<CodePoint, String>;
  
  public function new(name:String) {
    this.name = name;
    
    var codesMap = new Map<CodePageValue, CodePoint>();
    this.codeMap = new OrderedMap(codesMap);
    var namesMap = new Map<CodePoint, String>();
    this.codePointNames = new OrderedMap(namesMap);
  }
  
  inline public function setMapping(codePageValue:CodePageValue, codePoint:CodePoint, codePointName:String) {
    codeMap.set(codePageValue, codePoint);
    codePointNames.set(codePoint, codePointName);
  }
  
  inline public function removeMapping(codePageValue:CodePageValue) {
    var codePoint = codeMap.get(codePageValue);
    codeMap.remove(codePageValue);
    codePointNames.remove(codePoint);
  }
  
  inline public function getNameOf(codePoint:CodePoint):String {
    return codePointNames.get(codePoint);
  }
 
  inline public function exists(codePageValue:CodePageValue):Bool {
    return codeMap.exists(codePageValue);
  }
  
  public function repr():String {
    var buf = new StringBuf();
    buf.add("CodePage[" + name + "] (entries: " + length + ")\n");
    buf.add(" idx    | value  | codePt | name\n");
    
    for (i in 0...codeMap._keys.length) {
      buf.add(reprOf(i) + "\n");
    }
    
    return buf.toString();
  }
  
  inline function asHex4(n:Int):String {
    return "0x" + n.hex(4);
  }
  
  public function reprOf(idx:Int):String {
    var value = codeMap._keys[idx];
    var codePoint = codeMap.get(value);
    var name = codePointNames.get(codePoint);
    return " " + asHex4(idx) + " | " + asHex4(value) + " | " + asHex4(codePoint) + " | " + name;
  }
  
  /** Iterates over the codeMap values (codePoints) */
  inline public function iterator():Iterator<CodePoint> {
    return codeMap.iterator();
  }
  
  /** Iterates over the codeMap keys (codePageValues) */
  inline public function keys():Iterator<CodePageValue> {
    return codeMap._keys.iterator();
  }
  
  public var length(get, never):Int;
  inline function get_length():Int {
    return codeMap._keys.length;
  }
  
  inline public function indexOf(codePageValue:CodePageValue) {
    return codeMap._keys.indexOf(codePageValue);
  }
  
  public function entryAt(idx:Int):CodePageEntry {
    var codePageValue = codeMap._keys[idx];
    var codePoint = codeMap.get(codePageValue);
    return new CodePageEntry(codePageValue, codePoint, codePointNames.get(codePoint));
  }
  
  inline public function entryFor(codePageValue:CodePageValue):CodePageEntry {
    return entryAt(indexOf(codePageValue));
  }
}


class CodePageEntry {
  
  public var codePageValue(default, null):CodePageValue;
  public var codePoint(default, null):CodePoint;
  public var name(default, null):String;
  
  public function new (codePageValue:CodePageValue, codePoint:CodePoint, name:String) {
    this.codePageValue = codePageValue;
    this.codePoint = codePoint;
    this.name = name;
  }
}