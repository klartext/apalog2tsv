{
  (*
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" combined
  *)
  open Combinedparse
  exception CombinedLexError
  let linecnt = ref 1
  let bufsize = 750
  let buf = Buffer.create bufsize

type scan_item = IP
}

let digit = ['0' - '9']
let alnum = ['a'-'z' 'A' - 'Z' '0' - '9']
let blanks = [' ' '\t' '\n' '\r']+
let empty = '-'
let hex = ['0'-'9' 'a' - 'f' 'A' - 'F']
let ipv6 = ['0'-'9' 'a' - 'f' 'A' - 'F' ':']


rule read_log = parse
   | [ '\t' ]   { raise CombinedLexError }
   | "\n"           { incr linecnt; EOL }
   | digit+         { INT (int_of_string (Lexing.lexeme lexbuf)) }
   | ipv6+          { IPv6 (Lexing.lexeme lexbuf) }
   | '['            { read_datetime lexbuf }
   | '.'            { DOT }
   | '-'            { EMPTY }
   | '"'            { read_string lexbuf }
   | _              { read_log lexbuf }
   | eof            { raise End_of_file }


and read_string = parse
   | [^ '"' '\\' ]+ { Buffer.add_string buf (Lexing.lexeme lexbuf); read_string lexbuf }
   | '"'            { let s = (Buffer.contents buf) in Buffer.truncate buf 0; STRING s }
   | '\\' _         { Buffer.add_string buf (Lexing.lexeme lexbuf); read_string lexbuf }
   | eof            { raise End_of_file }



and read_datetime = parse
   | [^ ']' ]+  { Buffer.add_string buf (Lexing.lexeme lexbuf); read_datetime lexbuf }
   | "]"        { let dt = (Buffer.contents buf) in Buffer.truncate buf 0; DATETIME dt }
   | eof        { raise End_of_file }


