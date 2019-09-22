import haxe.io.*;

class TestEndianness {
    static function main() {
        trace("isLittleEndian: " + isLittleEndian);
    }
    
    public static var isLittleEndian(default, null):Bool = {
    	// from TooTallNate / endianness.js.   https://gist.github.com/TooTallNate/4750953
        var a:UInt32Array = UInt32Array.fromArray([0xDEADBEEF]);
        var b:UInt8Array = UInt8Array.fromBytes(a.view.buffer);
        trace(StringTools.hex(a[0], 8));
        trace(StringTools.hex(b[0], 8));
        if (b[0] == 0xef) { return true; }
        else if (b[0] == 0xde) { return false; }
        else throw 'unknown endianness';
    }
}