package de.stefan1200.jts3serverquery;

import java.io.BufferedReader;
import java.io.EOFException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.InetAddress;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

/**
 * JTS3ServerQuery library version 2.0.2
 * <br><br>
 * This library allows you to create a query connection to the Teamspeak 3 telnet interface.
 * Almost anything is supported: Query lists or just informations, get log entries, receiving events, add or delete complains, kick or move clients and of course send own commands.
 * <br><br>
 * This library is free for use, but please notify me if you found a bug or if you have some suggestion.
 * The author of this library is not responsible for any damage or data loss!
 * It is not allowed to sell this library for money, it has to be free to get!<br><br>
 * 
 * <b>E-Mail:</b><br><a href="mailto:info@stefan1200.de">info@stefan1200.de</a><br><br>
 * <b>Homepage:</b><br><a href="http://www.stefan1200.de" target="_blank">http://www.stefan1200.de</a>
 * 
 * @author Stefan Martens
 * @version 2.0.2 Final (06.07.2015)
 */
public class JTS3ServerQuery
{
	/**
	 * Setting DEBUG to <code>true</code> will write every internal exception into an error log file and write the communication log file.
	 * It is also possible to set the filename and path to the communication and error log file, see DEBUG_COMMLOG_PATH and DEBUG_ERRLOG_PATH.
	 * @since 1.0.4
	 * @see JTS3ServerQuery#DEBUG_COMMLOG_PATH
	 * @see JTS3ServerQuery#DEBUG_ERRLOG_PATH
	 */
	public boolean DEBUG = false;
	
	/**
	 * Set the path to the communication log file or <code>null</code> to disable writing of this log file.
	 * This will be used only if DEBUG is set to <code>true</code>.
	 * In the communication log file you can see any outgoing and incoming messages between this library and the TS3 server.
	 * @since 1.0.4
	 * @see JTS3ServerQuery#DEBUG
	 */
	public String DEBUG_COMMLOG_PATH = "JTS3ServerQuery-communication.log";
	
	/**
	 * Set the path to the error log file or <code>null</code> to disable writing of this log file.
	 * This will be used only if DEBUG is set to <code>true</code>.
	 * In the error log file you can see all internal exceptions thrown by this library.
	 * @since 1.0.10
	 * @see JTS3ServerQuery#DEBUG
	 */
	public String DEBUG_ERRLOG_PATH = "JTS3ServerQuery-error.log";
	
	/**
	 * List mode for getList(), use this mode to get a list of clients currently online.<br><br>
	 * Possible optional arguments:<br>
	 * <code>-uid<br>-away<br>-voice<br>-times<br>-groups<br>-info<br>-icon<br>-country<br>-ip</code>
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_CLIENTLIST = 1;
	
	/**
	 * List mode for getList(), use this mode to get a list of current channels.<br><br>
	 * Possible optional arguments:<br>
	 * <code>-topic<br>-flags<br>-voice<br>-limits<br>-icon<br>-secondsempty</code>
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_CHANNELLIST = 2;
	
	/**
	 * List mode for getList(), use this mode to get a list of virtual servers.<br><br>
	 * Possible optional arguments:<br>
	 * <code>-all<br>-onlyoffline<br>-short<br>-uid</code>
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_SERVERLIST = 3;
	
	/**
	 * List mode for getList(), use this mode to get a list of server groups.
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_SERVERGROUPLIST = 4;
	
	/**
	 * List mode for getList(), use this mode to get a list of all clients in database.
	 * By default only the first 25 entries will be returned.<br><br>
	 * Possible optional arguments:<br>
	 * <code>start=&lt;number&gt;<br>duration=&lt;number&gt;<br>-count</code>
	 * <br><br>
	 * For example:<br>
	 * <code>start=0<br>duration=25</code>
	 * <br><br>
	 * <b>Important:</b><br>
	 * Requesting to many clients at once make the TS3 server unstable.
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_CLIENTDBLIST = 5;
	
	/**
	 * List mode for getList(), use this mode to get a list of permissions.
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_PERMISSIONLIST = 6;
	
	/**
	 * List mode for getList(), use this mode to get a list of bans.
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_BANLIST = 7;
	
	/**
	 * List mode for getList(), use this mode to get a list of complains.
	 * Without arguments you get a list of all complains on the server.
	 * Use the optional argument to get complains of only one client.<br><br>
	 * Possible optional arguments:<br>
	 * <code>tcldbid=&lt;client database ID&gt;</code>
	 * <br><br>
	 * For example:<br>
	 * <code>tcldbid=2</code>
	 * @since 1.0
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_COMPLAINLIST = 8;
	
	/**
	 * List mode for getList(), use this mode to get a list of server group members.<br><br>
	 * Required argument:<br>
	 * <code>sgid=&lt;server group ID&gt;</code>
	 * <br><br>
	 * For example:<br>
	 * <code>sgid=6</code>
	 * <br><br>
	 * Possible optional argument:<br>
	 * <code>-names</code>
	 * @since 2.0.1
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 */
	public static final int LISTMODE_SERVERGROUPCLIENTLIST = 9;
	
	/**
	 * Info mode for getInfo(), use this mode to get informations about the current selected server.
	 * The second parameter is not needed, just use a number like 0.
	 * @see JTS3ServerQuery#getInfo(int, int)
	 */
	public static final int INFOMODE_SERVERINFO = 11;
	
	/**
	 * Info mode for getInfo(), use this mode to get informations about a channel.
	 * The second parameter has to be a channel id.
	 * @see JTS3ServerQuery#getInfo(int, int)
	 */
	public static final int INFOMODE_CHANNELINFO = 12;
	
	/**
	 * Info mode for getInfo(), use this mode to get informations about a client.
	 * The second parameter has to be a client id.
	 * @see JTS3ServerQuery#getInfo(int, int)
	 */
	public static final int INFOMODE_CLIENTINFO = 13;
	
	/**
	 * Info mode for getInfo(), use this mode to get informations about a client from the database.
	 * The second parameter has to be a client database id.
	 * @since 2.0.2
	 * @see JTS3ServerQuery#getInfo(int, int)
	 */
	public static final int INFOMODE_CLIENTDBINFO = 14;
	
	/**
	 * Permission list mode for getPermissionList(), use this mode to get a list of channel permissions.
	 * The second parameter has to be a channel id.
	 * @see JTS3ServerQuery#getPermissionList(int, int)
	 */
	public static final int PERMLISTMODE_CHANNEL = 21;
	
	/**
	 * Permission list mode for getPermissionList(), use this mode to get a list of server group permissions.
	 * The second parameter has to be a server group id.
	 * @see JTS3ServerQuery#getPermissionList(int, int)
	 */
	public static final int PERMLISTMODE_SERVERGROUP = 22;
	
	/**
	 * Permission list mode for getPermissionList(), use this mode to get a list of client permissions.
	 * The second parameter has to be a client database id.
	 * @see JTS3ServerQuery#getPermissionList(int, int)
	 */
	public static final int PERMLISTMODE_CLIENT = 23;
	
	/**
	 * Text message target mode for sendTextMessage() to send a message to a single client.
	 * @see JTS3ServerQuery#sendTextMessage(int, int, String)
	 */
	public static final int TEXTMESSAGE_TARGET_CLIENT = 1;

	/**
	 * Text message target mode for sendTextMessage() to send a message to a channel.
	 * @see JTS3ServerQuery#sendTextMessage(int, int, String)
	 */
	public static final int TEXTMESSAGE_TARGET_CHANNEL = 2;
	
	/**
	 * Text message target mode for sendTextMessage() to send a message to a virtual server.
	 * @see JTS3ServerQuery#sendTextMessage(int, int, String)
	 */
	public static final int TEXTMESSAGE_TARGET_VIRTUALSERVER = 3;
	
	/**
	 * Text message target mode for sendTextMessage() to send a message to all virtual servers.
	 * @see JTS3ServerQuery#sendTextMessage(int, int, String)
	 */
	public static final int TEXTMESSAGE_TARGET_GLOBAL = 4;
	
	/**
	 * Event mode for addEventNotify() to add server chat events (like receiving or sending chat messages).
	 * @since 0.7
	 * @see JTS3ServerQuery#addEventNotify(int, int)
	 */
	public static final int EVENT_MODE_TEXTSERVER = 1;
	
	/**
	 * Event mode for addEventNotify() to add channel chat events (like receiving or sending chat messages).
	 * @since 0.7
	 * @see JTS3ServerQuery#addEventNotify(int, int)
	 */
	public static final int EVENT_MODE_TEXTCHANNEL = 2;
	
	/**
	 * Event mode for addEventNotify() to add private chat events (like receiving or sending chat messages).
	 * @since 0.7
	 * @see JTS3ServerQuery#addEventNotify(int, int)
	 */
	public static final int EVENT_MODE_TEXTPRIVATE = 3;
	
	/**
	 * Event mode for addEventNotify() to add server events (like clients join or left the server).
	 * @since 0.7
	 * @see JTS3ServerQuery#addEventNotify(int, int)
	 */
	public static final int EVENT_MODE_SERVER = 4;
	
	/**
	 * Event mode for addEventNotify() to add channel events (like clients join or left the channel).<br><br>
	 * <b>Notice:</b><br>
	 * This mode also need to set a channel ID.
	 * @since 0.7
	 * @see JTS3ServerQuery#addEventNotify(int, int)
	 */
	public static final int EVENT_MODE_CHANNEL = 5;
	
	private boolean eventNotifyCheckActive = false;
	private TeamspeakActionListener actionClass = null;
	private int queryCurrentServerPort = -1;
	private int queryCurrentServerID = -1;
	private int queryCurrentClientID = -1;
	private int queryCurrentChannelID = -1;
	private String queryCurrentChannelPassword = null;
	private String queryCurrentClientName = null;
	
	private Socket socketQuery = null;
	private BufferedReader in = null;
	private PrintStream out = null;
	private PrintStream commLogOut = null;
	private PrintStream errLogOut = null;
	private Timer eventNotifyTimer = null;
	private TimerTask eventNotifyTimerTask = null;
	private String threadName = null;
	private SimpleDateFormat sdfDebug = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	public JTS3ServerQuery()
	{
		threadName = "";
	}
	
	/**
	 * New JTS3ServerQuery object which allows to set a prefix for the handleAction thread name.
	 * @param threadName Prefix of the thread name
	 * @since 1.0.8
	 */
	public JTS3ServerQuery(String threadName)
	{
		this.threadName = threadName + "_";
	}
	
	private synchronized void writeCommLog(String commMessage)
	{
		if (!DEBUG) return;
		if (DEBUG_COMMLOG_PATH == null) return;
		if (commMessage == null) return;
		
		try
		{
			if (commLogOut == null)
			{
				commLogOut = new PrintStream(DEBUG_COMMLOG_PATH, "UTF-8");
			}
			
			commLogOut.println(commMessage);
			commLogOut.flush();
		}
		catch (Exception e)
		{
			writeErrLog(e);
		}
	}
	
	private void writeErrLog(Exception e)
	{
		if (!DEBUG) return;
		if (DEBUG_ERRLOG_PATH == null) return;
		if (e == null) return;
		
		try
		{
			if (errLogOut == null)
			{
				errLogOut = new PrintStream(DEBUG_ERRLOG_PATH, "UTF-8");
			}
			
			errLogOut.println(sdfDebug.format(new Date(System.currentTimeMillis())));
			e.printStackTrace(errLogOut);
			errLogOut.flush();
		}
		catch (Exception ex)
		{
			if (DEBUG) ex.printStackTrace();
		}
	}
	
	private void eventNotifyRun()
	{
		if (eventNotifyCheckActive && isConnected())
		{
			try
			{
				if (in.ready())
				{
					String inputLine = in.readLine();
					if (inputLine.length() > 0)
					{
						writeCommLog("< " + inputLine);
						handleAction(inputLine);
					}
				}
			}
			catch (Exception ex)
			{
				writeErrLog(ex);
			}
		}
	}
	
	/**
	 * Set a new thread name prefix
	 * @param threadName - The new prefix
	 * @since 1.0.8
	 */
	public void changeThreadName(String threadName)
	{
		this.threadName = threadName + "_";
	}
	
	/**
	 * Set a class that should receive the Teamspeak events. This class must implement the TeamspeakActionListener interface.
	 * @param listenerClass - A class that implements the TeamspeakActionListener interface.
	 * @since 0.7
	 * @see TeamspeakActionListener
	 */
	public void setTeamspeakActionListener(TeamspeakActionListener listenerClass)
	{
		this.actionClass = listenerClass;
	}
	
	/**
	 * Remove the class from receiving Teamspeak events. This function also call removeAllEvents(), if needed.
	 * @since 0.7
	 */
	public void removeTeamspeakActionListener()
	throws TS3ServerQueryException
	{
		if (eventNotifyTimerTask != null)
		{
			removeAllEvents();
		}
		this.actionClass = null;
	}
	
	/**
	 * Activate a Teamspeak event notify.<br><br>
	 * <b>Notice:</b><br>
	 * You have to use setTeamspeakActionListener() first!
	 * @param eventMode Use an EVENT_MODE constant
	 * @param channelID A channel ID, only needed for EVENT_MODE_CHANNEL. Use any number for any other EVENT_MODE.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or no TeamspeakActionListener class was set using setTeamspeakActionListener().
	 * @throws IllegalArgumentException If invalid eventMode was given.
	 * @since 0.7
	 * @see JTS3ServerQuery#EVENT_MODE_CHANNEL
	 * @see JTS3ServerQuery#EVENT_MODE_SERVER
	 * @see JTS3ServerQuery#EVENT_MODE_TEXTCHANNEL
	 * @see JTS3ServerQuery#EVENT_MODE_TEXTPRIVATE
	 * @see JTS3ServerQuery#EVENT_MODE_TEXTSERVER
	 * @see JTS3ServerQuery#setTeamspeakActionListener(TeamspeakActionListener)
	 */
	public void addEventNotify(int eventMode, int channelID)
	throws TS3ServerQueryException
	{
		if (actionClass == null)
		{
			throw new IllegalStateException("Use setTeamspeakActionListener() first!");
		}
		
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		String command = null;
		
		if (eventMode == EVENT_MODE_SERVER)
		{
			command = "servernotifyregister event=server";
		}
		if (eventMode == EVENT_MODE_CHANNEL)
		{
			command = "servernotifyregister id=" + Integer.toString(channelID) + " event=channel";
		}
		if (eventMode == EVENT_MODE_TEXTSERVER)
		{
			command = "servernotifyregister event=textserver";
		}
		if (eventMode == EVENT_MODE_TEXTCHANNEL)
		{
			command = "servernotifyregister event=textchannel";
		}
		if (eventMode == EVENT_MODE_TEXTPRIVATE)
		{
			command = "servernotifyregister event=textprivate";
		}
		
		if (command == null)
		{
			throw new IllegalArgumentException("Invalid eventMode given!");
		}
		
		HashMap<String, String> hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("addEventNotify()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		if (eventNotifyTimerTask == null)
		{
			eventNotifyTimerTask = new TimerTask()
			{
				public void run()
				{
					eventNotifyRun();
				}
			};
			eventNotifyTimer.schedule(eventNotifyTimerTask, 200, 200);
		}
	}
	
	/**
	 * Removes all activated events.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @since 0.7
	 */
	public void removeAllEvents()
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		String command = "servernotifyunregister";
		
		HashMap<String, String> hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("removeAllEvents()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		if (eventNotifyTimerTask != null)
		{
			eventNotifyTimerTask.cancel();
			eventNotifyTimerTask = null;
		}
	}
	
	/**
	 * Open a query connection to the TS3 server. 
	 * @param ip IP or Host address to the TS3 server
	 * @param queryport Query Port of the TS3 server
	 * @throws IllegalStateException If already connected or an invalid response detected.
	 * @throws EOFException If the connection was closed unexpected (maybe banned by the TS3 server).
	 * @throws IOException If an I/O error occurs when creating the socket or streams.
	 * @throws UnsupportedEncodingException If the UTF-8 charset is not supported.
	 */
	public void connectTS3Query(String ip, int queryport)
	throws Exception
	{
		connectTS3Query(ip, queryport, null, -1);
	}
	
	/**
	 * Open a query connection to the TS3 server, you can set a local IP and port to bind the socket to it.
	 * @param ip IP or Host address to the TS3 server
	 * @param queryport Query Port of the TS3 server
	 * @param localIP Local IP address to bind the socket or <code>null</code> to bind to default IP. localPort must be set to use localIP.
	 * @param localPort Local Port to bind the socket, localIP must be set to use localPort.
	 * @throws IllegalStateException If already connected or an invalid response detected.
	 * @throws EOFException If the connection was closed unexpected (maybe banned by the TS3 server).
	 * @throws IOException If an I/O error occurs when creating the socket or streams.
	 * @throws UnsupportedEncodingException If the UTF-8 charset is not supported.
	 * @since 1.0.4
	 */
	public void connectTS3Query(String ip, int queryport, String localIP, int localPort)
	throws Exception
	{
		if (socketQuery != null)
		{
			throw new IllegalStateException("Close currently open connection first!");
		}
		
		try  // Open socket connection to TS3 telnet port
		{
			if (localIP != null && localPort >= 1 && localPort <= 65535)
			{
				socketQuery = new Socket(ip, queryport, InetAddress.getByName(localIP), localPort);
			}
			else
			{
				socketQuery = new Socket(ip, queryport);
			}
		}
		catch (Exception e)
		{
			socketQuery = null;
			throw e;
		}
		

		if (socketQuery.isConnected())
		{
			try
			{
				in = new BufferedReader(new InputStreamReader(socketQuery.getInputStream(), "UTF-8"));
				out = new PrintStream(socketQuery.getOutputStream(), true, "UTF-8");
				
				socketQuery.setSoTimeout(5000);
				
				String serverIdent = in.readLine();
				writeCommLog("< " + serverIdent);
				if (!serverIdent.equals("TS3"))
				{
					closeTS3Connection();
					throw new IllegalStateException("Server does not respond as TS3 server!");
				}
				
				socketQuery.setSoTimeout(500);  // Set the timeout for reading all useless lines after connecting
				
				try
				{
					String tmp = null;
					while (true)
					{
						tmp = in.readLine();
						if (tmp == null)
							throw new EOFException("Connection was closed by TS3 server, maybe banned?");
						
						writeCommLog("< " + tmp); // Catch useless lines after connecting
					}
				}
				catch (EOFException eof)
				{
					closeTS3Connection();
					throw eof;
				}
				catch (Exception e)
				{
				}
				
				socketQuery.setSoTimeout(40000);  // Set shorter timeout than default
			}
			catch (Exception e)
			{
				closeTS3Connection();
				throw e;
			}
		}
		else
		{
			try
			{
				socketQuery.close();
			}
			catch (Exception e)
			{
			}
			
			socketQuery = null;
			throw new IllegalStateException("Unknown connection error occurred!");
		}
		
		if (eventNotifyTimer != null)
		{
			eventNotifyTimer.cancel();
			eventNotifyTimer = null;
		}
		if (eventNotifyTimerTask != null)
		{
			eventNotifyTimerTask.cancel();
			eventNotifyTimerTask = null;
		}
		eventNotifyTimer = new Timer(true);
	}
	
	/**
	 * Login with an account.
	 * @param loginname Login name
	 * @param password Login password
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @since 0.8
	 */
	public void loginTS3(String loginname, String password)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		HashMap<String, String> hmIn;

		hmIn = doInternalCommand("login " + encodeTS3String(loginname) + " " + encodeTS3String(password));
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("loginTS3()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		updateClientIDChannelID();
	}
	
	/**
	 * Change the display name on the Teamspeak 3 server of this query connection. This name will be displayed on many actions like kickClient(), moveClient(), pokeClient() and sendTextMessage().
	 * @param displayName A String with the new display name of this connection.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If displayName is <code>null</code> or shorter than 3 characters.
	 * @since 0.8
	 */
	public void setDisplayName(String displayName)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		if (displayName == null || displayName.length() < 3)
		{
			throw new IllegalArgumentException("displayName null or shorter than 3 characters!");
		}
		
		HashMap<String, String> hmIn = doInternalCommand("clientupdate client_nickname=" + encodeTS3String(displayName));
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("setDisplayName()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		queryCurrentClientName = displayName;
	}

	/**
	 * Select a virtual server to work with.
	 * @param serverID A virtual server id
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 */
	public void selectVirtualServer(int serverID)
	throws TS3ServerQueryException
	{
		selectVirtualServer(serverID, false, false);
	}
	
	/**
	 * Select a virtual server to work with. This method allows to select the virtual server by id or port.
	 * @param server A virtual server id or port
	 * @param selectPort <code>true</code> if <code>server</code> is the virtual server port, <code>false</code> if <code>server</code> is the virtual server id.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @since 0.9
	 */
	public void selectVirtualServer(int server, boolean selectPort)
	throws TS3ServerQueryException
	{
		selectVirtualServer(server, selectPort, false);
	}
	
	/**
	 * Select a virtual server to work with. This method allows to select the virtual server by id or port.
	 * If the virtual server is offline, you can select the server in virtual mode.
	 * @param server A virtual server id or port
	 * @param selectPort <code>true</code> if <code>server</code> is the virtual server port, <code>false</code> if <code>server</code> is the virtual server id.
	 * @param virtual <code>true</code> if you want to select the virtual server in virtual mode (use this if the server is offline).
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @since 1.0.10
	 */
	public void selectVirtualServer(int server, boolean selectPort, boolean virtual)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		HashMap<String, String> hmIn;
		String command;
		if (selectPort)
		{
			command = "use port=" + Integer.toString(server);
		}
		else
		{
			command = "use sid=" + Integer.toString(server);
		}
		
		if (virtual) command += " -virtual";
					
		hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("selectVirtualServer()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		updateClientIDChannelID();
	}
	
	private void updateClientIDChannelID()
	throws TS3ServerQueryException
	{
		HashMap<String, String> hmIn = doInternalCommand("whoami");
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("updateClientIDChannelID()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		else if (hmIn.get("response") == null)
		{
			throw new IllegalStateException("No valid server response found!");
		}
		
		HashMap<String, String> response = parseLine(hmIn.get("response"));
		queryCurrentServerPort = Integer.parseInt(response.get("virtualserver_port"));
		queryCurrentServerID = Integer.parseInt(response.get("virtualserver_id"));
		queryCurrentClientID = Integer.parseInt(response.get("client_id"));
		queryCurrentClientName = response.get("client_nickname");
		queryCurrentChannelID = Integer.parseInt(response.get("client_channel_id"));
		queryCurrentChannelPassword = null;
	}
	
	/**
	 * Close the query connection.
	 */
	public void closeTS3Connection()
	{
		if (eventNotifyTimerTask != null)
		{
			eventNotifyTimerTask.cancel();
			eventNotifyTimerTask = null;
			eventNotifyTimer.cancel();
			eventNotifyTimer = null;
		}
		
		queryCurrentClientID = -1;
		queryCurrentServerID = -1;
		queryCurrentChannelPassword = null;
		
		try
		{
			if (out != null)
			{
				out.println("quit");
				out.close();
				out = null;
				writeCommLog("> quit");
			}
		}
		catch (Exception e)
		{
			writeErrLog(e);
		}
		
		if (commLogOut != null)
		{
			commLogOut.close();
			commLogOut = null;
		}
		
		try
		{
			if (in != null)
			{
				in.close();
				in = null;
			}
		}
		catch (Exception e)
		{
			writeErrLog(e);
		}
		
		try
		{
			if (socketQuery != null)
			{
				socketQuery.close();
				socketQuery = null;
			}
		}
		catch (Exception e)
		{
			writeErrLog(e);
		}
	}
	
	/**
	 * Delete a channel of the server.
	 * @param channelID The Channel ID to be deleted
	 * @param forceDelete <code>true</code> for a force channel delete (kicks also clients out of it), <code>false</code> to delete only an empty channel
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 */
	public void deleteChannel(int channelID, boolean forceDelete)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		HashMap<String, String> hmIn;
		String command = "channeldelete cid=" + Integer.toString(channelID) + " force=" + (forceDelete ? "1" : "0");
		
		hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("deleteChannel()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		if (queryCurrentChannelID == channelID)
		{
			updateClientIDChannelID();
		}
	}
	
	/**
	 * Move a client into another channel.
	 * @param clientID Current Client ID
	 * @param channelID Target Channel ID
	 * @param channelPassword Password of the target channel or <code>null</code> if no password needed
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 */
	public void moveClient(int clientID, int channelID, String channelPassword)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		HashMap<String, String> hmIn;
		String command = "clientmove clid=" + Integer.toString(clientID) + " cid=" + Integer.toString(channelID);
		
		if (channelPassword != null && channelPassword.length() > 0)
		{
			command += " cpw=" + encodeTS3String(channelPassword);
		}
		
		hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("moveClient()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		
		if (clientID == queryCurrentClientID)
		{
			queryCurrentChannelID = channelID;
			queryCurrentChannelPassword = channelPassword;
		}
	}
	
	/**
	 * Kick a client from channel or from server.
	 * @param cientID The Client ID to be kicked
	 * @param onlyChannelKick <code>true</code> for a channel kick, <code>false</code> for a server kick
	 * @param kickReason The kick reason
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 */
	public void kickClient(int cientID, boolean onlyChannelKick, String kickReason)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		HashMap<String, String> hmIn;
		String command = "clientkick reasonid=" + (onlyChannelKick ? "4" : "5");
		
		if (kickReason != null && kickReason.length() > 0)
		{
			command += " reasonmsg=" + encodeTS3String(kickReason);
		}
		
		command += " clid=" + Integer.toString(cientID);
		
		hmIn = doInternalCommand(command);
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("kickClient()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
	}
	
	/**
	 * Returns the current client ID of the query connection. You need this maybe to move the client or something else.
	 * @return The client ID or -1 if unknown.
	 * @since 0.6
	 */
	public int getCurrentQueryClientID()
	{
		return queryCurrentClientID;
	}
	
	/**
	 * Returns the current virtual server ID of the query connection.
	 * @return The virtual server ID or -1 if unknown.
	 * @since 0.6
	 */
	public int getCurrentQueryClientServerID()
	{
		return queryCurrentServerID;
	}
	
	/**
	 * Returns the current virtual server port of the query connection.
	 * @return The virtual server port or -1 if unknown.
	 * @since 2.0
	 */
	public int getCurrentQueryClientServerPort()
	{
		return queryCurrentServerPort;
	}
	
	/**
	 * Returns the current channel ID of the query client.
	 * @return The channel ID or -1 if unknown.
	 * @since 0.6
	 */
	public int getCurrentQueryClientChannelID()
	{
		return queryCurrentChannelID;
	}
	
	/**
	 * Returns the current client name of the query client.
	 * @return The client name or <code>null</code> if nothing set.
	 * @since 2.0
	 */
	public String getCurrentQueryClientName()
	{
		return queryCurrentClientName;
	}
	
	/**
	 * Sends a text message to a client / channel / virtual server / global (all virtual servers).<br><br>
	 * <b>Notice:</b><br>
	 * If you use a channel or virtual server id, which is not currently used by this connection, sendTextMessage() work as follow:<br>
	 * Switch to the channel or virtual server, sends the text message and switch back to old channel or virtual server.<br><br>
	 * If you want to send more messages to this channel or virtual server, just use selectVirtualServer() or moveClient() first.
	 * @param targetID The client, channel or virtual server id. Use any number for a global message.
	 * @param targetMode A text message target mode constant
	 * @param msg The message to be send
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If no message or an invalid targetMode given.
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_CLIENT
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_CHANNEL
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_VIRTUALSERVER
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_GLOBAL
	 * @see JTS3ServerQuery#moveClient(int, int, String)
	 * @see JTS3ServerQuery#selectVirtualServer(int)
	 */
	public void sendTextMessage(int targetID, int targetMode, String msg)
	throws TS3ServerQueryException
	{
		sendTextMessage(targetID, targetMode, msg, null);
	}
	
	/**
	 * Sends a text message to a client / channel / virtual server / global (all virtual servers).<br><br>
	 * <b>Notice:</b><br>
	 * If you use a channel or virtual server id, which is not currently used by this connection, sendTextMessage() work as follow:<br>
	 * Switch to the channel or virtual server, sends the text message and switch back to old channel or virtual server.<br><br>
	 * If you want to send more messages to this channel or virtual server, just use selectVirtualServer() or moveClient() first.
	 * @param targetID The client, channel or virtual server id. Use any number for a global message.
	 * @param targetMode A text message target mode constant
	 * @param msg The message to be send
	 * @param channelPassword Channel password, is only needed for a text message to channel. Use <code>null</code> if channel has no password or not a channel text message.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If no message or an invalid targetMode given.
	 * @since 0.6
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_CLIENT
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_CHANNEL
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_VIRTUALSERVER
	 * @see JTS3ServerQuery#TEXTMESSAGE_TARGET_GLOBAL
	 * @see JTS3ServerQuery#moveClient(int, int, String)
	 * @see JTS3ServerQuery#selectVirtualServer(int)
	 */
	public void sendTextMessage(int targetID, int targetMode, String msg, String channelPassword)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		if (msg == null || msg.length() == 0)
		{
			throw new IllegalArgumentException("No message given!");
		}
		
		if (targetMode < TEXTMESSAGE_TARGET_CLIENT || targetMode > TEXTMESSAGE_TARGET_GLOBAL)
		{
			throw new IllegalArgumentException("Invalid targetMode given!");
		}
		
		HashMap<String, String> hmIn = null;
		String command = null;
		if (targetMode == TEXTMESSAGE_TARGET_GLOBAL)
		{
			command = "gm msg=" + encodeTS3String(msg);
			
			hmIn = doInternalCommand(command);
		}
		else if (targetMode == TEXTMESSAGE_TARGET_CHANNEL)
		{
			int oldChannel = -1;
			String oldChannelPassword = null;
			if (targetID != queryCurrentChannelID)
			{
				oldChannel = queryCurrentChannelID;
				oldChannelPassword = queryCurrentChannelPassword;
				moveClient(queryCurrentClientID, targetID, channelPassword);
			}
			
			command = "sendtextmessage targetmode=" + Integer.toString(targetMode) + " msg=" + encodeTS3String(msg);
			
			hmIn = doInternalCommand(command);
			
			if (oldChannel != -1)
			{
				moveClient(queryCurrentClientID, oldChannel, oldChannelPassword);
			}
		}
		else if (targetMode == TEXTMESSAGE_TARGET_CLIENT)
		{
			command = "sendtextmessage targetmode=" + Integer.toString(targetMode) + " msg=" + encodeTS3String(msg) + " target=" + Integer.toString(targetID);
			
			hmIn = doInternalCommand(command);
		}
		else if (targetMode == TEXTMESSAGE_TARGET_VIRTUALSERVER)
		{
			int oldServer = -1;
			if (targetID != queryCurrentServerID)
			{
				oldServer = queryCurrentServerID;
				selectVirtualServer(targetID);
			}
			
			command = "sendtextmessage targetmode=" + Integer.toString(targetMode) + " msg=" + encodeTS3String(msg);
			
			hmIn = doInternalCommand(command);
			
			if (oldServer != -1)
			{
				selectVirtualServer(oldServer);
			}
		}
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("sendTextMessage()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
	}
	
	/**
	 * Send a single command to the TS3 server and read the response.<br><br>
	 * <b>Notice:</b><br>
	 * You can use parseRawData() to get the response String in a HashMap.<br>
	 * The returned HashMap can also contain a library error id and error message, if the connection to the Teamspeak 3 Server got lost while reading the response.<br><br>
	 * <b>Important:</b><br>
	 * Do not use the following commands here:<br>
	 * <code>channeldelete</code><br>
	 * <code>clientmove</code><br>
	 * <code>use</code><br>
	 * Please use deleteChannel(), moveClient() or selectVirtualServer() instead!
	 * @param command Any TS3 telnet command, see TS3 documentation or use the <code>help</code> command.
	 * @return An HashMap with 3 keys: <code>id</code> (error id), <code>msg</code> (error message) and <code>response</code> (unformatted server response).
	 * @throws IllegalArgumentException If command missing or not allowed.
	 * @throws IllegalStateException If not connected to a TS3 server or connection was closed while receiving the response.
	 * @see JTS3ServerQuery#deleteChannel(int, boolean)
	 * @see JTS3ServerQuery#moveClient(int, int, String)
	 * @see JTS3ServerQuery#selectVirtualServer(int)
	 */
	public HashMap<String, String> doCommand(String command)
	{
		if (command.startsWith("use ") || command.startsWith("clientmove ") || command.startsWith("channeldelete "))
		{
			throw new IllegalArgumentException("This commands are not allowed here. Please use deleteChannel(), moveClient() or selectVirtualServer()!");
		}
		
		return doInternalCommand(command);
	}
	
	private synchronized HashMap<String, String> doInternalCommand(String command)
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		if (command == null || command.length() == 0)
		{
			throw new IllegalArgumentException("No command given!");
		}
		
		eventNotifyCheckActive = false;
		
		writeCommLog("> " + command);
		out.println(command);
		return readIncoming();
	}
	
	/**
	 * Poke a client. This opens a message dialog at the selected Teamspeak 3 client with the given message.
	 * @param clientID The client ID, which should get the message.
	 * @param msg The message for the message dialog.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If no message given.
	 * @since 0.4
	 */
	public void pokeClient(int clientID, String msg)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		if (msg == null || msg.length() == 0)
		{
			throw new IllegalArgumentException("No message given!");
		}
		
		String command = "clientpoke clid=" + Integer.toString(clientID) + " msg=" + encodeTS3String(msg);
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("pokeClient()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
	}
	
	/**
	 * Add a complain to a client.
	 * @param clientDBID The client database ID, which should get the complain.
	 * @param msg The message of the complain.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If no message given.
	 * @since 1.0
	 */
	public void complainAdd(int clientDBID, String msg)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		if (msg == null || msg.length() == 0)
		{
			throw new IllegalArgumentException("No message given!");
		}
		
		String command = "complainadd tcldbid=" + Integer.toString(clientDBID) + " message=" + encodeTS3String(msg);
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("complainAdd()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
	}
	
	/**
	 * Deletes complains from a client (from a specified sender).
	 * @param clientDBID The client database ID, which should get a complain removed.
	 * @param deleteClientDBID Delete complains submitted from this client database ID.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server.
	 * @throws IllegalArgumentException If no message given.
	 * @since 1.0
	 */
	public void complainDelete(int clientDBID, int deleteClientDBID)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		String command = "complaindel tcldbid=" + Integer.toString(clientDBID) + " fcldbid=" + Integer.toString(deleteClientDBID);
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("complainDelete()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
	}
	
	/**
	 * Check if connected to the TS3 server.
	 * @return <code>true</code> if connected, <code>false</code> if not.
	 */
	public boolean isConnected()
	{
		if (socketQuery == null || in == null || out == null)
		{
			return false;
		}
		
		return socketQuery.isConnected();
	}
	
	/**
	 * Parse unformatted response from TS3 server, like from the doCommand method.<br><br>
	 * <b>Notice:</b><br>
	 * Don't use this for help messages, since they are already formatted by the TS3 server!<br>
	 * If you only have a single line response, you can also use the parseLine() method!
	 * @param rawData The unformatted TS3 server response
	 * @return A Vector which contains a HashMap for each entry with the keys given by the TS3 Server.
	 * @throws NullPointerException If rawData is <code>null</code>
	 * @see JTS3ServerQuery#parseLine(String)
	 */
	public Vector<HashMap<String, String>> parseRawData(String rawData)
	{
		if (rawData == null)
		{
			throw new NullPointerException("rawData was null");
		}
		
		Vector<HashMap<String, String>> formattedData = new Vector<HashMap<String, String>>();
		
		StringTokenizer stEntries = new StringTokenizer(rawData, "|", false);
		while(stEntries.hasMoreTokens())
		{
			formattedData.addElement(parseLine(stEntries.nextToken()));
		}
		
		return formattedData;
	}
	
	/**
	 * Searching for clients in the TS3 client database, useful for the getInfo() method to request more information. 
	 * @param search The search string, you can use the % character as wildcard.
	 * @param isUID If the search string is a unique id, set <code>true</code> here. If not, set <code>false</code>.
	 * @return A Vector containing Integer numbers with the client database id. 
	 * @throws TS3ServerQueryException
	 * @since 2.0.2
	 * @see JTS3ServerQuery#getInfo(int, int)
	 */
	public Vector<Integer> searchClientDB(String search, boolean isUID)
	throws TS3ServerQueryException
	{
		if (search == null || search.length() == 0)
		{
			throw new IllegalArgumentException("No search string given!");
		}
		
		String command = "clientdbfind pattern=" + search + (isUID ? " -uid" : "");
		
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("searchClientDB()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		else if (hmIn.get("response") == null)
		{
			throw new IllegalStateException("No valid server response found!");
		}
		
		Vector<HashMap<String, String>> info = parseRawData(hmIn.get("response"));
		Vector<Integer> list = new Vector<Integer>();
		
		for (int i = 0; i < info.size(); i++)
		{
			try
			{
				list.addElement(Integer.parseInt(info.elementAt(i).get("cldbid")));
			}
			catch (Exception e)
			{
			}
		}
		
		return list;
	}
	
	/**
	 * Get Informations about a server, channel or client.<br><br>
	 * <b>Notice:</b><br>
	 * If you want server informations, the server will return informations only about the current selected virtual server. To get informations about another virtual server, just select first.
	 * @param infoMode An INFOMODE constant.
	 * @param objectID A channel or client ID, use any number for server informations.
	 * @return A HashMap with the informations as key / value pairs like in the TS3 server response.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 * @throws IllegalArgumentException If infoMode argument is invalid.
	 * @see JTS3ServerQuery#INFOMODE_CHANNELINFO
	 * @see JTS3ServerQuery#INFOMODE_CLIENTINFO
	 * @see JTS3ServerQuery#INFOMODE_CLIENTDBINFO
	 * @see JTS3ServerQuery#INFOMODE_SERVERINFO
	 * @see JTS3ServerQuery#selectVirtualServer(int)
	 */
	public HashMap<String, String> getInfo(int infoMode, int objectID)
	throws TS3ServerQueryException
	{
		String command = getCommand(infoMode, 2);
		
		if (command == null)
		{
			throw new IllegalArgumentException("Unknown infoMode!");
		}
		
		if (infoMode != INFOMODE_SERVERINFO)
		{
			command += Integer.toString(objectID);
		}
		
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("getInfo()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		else if (hmIn.get("response") == null)
		{
			throw new IllegalStateException("No valid server response found!");
		}
		
		HashMap<String, String> info = parseLine(hmIn.get("response"));
		
		return info;
	}
	
	/**
	 * Get informations about a permission ID.<br><br>
	 * If the permission ID was found, the HashMap will contain the following keys:<br>
	 * <code>permid</code> with the permission ID<br>
	 * <code>permname</code> with the permission name<br>
	 * <code>permdesc</code> with the permission description (may be empty, if not exist)
	 * @param permID A permission ID
	 * @return A HashMap with the information about the permission ID.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 */
	public HashMap<String, String> getPermissionInfo(int permID)
	throws TS3ServerQueryException
	{
		Vector<HashMap<String, String>> permList = getList(LISTMODE_PERMISSIONLIST);
		
		HashMap<String, String> retPermInfo = null;
		
		for (HashMap<String, String> permInfo : permList)
		{
			if (Integer.parseInt(permInfo.get("permid")) == permID)
			{
				retPermInfo = permInfo;
				break;
			}
		}
		
		return retPermInfo;
	}
	
	/**
	 * Get a list of permissions of a server group / channel / client.
	 * @param permListMode A PERMLISTMODE constant
	 * @param targetID A channel, client or server group ID
	 * @return A Vector which contains a HashMap for each entry with the keys given by the TS3 Server.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 * @throws IllegalArgumentException If permListMode argument is invalid.
	 * @see JTS3ServerQuery#PERMLISTMODE_CHANNEL
	 * @see JTS3ServerQuery#PERMLISTMODE_CLIENT
	 * @see JTS3ServerQuery#PERMLISTMODE_SERVERGROUP
	 */
	public Vector<HashMap<String, String>> getPermissionList(int permListMode, int targetID)
	throws TS3ServerQueryException
	{
		String command = getCommand(permListMode, 3);
		
		if (command == null)
		{
			throw new IllegalArgumentException("Unknown permListMode!");
		}
		
		command += Integer.toString(targetID);
		
		return getList(command);
	}
	
	/**
	 * Returns log entries.
	 * @param linesCount How many log entries should be returned, has to be between 1 and 100.
	 * @param reverse Return lines in reverse order of the log (newest entry first)?
	 * @param masterlog Return lines from master instance log? Set to false to get the log entries of the selected server! 
	 * @param beginpos Start position in bytes, default is 0.
	 * @return A Vector which contains a HashMap for each entry with the keys given by the TS3 Server.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 * @throws IllegalArgumentException If listLimitCount or beginpos argument is invalid.
	 * @since 0.4
	 */
	public Vector<HashMap<String, String>> getLogEntries(int linesCount, boolean reverse, boolean masterlog, int beginpos)
	throws TS3ServerQueryException
	{
		if (linesCount < 1 || linesCount > 100)
		{
			throw new IllegalArgumentException("listLimitCount has to be between 1 and 100!");
		}
		
		if (beginpos < 0)
		{
			throw new IllegalArgumentException("beginpos must be 0 or higher!");
		}
		
		String command = "logview lines=" + Integer.toString(linesCount) + " reverse=" + (reverse ? "1" : "0") + " instance=" + (masterlog ? "1" : "0") + " begin_pos=" + Integer.toString(beginpos);
		
		return getList(command);
	}
	
	/**
	 * Get a list from the TS3 server. Use LISTMODE constants to get the wanted list.
	 * @param listMode Use a LISTMODE constant
	 * @return A Vector which contains a HashMap for each entry with the keys given by the TS3 Server.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 * @throws IllegalArgumentException If listMode argument is invalid.
	 * @see JTS3ServerQuery#LISTMODE_BANLIST
	 * @see JTS3ServerQuery#LISTMODE_CHANNELLIST
	 * @see JTS3ServerQuery#LISTMODE_CLIENTDBLIST
	 * @see JTS3ServerQuery#LISTMODE_CLIENTLIST
	 * @see JTS3ServerQuery#LISTMODE_COMPLAINLIST
	 * @see JTS3ServerQuery#LISTMODE_PERMISSIONLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERGROUPLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERGROUPCLIENTLIST
	 */
	public Vector<HashMap<String, String>> getList(int listMode)
	throws TS3ServerQueryException
	{
		return getList(listMode, null);
	}
	
	/**
	 * Get a list from the TS3 server. Use LISTMODE constants to get the wanted list.<br><br>
	 * This method allows to pass many arguments separated with comma, see LISTMODE comments for possible arguments.
	 * @param listMode Use a LISTMODE constant
	 * @param arguments A comma separated list of arguments or a single argument for the LISTMODE. Or just <code>null</code> if no arguments needed.
	 * @return A Vector which contains a HashMap for each entry with the keys given by the TS3 Server.
	 * @throws TS3ServerQueryException If the TS3 server is returning an error code/message.
	 * @throws IllegalStateException If not connected to a TS3 server or invalid server response received.
	 * @throws IllegalArgumentException If listMode argument is invalid.
	 * @see JTS3ServerQuery#LISTMODE_BANLIST
	 * @see JTS3ServerQuery#LISTMODE_CHANNELLIST
	 * @see JTS3ServerQuery#LISTMODE_CLIENTDBLIST
	 * @see JTS3ServerQuery#LISTMODE_CLIENTLIST
	 * @see JTS3ServerQuery#LISTMODE_COMPLAINLIST
	 * @see JTS3ServerQuery#LISTMODE_PERMISSIONLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERGROUPLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERLIST
	 * @see JTS3ServerQuery#LISTMODE_SERVERGROUPCLIENTLIST
	 */
	public Vector<HashMap<String, String>> getList(int listMode, String arguments)
	throws TS3ServerQueryException
	{
		String command = getCommand(listMode, 1);
		
		if (command == null)
		{
			throw new IllegalArgumentException("Unknown listMode!");
		}
		
		if (arguments != null && arguments.length() > 1)
		{
			StringTokenizer st = new StringTokenizer(arguments, ",", false);
			String arg;
			while (st.hasMoreTokens())
			{
				arg = st.nextToken();
				if (checkListArguments(listMode, arg))
				{
					command += " " + arg;
				}
			}
		}
		
		return getList(command);
	}
	
	private Vector<HashMap<String, String>> getList(String command)
	throws TS3ServerQueryException
	{
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
				
		HashMap<String, String> hmIn = doInternalCommand(command);
		
		Vector<HashMap<String, String>> list;
		
		if (!hmIn.get("id").equals("0"))
		{
			throw new TS3ServerQueryException("getList()", hmIn.get("id"), hmIn.get("msg"), hmIn.get("extra_msg"), hmIn.get("failed_permid"));
		}
		else if (hmIn.get("response") == null)
		{
			throw new IllegalStateException("No valid server response found!");
		}
		
		list = parseRawData(hmIn.get("response"));
				
		return list;
	}
	
	private HashMap<String, String> readIncoming()
	{
		String inData = "";
		HashMap<String, String> hmIn = new HashMap<String, String>();
		String temp;
		
		if (!isConnected())
		{
			throw new IllegalStateException("Not connected to TS3 server!");
		}
		
		while (true)
		{
			try
			{
				temp = in.readLine();
				writeCommLog("< " + temp);
			}
			catch (SocketTimeoutException e1)
			{
				closeTS3Connection();
				throw new IllegalStateException("Closed TS3 Connection: " + e1.toString(), e1);
			}
			catch (SocketException e2)
			{
				closeTS3Connection();
				throw new IllegalStateException("Closed TS3 Connection: " + e2.toString(), e2);
			}
			catch (Exception e)
			{
				throw new IllegalStateException("Unknown exception: " + e.toString(), e);
			}
			
			if (temp == null)
			{
				closeTS3Connection();
				throw new IllegalStateException("null object, maybe connection to TS3 server interrupted.");
			}
			
			// Jump out of the loop when reached the end of the server response.
			if (temp.startsWith("error "))
			{
				break;
			}
			
			// Save non empty lines of the response and add a new line
			if (temp.length() > 2)
			{
				if (!handleAction(temp)) // Parse notify messages
				{
					if (inData.length() != 0)
					{
						inData += System.getProperty("line.separator", "\n");
					}
					inData += temp;
				}
			}
		}
		
		// Creates a hash map with the parsed error id and message.
		hmIn = parseLine(temp);
		if (hmIn == null)
		{
			throw new IllegalStateException("null object, maybe connection to TS3 server interrupted.");
		}
		else
		{
			// Puts the server response in the hash map.
			hmIn.put("response", inData);
		}
		
		eventNotifyCheckActive = true;
		return hmIn;
	}
	
	/**
	 * Escape all special characters for the TS3 server.<br>Use this for all Strings you use as value while using doCommand()!<br><br>
	 * <b>Important:</b><br>
	 * Almost all functions in this library do this already if needed. You only need this if you want to send an own command with doCommand().
	 * @param str The String which should be escaped.
	 * @return The escaped String
	 * @since 0.5
	 * @see JTS3ServerQuery#doCommand(String)
	 */
	public String encodeTS3String(String str)
	{
		str = str.replace("\\", "\\\\");
		str = str.replace(" ", "\\s");
		str = str.replace("/", "\\/");
		str = str.replace("|", "\\p");
		str = str.replace("\b", "\\b");
		str = str.replace("\f", "\\f");
		str = str.replace("\n", "\\n");
		str = str.replace("\r", "\\r");
		str = str.replace("\t", "\\t");

		Character cBell = new Character((char)7); // \a (not supported by Java)
		Character cVTab = new Character((char)11); // \v (not supported by Java)
		
		str = str.replace(cBell.toString(), "\\a");
		str = str.replace(cVTab.toString(), "\\v");
		
		return str;
	}
	
	/**
	 * Convert escaped characters to normal characters.<br>Use this for received String values after using doCommand()<br><br>
	 * <b>Important:</b><br>
	 * Almost all functions in this library do this already if needed. You only need this if you want to read the server response after using doCommand() without using parseRawData().
	 * @param str The String which should be unescaped.
	 * @return The unescaped String
	 * @since 0.5
	 * @see JTS3ServerQuery#doCommand(String)
	 * @see JTS3ServerQuery#parseRawData(String)
	 */
	public String decodeTS3String(String str)
	{
		str = str.replace("\\\\", "\\[$mksave]");
		str = str.replace("\\s", " ");
		str = str.replace("\\/", "/");
		str = str.replace("\\p", "|");
		str = str.replace("\\b", "\b");
		str = str.replace("\\f", "\f");
		str = str.replace("\\n", "\n");
		str = str.replace("\\r", "\r");
		str = str.replace("\\t", "\t");

		Character cBell = new Character((char)7); // \a (not supported by Java)
		Character cVTab = new Character((char)11); // \v (not supported by Java)
		
		str = str.replace("\\a", cBell.toString());
		str = str.replace("\\v", cVTab.toString());
		
		str = str.replace("\\[$mksave]", "\\");
		return str;
	}
	
	/**
	 * Parse an unformatted single line response from TS3 server, like from the doCommand method.<br><br>
	 * <b>Notice:</b><br>
	 * Don't use this for help messages, since they are already formatted by the TS3 server!<br>
	 * Also don't use this for lists, use getList() or parseRawData() instead!
	 * @param rawData The unformatted single line TS3 server response
	 * @return A HashMap for each entry with the keys given by the TS3 Server.
	 * @throws NullPointerException If rawData is <code>null</code>
	 * @see JTS3ServerQuery#getList(int)
	 * @see JTS3ServerQuery#getList(int, String)
	 * @see JTS3ServerQuery#parseRawData(String)
	 */
	public HashMap<String, String> parseLine(String line)
	{
		if (line == null || line.length() == 0)
		{
			return null;
		}
		
		StringTokenizer st = new StringTokenizer(line, " ", false);
		HashMap<String, String> retValue = new HashMap<String, String>();
		String key;
		String temp;
		int pos = -1;
		
		while (st.hasMoreTokens())
		{
			temp = st.nextToken();
			
			// The next 10 lines split the key / value pair at the equal sign and put this into the hash map.
			pos = temp.indexOf("=");
			
			if (pos == -1)
			{
				retValue.put(temp, "");
			}
			else
			{
				key = temp.substring(0, pos);
				retValue.put(key, decodeTS3String(temp.substring(pos+1)));
			}
		}
		
		return retValue;
	}
	
	private boolean checkListArguments(int listMode, String argument)
	{
		if (listMode == LISTMODE_CHANNELLIST)
		{
			if (argument.equalsIgnoreCase("-topic"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-flags"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-voice"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-limits"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-icon"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-secondsempty"))
			{
				return true;
			}
		}
		
		if (listMode == LISTMODE_CLIENTLIST)
		{
			if (argument.equalsIgnoreCase("-uid"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-away"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-voice"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-times"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-groups"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-info"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-icon"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-country"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-ip"))
			{
				return true;
			}
		}
		
		if (listMode == LISTMODE_SERVERLIST)
		{
			if (argument.equalsIgnoreCase("-uid"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-all"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-short"))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-onlyoffline"))
			{
				return true;
			}
		}
		
		if (listMode == LISTMODE_CLIENTDBLIST)
		{
			if (argument.startsWith("start=") && (argument.indexOf(" ") == -1))
			{
				return true;
			}
			if (argument.startsWith("duration=") && (argument.indexOf(" ") == -1))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-count"))
			{
				return true;
			}
		}
		
		if (listMode == LISTMODE_COMPLAINLIST)
		{
			if (argument.startsWith("tcldbid=") && (argument.indexOf(" ") == -1))
			{
				return true;
			}
		}
		
		if (listMode == LISTMODE_SERVERGROUPCLIENTLIST)
		{
			if (argument.startsWith("sgid=") && (argument.indexOf(" ") == -1))
			{
				return true;
			}
			if (argument.equalsIgnoreCase("-names"))
			{
				return true;
			}
		}
		
		return false;
	}
	
	private String getCommand(int mode, int listType)
	{
		if (listType == 1)
		{
			if (mode == LISTMODE_CHANNELLIST)
			{
				return "channellist";
			}
			else if (mode == LISTMODE_CLIENTDBLIST)
			{
				return "clientdblist";
			}
			else if (mode == LISTMODE_CLIENTLIST)
			{
				return "clientlist";
			}
			else if (mode == LISTMODE_PERMISSIONLIST)
			{
				return "permissionlist";
			}
			else if (mode == LISTMODE_SERVERGROUPLIST)
			{
				return "servergrouplist";
			}
			else if (mode == LISTMODE_SERVERLIST)
			{
				return "serverlist";
			}
			else if (mode == LISTMODE_BANLIST)
			{
				return "banlist";
			}
			else if (mode == LISTMODE_COMPLAINLIST)
			{
				return "complainlist";
			}
			else if (mode == LISTMODE_SERVERGROUPCLIENTLIST)
			{
				return "servergroupclientlist";
			}
		}
		else if (listType == 2)
		{
			if (mode == INFOMODE_SERVERINFO)
			{
				return "serverinfo";
			}
			else if (mode == INFOMODE_CHANNELINFO)
			{
				return "channelinfo cid=";
			}
			else if (mode == INFOMODE_CLIENTINFO)
			{
				return "clientinfo clid=";
			}
			else if (mode == INFOMODE_CLIENTDBINFO)
			{
				return "clientdbinfo cldbid=";
			}
		}
		else if (listType == 3)
		{
			if (mode == PERMLISTMODE_CHANNEL)
			{
				return "channelpermlist cid=";
			}
			else if (mode == PERMLISTMODE_CLIENT)
			{
				return "clientpermlist cldbid=";
			}
			else if (mode == PERMLISTMODE_SERVERGROUP)
			{
				return "servergrouppermlist sgid=";
			}
		}
		
		return null;
	}
	
	private boolean handleAction(final String actionLine)
	{
		if (!actionLine.startsWith("notify"))
		{
			return false;
		}
		
		if (actionClass != null)
		{
			final int pos = actionLine.indexOf(" ");
			
			if (pos != -1)
			{
				final String eventType = actionLine.substring(0, pos);

				Thread t = new Thread(new Runnable()
				{
					public void run()
					{
						try
						{
							actionClass.teamspeakActionPerformed(eventType, parseLine(actionLine.substring(pos+1)));
						}
						catch (Exception e)
						{
							writeErrLog(e);
						}
					}
				});
				t.setName(threadName + "handleAction");
				t.start();
			}
		}
		
		return true;
	}
}
