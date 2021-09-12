all: native-code
#all: byte-code
#all: debug-code


SOURCES :=  logdefs.ml combinedparse.mly combinedlex.mll main.ml

LIBS := unix

#OCAMLFLAGS := -w +11+22+26+32+33+34+35+36+37+38+39-58 -safe-string

YFLAGS=-v
OCAMLYACC = ocamlyacc

RESULT = apalog2tsv


include OCamlMakefile
