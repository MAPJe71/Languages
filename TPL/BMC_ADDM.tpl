// (c) Copyright 2010-2014 BMC Software, Inc. All rights reserved.
// 
// Contains pattern for ADDM 
//
tpl 1.13 module BMC.ADDM;

metadata
   origin := "TKU";
   tkn_name := "BMC Atrium Discovery and Dependency Mapping - Legacy";
    tree_path := 'System and Network Management Software', 'Change and Configuration Management Software', 'BMC', 'Atrium Discovery and Dependency Mapping - Legacy';
end metadata;

from Common_Functions import functions 1.0;

//
// Patterns: BMC Atrium Discovery and Dependency Mapping Server Manager Service
//

pattern ADDM_Manager_service 2.3
    '''
        This pattern models BMC Atrium Discovery and Dependency Mapping Server Manager service.

        The pattern triggers on a process where the command appears to be the td_manager.exe binary.

        It then:
        1. Queries the registry to identify the version
        2. Gets configuration file for ADDM associated database (Oracle/SQL)    
        3. Creates a Software Instance based on the discovered information
        4. Creates BAI of discovered information
        
        Supported Platforms:
        Windows

        Change History:
        2010-02-16 - Add publisher details to SI type;
        2010-11-05 - Improve linking to remote SIs (bug #13887);
        2012-07-19 - Implemented CommonFunctions to search for the related SI(US132668);
        2014-09-15 - Added short_name attribute to SI (TKU-2353)
    '''

    metadata
        publishers := "BMC";
        products := "Atrium Discovery and Dependency Mapping";
        categories := "Change and Configuration Management Software";
        known_versions := "1.6", "1.6.01", "1.6.02", "1.6.03", "7.5", "7.5.01", "7.5.01.01", "7.5.01.02", "7.5.01.03";
        urls := "http://www.bmc.com/products/product-listing/BMC-Atrium-Discovery-and-Dependency-Mapping.html";
    end metadata;

    overview
        tags TKU, BMC, ADDM, TD, TKU_2014_09_01;
    end overview;
    
    constants
        si_type := 'BMC ADDM Manager Service';
        short_si_type := 'BMC ADDM Manager';
    end constants;

    triggers
        on process := DiscoveredProcess where cmd matches windows_cmd "td_manager";
    end triggers;

    body
        host := model.host(process);
        hostname := host.name;
        install_location := "";
        full_version := "";
        product_version := "";    
        revision := "";
        patch := "";        
        db_server_name := "";
        database_type := "";        
        addm_db_file := "";
        addm_db_file_location := "";
        registry_install_location := "";
        config_file := "";
        
        // Check OS Architecture using registry key values x32 or x64
        // Get version information from the Registry        
        key_prefix := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\BMC Software\\Discovery';                           
        key_prefix_64bit := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\BMC Software\\Discovery';             

        display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');
        
        if display_version then
            log.debug("ADDM Discovered OS Architecture Type: 32x.");
        else
            key_prefix := key_prefix_64bit;
            display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');            
            if display_version then
                log.debug("ADDM Discovered OS Architecture Type: 64x.");
            end if;    
        end if;
        
        registry_install_location := discovery.registryKey(host, key_prefix + raw '\InstallDir');
        
        // Check that the display_version and install_location returned a registry node
        if display_version then
            full_version := "%display_version.value%";                     
            product_version := regex.extract(full_version, regex '(\d.\d)', raw '\1');            
            revision := regex.extract(full_version, regex '\d.\d\.(\d+)', raw '\1');             
            patch := regex.extract(full_version, regex '\d.\d\.\d+\.(\d+)', raw '\1');     
        end if;
        
        log.debug("ADDM Pattern full version: %full_version%.");
        log.debug("ADDM Pattern Display Patch: %patch%.");
        
        
        if registry_install_location and registry_install_location.value then
            
            log.debug("ADDM raw install location value: %registry_install_location.value%.");
        
            // Concate install location to file location     
            install_location := "%registry_install_location.value%";
            
            addm_db_file_location := '"%install_location%"\\config\\instances\\domain\\perform\\host\\manager\\database\\mib\\config.xml';                    
            log.debug("ADDM Database Configuration file is present at: %addm_db_file_location%.");    
            
            config_file := discovery.fileGet(process, addm_db_file_location);    
        end if;
        
        // log.debug("ADDM install location: %install_location.value%.");    
        // log.debug("ADDM Database Configuration file is present at: %addm_db_file_location%.");        
        
        // Using xpath extract the database url from the config.xml content 
        // 8th config property is Db URL
        database_host := "";
        database_port := "";
        database_server_name := "";
        database_type := "";
        
        if config_file and config_file.content then
        
            db_url := "";
            db_obj_type := "";
            db_data_type := "";

            db_url := xpath.evaluate(config_file.content, raw "/PropertySet/Property[@Name='DATABASE_URL']/@Value");

            if (db_url) then            
                log.debug("ADDM Database URL: %db_url%.");
                // Reading database type associated with ADDM
                db_obj_type := xpath.evaluate(config_file.content, raw "/PropertySet/Property[@Name='OBJECT_TYPE']/@Value");                

                if db_obj_type then
                    log.debug("ADDM object type for database: %db_obj_type%.");
                    database_type := regex.extract(db_obj_type[0], regex 'meta\:(\S+?):', raw '\1');            

                end if;

                log.debug("ADDM Database type: %database_type%.");

                // Obtain DB Server hostname and port
                database_host := regex.extract(db_url[0], regex 'dm.db.server\((\S+?)\)', raw '\1');
                database_port := regex.extract(db_url[0], regex 'dm.db.port\((\S+?)\)', raw '\1');
                
                if database_type = 'oracle' then                                    
                    database_server_name := regex.extract(db_url[0], regex 'name\((\S+?)\)', raw '\1');

                end if; 

            end if;

        end if;

        log.debug("ADDM Database host:  %database_host% .");
        log.debug("ADDM Database port:  %database_port% .");
        log.debug("ADDM Database server name:  %database_server_name% .");

        // Assign name based on the gathered information
        if product_version then
            name := "%si_type% %product_version% on %host.name%";
            short_name := "%short_si_type% %product_version%";
        else
            name := "%si_type% on %host.name%";
            short_name := short_si_type;
        end if;


        // Create software instance 
        addm_si := model.SoftwareInstance( key := "%si_type%/%host.key%",
                                name := name,
                                short_name := short_name,
                                type := si_type,
                                version := full_version,
                                product_version := product_version,
                                revision := revision,
                                patch  := patch);
        log.info("%si_type% SI modeled on %host.name%.");
    
        // Create Communication link between ADDM server and databse instance on other or local host
        if database_host and database_type then
        
            db_servers := [];
            db_type := '';
            if database_type = 'mssql' then
                db_type := 'Microsoft SQL Server';
            elif database_type = 'oracle' then
                db_type := 'Oracle Database Server';
            end if;
            
            log.debug("ADDM Pattern Creating database and ADDM server communication link.");
            db_servers_raw := functions.related_sis_search(host, database_host, db_type);
            if db_servers_raw and db_type = 'Microsoft SQL Server' and database_port then
                db_servers := search(in db_servers_raw where port = %database_port%);
            elif db_servers_raw and db_type = 'Oracle Database Server' and database_server_name then
                db_servers := search(in db_servers_raw where instance has subword %database_server_name%);
            end if;
            
            if db_servers then 
                model.rel.Communication(Client := addm_si, Server := db_servers);
            end if;
        end if; 
    end body;
end pattern;

//
// Patterns: BMC Atrium Discovery and Dependency Mapping  Client Service
//

pattern ADDM_Client_service 2.1
    '''
        This pattern models BMC Atrium Discovery and Dependency Mapping Client service.

        This pattern triggers on a process where the command appears to be the td_client.exe binary.

        It then:
        1. Queries the registry to identify the version 
        2. Creates a Software Instance based on the discovered information
        
        Supported Platforms:
        Windows

        Change History:
        2010-02-16 - Add publisher details to SI type
        2014-09-15 - Added short_name attribute to SI (TKU-2353)
    '''

    metadata
        publishers := "BMC";
        products := "Atrium Discovery and Dependency Mapping";
        categories := "Change and Configuration Management Software";
        known_versions := "1.6", "1.6.01", "1.6.02", "1.6.03", "7.5", "7.5.01", "7.5.01.01", "7.5.01.02", "7.5.01.03";
        urls := "http://www.bmc.com/products/product-listing/BMC-Atrium-Discovery-and-Dependency-Mapping.html";
    end metadata;    
    

    overview
        tags TKU, BMC, ADDM, TD, TKU_2014_07_01;
    end overview;
    
    constants
        si_type := 'BMC ADDM Client Service';
        short_si_type := 'BMC ADDM Client';
    end constants;

    triggers
        on process := DiscoveredProcess where cmd matches windows_cmd "td_client";
    end triggers;

    body
        host := model.host(process);
        hostname := host.name;
        product_version := "";
        revision := "";
        patch := "";  
        full_version := "";
        key :="";

        // Get version information from the Registry
        
        // Check OS Architecture using registry key values x32 or x64
        // Get version information from the Registry        
        key_prefix := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\BMC Software\\Discovery';    
        key_prefix_64bit := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\BMC Software\\Discovery';             

        display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');
        
        if display_version then
            log.debug("ADDM 7.5 Discovered  OS Architecture  Type:  32x .");
        else
            key_prefix := key_prefix_64bit;
            display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');            
            if display_version then
                log.debug("ADDM Discovered OS Architecture  Type:  64x .");
            end if;
        end if;
        
        // Check that the display_version and install_location returned a registry node
        if display_version then
        
            full_version := "%display_version.value%";
            
            product_version := regex.extract(full_version, regex '(\d.\d)', raw '\1');
            
            revision := regex.extract(full_version, regex '\d.\d\.(\d+)', raw '\1');
            
            patch := regex.extract(full_version, regex '\d.\d\.\d+\.(\d+)', raw '\1');
        end if;
        
        // Assign name based on the gathered information
        if product_version then
            name := "%si_type% %product_version% on %host.name%";
            short_name := "%short_si_type% %product_version%";
        else
            name := "%si_type% on %host.name%";
            short_name := short_si_type;
        end if;
        
        // Create software instance 
        addm_client_si := model.SoftwareInstance( key := "%si_type%/%host.key%",
                                name := name,
                                short_name := short_name,
                                type := si_type,
                                version := full_version,
                                product_version := product_version,
                                revision := revision,
                                patch  := patch);
                                
        log.info("%si_type% SI modeled on %host.name%.");
        

        //  create client - server relationship to ADDM Client Service to Manager Service SI on this host
        addm_manager_si:= search(in host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance
                                 where type="BMC ADDM Manager Service");

        if addm_manager_si then
            model.rel.Communication(Client := addm_client_si, Server := addm_manager_si);
        end if;
    end body;
end pattern;


//
// Patterns: BMC Atrium Discovery and Dependency Mapping Agent Service
//

pattern ADDM_Agent_service 2.1
    '''
        This pattern models BMC Atrium Discovery and Dependency Mapping Agent service.

        This pattern triggers on a process where the command appears to be the td_agent.exe binary.

        It then:
        1. Queries the registry to identify the version 
        2. Creates a Software Instance based on the discovered information
        
        Supported Platforms:
        Windows

        Change History:
        2010-02-16 - Add publisher details to SI type
        2014-09-15 - Added short_name attribute to SI (TKU-2353)
    '''

    metadata
        publishers := "BMC";
        products := "Atrium Discovery and Dependency Mapping";
        categories := "Change and Configuration Management Software";
        known_versions := "1.6", "1.6.01", "1.6.02", "1.6.03", "7.5", "7.5.01", "7.5.01.01", "7.5.01.02", "7.5.01.03";
        urls := "http://www.bmc.com/products/product-listing/BMC-Atrium-Discovery-and-Dependency-Mapping.html";
    end metadata;

    overview
        tags TKU, BMC, ADDM, TD, TKU_2014_09_01;
    end overview;
    
    constants
        si_type := 'BMC ADDM Agent Service';
        short_si_type := 'BMC ADDM Agent';
    end constants;

    triggers
        on process := DiscoveredProcess where cmd matches windows_cmd "td_agent";
    end triggers;

    body

        host := model.host(process);
        hostname := host.name;
        product_version := "";
        revision := "";
        patch := "";  
        full_version := "";
        key := "";

        // Check OS Architecture using registry key values x32 or x64
        // Get version information from the Registry
        key_prefix := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\BMC Software\\Discovery';
        key_prefix_64bit := 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\BMC Software\\Discovery';

        display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');
        
        if display_version then
            log.debug("ADDM Discovered OS Architecture Type: 32x.");
        else
            key_prefix := key_prefix_64bit;
            display_version := discovery.registryKey(host, key_prefix + raw '\CurrentVersion');
            if display_version then
                log.debug("ADDM Discovered OS Architecture Type: 64x.");
            end if;    
        end if;

        // Check that the display_version and install_location returned a registry node
        if display_version then
        
            full_version := "%display_version.value%";
            
            product_version := regex.extract(full_version, regex '(\d.\d)', raw '\1');
            
            revision := regex.extract(full_version, regex '\d.\d\.(\d+)', raw '\1');
            
            patch := regex.extract(full_version, regex '\d.\d\.\d+\.(\d+)', raw '\1');

        end if;
            
        
        // Assign name based on the gathered information
        if product_version then
            name := "%si_type% %product_version% on %host.name%";
            short_name := "%short_si_type% %product_version%";
        else
            name := "%si_type% on %host.name%";
            short_name := short_si_type;
        end if;

        // Create software instance 
        addm_agent_si := model.SoftwareInstance(  key := "%si_type%/%host.key%" ,
                                name := name,
                                short_name := short_name,
                                type := si_type,
                                version := full_version,
                                product_version := product_version,
                                revision := revision,
                                patch  := patch);
                                
        log.info("%si_type% SI modeled on %host.name%.");
        
        //  create agent - server relationship to ADDM agent Service to Manager Service SI on this host
        addm_manager_si:= search(in host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance
                                 where type="BMC ADDM Manager Service");

        if addm_manager_si then
            model.rel.Communication(Client := addm_agent_si, Server := addm_manager_si);
        end if;
    end body;
end pattern;

//
// Patterns: BMC Atrium Discovery and Dependency Mapping Business Application
//
pattern ADDM_BAI 3.2
    """
        This pattern triggers on the creation of an SI where the type is
        'ADDM Manager Service'
 
        It then:
        1. Searches the datastore to identify the host the SI is running on
        2. Creates a Software Instance based on the discovered information
        3. Relates the Software Instance with the SI that caused the pattern
        to be triggered
 
        Change History:
        2010-02-16 - Add publisher details to SI type in trigger and searches.
                   - Additionally, SI key improved so that version upgrade does not cause
                     a new BAI to be generated
        2012-10-10 - SI is to be created instead of BAI (Zilla defect 16347)
        2013-03-20 - Minor logs and comments update
        2014-09-15 - Corrected SI's type attribute. Added short_name attribute to SI (TKU-2353)
 
        Supported Platforms:
        Windows
    """

    metadata
        publishers := "BMC";
        products := "Atrium Discovery and Dependency Mapping";
        categories := "Change and Configuration Management Software";
        known_versions := "1.6", "1.6.01", "1.6.02", "1.6.03", "7.5", "7.5.01", "7.5.01.01", "7.5.01.02", "7.5.01.03";
        urls := "http://www.bmc.com/products/product-listing/BMC-Atrium-Discovery-and-Dependency-Mapping.html";
    end metadata;

    overview
        tags TKU, BMC, ADDM, TD, TKU_2014_09_01;
    end overview;

    constants
        key_si_type := "BMC ADDM";
        si_type := "BMC Atrium Discovery and Dependency Mapping (Legacy)";
        short_si_type := "BMC ADDM";
    end constants;
    
    triggers
        on addm_manager_si := SoftwareInstance created, confirmed where type = "BMC ADDM Manager Service";
    end triggers;


    body
        host := model.host(addm_manager_si);

        full_version := addm_manager_si.version;
        product_version := addm_manager_si.product_version;
        revision := addm_manager_si.revision;
        patch := addm_manager_si.patch;

        // Set the name variable
        if product_version then
            name := "%si_type% %product_version% on %host.name%";
            short_name := "%short_si_type% %product_version%";
        else
            name := "%si_type% on %host.name%";
            short_name := short_si_type;
        end if;

        addm_si := model.SoftwareInstance(key := "%key_si_type%/%host.key%",
                                          name := name,
                                          short_name := short_name,
                                          type := si_type,
                                          version := full_version,
                                          product_version := product_version,
                                          revision := revision,
                                          patch := patch
                                         );

        log.debug("Created %name%, will now try to create relationships");

        // Create containment relationship between the ADDM Second Order SI and the ADDM SIs

        addm_client_si := search(in host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance
                                where type = 'BMC ADDM Client Service' );

        addm_agent_si := search(in host traverse Host:HostedSoftware:RunningSoftware:SoftwareInstance
                                where type = 'BMC ADDM Agent Service' );

        model.setContainment(addm_si, addm_manager_si);
        if addm_client_si then
            model.setContainment(addm_si, addm_client_si);
        end if;
        if addm_agent_si then
            model.setContainment(addm_si, addm_agent_si);
        end if;
        // Deleting BAI created by old versions of patterns
        bai_candidates := search(in addm_manager_si traverse ContainedSoftware:SoftwareContainment:SoftwareContainer:BusinessApplicationInstance
                                        where type = "%si_type%");
        if bai_candidates then
            model.destroy(bai_candidates);
        end if;
    end body;
end pattern;

// BMC Atrium Discovery and Dependency Mapping Server Manager Service

identify ADDM_services 1.2
    tags inference.simple_identity.ADDM.Manager.Service;
    DiscoveredProcess cmd -> simple_identity;
    windows_cmd 'td_manager' -> 'BMC Atrium Discovery and Dependency Mapping Server Manager Service';
    windows_cmd 'td_agent' -> 'BMC Atrium Discovery and Dependency Mapping Server Agent Service';
    windows_cmd 'td_client' -> 'BMC Atrium Discovery and Dependency Mapping Server Client Service';
end identify;
