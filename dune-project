(lang dune 3.16)

(package
 (name pinball_server)
 (synopsis "A web app for playing our game PinballPanic")
 (description
  "A web app for playing our game PinballPanic. The deeper you go into the game, the harder the levels get.")
 (depends
  (core
   (>= 0.16.2))
  (dream
   (>= 1.0.0~alpha5))
  (ppx_jane
   (>= v0.16.0))
  (bisect_ppx
   (>= 2.8.3))
   ))

(generate_opam_files true)
(authors "Kenneth Elsman" "Arshana Welivita")
(maintainers "kelsman@icloud.com" "awelivita04@gmail.com")
(package
 (name pinball_panic)
 (allow_empty)
 (synopsis "Our pinball-based memory game, PinballPanic")
 (description "Traverse through 16 randomly generated levels that increase in complexity and difficulty.
    You only have a few seconds to figure out the end position before the grid disappears.")
 (depends
  (ounit2 (>= 2.2.7))
  (core (>= 0.17.1))
  (dream (>= 1.0.0~alpha5))
  (bisect_ppx (>= 2.8.3))
  (ppx_jane (>= v0.16.0))
))