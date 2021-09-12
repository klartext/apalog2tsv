

type ipv4 = int * int * int * int
type ipv6 = string


type host = Hostname of string | Host_ipv4 of ipv4 | Host_ipv6 of ipv6
type clientid = string
type username = string
type timestamp = string
type request = string
type status  = int
type length = int
type referer = string
type useragent = string

type combined_t = host * clientid * username * timestamp * request * status * length * referer * useragent



module Helpers =
struct
  let ip_to_string ipnum =
    match ipnum with
      oct1, oct2, oct3, oct4 -> Printf.sprintf "%d.%d.%d.%d" oct1 oct2 oct3 oct4

end


