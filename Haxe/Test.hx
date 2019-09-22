class Test {
    
    static var MIN_16_BITS = 0x8000;
    static var MAX_16_BITS = 0x7FFF;
    
    static var passed = 0;
    
    static function main() {
        trace("Haxe is great!");
        
        var i = -1;
        
        log("isrc: ", i, 8);
        
        var i16 = mapTo16Bits(i);
        log("to16: ", i16, 4);
        
        var i32 = expandTo32Bits(i16);
        log("to32: ", i32, 8);
        
        // add random tests
        var N_TESTS = 100;
        var tests = [];
        for (r in 0...N_TESTS) {
            i = Std.random(MIN_16_BITS);
            if (Math.random() < .5) i = -i;
            tests.push(i);
        }
        
        // add special cases to tests
        tests = tests.concat([1, -1, 0, MIN_16_BITS - 1, -MIN_16_BITS]);
        var failures = [MIN_16_BITS, 0xF1FFFFFF, -MIN_16_BITS - 1];
        tests = tests.concat(failures);
        
        // test them all
        for (i in tests) {
            i16 = mapTo16Bits(i);
            i32 = expandTo32Bits(i16);
            trace("\n");
            log("isrc: ", i, 8);
            log("to16: ", i16, 4);
            log("to32: ", i32, 8);
            test(i);
        }
        
    	trace("");
        trace(passed + "/" + tests.length + " tests passed");
    	trace("");
    
    
    	// mapping coords
    	var x:Int = -32768;
    	var y:Int = 32767;
    
    	var z:Int;
    
    	z = (mapTo16Bits(x) << 16) | mapTo16Bits(y);
    
    	log("ox: ", x);
    	log("oy: ", y);
    	log("x16: ", mapTo16Bits(x), 4);
    	log("y16: ", mapTo16Bits(y), 4);
    	log("z: ", z);
    	var roundTripX = expandTo32Bits(z >> 16);
    	var roundTripY = expandTo32Bits(z & 0xFFFF);
    
    	log("zx: ", roundTripX);
    	log("zy: ", roundTripY);

    	trace("zx == ox : " + (roundTripX == x));
    	trace("zy == oy : " + (roundTripY == y));
    	trace("");
    	trace("");
    
    }
    
    
    static function mapTo16Bits(i:Int):Int {
        return (i - MIN_16_BITS) & 0xFFFF;
    }
    
    static function expandTo32Bits(i:Int):Int {
        return (i | 0xFFFF0000) + MIN_16_BITS;
    }
    
    

    static function test(i:Int) {
        if (i < -MIN_16_BITS || i > MIN_16_BITS - 1) {
            trace('[FAIL] Cannot map to 16 bits (value $i out of range [-$MIN_16_BITS...$MAX_16_BITS])');
            return;
        }
        var roundTrip = expandTo32Bits(mapTo16Bits(i));
        if (i != roundTrip) {
            log("Error mapping ", i);
        } else {
            passed++;
        }
    }
    
    
    static function log(msg:String, i:Int, ?digits:Int) {
        trace(msg + "" + i + " (" + hex(i, digits) + ")");
    }
    
    static function hex(i:Int, ?digits:Int):String {
        return ("0x" + StringTools.hex(i, digits));
    }
}