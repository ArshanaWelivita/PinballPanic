(* Downloaded dream on both team member's laptops. This was a copy of the test to print 'hello world' on the OCaml
Dream website to ensure that the library was installed correctly. *)
let hello who =
  <html>
  <body>
    <h1>Hello, <%s who %>!</h1>
  </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (hello "world"));
  ]