/*
 * The Visual Quantify API for Java on Windows NT
 *
 * Explicitly no copyright.
 * You may recompile and redistribute these definitions as required.
 *
 */

package com.Rational;

/*
 * Call each function as, for example,
 * 	com.Rational.Quantify.isRunning()
 *  or
 *	import com.Rational.Quantify;
 *	...
 * 	Quantify.isRunning()
 */

/**
 * The Visual Quantify API
 *
 * @version	1.0  April 17,	1997
 * @version	1.1  Augest 11, 1998
 */
public
class Quantify
{
    static {
		System.loadLibrary("QJavaAPI");
    }

/**
 * Checks if Quantify is running.
 */
    public static int isRunning() { return QuantifyIsRunning(); }

/**
 * Disables collection of all data by Quantify.
 * CAUTION: Once you call this function, you cannot re-enable data
 * collection for this process.  No data is recorded and no data is
 * transmitted. The program is modified to incur the minimum overhead
 * when disabled.
 *
 * This function always returns true.
 */
    public static int disableRecordingData() { return QuantifyDisableRecordingData(); }

/**
 * Tells Quantify to start recording all program performance data.
 * By default, a Quantify'd program starts recording data automatically.
 *
 * Using option -record-data=yes is like calling this
 * function before your program begins executing.
 *
 * The function returns true if it changed the state of Quantify
 * data recording, and false otherwise.
 */
    public static int startRecordingData() { return QuantifyStartRecordingData(); }

/**
 * Tells Quantify to stop recording all program performance data.
 *
 * You can turn off native method timing separately using the other
 * functions below.
 *
 * Using option -record-data=no is like calling this
 * function before your program begins executing.
 *
 * The function return true if it changed the state of Quantify
 * data recording, and false otherwise.
 */
    public static int stopRecordingData() { return QuantifyStopRecordingData(); }

/**
 * Checks if Quantify is currently recording all program performance data.
 */
    public static int isRecordingData() { return QuantifyIsRecordingData(); }

/**
 * Tells Quantify to clear all the data it has recorded about
 * your program's performance to this point.  You can use this function,
 * for example, to ignore the performance of the startup phase of your program.
 *
 * This function always returns true.
 */
    public static int clearData() { return QuantifyClearData(); }


/**
 * Saves all the data recorded since
 * program start (or the last call to clearData()) into a dataset
 * (a ".qfy" file).
 *
 * NOTE: This function calls clearData() after saving the data.
 *
 * This function returns true if successful, and false otherwise.
 */

    public static int saveData() { return QuantifySaveData(); }


/**
 * Sets the name of the current thread in the viewer.
 *
 * This function returns true if successful, and false otherwise.
 */

    public static int setThreadName(String name) { return QuantifySetThreadName(name); }


/**
 * Tells Quantify to save the argument string in the
 * *next* output datafile written by saveData() (the datafile
 * corresponding to the current part of the program's run).  These annotations
 * can be viewed later using the "qv" program.  The function is typically used
 * to mark datafiles with important information about how the data was
 * recorded (e.g., what the program arguments were, who ran the program, or
 * what datafiles were used).
 *
 * This function returns the length of the string, or 0 if it is passed a
 * null reference.
 */
    public static int addAnnotation(String annotation) { return QuantifyAddAnnotation(annotation); }

/** @see com.Rational.Quantify#isRunning */
    public native static int QuantifyIsRunning ();
/** @see com.Rational.Quantify#disableRecordingData */
    public native static int QuantifyDisableRecordingData();
/** @see com.Rational.Quantify#startRecordingData */
    public native static int QuantifyStartRecordingData();
/** @see com.Rational.Quantify#stopRecordingData */
    public native static int QuantifyStopRecordingData();
/** @see com.Rational.Quantify#isRecordingData */
    public native static int QuantifyIsRecordingData();
/** @see com.Rational.Quantify#clearData */
    public native static int QuantifyClearData();
/** @see com.Rational.Quantify#saveData */
    public native static int QuantifySaveData();
/** @see com.Rational.Quantify#setThreadName */
    public native static int QuantifySetThreadName();
/** @see com.Rational.Quantify#addAnnotation */
    public native static int QuantifyAddAnnotation(String annotation);
}

