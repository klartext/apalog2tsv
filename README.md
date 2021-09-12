# apalog2tsv

Tool to convert Apache Common Log files to tsv files.
Accepts IPv4 and IPv6 adresses.


# Usage
There are three ways how to use that tool.

- pipe the data from stdin
- read data from a certain file
- read default file "access.log.current"

See below for more details
(the $ in the examples is meant to be the shell prompt).

## Read Data from STDIN
Just pipe the logdata into apalog2tsv.

For example:
```
$ head -5 access.log.20210910 | apalog2tsv
```

## Read Data from a certain file
Use the filename as command line argument:

```
$ apalog2tsv access.log.20210910
```

## Read Data from default file ("access.log.current")
If you are in a directory, with "access.log.current",
just call apalog2tsv without command line arguments,
and it will read the logdata from that file.
```
$ apalog2tsv
```

# Compilation
Type "make" at the command line and apalog2tsv should be compiled.

# Installation
No installation procedure is forseen.
Just copy the tool to your bin directory in your HOME directory.

# License
GPL 3.0
