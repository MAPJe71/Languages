/*
 * The PureCoverage API for Java on Windows NT
 *
 * Explicitly no copyright.
 * You may recompile and redistribute these definitions as required.
 *
 */

package com.Rational;

/*
 * Call each function as, for example,
 * 	com.Rational.Coverage.isRunning()
 *  or
 *	import com.Rational.Coverage;
 *	...
 * 	Coverage.isRunning()
 */

/**
 * The PureCoverage API
 *
 * @version	1.0  April  02, 1998
 * @version	1.1  August 11, 1998
 */
public
class Coverage
{
    static {
		System.loadLibrary("CJavaAPI");
    }

/**
 * Checks if Coverage is running.
 */
    public static int isRunning() { return CoverageIsRunning(); }

/**
 * Disables collection of all data by Coverage.
 * CAUTION: Once you call this function, you cannot re-enable data
 * collection for this process.  No data is recorded and no data is
 * transmitted. The program is modified to incur the minimum overhead
 * when disabled.
 *
 * This function always returns true.
 */
    public static int disableRecordingData() { return CoverageDisableRecordingData(); }

/**
 * Tells Coverage to start recording all program performance data.
 * By default, a Coverage'd program starts recording data automatically.
 *
 * Using option -record-data=yes is like calling this
 * function before your program begins executing.
 *
 * The function returns true if it changed the state of Coverage
 * data recording, and false otherwise.
 */
    public static int startRecordingData() { return CoverageStartRecordingData(); }

/**
 * Tells Coverage to stop recording all program performance data.
 *
 * You can turn off native method timing separately using the other
 * functions below.
 *
 * Using option -record-data=no is like calling this
 * function before your program begins executing.
 *
 * The function return true if it changed the state of Coverage
 * data recording, and false otherwise.
 */
    public static int stopRecordingData() { return CoverageStopRecordingData(); }

/**
 * Checks if Coverage is currently recording all program performance data.
 */
    public static int isRecordingData() { return CoverageIsRecordingData(); }

/**
 * Tells Coverage to clear all the data it has recorded about
 * your program's performance to this point.  You can use this function,
 * for example, to ignore the performance of the startup phase of your program.
 *
 * This function always returns true.
 */
    public static int clearData() { return CoverageClearData(); }


/**
 * Saves all the data recorded since
 * program start (or the last call to clearData()) into a dataset
 * (a ".qfy" file).
 *
 * NOTE: This function calls clearData() after saving the data.
 *
 * This function returns true if successful, and false otherwise.
 */

    public static int saveData() { return CoverageSaveData(); }


/**
 * Tells Coverage to save the argument string in the
 * *next* output datafile written by saveData() (the datafile
 * corresponding to the current part of the program's run).  These annotations
 * can be viewed later using the "cv" program.  The function is typically used
 * to mark datafiles with important information about how the data was
 * recorded (e.g., what the program arguments were, who ran the program, or
 * what datafiles were used).
 *
 * This function returns the length of the string, or 0 if it is passed a
 * null reference.
 */
    public static int addAnnotation(String annotation) { return CoverageAddAnnotation(annotation); }

/** @see com.Rational.Coverage#isRunning */
    public native static int CoverageIsRunning ();
/** @see com.Rational.Coverage#disableRecordingData */
    public native static int CoverageDisableRecordingData();
/** @see com.Rational.Coverage#startRecordingData */
    public native static int CoverageStartRecordingData();
/** @see com.Rational.Coverage#stopRecordingData */
    public native static int CoverageStopRecordingData();
/** @see com.Rational.Coverage#isRecordingData */
    public native static int CoverageIsRecordingData();
/** @see com.Rational.Coverage#clearData */
    public native static int CoverageClearData();
/** @see com.Rational.Coverage#saveData */
    public native static int CoverageSaveData();
/** @see com.Rational.Coverage#addAnnotation */
    public native static int CoverageAddAnnotation(String annotation);
}

