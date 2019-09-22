// (c) Copyright 2011 - 2015 BMC Software Inc. All rights reserved.
//
// Module with common functions, which can be applied from another modules
tpl 1.6 module Common_Functions;

metadata
    origin := "TKU";
    tree_path := 'ADDM Operation', 'Model Construction', 'Common functions';
end metadata;

definitions functions 1.23
    '''User functions

        Change History:
        2013-03-06 - Updated get_max_version() for TKU_2013_03_01 release
        2013-04-24 - Updated identify_host() for TKU_2013_05_01 release
        2013-05-29 - Updated identify_host() for TKU_2013_06_01 release
        2013-09-04 - Updated identify_host() for TKU_2013_09_01 release
                     Updated related_sis_search() for TKU_2013_09_01 release
                     Added new validate_host_address_format(), domain_lookup(), identify_host_perform_search() and
                     related_sis_search_extended() functions for TKU_2013_09_01 release
        2013-11-18 - updated identify_host() and added new identify_host_extended() for TKU_2013_11_01
        2013-12-17 - added new identify_host_perform_search_in_scope(), related_sis_search_on_multiple_hosts() for TKU_2013_12_01
                     updated identify_host_perform_search() for TKU_2013_12_01
        2014-02-25 - added new sort_list() for TKU_2014_03_01
        2014-04-16 - updated related_sis_search() and related_sis_search_extended() functions for TKU_2014_04_01
        2014-04-16 - updated sort_list() function for TKU_2014_05_01
        2014-10-23 - added related_si_types_search() and
                     updated related_sis_search(), related_sis_search_extended() for TKU_2014_11_01
        2014-12-08  - updated function get_exe_cwd_path() for TKU_2014_12_01
        2015-02-09  - added run_priv_cmd() and has_process() functions
    '''
    type := function;

    define validate_host_address_format(rel_host_address) -> rel_host_address
    """ Function validates <rel_host_address> format.
        If <rel_host_address> does not meet requirements(regex '^[\da-z\:][\w\:\.\-]*$') then functions returns empty string
    """
        rel_host_address := text.lower(text.strip(rel_host_address));
        if rel_host_address and not rel_host_address matches regex '^[\da-z\:][\w\:\.\-]*$' then
            log.debug("rel_host_address:'%rel_host_address%' contains illegal characters!");
            rel_host_address := '';
        end if;

        return rel_host_address;
    end define;

    define domain_lookup(host, rel_host_address_domain) -> rel_host_address_ip
    ''' Function resolves domain to IP address using "nslookup" command
    '''
        rel_host_address_ip := '';
        timeout := 4; //seconds

        if not rel_host_address_domain matches regex '^\d+(?:\.\d+){3}$' or not rel_host_address_domain has substring ':' then
            start_time := time.current();

            nslookup_cmd := discovery.runCommand(host, "nslookup -timeout=%timeout% %rel_host_address_domain%");
            // with -retry=1 - is not working
            if nslookup_cmd and nslookup_cmd.result then
                rel_host_address_ip := regex.extract(nslookup_cmd.result, regex '(?is)Name:\s*\S+\s*Address(?:es)?:\s*([^\s,;]+)', raw'\1' );
            end if;
            delta_time_tics := time.toTicks(time.current()) - time.toTicks(start_time);

            log.debug("Domain '%rel_host_address_domain%' is resolved to '%rel_host_address_ip%' from host %host.name%. Execution time:" + number.toText(delta_time_tics/10000) + "ms" );
        end if;

        return rel_host_address_ip;
    end define;

    define identify_host_perform_search(host, rel_host_address) -> related_host
    '''Function searches for one "rel_host_address" Host,
            where "rel_host_address" could be:
            - loopback, like "localhost", "127.0.0.1" or "::1"
            - IPv4 or IPv6 address
            - full domain name, like "full.domain.com"
            - short host_name/host_alias, like "orcl9_host"

        HOST attributes description:
            - name, usually contains "short host_name", but could be a "full domain name" as well
            - local_fqdn, usually contains "full domain name", in rare cases - "short host_name"
            - __all_ip_addrs - is a list of all hosted ips, equal to: host.#DeviceWithInterface:DeviceInterface:InterfaceOfDevice:NetworkInterface.ip_addr
            - __all_dns_names - is a list of hosted domains, equal to: host.#DeviceWithInterface:DeviceInterface:InterfaceOfDevice:NetworkInterface.fqdns

        Function returns ONE Host node or "none" value.

        Change history:
        2013-05-01 - added support for IP allocations in virtual environments (QM001787784)
        2013-05-29 - updated inefficient search queries(#3,4) for ADDM 9.0 (QM001790964)
        2013-09-04 - updated conditions for search queries(#1)
        2013-12-12 - removed lower from search queries. All host.name and host.local_fqdn should be stored in lower case by default.
    '''
        related_host := none;
        related_hosts := [];

        log_message := "";
        log.debug("Try to find Host node matches '%rel_host_address%'");

        if rel_host_address matches regex '^(?i)localhost(?:\.|$)' or
           rel_host_address in [host.name, host.local_fqdn, '127.0.0.1', '::1' ] or
           rel_host_address in host.__all_ip_addrs or
           rel_host_address in host.__all_dns_names then
            // 1. will return a host node

            log_message := "identified as local host (search #1)";
            related_hosts := [host];
        elif rel_host_address matches regex '^\d+(?:\.\d+){3}$' or rel_host_address has substring ':' then

            // 2. Search by IP address in HOST.__all_ip_addrs attribute

            log_message := "found by IP address in '__all_ip_addrs' attribute (search #2)";
            related_hosts := search( Host where __all_ip_addrs has subword %rel_host_address%);

            if related_hosts and size(related_hosts) = 2 then
                // Manage the case when have a deal with Virtual Environments: 'Solaris Zone Container', 'Virtuozzo/OpenVZ' and maybe other
                // when the same IP address can be bound to VM and its Host_Container at the same time
                vm := none;
                vm_container := none;
                if related_hosts[0].virtual and not related_hosts[1].virtual then
                    vm := related_hosts[0];
                    vm_container := related_hosts[1];
                elif not related_hosts[0].virtual and related_hosts[1].virtual then
                    vm := related_hosts[1];
                    vm_container := related_hosts[0];
                // 'else' case in not considered since in this case something in really wrong with network architecture
                end if;

                if vm and vm_container then
                    // confirm that <vm_container> is a container for <vm>
                    vm_container_cand := search( in vm traverse ContainedHost:HostContainment:HostContainer:SoftwareInstance traverse RunningSoftware:HostedSoftware:Host:Host ) ;
                    if vm_container_cand and vm_container_cand[0] = vm_container then
                        related_hosts := [vm];
                    end if;
                // 'else' case in not considered since in this case something in really wrong with network architecture
                end if;
            end if;

        elif rel_host_address has substring '.' then
            // 3. Search by full domain name in a)HOST.local_fqdn, b)HOST.name and c)HOST.__all_dns_names attributes

            log_message := "found by domain_name in 'local_fqdn','name' or '__all_dns_names' attributes (search #3)";
            related_hosts := search( Host where local_fqdn = %rel_host_address% or
                                                name = %rel_host_address% or
                                                %rel_host_address% in __all_dns_names);
        else
            // 4. Search by host_name/host_alias in HOST.name attribute

            log_message := "found by host_name in 'name' attributes (search #4)";
            related_hosts := search( Host where name = %rel_host_address% );

            if not related_hosts and host.dns_domain then
                // 5. Search by "host_name + host.dns_domain" in a)HOST.local_fqdn, b)HOST.name and c)HOST.__all_dns_names attributes

                log_message := "found by 'host_name + host.dns_domain' in 'local_fqdn','name' or '__all_dns_names' attributes (search #5)";
                full_rel_host_address := "%rel_host_address%.%host.dns_domain%";
                related_hosts := search( Host where local_fqdn = %full_rel_host_address% or
                                                    name = %full_rel_host_address% or
                                                    %full_rel_host_address% in __all_dns_names);
            end if;

            if not related_hosts then
                // 6. if nothing found then run EXTENDED search by host_name in HOST.name and HOST.local_fqdn attributes

                log_message := "found by 'hostname.*' in 'name' or 'local_fqdn' attributes (search #6)";
                rel_host_address_regex := '(?i)^%rel_host_address%\\.';
                related_hosts := search (Host where (name has subword %rel_host_address% or local_fqdn has subword %rel_host_address%) and
                                                    (name matches %rel_host_address_regex% or local_fqdn matches %rel_host_address_regex%));
            end if;

        end if;

        if related_hosts then
            if size(related_hosts) = 1 then
                related_host := related_hosts[0];
                log.debug("'%related_host.name%' host is %log_message%");
            else
                all_host_names := [];
                for found_host in related_hosts do
                    list.append(all_host_names, found_host.name);
                end for;
                log.debug("Unable to uniquely identify the host by %rel_host_address%! Hosts:%all_host_names% are %log_message%");
            end if;
        else
            log.debug("Unable to find the host!");
        end if;
        return related_host;
    end define;

    define identify_host_perform_search_in_scope(host, rel_host_address, hosts_scope) -> related_host
    '''Function searches for one "rel_host_address" Host in some narrowed scope of hosts,
       but not on all available hosts like identify_host_perform_search()

       Function returns ONE Host node or "none" value.
    '''
        related_host := none;
        related_hosts := [];

        log_message := "";
        log.debug("Try to find Host node matches '%rel_host_address%'");

        if rel_host_address matches regex '^(?i)localhost(?:\.|$)' or
           rel_host_address in [host.name, host.local_fqdn, '127.0.0.1', '::1' ] or
           rel_host_address in host.__all_ip_addrs or
           rel_host_address in host.__all_dns_names then
            // 1. will return a host node

            log_message := "identified as local host (search #1)";
            related_hosts := [host];
        elif rel_host_address matches regex '^\d+(?:\.\d+){3}$' or rel_host_address has substring ':' then

            // 2. Search by IP address in HOST.__all_ip_addrs attribute

            log_message := "found by IP address in '__all_ip_addrs' attribute (search #2)";
            related_hosts := search( in hosts_scope where __all_ip_addrs has subword %rel_host_address%);

            if related_hosts and size(related_hosts) = 2 then
                // Manage the case when have a deal with Virtual Environments: 'Solaris Zone Container', 'Virtuozzo/OpenVZ' and maybe other
                // when the same IP address can be bound to VM and its Host_Container at the same time
                vm := none;
                vm_container := none;
                if related_hosts[0].virtual and not related_hosts[1].virtual then
                    vm := related_hosts[0];
                    vm_container := related_hosts[1];
                elif not related_hosts[0].virtual and related_hosts[1].virtual then
                    vm := related_hosts[1];
                    vm_container := related_hosts[0];
                // 'else' case in not considered since in this case something in really wrong with network architecture
                end if;

                if vm and vm_container then
                    // confirm that <vm_container> is a container for <vm>
                    vm_container_cand := search( in vm traverse ContainedHost:HostContainment:HostContainer:SoftwareInstance traverse RunningSoftware:HostedSoftware:Host:Host ) ;
                    if vm_container_cand and vm_container_cand[0] = vm_container then
                        related_hosts := [vm];
                    end if;
                // 'else' case in not considered since in this case something in really wrong with network architecture
                end if;
            end if;

        elif rel_host_address has substring '.' then
            // 3. Search by full domain name in a)HOST.local_fqdn, b)HOST.name and c)HOST.__all_dns_names attributes

            log_message := "found by domain_name in 'local_fqdn','name' or '__all_dns_names' attributes (search #3)";
            related_hosts := search( in hosts_scope where local_fqdn = %rel_host_address% or
                                                name = %rel_host_address% or
                                                %rel_host_address% in __all_dns_names);
        else
            // 4. Search by host_name/host_alias in HOST.name attribute

            log_message := "found by host_name in 'name' attributes (search #4)";
            related_hosts := search( in hosts_scope where name = %rel_host_address% );

            if not related_hosts and host.dns_domain then
                // 5. Search by "host_name + host.dns_domain" in a)HOST.local_fqdn, b)HOST.name and c)HOST.__all_dns_names attributes

                log_message := "found by 'host_name + host.dns_domain' in 'local_fqdn','name' or '__all_dns_names' attributes (search #5)";
                full_rel_host_address := "%rel_host_address%.%host.dns_domain%";
                related_hosts := search( in hosts_scope where local_fqdn = %full_rel_host_address% or
                                                              name = %full_rel_host_address% or
                                                              %full_rel_host_address% in __all_dns_names);
            end if;

            if not related_hosts then
                // 6. if nothing found then run EXTENDED search by host_name in HOST.name and HOST.local_fqdn attributes

                log_message := "found by 'hostname.*' in 'name' or 'local_fqdn' attributes (search #6)";
                rel_host_address_regex := '(?i)^%rel_host_address%\\.';
                related_hosts := search (in hosts_scope where (name has subword %rel_host_address% or local_fqdn has subword %rel_host_address%) and
                                                              (name matches %rel_host_address_regex% or local_fqdn matches %rel_host_address_regex%));
            end if;

        end if;

        if related_hosts then
            if size(related_hosts) = 1 then
                related_host := related_hosts[0];
                log.debug("'%related_host.name%' host is %log_message%");
            else
                all_host_names := [];
                for found_host in related_hosts do
                    list.append(all_host_names, found_host.name);
                end for;
                log.debug("Unable to uniquely identify the host by %rel_host_address%! Hosts:%all_host_names% are %log_message%");
            end if;
        else
            log.debug("Unable to find the host!");
        end if;
        return related_host;
    end define;

    define identify_host(host, rel_host_address, extended) -> related_host
    '''Function searches for one "rel_host_address" Host,

        Change history:
        2013-09-04 - block with search queries is moved to separated function.
                     added call of domain_lookup() function if initial search is failed
        2013-11-18 - moved call of domain_lookup() into separated identify_host_extended() function in order to prevent creation of big .pq files.
                     function does not process extended["domain_lookup"] argument any more
    '''
        related_host := none;

        rel_host_address := functions.validate_host_address_format(rel_host_address);

        if host and rel_host_address then
            related_host := functions.identify_host_perform_search(host, rel_host_address);
        else
            log.debug("Local Host node or rel_host_address:'%rel_host_address%' is not specified! 'identify_host' function is stopped");
        end if;

        return related_host;
    end define;

    define identify_host_extended(host, rel_host_address, extended) -> related_host
    '''Function searches for one "rel_host_address" Host.

        Extended functionality:
            Function tries to resolve domain to IP address if initial search is not successful and extended["domain_lookup"] is specified.
    '''
        related_host := none;

        rel_host_address := functions.validate_host_address_format(rel_host_address);

        if host and rel_host_address then
            related_host := functions.identify_host_perform_search(host, rel_host_address);
            if not related_host
               and extended and 'domain_lookup' in extended and extended['domain_lookup'] = true
               and (not rel_host_address matches regex '^\d+(?:\.\d+){3}$' or not rel_host_address has substring ':' ) then

                rel_host_address_ip := functions.domain_lookup(host, rel_host_address);
                if rel_host_address_ip then
                    related_host := functions.identify_host_perform_search(host, rel_host_address_ip);
                end if;
            end if;
        else
            log.debug("Local Host node or rel_host_address:'%rel_host_address%' is not specified! 'identify_host' function is stopped");
        end if;

        return related_host;
    end define;

    define related_sis_search(host, rel_host_address, rel_si_type) -> related_sis
    '''Function searches for all SIs with "rel_si_type" TYPE on "rel_host_address" host,

        Function returns SIs node set or empty list [].

        Change history:
        2013-09-04 - updated format for identify_host() function.
        2014-04-16 - added special behaviour for Mysql Database Server (QM001817560 & QM001817561)
        2014-10-23 - special behaviour for Mysql is completely moved to RDBMS_Functions module (TKU-2319)
    '''
        related_sis := [];
        if host and rel_host_address and rel_si_type then
            log.debug("Try to find all related '%rel_si_type%' SIs on host '%rel_host_address%'");

            related_host := functions.identify_host(host, rel_host_address, table());
            if related_host then
                related_sis := search (in related_host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance where type = %rel_si_type%);
            end if;
        else
            log.debug("rel_si_type:'%rel_si_type%' or rel_host_address:'%rel_host_address%' is not specified! Related sis search function is stopped");
        end if;

        return related_sis;
    end define;

    define related_sis_search_on_multiple_hosts(host, rel_host_addresses, rel_si_type) -> related_sis
    '''Function searches for all SIs with "rel_si_type" TYPE on multiple "rel_host_addresses" hosts.

        Unlike related_sis_search(), this function tries to
        - find all hosts with <rel_si_type> is running on
        - and among them find needed hosts which are listed in <rel_host_addresses>

        Function returns SIs node set or empty list [].
    '''
        related_sis := [];

        if not (host and rel_host_addresses and rel_si_type) then
            log.debug("rel_si_type:'%rel_si_type%' or rel_host_addresses:'%rel_host_addresses%' is not specified! Related sis search function is stopped");
            return related_sis;
        end if;

        log.debug("Try to find all related '%rel_si_type%' SIs on host '%rel_host_addresses%'");

        related_hosts := [];
        related_hosts_with_si := search(SoftwareInstance where type = %rel_si_type% traverse RunningSoftware:HostedSoftware:Host:Host);
        if related_hosts_with_si then
            for rel_host_address in rel_host_addresses do
                rel_host_address_validated := functions.validate_host_address_format(rel_host_address);
                if rel_host_address_validated then
                    related_host := functions.identify_host_perform_search_in_scope(host, rel_host_address_validated, related_hosts_with_si);
                    if related_host then
                        list.append(related_hosts, related_host);
                    end if;
                end if;
            end for;
        end if;

        if related_hosts then
            related_sis := search (in related_hosts traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance where type = %rel_si_type%);
        end if;

        return related_sis;
    end define;

    define related_sis_search_extended(host, rel_host_address, rel_si_type, extended) -> related_sis
    '''Function searches for all SIs with "rel_si_type" TYPE on "rel_host_address" host,

        Function is able to pass 'domain_lookup' option to identify_host() function

        Function returns SIs node set or empty list [].

        Change history:
        2013-11-18 - changed call of identify_host() function with identify_host_extended()
        2014-04-16 - added special behaviour for Mysql Database Server (QM001817560 & QM001817561)
        2014-10-23 - special behaviour for Mysql is completely moved to RDBMS_Functions module (TKU-2319)
    '''
        related_sis := [];
        if host and rel_host_address and rel_si_type then
            log.debug("Try to find all related '%rel_si_type%' SIs on host '%rel_host_address%'");

            related_host := functions.identify_host_extended(host, rel_host_address, extended);

            if related_host then
                related_sis := search (in related_host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance where type = %rel_si_type%);
            end if;
        else
            log.debug("rel_si_type:'%rel_si_type%' or rel_host_address:'%rel_host_address%' is not specified! Related sis search function is stopped");
        end if;

        return related_sis;
    end define;

    define related_si_types_search(host, rel_host_address, rel_si_types) -> related_sis
    '''Function searches for all SIs with different TYPEs in "rel_si_types" LIST on "rel_host_address" host

        Function returns SI nodes set or empty list [].
    '''
        related_sis := [];
        if host and rel_host_address and rel_si_types then
            log.debug("Try to find all related '%rel_si_types%' SIs on host '%rel_host_address%'");

            related_host := functions.identify_host(host, rel_host_address, table());
            if related_host then
                related_sis := search (in related_host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance where type in %rel_si_types%);
            end if;
        else
            log.debug("rel_si_types:'%rel_si_types%' or rel_host_address:'%rel_host_address%' is not specified! Related sis search function is stopped");
        end if;

        return related_sis;
    end define;

    define path_normalization(host,install_root) -> install_root
    'Current function determines "~" in the path, normalizes it and returns back full path'

        normalized_install_root := '';
        normalized := true;
        parts := text.split(install_root, '\\');
        for part in parts do
            if part matches regex '~' then
                if normalized_install_root matches regex '\w:$' then
                    normalizing_cmd := discovery.runCommand(host, 'cmd /c dir /x "%normalized_install_root%\\"');
                else
                    normalizing_cmd := discovery.runCommand(host, 'cmd /c dir /x "%normalized_install_root%"');
                end if;
                if normalizing_cmd and normalizing_cmd.result then
                    modified_part := text.replace(part, '$', '\\$');
                    normalized_element := regex.extract(normalizing_cmd.result, expand(regex '(?i)%modified_part%\s+([\S ]+)\r*\n', modified_part), raw '\1');
                    if normalized_element then
                        normalized_install_root := normalized_install_root + '\\' + normalized_element;
                    else
                        log.info('Could not normalize the path');
                        // In this case the pattern uses 'normalized' flag, as 'break' operator doesn't work (zilla bug #13097)
                        normalized := false;
                    end if;
                else
                    log.info('Could not normalize the path');
                    // In this case the pattern uses 'normalized' flag, as 'break' operator doesn't work (zilla bug #13097)
                    normalized := false;
                end if;
            elif part matches regex '\w:$' then
                normalized_install_root := part;
            else
                normalized_install_root := normalized_install_root + '\\' + part;
            end if;
        end for;
        if normalized_install_root and normalized then
            install_root := normalized_install_root;
        end if;
        log.debug('Normalized installation directory is: %install_root%');

        return install_root;
    end define;

    define links_management(si_node, recently_found_sis, related_si_type)
    'Function that manages Communication and Dependency links between the current SI and related SIs'
        // recently_found_sis - Found related SIs with 'related_si_type', which should be linked or which links should be updated
        // Determining relationship
        relation_type := '';
        existent_srvs := '';
        links := '';
        // Searching for the existent connections and determining relationship type
        existent_srvs := search(in si_node traverse Peer:Communication:Peer:SoftwareInstance
                                           where type = related_si_type);
        if not existent_srvs then
            existent_srvs := search(in si_node traverse Client:Communication:Server:SoftwareInstance
                                               where type = related_si_type);
            if not existent_srvs then
                existent_srvs := search(in si_node traverse Dependant:Dependency:DependedUpon:SoftwareInstance
                                                   where type = related_si_type);
                if not existent_srvs then
                    existent_srvs := search(in si_node traverse Server:Communication:Client:SoftwareInstance
                                                       where type = related_si_type);
                    if not existent_srvs then
                        existent_srvs := search(in si_node traverse DependedUpon:Dependency:Dependant:SoftwareInstance
                                                           where type = related_si_type);
                        if not existent_srvs then
                            log.debug('No known relationships found');
                        else
                            relation_type := 'depupon-dependant';
                        end if;
                    else
                        relation_type := 'server-client';
                    end if;
                else
                    relation_type := 'dependant-depupon';
                end if;
            else
                relation_type := 'client-server';
            end if;
        else
            relation_type := 'peer-peer';
        end if;
        if relation_type then
            // Creating new links and updating/removing old ones
            if recently_found_sis then
                // Removing obsolete links
                if existent_srvs then
                    new_keys := [];
                    for recently_found_si in recently_found_sis do
                        list.append(new_keys, recently_found_si.key);
                    end for;
                    for existent_srv in existent_srvs do
                        if not existent_srv.key in new_keys then
                            if relation_type = 'peer-peer' then
                                links := search(in existent_srv step in Peer:Communication
                                                                where #:Peer:SoftwareInstance.key = "%si_node.key%");
                            elif relation_type = 'client-server' then
                                links := search(in existent_srv step in Client:Communication
                                                                where #:Server:SoftwareInstance.key = "%si_node.key%");
                            elif relation_type = 'dependant-depupon' then
                                links := search(in existent_srv step in Dependant:Dependency
                                                                where #:DependedUpon:SoftwareInstance.key = "%si_node.key%");
                            elif relation_type = 'server-client' then
                                links := search(in existent_srv step in Server:Communication
                                                                where #:Client:SoftwareInstance.key = "%si_node.key%");
                            elif relation_type = 'depupon-dependant' then
                                links := search(in existent_srv step in DependedUpon:Dependency
                                                                where #:Dependant:SoftwareInstance.key = "%si_node.key%");
                            end if;
                            if links then
                                model.destroy(links);
                            end if;
                        end if;
                    end for;
                end if;
                // Creating new links or updating existent
                if relation_type = 'peer-peer' then
                    model.rel.Communication(Peer := si_node, Peer := recently_found_sis);
                elif relation_type = 'client-server' then
                    model.rel.Communication(Client := si_node, Server := recently_found_sis);
                elif relation_type = 'dependant-depupon' then
                    model.rel.Dependency(Dependant := si_node, DependedUpon := recently_found_sis);
                elif relation_type = 'server-client' then
                    model.rel.Communication(Server := si_node, Client := recently_found_sis);
                elif relation_type = 'depupon-dependant' then
                    model.rel.Dependency(DependedUpon := si_node, Dependant := recently_found_sis);
                end if;
            else
                // Removing obsolete links
                if relation_type = 'peer-peer' then
                    links := search(in si_node step in Peer:Communication
                                               where #:Peer:SoftwareInstance.type = related_si_type);
                elif relation_type = 'client-server' then
                    links := search(in si_node step in Client:Communication
                                               where #:Server:SoftwareInstance.type = related_si_type);
                elif relation_type = 'dependant-depupon' then
                    links := search(in si_node step in Dependant:Dependency
                                               where #:DependedUpon:SoftwareInstance.type = related_si_type);
                elif relation_type = 'server-client' then
                    links := search(in si_node step in Server:Communication
                                               where #:Client:SoftwareInstance.type = related_si_type);
                elif relation_type = 'depupon-dependant' then
                    links := search(in si_node step in DependedUpon:Dependency
                                               where #:Dependant:SoftwareInstance.type = related_si_type);
                end if;
                if links then
                    model.destroy(links);
                end if;
            end if;
        end if;
    end define;

    define get_cleanedup_path(path, os) -> path_norm
    'Function which normalizes directory path by removing "\.\", "\..\", etc.'
        //  COMMENTS
        //  requirements:
        //    1. Only full paths are applied for this function
        //    2. Network path cannot be used, like "\\\\193.169.188.101\\c$"
        //    3. function does not normalize paths with triples like "///" or "\\\\\\"
        // output:
        // function returns normalized path or empty one, if it does not meet requirements

        if os = "Windows" then
            if path matches regex "^\w:" then
                path := text.lower(path);
                path := text.replace(path, "/", "\\");
                path := text.replace(path, "\\\\", "\\");
                path := text.replace(path, "\\.\\", "\\");
                parent_dirs_counter := regex.extractAll(path, regex "(\\\.\.)");
                for counter in parent_dirs_counter do
                    parent_dir := regex.extract(path, regex "(\\[^\\]+\\\.\.(?:\\|$))", raw "\1");
                    if parent_dir then
                        path :=  text.replace(path, parent_dir, "\\");
                    end if;
                end for;
            else
                path := "";
            end if;
        else
            if path matches regex "^/" then
                path := text.replace(path, "//", "/");
                path := text.replace(path, "/./", "/");
                parent_dirs_counter := regex.extractAll(path, regex "(/\.\.)");
                for counter in parent_dirs_counter do
                    parent_dir := regex.extract(path, regex "(/[^/]+/\.\.(?:/|$))", raw "\1");
                    if parent_dir then
                        path :=  text.replace(path, parent_dir, "/");
                    end if;
                end for;
                remove_last_slash := regex.extract(path, regex "(/.+)/$", raw "\1");
                if remove_last_slash then
                    path := remove_last_slash;
                end if;
            else
                path := "";
            end if;
        end if;
        if path and path matches regex '(?:\\|/)$' then
            path := regex.extract(path, regex '((?:\w:|/).+)(?:\\|/)$', raw '\1');
        end if;
        log.debug("Path: '%path%' - after the normalization");
        return path;

    end define;

    define get_max_version(ver1, ver2) -> maxversion
    '''functions.get_max_version  - compares to version strings like "10.08.10" and "7.18" and returns the biggest one

       Change History:
       2013-03-06 - Now handles the situation where one of the inputs is an empty string and the other is not.
    '''

        if ver1 matches regex "^\d+(?:\.\d+)*$" and ver2 matches regex "^\d+(?:\.\d+)*$" then
            maxversion := ver1; // by default

            ver1_nums := text.split(ver1, ".");
            ver2_nums := text.split(ver2, ".");

            dif := size(ver2_nums) - size(ver1_nums);
            if dif > 0 then
                short_ver := ver1_nums;
                last_index := size(ver1_nums) - 1;
            else
                short_ver := ver2_nums;
                last_index := size(ver2_nums) - 1;
            end if;

            index := 0;
            for ver in short_ver do
                if text.toNumber(ver1_nums[index]) < text.toNumber(ver2_nums[index]) then
                    maxversion := ver2;
                    break ;
                elif text.toNumber(ver1_nums[index]) > text.toNumber(ver2_nums[index]) then
                    break ;
                elif index = last_index and dif > 0 then // check if this is the last element
                    maxversion := ver2;
                end if;
                index := index + 1;
            end for;
        elif ver1 matches regex "^\d+(?:\.\d+)*$" and ver2 = "" then
            log.debug("Defaulting to version string '%ver1%' being higher as other input is an empty string");
            maxversion := ver1;
        elif ver1 = "" and ver2 matches regex "^\d+(?:\.\d+)*$" then
            log.debug("Defaulting to version string '%ver2%' being higher as other input is an empty string");
            maxversion := ver2;
        else
            log.debug("The version strings '%ver1%' and '%ver2%' don't match regex '^\d+(?:\.\d+)*$'");
            maxversion := "";
        end if;
        return maxversion;
    end define;

    define get_exe_cwd_path(process, expected_binary_name) -> exe_path, cwd_path
    '''
        Function tries to obtain:
        - full process command path (exe_path)
            and/or
        - current working directory (cwd_path) - directory the process was started from

        cwd_path could be obtained only from "/proc/<pid>" directory.
        exe_path could be obtained using "/proc/<pid>" directory (example above), or using command "/usr/bin/pmap <pid>"

        Example, what we see in the process list:
        USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
        tideway   2478  0.0  1.2 262612 23808 ?        S    Nov15   0:00 python Launch.pyc --daemon start

        1. method: using "/proc/<pid>" directory
            [tideway@localhost ~]$ ls -la /proc/2478
            lrwxrwxrwx   1 tideway tideway 0 Nov 19 16:06 cwd -> /usr/tideway/python/ui/web
            lrwxrwxrwx   1 tideway tideway 0 Nov 19 16:06 exe -> /usr/tideway/bin/python2.7

        2. method: using command "/usr/bin/pmap <pid>"
            [tideway@localhost ~]$ pmap 2478
            0000000000400000   1488K r-x--  /usr/tideway/bin/python2.7

        3. method:(for AIX only) using command "svmon -P <pid> -O format=nolimit,filename=on,filtertype=client"

        Limitations:
            - all methods require PRIV_RUNCMD be configured.
            - cwd_path can be obtained only for such OSs: Linux, AIX, Solaris

        Arguments:
            expected_binary_name - is optional attribute and used for correct full path extraction from pmap/svmon commands output,
                when process name significantly differs from real executed binary file name:
                example: if process.cmd = "ora_smon_newsid" BUT real exe_path = "/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/oracle", then <expected_binary_name> must be set to "oracle".

                <expected_binary_name> argument is not needed when <real file name> starts with process name, like
                    - process.cmd = "python"    and exe_path = "/usr/bin/python2.8"
                    - process.cmd = "sendmail:" and exe_path = "/usr/sbin/sendmail.sendmail"

        Change History:
        2014-12-08 - Removed 2 arguments priv_function and pmap_path,
                     Because all configuration blocks with pmap were deleted from patterns (TKU-2342)
    '''
        host := model.host(process);
        exe_path := "";
        cwd_path := "";

        //  try to use "ls -la /proc/<pid>"
        ls := "";
        ls_cmd := "";
        if host.os_type has subword "Linux" or host.os_type = "AIX" then
            ls := "-la /proc/%process.pid% | grep -";  // grep is used for making plain text output, otherwise Result is: [00mlrwxrwxrwx 1 root root 0 Jan 12 18:38 [01;36m/proc/26848/exe[00m -> [01;32m/usr/local/nginx/sbin/nginx[00m[m
        elif host.os_type = "Solaris" then
            ls := "-lF /proc/%process.pid% | grep -";
        end if;

        if ls then
            ls_cmd := discovery.runCommand(host, "PRIV_LS %ls%");
            if ls_cmd and ls_cmd.result then
                cwd_path := regex.extract(ls_cmd.result, regex '(?m)cwd -> (/\S.*\S)', raw '\1');
                exe_path := regex.extract(ls_cmd.result, regex '(?m)exe -> (/\S.*\S)', raw '\1');
            end if;
        end if;

        if not exe_path then
            if expected_binary_name then
                file_name := expected_binary_name;
            else
                file_name := regex.extract(process.cmd, regex '([^/]+?):?$', raw '\1');
                // Some process could have ':' at the end, so ignore it. Examples "postgres:", "sendmail:"
            end if;

            //  try to use svmon for AIX command
            if host.os_type = "AIX" then
                svmon_cmd := discovery.runCommand(host, "PRIV_RUNCMD svmon -P %process.pid% -O format=nolimit,filename=on,filtertype=client");
                if svmon_cmd and svmon_cmd.result then
                    exe_path := regex.extract(svmon_cmd.result, expand(regex '\s(/\S.*\S/%file_name%[\w\.\-\:]*)', file_name ), raw '\1');
                end if;
            else
                // Try to use pmap
                pmap_cmd := discovery.runCommand(host, 'PRIV_RUNCMD pmap %process.pid%');
                if pmap_cmd and pmap_cmd.result then
                    exe_path := regex.extract(pmap_cmd.result, expand(regex '\s(/\S.*\S/%file_name%[\w\.\-\:]*)', file_name ), raw '\1');
                end if;
            end if;
        end if;

        return exe_path, cwd_path;
    end define;

    define sort_list(list) -> sorted_list
    '''Function returns sorted list of strings

        Change History:
        2014-04-16 - added case when <list> contains only one element(QM001827800)
    '''
        sorted_list := list;
        len := size(list);

        if len > 1 then
            count := 0;
            for item in list do

                min_item_index := count;
                min_item := sorted_list[min_item_index];

                count_internal := count + 1 ;
                for internal_item in list do
                    if sorted_list[count_internal] < min_item then
                        min_item_index := count_internal;
                        min_item := sorted_list[count_internal];
                    end if;

                    count_internal := count_internal + 1;
                    if count_internal = len then
                        break; // if last element
                    end if;
                end for;

                if not min_item_index = count then
                    sorted_list[min_item_index] := sorted_list[count];
                    sorted_list[count] := min_item;
                end if;

                count := count + 1;
                if count = len - 1 then
                    break; // if pre-last element
                end if;

            end for;
        end if;
        return sorted_list;
    end define;

    define run_priv_cmd(host, command, priv_cmd := 'PRIV_RUNCMD') -> result
        '''
        Run the given command, using privilege elevation on UNIX, if required.
        The command is first run as given. If this fails, produces no output
        and the platform is UNIX then the command is executed again using the
        given priv_cmd.

        Parameters:
            host     - Host node
            command  - Command string. Must be valid when prefixed with
                       the privilege command
            priv_cmd - Optional privilege command. Defaults to PRIV_RUNCMD

        Returns the command output (NOT the node) on success, or none
        if the command fails. The returned command string may be empty.
        '''

        // Run the command without any prvilege elevation
        result := discovery.runCommand(host, command);

        // If the command failed on a UNIX host as we have a privilege command
        // prefix, run the command again
        if (not result or not result.result) and
           priv_cmd and host.os_class = 'UNIX' then
            result := discovery.runCommand(host, "%priv_cmd% %command%");
        end if;

        // Did the command fail?
        if not result then
            return none;
        end if;

        // Return result, may be empty
        return result.result;
    end define;

    define has_process(host, command) -> result
        '''
        Returns true if the given process is running on the given host.
        '''

        results := search(in host
            traverse InferredElement:Inference:Associate:DiscoveryAccess
            traverse DiscoveryAccess:DiscoveryAccessResult:DiscoveryResult:ProcessList
            traverse List:List:Member:DiscoveredProcess
               where cmd = %command%);

        if not results then
            return false;
        end if;

        return true;
    end define;

end definitions;

