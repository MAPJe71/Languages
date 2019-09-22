/*
**  https://notepad-plus-plus.org/community/topic/18087/wrong-parsing-for-c-function
*/

if (ifconfig (IF_ETH0, IFS_IPADDR, syspar.net.myip, IFS_NETMASK, syspar.net.mask, IFS_ROUTER_SET, syspar.net.gw, IFS_UP, IFS_END))
{
    printf ("Failed to set IP address");
    syspar_init ();
    exit (0);
}