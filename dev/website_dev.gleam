import gleam/erlang/process
import gleam/function
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
  let _ = website.build_site()
  wisp.log_info("Site built")

  let assert Ok(_) = watch_files()

  let assert Ok(_) =
    wisp_mist.handler(handle_req, "")
    |> mist.new
    |> mist.bind("localhost")
    |> mist.port(3000)
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
  request: request.Request(wisp.Connection),
) -> request.Request(wisp.Connection) {
  let path = string.remove_suffix(request.path, "/")
  case string.contains(path, ".") {
    True -> request
    False -> request.set_path(request, path <> "/index.html")
  }
}

fn watch_files() {
  let assert Ok(root) = simplifile.current_directory()

  actor.new_with_initialiser(5000, fn(_subject) {
    let assert Ok(watcher) =
      watchexec.new(watching: root)
      |> watchexec.filter("**/pages/**")
      |> watchexec.filter("**/src/**")
      |> watchexec.filter("**/priv/**")
      |> watchexec.start

    let selector =
      process.new_selector()
      |> watchexec.select(watcher, function.identity)

    actor.initialised(watcher)
    |> actor.selecting(selector)
    |> Ok
  })
  |> actor.on_message(fn(watcher, data) {
    let assert Ok(#(watcher, events)) = watchexec.parse_data(watcher, data)

    handle_update(root, events)
    actor.continue(watcher)
  })
  |> actor.start()
}

fn handle_update(root: String, events: List(watchexec.FileEvent)) -> Nil {
  let rebuild_required =
    list.fold(events, False, fn(rebuild_required, event) {
      case string.remove_prefix(event.path, root) {
        "/gleam.toml" | "/pages/" <> _ | "/guides/" <> _ | "/src/" <> _ -> True
        "/priv/" <> path -> {
          copy_priv_file(path)
          rebuild_required
        }
        _ -> rebuild_required
      }
    })

  case rebuild_required {
    True -> {
      let _ = website.build_site()
      wisp.log_info("Rebuilt full website")
    }
    False -> {
      Nil
    }
  }
}

fn copy_priv_file(path: String) -> Nil {
  let source = "./priv/" <> path
  let destination = "./dist/" <> path
  case simplifile.copy_file(source, destination) {
    Ok(_) -> wisp.log_info("Replaced " <> source)
    Error(simplifile.Enoent) -> Nil
    Error(error) -> {
      let error = simplifile.describe_error(error)
      wisp.log_warning("Failed to copy " <> path <> ": " <> error)
    }
  }
}
