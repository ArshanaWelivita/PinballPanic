open Core

(* Type representing a position on the grid *)
type pos = int * int

(* Type representing if the teleporter is the entryway or the exit *)
type entryOrExit =
    | Entry
    | Exit


    