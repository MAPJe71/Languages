# let lexer s =
   let ll = Genlex.make_lexer ["+";"*"] 
   in  ll (Stream.of_string s) ;;
val lexer : string -> Genlex.token Stream.t = <fun>
# let rec stream_parse s = 
   match s with parser
     [<'Genlex.Ident x>] -> x
   | [<'Genlex.Int n>] -> string_of_int n
   | [<'Genlex.Kwd "+"; e1=stream_parse; e2=stream_parse>] -> "("^e1^"+"^e2^")"
   | [<'Genlex.Kwd "*"; e1=stream_parse; e2=stream_parse>] -> "("^e1^"*"^e2^")"
   | [<>] -> failwith "Parse error"
 ;;
val stream_parse : Genlex.token Stream.t -> string = <fun>
# let infix_of s = stream_parse (lexer s) ;; 
val infix_of : string -> string = <fun>
# infix_of "* +3 11 22";;
- : string = "((3+11)*22)"