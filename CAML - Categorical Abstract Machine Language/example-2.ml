let boatGenO () =
    for boat=0 to 4 do
        let length = boatLength.(boat) in
        let isPlaced = ref false in
        while not !isPlaced do
            if (Random.bool()) then begin
                let x = Random.int (10-length) and
                    y = Random.int 10 in
                let canBePlaced = ref true in
                for i=0 to pred length do
                    if plateauO.(x+i).(y)<>" " then canBePlaced := false;
                done;
                if !canBePlaced then begin
                    for d=0 to pred length do
                        plateauO.(x+d).(y) <- (boatSymbol.(boat));
                    done;
                    tabBateauO := Array.concat [!tabBateauO; [|(x, y, (boat, false), 1)|]];
                    isPlaced := true;
                end;
            end else begin
                let y = Random.int (10-length) and
                    x = Random.int 10 in
                let canBePlaced = ref true in
                for i=0 to pred length do
                    if plateauO.(x).(y+i)<>" " then canBePlaced := false;
                done;
                if !canBePlaced then begin
                    for d=0 to pred length do
                        plateauO.(x).(y+d) <- (boatSymbol.(boat));
                    done;
                    tabBateauO := Array.concat [!tabBateauO; [|(x, y, (boat, false), 0)|]];
                    isPlaced := true;
                end;
            end;
        done;
    done;
    Array.iter (fun ligne -> begin
        print_string "|";
        Array.iter (fun symb -> print_string (symb^"|");) ligne;
        print_string "\n";
        end;) plateauO;
in
