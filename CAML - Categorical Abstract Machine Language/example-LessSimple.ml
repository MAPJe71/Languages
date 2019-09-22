# let rec rest = parser 
     [< 'Lsymbol "+"; e2 = atom >]  -> Some (PLUS,e2)
   | [< 'Lsymbol "-"; e2 = atom >]  -> Some (MINUS,e2)
   | [< 'Lsymbol "*"; e2 = atom >]  -> Some (MULT,e2)
   | [< 'Lsymbol "/"; e2 = atom >]  -> Some (DIV,e2)
   | [< >] -> None
 and atom = parser 
     [< 'Lint i >] -> ExpInt i
   | [< 'Lsymbol "("; e = expr ; 'Lsymbol ")" >] -> e
 and expr s =
   match s with parser
     [< e1 = atom >] ->  
       match rest s with
           None -> e1
         | Some (op,e2) -> ExpBin(e1,op,e2) ;;
val rest : lexeme Stream.t -> (bin_op * expression) option = <fun>
val atom : lexeme Stream.t -> expression = <fun>
val expr : lexeme Stream.t -> expression = <fun>
