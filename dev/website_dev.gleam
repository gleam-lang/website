import gleam/erlang/process
import gleam/http/request
import gleam/http/response
import gleam/list
import gleam/otp/actor
import gleam/string
import mist
import simplifile
import watchexec
import website
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let assert Ok(_) = watch_files()

  let assert Ok(_) =
    wisp_mist.handler(handle_req, "")
    |> mist.new
    |> mist.bind("localhost")
    |> mist.port(8080)
    |> mist.start

  process.sleep_forever()
}

fn handle_req(
  req: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  // Add index.html to our directory requests
  let req = rewrite_index(req)

  use <- wisp.serve_static(req, under: "", from: "./dist")

  response.new(404)
  |> response.set_body(wisp.Text("404 page not found"))
}

fn rewrite_index(
  req: request.Request(wisp.Connection),
) -> request.Request(wisp.Connection) {
  let path = req.path
  case string.ends_with(path, "/") {
    True -> request.set_path(req, path <> "index.html")
    False ->
      case string.contains(path, ".") {
        True -> req
        False -> request.set_path(req, path <> "/index.html")
      }
  }
}

type UpdateEvent {
  SrcEvent(watchexec.WatchexecData)
  PrivEvent(watchexec.WatchexecData)
}

fn watch_files() {
  actor.new_with_initialiser(5000, fn(_subject) {
    let assert Ok(src_watcher) =
      watchexec.new(watching: "./src") |> watchexec.start
    let assert Ok(priv_watcher) =
      watchexec.new(watching: "./priv") |> watchexec.start

    let selector =
      process.new_selector()
      |> watchexec.select(src_watcher, SrcEvent)
      |> watchexec.select(priv_watcher, PrivEvent)

    actor.initialised(#(src_watcher, priv_watcher))
    |> actor.selecting(selector)
    |> Ok
  })
  |> actor.on_message(fn(state, event) {
    let #(src_watcher, priv_watcher) = state

    let #(src_watcher, priv_watcher) = case event {
      SrcEvent(data) -> {
        let assert Ok(#(updated, events)) =
          watchexec.parse_data(src_watcher, data)
        let paths = event_to_path(events)
        rebuild_full(paths)
        #(updated, priv_watcher)
      }
      PrivEvent(data) -> {
        let assert Ok(#(updated, events)) =
          watchexec.parse_data(priv_watcher, data)
        let paths = event_to_path(events)
        rebuild_assets(paths)
        #(src_watcher, updated)
      }
    }

    actor.continue(#(src_watcher, priv_watcher))
  })
  |> actor.start()
}

fn rebuild_full(_paths: List(String)) {
  let _ = website.build_site()
  wisp.log_info("Rebuilt full website")
}

fn rebuild_assets(changed_paths: List(String)) {
  list.each(changed_paths, fn(path) {
    let dest = string.replace(path, each: "/priv", with: "/dist")
    let assert Ok(#(_, shortened_path)) = string.split_once(path, "/priv")

    case simplifile.copy_file(path, dest) {
      Ok(_) -> wisp.log_info("Replaced " <> shortened_path)
      Error(e) ->
        wisp.log_warning("Failed to copy " <> path <> ": " <> string.inspect(e))
    }
  })
}

fn event_to_path(events: List(watchexec.FileEvent)) -> List(String) {
  case events {
    [] -> []
    _ -> {
      list.filter_map(events, fn(event) {
        case string.ends_with(event.path, "~") {
          True -> Error(Nil)
          False -> Ok(event.path)
        }
      })
      |> list.unique
    }
  }
}
