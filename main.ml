let logfile_defaultname = "access.log.current"


open Logdefs


exception Parse_error_in_line of int


let readlog_from_channel input_channel =

  let lineslist = ref [] in

    let num = ref 1 in

    let lexer = Lexing.from_channel input_channel in
    begin
      try
        while true do
          let result = Combinedparse.main Combinedlex.read_log lexer in
          lineslist := result :: !lineslist;
          incr num
        done
      with
        | End_of_file         -> ()
        | Parsing.Parse_error -> raise (Parse_error_in_line (!Combinedlex.linecnt))
    end;
    Combinedlex.linecnt := 1; (* reset linecnt *)

  List.rev !lineslist


let readlog_from_file filename =
    let inchan = open_in filename in
    let tl = (readlog_from_channel inchan) in
    close_in inchan;
    tl


let workasfilter () =
  let open Unix in
    not (isatty stdin)


let filenames_from_argv () =
  List.tl (Array.to_list Sys.argv)


let print_tsv_to_channel parsed out_channel =
  output_string out_channel "Host\tClient\tUser\tDateTime\tRequest\tStatus\tLength\tReferer\tUserAgent";
  output_char out_channel '\n';
  List.iter (
              fun parsedline ->
                match parsedline with
                  hst, ci, un, ts, req, st, len, ref, ua ->
                    begin
                      match hst with
                        | Hostname hn -> Printf.fprintf out_channel "%s\t%s\t%s\t%s\t%s\t%d\t%d\t%s\t%s\n" hn ci un ts req st len ref ua
                        | Host_ipv4 ip  ->  let ipstr = Logdefs.Helpers.ip_to_string ip in
                                          Printf.fprintf out_channel "%s\t%s\t%s\t%s\t%s\t%d\t%d\t%s\t%s\n" ipstr ci un ts req st len ref ua
                        | Host_ipv6 ipstr  -> Printf.fprintf out_channel "%s\t%s\t%s\t%s\t%s\t%d\t%d\t%s\t%s\n" ipstr ci un ts req st len ref ua
                    end
            ) parsed



let main () =
  let fname = if Array.length Sys.argv = 2 then Sys.argv.(1) else logfile_defaultname in

  let parsed =
  match workasfilter() with
    | true  -> readlog_from_channel stdin
    | false -> readlog_from_file fname
  in

  print_tsv_to_channel parsed stdout


let () =
  try
    main()
  with Combinedlex.CombinedLexError -> Printf.eprintf "Lexing Error in line %d\n" !Combinedlex.linecnt


