open Lwt.Infix
open Cmdliner

let config path =
  let head = Git.Reference.of_string "refs/heads/master" in
  Irmin_git.config ~head path

let run port root contents store =
  let c = Irmin_unix.Cli.mk_contents contents in
  let (module Store) = Irmin_unix.Cli.mk_store store c in
  let module Store_graphql = Irmin_graphql.Make(Store) in
  let p =
    Store.Repo.v (config root) >>= fun repo ->
    Store.master repo >>= fun store ->
    Store_graphql.start_server ?port store
  in Lwt_main.run p

let port =
  let doc = "Port to listen on" in
  Arg.(value & pos 0 (some int) None & info [] ~docv:"PORT" ~doc)

let contents =
  let doc = "Content type" in
  Arg.(value & opt string "string" & info ["c"; "contents"] ~docv:"CONTENTS" ~doc)

let store =
  let doc = "Store type" in
  Arg.(value & opt string "git" & info ["s"; "store"] ~docv:"STORE" ~doc)

let root =
  let doc = "Store location" in
  Arg.(value & opt string "/tmp/irmin" & info ["root"] ~docv:"PATH" ~doc)

let main_t = Term.(const run $ port $ root $ contents $ store)
let () = Term.exit @@ Term.eval (main_t, Term.info "irmin-graphql")

