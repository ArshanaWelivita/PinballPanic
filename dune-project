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