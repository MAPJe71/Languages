#!/home/knoppix/rebol/rebol -qs 

    REBOL [ 
        Title: "Auto FTP" 
        File: %myftp.r 
        Date: 02-Sep-2003 
        Purpose: {Uploads 3 files from local server to an FTP site} 
    ]

    ; internet setup
    set-net [ 
        carlos.lorenz@bol.com.br 
        pop.bol.com.br 
    ]

    ; URL of FTP server
    site: ftp://user:pass@meuservidor.com.br/ 

    ; files on local server
    arquivos-servidor2: [ 
        %/servidor2/c/f/xgrade/enviar/tvmagazine.zip 
        %/servidor2/c/f/xgrade/enviar/hands.zip 
        %/servidor2/c/f/xgrade/enviar/ina_telecom.zip 
    ] 

    ; destination directories on FTP server
    diretorios-ftp: [ 
        %public_html/e/users/vmagazine 
        %public_html/e/users/hands 
        %public_html/e/users/ina_telecom 
    ] 

    ; emails to be notified
    email-responsaveis: [ 
        usuario@exampletvmagazine.com.br 
        usuario@examplehands.com.br 
        usuario@exampleuol.com.br 
    ] 

    print newline 

    ; traverses the local server files block 
    foreach file arquivos-servidor2 [ 

        ; picks first element of destination 
        ; directories and emails blocks
        dest: first diretorios-ftp 
        resp: first email-responsaveis 

        ; mounts nomearquivo 
        set [diretorio nomearquivo] split-path file 
        nomearq: rejoin [site dest "/" nomearquivo] 

        ; deletes old files at FTP server
        if exists? nomearq[ 
            delete nomearq 
        ] 

        ; transfers the files
        write/binary nomearq read/binary file 

        ; prints a warning message to the screen
        print [file "sucessfully uploaded!"]

        ; assembles the body of the standard message 
        message: rejoin [ 
            "Hello user," 
            newline 
            "This is an automatic message." 
            newline 
            "The file ["nomearquivo"] was updated and is ready for download." 
            newline 
            newline 
            "Have a nice day!" 
            newline 
            "Your REBOL Script" 
        ] 

        ; sends emails
        send/subject resp message "Download notification" 

        ; get next element at destination directories and emails blocks
        diretorios-ftp: next diretorios-ftp 
        email-responsaveis: next email-responsaveis 
    ] 

    print newline 
    print "File transfer finished" 
    wait 3
    quit