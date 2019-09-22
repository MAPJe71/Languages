    copy-dir: func [source dest] [
        if not exists? dest [make-dir/deep dest]
        foreach file read source [
            either find file "/" [
                copy-dir source/:file dest/:file
            ][
                print file
                write/binary dest/:file read/binary source/:file
            ]
        ]
    ]