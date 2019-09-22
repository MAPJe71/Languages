import flash.system.System;
import haxe.PosInfos;


class Main {
    static function main() {
		var test:TestSuite = new TestSuite();	// haxe.unit.* was overlapping traces in Flash so...
		test.testNull();
		trace("[ALL TESTS PASSED]");
		TestSuite.quit();
    }
}

class TestSuite {
    var c1:Color;
    var c2:Color;
    var i:Int;
    var u:UInt;
	
    public function new() {
        c1 = 0xffffffff;
        c2 = 0xfffffff0;
        i = c1-1;
        u = c2;
		u++;
        trace('c1: ${StringTools.hex(c1)} ($c1)');
        trace('c2: ${StringTools.hex(c2)} ($c2)');
        trace('i : ${StringTools.hex(i)} ($i)');
        trace('u : ${StringTools.hex(u)} ($u)');
    }	
	
	public static function quit() {
		#if (flash || js)
		System.exit(1);
		#else
		Sys.exit(1);
		#end
	}
	
	public static function assertTrue(b:Bool, ?str:String, ?pos:PosInfos):Void 
	{
		var msg = (!b ? '[FAIL]' : ' [OK]') + ' @${pos.fileName}:${pos.lineNumber}: expected TRUE    ' + (str != null ? str : '');
		if (!b) {
			/*trace*/throw(msg);
			quit();
		} else {
			trace(msg);
		}
	}
	
	public static function assertFalse(b:Bool, ?str:String, ?pos:PosInfos):Void 
	{
		var msg = (b ? '[FAIL]' : ' [OK]') + ' @${pos.fileName}:${pos.lineNumber}: expected FALSE    ' + (str != null ? str : '');
		if (b) {
			/*trace*/throw(msg);
			quit();
		} else {
			trace(msg);
		}
	}
	
	public function testNull() {
		trace("-- testNull");
		var defaultColor = 0x0000DEFA;
		
		function nullable(?color:Color):Color {
			trace("   in nullable()    color: " + color + "  isNull: " + (color == null));
			if (null != color) {
				return color;
			} else {
				return defaultColor;
			}
		}
		
		var c3:Null<Color> = null;
		assertTrue(c3 == null);
		assertTrue(nullable() == defaultColor);
		assertTrue(nullable(0xFFFF0000) == 0xFFFF0000);
	}
}


// NOTE: Uncomment the following lines to make it also work with CPP

//#if !cpp
abstract Color(Int) from Int to Int from UInt to UInt {
//#else
//abstract Color(Null<Int>) from Int to Int from UInt to UInt {
//#end

    public function new(value:Int) this = toColor(value);
    
	
	// Int
	
    @:op(C < I) 
    inline static function lt_i(c:Color, i:Int):Bool return c < toColor(i);
	
    @:op(I < C) 
    inline static function lt_i2(i:Int, c:Color):Bool return toColor(i) < c;
    
    @:op(C > I) 
    inline static function gt_i(c:Color, i:Int):Bool return c > toColor(i);
    
    @:op(I > C) 
    inline static function gt_i2(i:Int, c:Color):Bool return toColor(i) > c;
    
    @:op(C <= I) 
    inline static function lte_i(c:Color, i:Int):Bool return c <= toColor(i);

    @:op(I <= C) 
    inline static function lte_i2(i:Int, c:Color):Bool return toColor(i) <= c;
    
	@:op(C >= I) 
    inline static function gte_i(c:Color, i:Int):Bool return c >= toColor(i);
	
	@:op(I >= C) 
    inline static function gte_i2(i:Int, c:Color):Bool return toColor(i) >= c;

    
	// UInt
	
    @:commutative 
    @:op(C == U) 
    inline static function eq_ui(c:Color, ui:Null<UInt>):Bool return c == toColor(ui);

    @:commutative 
    @:op(C != U) 
    inline static function neq_ui(c:Color, ui:Null<UInt>):Bool return !eq_ui(c, ui);
    
	
	inline static function toColor(i:Null<Int>):Color return /*cast*/ i;
}