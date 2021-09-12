%token EOL
%token EMPTY
%token DOT

%token DATETIME
%token OPEN
%token CLOSE

%token INT
%token STRING

%token OK /* testwise token */



%token <int>    INT
%token <string> STRING
%token <string> DATETIME
%token <string> IPv6

%token EOF
%token EOL


%start main
%type <Logdefs.combined_t> main


%{
%}



%%
main: line EOL { $1 };


line: host lname username timestamp request statuscode numbytes referer useragent { ($1, $2, $3, $4, $5, $6, $7, $8, $9) }
    ;


/* CombinedLog-Entries                                         */
/* http://fileformats.archiveteam.org/wiki/Combined_Log_Format */
/* ----------------------------------------------------------- */
host: host_ipv4 { $1 }
    | host_ipv6 { $1 }
    ;

host_ipv4: INT DOT INT DOT INT DOT INT { (*print_endline "IPv4" ; *)Host_ipv4($1, $3, $5, $7) } ;
    ;

host_ipv6: IPv6 { (*print_endline "IPv6" ; *) Host_ipv6($1) } ;
    ;

lname: EMPTY { "" }
    | STRING { $1 }
    ;

username: EMPTY { "" }
    | STRING { $1 }
    ;

timestamp: DATETIME { $1 }
    ;

request:  STRING { $1 }
    ;

statuscode: INT { $1 }
    ;

numbytes: INT { $1 }
    | EMPTY { 0 }
    ;

referer: STRING { $1 }
    ;

useragent: STRING { $1 }
    ;

%%
