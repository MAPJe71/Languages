(* https://notepad-plus-plus.org/community/topic/16501/function-list-for-caml *)

let read_int () = Scanf.scanf " %d" (fun x -> x) in

let n = read_int() and
    m = read_int() in
let amis = Array.init n (fun x -> pred (read_int())) and
    guir = Array.init n (fun x -> read_int()) in

let nCadeau = ref 0 and
    positions = ref [] and
    nb = ref 0 in

try
    while nb <  do
        incr nb;
        let cadeau = ref true in
        try
            for i=pred n downto 1 do
                if (guir.(amis.(pred i)) > guir.(amis.(i))) then begin
                    cadeau := false;
                    (* Printf.printf "guir.(%d) > guir.(%d)\n" (amis.(pred i) + pos) (amis.(i) + pos); *)
                    raise Exit;
                end;
                (* Printf.printf "guir.(%d) < guir.(%d)\n" (amis.(pred i) + pos) (amis.(i) + pos) *) (*DEBUG*)
            done;
            if (!cadeau) then begin
            incr nCadeau;
            positions := !positions @ [n];
        end;
        with
            | Exit -> begin () end;
        for i=0 to n-2 do
            guir.(i) <- guir.(succ i);
        done;
        guir.(pred n) <- read_int();
    done;
with
    | Invalid_argument "end of file" -> ();

Printf.printf "%d\n" (!nCadeau);
List.iter (fun x -> Printf.printf "%d " x;) (!positions);
