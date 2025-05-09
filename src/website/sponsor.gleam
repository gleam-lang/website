import envoy
import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import simplifile
import snag
import website/fs

/// Update the list of people sponsoring lpil.
pub fn update_list() -> snag.Result(Nil) {
  use token <- result.try(
    envoy.get("GITHUB_TOKEN")
    |> snag.map_error(fn(_) { "GITHUB_TOKEN environment variable not set" }),
  )

  io.println("Querying GitHub API")
  use sponsors <- result.try(get_github_sponsors(token, option.None, []))
  let sponsors = list.sort(sponsors, fn(a, b) { string.compare(a.url, b.url) })

  io.println("Updating sponsor.gleam")

  use src <- result.try(fs.read("src/website/sponsor.gleam"))
  use src <- result.try(
    case string.split_once(src, "// GENERATED CODE BELOW\n") {
      Ok(#(src, _)) -> Ok(src)
      Error(_) -> snag.error("Failed to parse sponsor.gleam")
    },
  )
  let src =
    src
    <> "// GENERATED CODE BELOW\n"
    <> "\n"
    <> render_sponsors_code(sponsors)
    <> "\n"

  simplifile.write("src/website/sponsor.gleam", src)
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Could not write src/website/sponsor.gleam")
}

fn render_sponsors_code(sponsors: List(Sponsor)) -> String {
  "pub const sponsors = ["
  <> string.concat(
    list.map(sponsors, fn(sponsor) {
      let Sponsor(name:, url:, avatar:) = sponsor
      "
  Sponsor(
    name: \"" <> name <> "\",
    url: \"" <> url <> "\",
    avatar: \"" <> avatar <> "\",
  ),"
    }),
  )
  <> "\n]"
}

fn get_github_sponsors(
  token: String,
  cursor: Option(String),
  sponsors: List(Sponsor),
) -> Result(List(Sponsor), snag.Snag) {
  let query = github_graphql_query(cursor)
  let body = json.to_string(json.object([#("query", json.string(query))]))
  let assert Ok(request) = request.to("https://api.github.com/graphql")
  let request =
    request
    |> request.set_method(http.Post)
    |> request.set_header("authorization", "Bearer " <> token)
    |> request.set_header("content-type", "application/json")
    |> request.set_body(body)
  use response <- result.try(
    httpc.send(request)
    |> snag.map_error(fn(error) {
      "HTTP request failed: " <> string.inspect(error)
    }),
  )
  use page <- result.try(
    json.parse(response.body, github_page_decoder())
    |> snag.map_error(fn(error) {
      "JSON error: " <> string.inspect(error) <> " for " <> response.body
    }),
  )
  let sponsors = list.append(sponsors, page.1)
  case page.0 {
    option.Some(_) -> get_github_sponsors(token, page.0, sponsors)
    option.None -> Ok(sponsors)
  }
}

fn github_graphql_query(cursor: Option(String)) -> String {
  let cursor = case cursor {
    option.None -> ""
    option.Some(cursor) -> ", after: \"" <> cursor <> "\""
  }

  let fragment = "{ login name avatarUrl(size: 50) }"

  "
  query {
    user(login: \"lpil\") {
      sponsorshipsAsMaintainer(activeOnly: true, first: 100" <> cursor <> ") {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes { 
          sponsorEntity {
            ... on User " <> fragment <> "
            ... on Organization " <> fragment <> "
          }
        }
      }
    }
  }
  "
}

pub type Sponsor {
  Sponsor(name: String, url: String, avatar: String)
}

fn github_page_decoder() -> decode.Decoder(#(Option(String), List(Sponsor))) {
  let cursor = {
    use has_next_page <- decode.field("hasNextPage", decode.bool)
    case has_next_page {
      True -> decode.at(["endCursor"], decode.string) |> decode.map(option.Some)
      False -> decode.success(option.None)
    }
  }

  let sponsor = {
    use name <- decode.field("name", decode.optional(decode.string))
    use login <- decode.field("login", decode.string)
    use avatar <- decode.field("avatarUrl", decode.string)
    let url = "https://github.com/" <> login
    let name = option.unwrap(name, login)
    decode.success(Sponsor(name:, url:, avatar:))
  }

  let sponsors = decode.list(decode.at(["sponsorEntity"], sponsor))

  let decoder = {
    use cursor <- decode.field("pageInfo", cursor)
    use sponsors <- decode.field("nodes", sponsors)
    decode.success(#(cursor, sponsors))
  }

  decode.at(["data", "user", "sponsorshipsAsMaintainer"], decoder)
}

// GENERATED CODE BELOW

pub const sponsors = [
  Sponsor(
    name: "Bjoern Paschen",
    url: "https://github.com/00bpa",
    avatar: "https://avatars.githubusercontent.com/u/89401395?s=50&v=4",
  ),
  Sponsor(
    name: "Luna",
    url: "https://github.com/2kool4idkwhat",
    avatar: "https://avatars.githubusercontent.com/u/120322313?s=50&u=336d5ad85b1cbc7376813848c1bce812c1ded7cc&v=4",
  ),
  Sponsor(
    name: "Mariano Uvalle",
    url: "https://github.com/AYM1607",
    avatar: "https://avatars.githubusercontent.com/u/24952509?s=50&u=3d31d5974afd09f9eb42135138ebf8dc579ce365&v=4",
  ),
  Sponsor(
    name: "Ameen Radwan",
    url: "https://github.com/Acepie",
    avatar: "https://avatars.githubusercontent.com/u/5996838?s=50&u=afb74e94eb5438bae05a0aa092a648f66e0f7ec7&v=4",
  ),
  Sponsor(
    name: "Adam Brodzinski",
    url: "https://github.com/AdamBrodzinski",
    avatar: "https://avatars.githubusercontent.com/u/1445367?s=50&u=3facd4ad78d85f857d6fc063d427d3873e0e0b68&v=4",
  ),
  Sponsor(
    name: "AndreHogberg",
    url: "https://github.com/AndreHogberg",
    avatar: "https://avatars.githubusercontent.com/u/70792178?s=50&u=58b3749f6434bcd2163fa78bcde664a209bab188&v=4",
  ),
  Sponsor(
    name: "Kritsada Sunthornwutthikrai",
    url: "https://github.com/Bearfinn",
    avatar: "https://avatars.githubusercontent.com/u/17377785?s=50&v=4",
  ),
  Sponsor(
    name: "Oliver Medhurst",
    url: "https://github.com/CanadaHonk",
    avatar: "https://avatars.githubusercontent.com/u/19228318?s=50&u=eea29901f58d6357f0fc2992747d0b4b80d23c8e&v=4",
  ),
  Sponsor(
    name: "Chris Rybicki",
    url: "https://github.com/Chriscbr",
    avatar: "https://avatars.githubusercontent.com/u/5008987?s=50&u=0263ce63fe2c5083367f5f9625ee2435652801b4&v=4",
  ),
  Sponsor(
    name: "Clifford Anderson",
    url: "https://github.com/CliffordAnderson",
    avatar: "https://avatars.githubusercontent.com/u/1919466?s=50&v=4",
  ),
  Sponsor(
    name: "Comamoca",
    url: "https://github.com/Comamoca",
    avatar: "https://avatars.githubusercontent.com/u/93137338?s=50&u=95a9601ff7e08488494cca78d0cd4958a13beefb&v=4",
  ),
  Sponsor(
    name: "Danielle Maywood",
    url: "https://github.com/DanielleMaywood",
    avatar: "https://avatars.githubusercontent.com/u/40153966?s=50&u=23d8600035ba5f98165ab8930b8c0cfe12a47588&v=4",
  ),
  Sponsor(
    name: "Patrick Wheeler",
    url: "https://github.com/Davorak",
    avatar: "https://avatars.githubusercontent.com/u/810921?s=50&u=e14ad505f9953cf50c700a6414e168edd993ca10&v=4",
  ),
  Sponsor(
    name: "DoctorCobweb",
    url: "https://github.com/DoctorCobweb",
    avatar: "https://avatars.githubusercontent.com/u/1377953?s=50&u=fe7ea884c1cee06a586b491cc59264b4f389a757&v=4",
  ),
  Sponsor(
    name: "EMR Technical Solutions",
    url: "https://github.com/EMRTS",
    avatar: "https://avatars.githubusercontent.com/u/13780078?s=50&v=4",
  ),
  Sponsor(
    name: "Emma",
    url: "https://github.com/Emma-Fuller",
    avatar: "https://avatars.githubusercontent.com/u/89794160?s=50&u=001967be40ee0403e58366174118d6fe2a0bd2e1&v=4",
  ),
  Sponsor(
    name: "ErikML",
    url: "https://github.com/ErikML",
    avatar: "https://avatars.githubusercontent.com/u/4176228?s=50&v=4",
  ),
  Sponsor(
    name: "Ethan Olpin",
    url: "https://github.com/EthanOlpin",
    avatar: "https://avatars.githubusercontent.com/u/53278645?s=50&u=0631a2f8a39c261824d9fe46eb3850c3ec50d444&v=4",
  ),
  Sponsor(
    name: "frankwang",
    url: "https://github.com/Frank-III",
    avatar: "https://avatars.githubusercontent.com/u/73262844?s=50&u=ba45dd9b5592369624fc08c7ba66b1a258e5c45a&v=4",
  ),
  Sponsor(
    name: "Graham Vasquez",
    url: "https://github.com/GV14982",
    avatar: "https://avatars.githubusercontent.com/u/7041175?s=50&u=698504a26b0d23796497defc48d1d143aa057221&v=4",
  ),
  Sponsor(
    name: "Aleksei Gurianov",
    url: "https://github.com/Guria",
    avatar: "https://avatars.githubusercontent.com/u/36270?s=50&u=20d51163ae394ca2ba441f85aa7f2ec3ad010913&v=4",
  ),
  Sponsor(
    name: "Xucong Zhan",
    url: "https://github.com/HymanZHAN",
    avatar: "https://avatars.githubusercontent.com/u/26806995?s=50&u=4de3c370201b6703a46769951516e7102d954a13&v=4",
  ),
  Sponsor(
    name: "Ian González",
    url: "https://github.com/Ian-GL",
    avatar: "https://avatars.githubusercontent.com/u/24900688?s=50&u=614cfcc202ae1bd60c5e86357af95131b5a9396b&v=4",
  ),
  Sponsor(
    name: "Anthony Maxwell",
    url: "https://github.com/Illbjorn",
    avatar: "https://avatars.githubusercontent.com/u/133805840?s=50&u=07e8ba13affdd1025b1add7f0cf96af68b01ca8f&v=4",
  ),
  Sponsor(
    name: "Martin Janiczek",
    url: "https://github.com/Janiczek",
    avatar: "https://avatars.githubusercontent.com/u/149425?s=50&u=45e293ad63d2bf7962eae677cc4c4548a05daff0&v=4",
  ),
  Sponsor(
    name: "Ajit Krishna",
    url: "https://github.com/JitPackJoyride",
    avatar: "https://avatars.githubusercontent.com/u/40203625?s=50&u=5f013f039bf9367bcbe43d833ae482854118d224&v=4",
  ),
  Sponsor(
    name: "John Björk",
    url: "https://github.com/JohnBjrk",
    avatar: "https://avatars.githubusercontent.com/u/1716064?s=50&u=f19404f104d8755da53b00ad665b49a8b497477f&v=4",
  ),
  Sponsor(
    name: "Jonas Hedman Engström",
    url: "https://github.com/JonasHedEng",
    avatar: "https://avatars.githubusercontent.com/u/2291502?s=50&u=367ad7712549b320466e91233f79160515accacd&v=4",
  ),
  Sponsor(
    name: "Leonardo Donelli",
    url: "https://github.com/LeartS",
    avatar: "https://avatars.githubusercontent.com/u/5588738?s=50&u=ea3058178b90b21f04a327921c947a2b10f1c557&v=4",
  ),
  Sponsor(
    name: "Lily Rose",
    url: "https://github.com/LilyRose2798",
    avatar: "https://avatars.githubusercontent.com/u/1974590?s=50&u=db6b5cdd872363494c1bd64913a3572401509a45&v=4",
  ),
  Sponsor(
    name: "Constantin (Cleo) Winkler",
    url: "https://github.com/Lucostus",
    avatar: "https://avatars.githubusercontent.com/u/41841989?s=50&u=0b45e3d70326d4353b850aaddab17b5de77cfb4a&v=4",
  ),
  Sponsor(
    name: "Jean-Adrien Ducastaing",
    url: "https://github.com/MightyGoldenOctopus",
    avatar: "https://avatars.githubusercontent.com/u/25876592?s=50&u=cbbe59f82b8fa74e99d859efb2831e8781b494fc&v=4",
  ),
  Sponsor(
    name: "MoeDev",
    url: "https://github.com/MoeDevelops",
    avatar: "https://avatars.githubusercontent.com/u/143090643?s=50&v=4",
  ),
  Sponsor(
    name: "Chris King",
    url: "https://github.com/Morzaram",
    avatar: "https://avatars.githubusercontent.com/u/70202379?s=50&u=11e527351e5edd08e8f30b10a2b648760eef179b&v=4",
  ),
  Sponsor(
    name: "NFIBrokerage",
    url: "https://github.com/NFIBrokerage",
    avatar: "https://avatars.githubusercontent.com/u/20132342?s=50&v=4",
  ),
  Sponsor(
    name: "Jérôme Schaeffer",
    url: "https://github.com/Neofox",
    avatar: "https://avatars.githubusercontent.com/u/6177937?s=50&u=dc6ff09d821fade92c48496d64214ce21162ae92&v=4",
  ),
  Sponsor(
    name: "Nicklas Sindlev Andersen",
    url: "https://github.com/NicklasXYZ",
    avatar: "https://avatars.githubusercontent.com/u/18580183?s=50&u=e78dfbd9cc44a243c17f052250ef73aec4cb3858&v=4",
  ),
  Sponsor(
    name: "NicoVIII",
    url: "https://github.com/NicoVIII",
    avatar: "https://avatars.githubusercontent.com/u/3983345?s=50&u=6962fb7c0e56ad3a812551fd9e7ff795d42eaf77&v=4",
  ),
  Sponsor(
    name: "Julian Hirn",
    url: "https://github.com/Nineluj",
    avatar: "https://avatars.githubusercontent.com/u/11633602?s=50&u=458d4a9b78fbb15d6c0bd86b8b803e241290c068&v=4",
  ),
  Sponsor(
    name: "OldhamMade",
    url: "https://github.com/OldhamMade",
    avatar: "https://avatars.githubusercontent.com/u/111193?s=50&v=4",
  ),
  Sponsor(
    name: "Rodrigo Álvarez",
    url: "https://github.com/Papipo",
    avatar: "https://avatars.githubusercontent.com/u/22678?s=50&u=549da05959fff2b6f3cc387ecdd89f08072b9d29&v=4",
  ),
  Sponsor(
    name: "Viv Verner",
    url: "https://github.com/PerpetualPossum",
    avatar: "https://avatars.githubusercontent.com/u/140846346?s=50&u=8680355810ade71e097281ab15bd882defa9f195&v=4",
  ),
  Sponsor(
    name: "Stephen Belanger",
    url: "https://github.com/Qard",
    avatar: "https://avatars.githubusercontent.com/u/205482?s=50&u=de3265fd6a286e3e51965136cbe7a04bb9ec051a&v=4",
  ),
  Sponsor(
    name: "Sean Roberts",
    url: "https://github.com/SeanRoberts",
    avatar: "https://avatars.githubusercontent.com/u/25376?s=50&u=d0a049653cb9f13363b9ad5b170fa5c3dff264f3&v=4",
  ),
  Sponsor(
    name: "Strandinator",
    url: "https://github.com/Strandinator",
    avatar: "https://avatars.githubusercontent.com/u/45405887?s=50&v=4",
  ),
  Sponsor(
    name: "Robert Attard",
    url: "https://github.com/TanklesXL",
    avatar: "https://avatars.githubusercontent.com/u/22840519?s=50&u=fdb6db7ecf363ff9064afd455a26b760c5464bb2&v=4",
  ),
  Sponsor(
    name: "Theo Harris",
    url: "https://github.com/Theosaurus-Rex",
    avatar: "https://avatars.githubusercontent.com/u/71990001?s=50&u=c2f36e63ffcfbb58b679a9e303b174467dc14a4d&v=4",
  ),
  Sponsor(
    name: "Tristan de Cacqueray",
    url: "https://github.com/TristanCacqueray",
    avatar: "https://avatars.githubusercontent.com/u/154392?s=50&u=e2455759892678ce94360af4620793f79a91a0e9&v=4",
  ),
  Sponsor(
    name: "Pedro Correa",
    url: "https://github.com/Tulkdan",
    avatar: "https://avatars.githubusercontent.com/u/22248651?s=50&u=c4b1d04eb416485cf409e678a9374aec67e1f6be&v=4",
  ),
  Sponsor(
    name: "Walton Hoops",
    url: "https://github.com/Whoops",
    avatar: "https://avatars.githubusercontent.com/u/304505?s=50&v=4",
  ),
  Sponsor(
    name: "Willyboar",
    url: "https://github.com/Willyboar",
    avatar: "https://avatars.githubusercontent.com/u/22755228?s=50&u=a25d2e6735b27e22172aa8fe6944873ccd1e3319&v=4",
  ),
  Sponsor(
    name: "Yasuo Higano",
    url: "https://github.com/Yasuo-Higano",
    avatar: "https://avatars.githubusercontent.com/u/115511765?s=50&u=a9f0a7f8885422b3f06ec611c942948d342c5390&v=4",
  ),
  Sponsor(
    name: "Grant Everett",
    url: "https://github.com/YoyoSaur",
    avatar: "https://avatars.githubusercontent.com/u/14967850?s=50&u=48693d8d785a01375bfa0bed9f9ee425086b72ce&v=4",
  ),
  Sponsor(
    name: "Abel Jimenez",
    url: "https://github.com/abeljim",
    avatar: "https://avatars.githubusercontent.com/u/34782317?s=50&u=481f582a8933dff3c8075fd99ab755064b99eebf&v=4",
  ),
  Sponsor(
    name: "Andrea Bueide",
    url: "https://github.com/abueide",
    avatar: "https://avatars.githubusercontent.com/u/19354425?s=50&u=ab750b23ba8530d4ed71973c97695754115aea1e&v=4",
  ),
  Sponsor(
    name: "ad-ops",
    url: "https://github.com/ad-ops",
    avatar: "https://avatars.githubusercontent.com/u/57237184?s=50&v=4",
  ),
  Sponsor(
    name: "Adam Wyłuda",
    url: "https://github.com/adam-wyluda",
    avatar: "https://avatars.githubusercontent.com/u/3045108?s=50&u=891792819b02cf166cceaa2aa02684359be28db5&v=4",
  ),
  Sponsor(
    name: "Adam Johnston",
    url: "https://github.com/adjohnston",
    avatar: "https://avatars.githubusercontent.com/u/666676?s=50&v=4",
  ),
  Sponsor(
    name: "Alex Viscreanu",
    url: "https://github.com/aexvir",
    avatar: "https://avatars.githubusercontent.com/u/8055505?s=50&u=3cc5cc4daba1b0eb027c6b20b29720831832025d&v=4",
  ),
  Sponsor(
    name: "Aaron Gunderson",
    url: "https://github.com/agundy",
    avatar: "https://avatars.githubusercontent.com/u/2281120?s=50&u=281d05e14d23bfc04c31eb84f3651d6598e9a4dc&v=4",
  ),
  Sponsor(
    name: "Alex Houseago",
    url: "https://github.com/ahouseago",
    avatar: "https://avatars.githubusercontent.com/u/41902631?s=50&v=4",
  ),
  Sponsor(
    name: "Alexander Koutmos",
    url: "https://github.com/akoutmos",
    avatar: "https://avatars.githubusercontent.com/u/4753634?s=50&u=2bfc852e0e6328c4295dfe20cef6abd580907a4d&v=4",
  ),
  Sponsor(
    name: "Gavin Panella",
    url: "https://github.com/allenap",
    avatar: "https://avatars.githubusercontent.com/u/348564?s=50&u=520d365b03a5178a13da8926c00bd39bbc141afb&v=4",
  ),
  Sponsor(
    name: "Metin Emiroğlu",
    url: "https://github.com/amiroff",
    avatar: "https://avatars.githubusercontent.com/u/919?s=50&u=bcd258373e84e2eb79dd6693bb0485aad1052c30&v=4",
  ),
  Sponsor(
    name: "Adrian Mouat",
    url: "https://github.com/amouat",
    avatar: "https://avatars.githubusercontent.com/u/246775?s=50&u=78d611a7d7698d84e44b93399578a19185b03b39&v=4",
  ),
  Sponsor(
    name: "Anthony Scotti",
    url: "https://github.com/amscotti",
    avatar: "https://avatars.githubusercontent.com/u/598958?s=50&v=4",
  ),
  Sponsor(
    name: "Antharuu",
    url: "https://github.com/antharuu",
    avatar: "https://avatars.githubusercontent.com/u/10176626?s=50&u=3f6ef490b330d5a9bbaa3137560b5d1d4cf13a4a&v=4",
  ),
  Sponsor(
    name: "Anthony Khong",
    url: "https://github.com/anthony-khong",
    avatar: "https://avatars.githubusercontent.com/u/12151757?s=50&u=ae67cbe1cad1e8bf6ec696c3439c38ba97c98ec3&v=4",
  ),
  Sponsor(
    name: "Arya Irani",
    url: "https://github.com/aryairani",
    avatar: "https://avatars.githubusercontent.com/u/538571?s=50&u=cbbedab2bf9de165653939807717a3b6c1e17074&v=4",
  ),
  Sponsor(
    name: "Arthur Weagel",
    url: "https://github.com/aweagel",
    avatar: "https://avatars.githubusercontent.com/u/5428607?s=50&v=4",
  ),
  Sponsor(
    name: "Azure Flash",
    url: "https://github.com/azureflash",
    avatar: "https://avatars.githubusercontent.com/u/140976898?s=50&u=f13cd969c39317d68f252d8a4c72bff3f08ecefb&v=4",
  ),
  Sponsor(
    name: "Bartek Górny",
    url: "https://github.com/bartekgorny",
    avatar: "https://avatars.githubusercontent.com/u/70064?s=50&v=4",
  ),
  Sponsor(
    name: "Benjamin Kane",
    url: "https://github.com/bbkane",
    avatar: "https://avatars.githubusercontent.com/u/6081085?s=50&u=cfea130a8721b472b99feb656c3579251e5e8e7c&v=4",
  ),
  Sponsor(
    name: "Ben Myles",
    url: "https://github.com/benmyles",
    avatar: "https://avatars.githubusercontent.com/u/164675?s=50&u=cf738ec5bec0ba1434e34d817fbcff08230245e2&v=4",
  ),
  Sponsor(
    name: "Brian Glusman",
    url: "https://github.com/bglusman",
    avatar: "https://avatars.githubusercontent.com/u/105444?s=50&v=4",
  ),
  Sponsor(
    name: "Ben Marx",
    url: "https://github.com/bgmarx",
    avatar: "https://avatars.githubusercontent.com/u/153267?s=50&u=a70b20a79361700fbf8d73fde753c454804ff9b6&v=4",
  ),
  Sponsor(
    name: "bgw",
    url: "https://github.com/bgwdotdev",
    avatar: "https://avatars.githubusercontent.com/u/29340584?s=50&u=90435e65f327fed2e3abf808f317d132035d3156&v=4",
  ),
  Sponsor(
    name: "Pawel Biernacki",
    url: "https://github.com/biernacki",
    avatar: "https://avatars.githubusercontent.com/u/230085?s=50&u=0567467ff401f114eca8ab3a64e96b2f3acf234a&v=4",
  ),
  Sponsor(
    name: "Bjarte Aarmo Lund",
    url: "https://github.com/bjartelund",
    avatar: "https://avatars.githubusercontent.com/u/13436038?s=50&u=784361eb9fcbc6d0b6b4d3c6681a14ea0c6238a0&v=4",
  ),
  Sponsor(
    name: "Sammy Isseyegh",
    url: "https://github.com/bkspace",
    avatar: "https://avatars.githubusercontent.com/u/1695350?s=50&u=27a9d5486661a7f1ada8ff6fc3ae52d09ca1985f&v=4",
  ),
  Sponsor(
    name: "Nikolai Steen Kjosnes",
    url: "https://github.com/blink1415",
    avatar: "https://avatars.githubusercontent.com/u/33166357?s=50&v=4",
  ),
  Sponsor(
    name: "Brad Mehder",
    url: "https://github.com/bmehder",
    avatar: "https://avatars.githubusercontent.com/u/4262025?s=50&v=4",
  ),
  Sponsor(
    name: "Vassiliy Kuzenkov",
    url: "https://github.com/bondiano",
    avatar: "https://avatars.githubusercontent.com/u/323479?s=50&u=c96c9d1d49bfc5815f2715a876d8b188338fb4e8&v=4",
  ),
  Sponsor(
    name: "István Bozsó",
    url: "https://github.com/bozso",
    avatar: "https://avatars.githubusercontent.com/u/15000107?s=50&u=71e2013a68c954fe16caf07cdddb119caaf6531e&v=4",
  ),
  Sponsor(
    name: "Georg Hartmann",
    url: "https://github.com/brasilikum",
    avatar: "https://avatars.githubusercontent.com/u/3106990?s=50&v=4",
  ),
  Sponsor(
    name: "Brendan P. ",
    url: "https://github.com/brendisurfs",
    avatar: "https://avatars.githubusercontent.com/u/64713032?s=50&u=cd0a8b39bbb2e0c996c18bd4f73e35c0d9860c02&v=4",
  ),
  Sponsor(
    name: "Brett Cannon",
    url: "https://github.com/brettcannon",
    avatar: "https://avatars.githubusercontent.com/u/54418?s=50&u=d802d54e21af0befea878eacff303c384b2a1871&v=4",
  ),
  Sponsor(
    name: "brettkolodny",
    url: "https://github.com/brettkolodny",
    avatar: "https://avatars.githubusercontent.com/u/22826580?s=50&u=bb86f3ee4fe47c8fdab43c116c0e96d849dad139&v=4",
  ),
  Sponsor(
    name: "Brian Dawn",
    url: "https://github.com/brian-dawn",
    avatar: "https://avatars.githubusercontent.com/u/1274409?s=50&v=4",
  ),
  Sponsor(
    name: "Bruce Williams",
    url: "https://github.com/bruce",
    avatar: "https://avatars.githubusercontent.com/u/72?s=50&u=947b0b113a0ce95efec9f380e8237a939b72f698&v=4",
  ),
  Sponsor(
    name: "bucsi",
    url: "https://github.com/bucsi",
    avatar: "https://avatars.githubusercontent.com/u/11545252?s=50&u=07123e7da757ad53d79e6128781f535116a355dd&v=4",
  ),
  Sponsor(
    name: "Stefan",
    url: "https://github.com/bytesource",
    avatar: "https://avatars.githubusercontent.com/u/610307?s=50&u=abdc0453058badb38af704c345c65e6f18f37cd6&v=4",
  ),
  Sponsor(
    name: "Cameron Presley",
    url: "https://github.com/cameronpresley",
    avatar: "https://avatars.githubusercontent.com/u/16687587?s=50&u=06eba1b589ec4d0f63eb81429b5109ec4a8defd1&v=4",
  ),
  Sponsor(
    name: "Cam Ray",
    url: "https://github.com/camray",
    avatar: "https://avatars.githubusercontent.com/u/4270079?s=50&u=63381011cceaa9eceb940cd2cd5bdff642051f57&v=4",
  ),
  Sponsor(
    name: "Carlo Munguia",
    url: "https://github.com/carlomunguia",
    avatar: "https://avatars.githubusercontent.com/u/43321570?s=50&u=fa86e33dadca898c3127c8e92c13cce29b058d1a&v=4",
  ),
  Sponsor(
    name: "Savva",
    url: "https://github.com/castletaste",
    avatar: "https://avatars.githubusercontent.com/u/74972418?s=50&u=cbba19cb268755aff763eba91930bb8ce9cab5fe&v=4",
  ),
  Sponsor(
    name: "Christopher Dieringer",
    url: "https://github.com/cdaringe",
    avatar: "https://avatars.githubusercontent.com/u/1003261?s=50&u=ab972d3bcf47c65c23b17d55721b9953f868a764&v=4",
  ),
  Sponsor(
    name: "Chris Donnelly",
    url: "https://github.com/ceedon",
    avatar: "https://avatars.githubusercontent.com/u/2904426?s=50&u=ce03755dfbcb8621134535e1b3d72ec5f61e5db3&v=4",
  ),
  Sponsor(
    name: "Chad Selph",
    url: "https://github.com/chadselph",
    avatar: "https://avatars.githubusercontent.com/u/315988?s=50&v=4",
  ),
  Sponsor(
    name: "Charlie Govea",
    url: "https://github.com/charlie-n01r",
    avatar: "https://avatars.githubusercontent.com/u/67932262?s=50&u=41a2fdc3ad7e4c564fcf5705263f8105639bd898&v=4",
  ),
  Sponsor(
    name: "Barry Moore",
    url: "https://github.com/chiroptical",
    avatar: "https://avatars.githubusercontent.com/u/3086255?s=50&u=3f489af77c45053d5cbfff9faebd3ae71f020c6a&v=4",
  ),
  Sponsor(
    name: "Chew Choon Keat",
    url: "https://github.com/choonkeat",
    avatar: "https://avatars.githubusercontent.com/u/473?s=50&v=4",
  ),
  Sponsor(
    name: "Raúl Chouza ",
    url: "https://github.com/chouzar",
    avatar: "https://avatars.githubusercontent.com/u/4700113?s=50&u=885b6365472d4384b67a81b111f574cfbd1bbfa2&v=4",
  ),
  Sponsor(
    name: "Chris Lloyd",
    url: "https://github.com/chrislloyd",
    avatar: "https://avatars.githubusercontent.com/u/718?s=50&v=4",
  ),
  Sponsor(
    name: "Christopher Keele",
    url: "https://github.com/christhekeele",
    avatar: "https://avatars.githubusercontent.com/u/1406220?s=50&v=4",
  ),
  Sponsor(
    name: "Christopher Jung",
    url: "https://github.com/christopherhjung",
    avatar: "https://avatars.githubusercontent.com/u/10675541?s=50&u=206f3dd3558d0a0259401bb20cda2e144ce7c245&v=4",
  ),
  Sponsor(
    name: "Christopher David Shirk",
    url: "https://github.com/christophershirk",
    avatar: "https://avatars.githubusercontent.com/u/1655014?s=50&u=d7c2baf3f4ebbd9ca587ce69aa76c60067423d13&v=4",
  ),
  Sponsor(
    name: "Shane Poppleton",
    url: "https://github.com/codemonkey76",
    avatar: "https://avatars.githubusercontent.com/u/3654457?s=50&v=4",
  ),
  Sponsor(
    name: "Coder",
    url: "https://github.com/coder",
    avatar: "https://avatars.githubusercontent.com/u/95932066?s=50&v=4",
  ),
  Sponsor(
    name: "Cole Lawrence",
    url: "https://github.com/colelawrence",
    avatar: "https://avatars.githubusercontent.com/u/2925395?s=50&u=ce880f76c8edf9cdd8ab1e5d16633ea117557590&v=4",
  ),
  Sponsor(
    name: "Comet",
    url: "https://github.com/comet-ml",
    avatar: "https://avatars.githubusercontent.com/u/31487821?s=50&v=4",
  ),
  Sponsor(
    name: "Carlos Saltos",
    url: "https://github.com/csaltos",
    avatar: "https://avatars.githubusercontent.com/u/32456?s=50&u=a2736cdb1eb8318361070ed9616cf2fbfaf1f215&v=4",
  ),
  Sponsor(
    name: "Charlie Duong",
    url: "https://github.com/ctdio",
    avatar: "https://avatars.githubusercontent.com/u/9613701?s=50&u=94b19a19eb944aaffc5c55f52ae202a64c2631eb&v=4",
  ),
  Sponsor(
    name: "Chris Vincent",
    url: "https://github.com/cvincent",
    avatar: "https://avatars.githubusercontent.com/u/8297?s=50&u=a809b558601fc7bb53a21e5d6d8f7773acfb30a3&v=4",
  ),
  Sponsor(
    name: "Dennis Dang",
    url: "https://github.com/dangdennis",
    avatar: "https://avatars.githubusercontent.com/u/22418429?s=50&u=0ce534ffcdff7e81d87c22b2ea693f32c5fe0864&v=4",
  ),
  Sponsor(
    name: "David Cornu",
    url: "https://github.com/davidcornu",
    avatar: "https://avatars.githubusercontent.com/u/325821?s=50&u=72749098165273a5b166f126b4ca8861487a1ef2&v=4",
  ),
  Sponsor(
    name: "Dylan Anthony",
    url: "https://github.com/dbanty",
    avatar: "https://avatars.githubusercontent.com/u/43723790?s=50&u=9d726785d08e50b1e1cd96505800c8ea8405bce2&v=4",
  ),
  Sponsor(
    name: "David Bernheisel",
    url: "https://github.com/dbernheisel",
    avatar: "https://avatars.githubusercontent.com/u/643967?s=50&u=a8d99b8f74fa44c72f8adbe86c379ae84999fc5c&v=4",
  ),
  Sponsor(
    name: "Dan Dresselhaus",
    url: "https://github.com/ddresselhaus",
    avatar: "https://avatars.githubusercontent.com/u/3826669?s=50&u=190d6605bce4ccd6f20eb748f2309fd7556a0bce&v=4",
  ),
  Sponsor(
    name: "Alexandre Del Vecchio",
    url: "https://github.com/defgenx",
    avatar: "https://avatars.githubusercontent.com/u/10920570?s=50&u=eb6aa68cc1f06c6c088db5758a135f3c70555bea&v=4",
  ),
  Sponsor(
    name: "lidashuang",
    url: "https://github.com/defp",
    avatar: "https://avatars.githubusercontent.com/u/612381?s=50&u=8fd36e3beb4c77f3552d37853b60f14786676ea4&v=4",
  ),
  Sponsor(
    name: "dennistruemper",
    url: "https://github.com/dennistruemper",
    avatar: "https://avatars.githubusercontent.com/u/16500337?s=50&u=bfb610a304289ae7aaed3be968e01785216a6b72&v=4",
  ),
  Sponsor(
    name: "Danny Martini",
    url: "https://github.com/despairblue",
    avatar: "https://avatars.githubusercontent.com/u/927609?s=50&u=0c51e10f46812b11a0e911a413474df5dbd827e8&v=4",
  ),
  Sponsor(
    name: "devinalvaro",
    url: "https://github.com/devinalvaro",
    avatar: "https://avatars.githubusercontent.com/u/129468386?s=50&v=4",
  ),
  Sponsor(
    name: "Christopher De Vries",
    url: "https://github.com/devries",
    avatar: "https://avatars.githubusercontent.com/u/1096938?s=50&u=240fe812be12d22bce10634be2fc5083551e9a34&v=4",
  ),
  Sponsor(
    name: "Diemo Gebhardt",
    url: "https://github.com/diemogebhardt",
    avatar: "https://avatars.githubusercontent.com/u/201413?s=50&u=d71b3a399516948b67150e77052ba19da4de5761&v=4",
  ),
  Sponsor(
    name: "Dillon Mulroy",
    url: "https://github.com/dmmulroy",
    avatar: "https://avatars.githubusercontent.com/u/2755722?s=50&u=a9746c9f33b5a17bee04d58b578a12a013b4d41b&v=4",
  ),
  Sponsor(
    name: "eli",
    url: "https://github.com/dropwhile",
    avatar: "https://avatars.githubusercontent.com/u/59039?s=50&u=4360e1f740ab5355c238c79d5223357206e2092d&v=4",
  ),
  Sponsor(
    name: "Benjamin Moss",
    url: "https://github.com/drteeth",
    avatar: "https://avatars.githubusercontent.com/u/376404?s=50&u=9aed5564453d8282c5de082a8ce9657aa8a22d11&v=4",
  ),
  Sponsor(
    name: "Damir Vandic",
    url: "https://github.com/dvic",
    avatar: "https://avatars.githubusercontent.com/u/1214337?s=50&u=746515aba84bb2fcae408ec38fe3e3f8c2e78ce0&v=4",
  ),
  Sponsor(
    name: "Éber Freitas Dias",
    url: "https://github.com/eberfreitas",
    avatar: "https://avatars.githubusercontent.com/u/137487?s=50&u=bd76f754d79e20f3565ee390fa89daffab86261d&v=4",
  ),
  Sponsor(
    name: "Ed Hinrichsen",
    url: "https://github.com/edhinrichsen",
    avatar: "https://avatars.githubusercontent.com/u/11088862?s=50&u=ecf645d9904c3b649b982c75e17e25432d72ac7c&v=4",
  ),
  Sponsor(
    name: "Edon Gashi",
    url: "https://github.com/edongashi",
    avatar: "https://avatars.githubusercontent.com/u/12145268?s=50&v=4",
  ),
  Sponsor(
    name: "Alex",
    url: "https://github.com/eelmafia",
    avatar: "https://avatars.githubusercontent.com/u/24531427?s=50&u=42eecd359ec785428196bd6aa51655c173e37e41&v=4",
  ),
  Sponsor(
    name: "Eric Koslow",
    url: "https://github.com/ekosz",
    avatar: "https://avatars.githubusercontent.com/u/212829?s=50&u=b74261b7ed7347ae20ccad9d27c62fc788137a19&v=4",
  ),
  Sponsor(
    name: "Eileen Noonan",
    url: "https://github.com/enoonan",
    avatar: "https://avatars.githubusercontent.com/u/6106851?s=50&u=b65944d2f22e4525e7d2b6d22a3a59f709b33db5&v=4",
  ),
  Sponsor(
    name: "erlend-axelsson",
    url: "https://github.com/erlend-axelsson",
    avatar: "https://avatars.githubusercontent.com/u/32471637?s=50&v=4",
  ),
  Sponsor(
    name: "Thomas Ernst",
    url: "https://github.com/ernstla",
    avatar: "https://avatars.githubusercontent.com/u/683620?s=50&u=943bff4a3e4209c8bf311dd6394fa4edb5cc3291&v=4",
  ),
  Sponsor(
    name: "Erik Terpstra",
    url: "https://github.com/eterps",
    avatar: "https://avatars.githubusercontent.com/u/39518?s=50&v=4",
  ),
  Sponsor(
    name: "Evaldo Bratti",
    url: "https://github.com/evaldobratti",
    avatar: "https://avatars.githubusercontent.com/u/1869525?s=50&u=c9d7da30fcbbc4f4bd8344ef42816f95940e4826&v=4",
  ),
  Sponsor(
    name: "evanasse",
    url: "https://github.com/evanasse",
    avatar: "https://avatars.githubusercontent.com/u/24358053?s=50&u=17c07bb355a690a5d1e1eda60249c33b25a74920&v=4",
  ),
  Sponsor(
    name: "Evan Johnson",
    url: "https://github.com/evanj2357",
    avatar: "https://avatars.githubusercontent.com/u/23486953?s=50&u=cbabbbcdd78cb085fb824bd40290c878933ae288&v=4",
  ),
  Sponsor(
    name: "Fabrizio Damicelli",
    url: "https://github.com/fabridamicelli",
    avatar: "https://avatars.githubusercontent.com/u/40115969?s=50&u=0a9d29ebf89e04ce2c70d32c4f915559ad8414f6&v=4",
  ),
  Sponsor(
    name: "Filip Figiel",
    url: "https://github.com/ffigiel",
    avatar: "https://avatars.githubusercontent.com/u/4096683?s=50&u=4f7dd14c03ea645950b699a958a48c2c0858e632&v=4",
  ),
  Sponsor(
    name: "Donnie Flood",
    url: "https://github.com/floodfx",
    avatar: "https://avatars.githubusercontent.com/u/35109?s=50&v=4",
  ),
  Sponsor(
    name: "Florian Kraft",
    url: "https://github.com/floriank",
    avatar: "https://avatars.githubusercontent.com/u/498241?s=50&u=125ca8b2e470d493555ff5e75630a794060b03c1&v=4",
  ),
  Sponsor(
    name: "Fede Esteban",
    url: "https://github.com/fmesteban",
    avatar: "https://avatars.githubusercontent.com/u/11654110?s=50&v=4",
  ),
  Sponsor(
    name: "Martijn Gribnau",
    url: "https://github.com/foresterre",
    avatar: "https://avatars.githubusercontent.com/u/5955761?s=50&u=79353233d532ae5cb23325afdadb5b32b1a3dd0b&v=4",
  ),
  Sponsor(
    name: "Francis Hamel",
    url: "https://github.com/francishamel",
    avatar: "https://avatars.githubusercontent.com/u/36383308?s=50&u=7d9dd4844132fd6398bcd1f3a86b0393a0636489&v=4",
  ),
  Sponsor(
    name: "Gabriel Vincent",
    url: "https://github.com/gabrielvincent",
    avatar: "https://avatars.githubusercontent.com/u/469519?s=50&v=4",
  ),
  Sponsor(
    name: "Geir Arne Hjelle",
    url: "https://github.com/gahjelle",
    avatar: "https://avatars.githubusercontent.com/u/728076?s=50&v=4",
  ),
  Sponsor(
    name: "Zsombor Gasparin",
    url: "https://github.com/gasparinzsombor",
    avatar: "https://avatars.githubusercontent.com/u/25465322?s=50&u=18186bbf5e9df8274c5795f2d8359a06ebf0885c&v=4",
  ),
  Sponsor(
    name: "Dylan Carlson",
    url: "https://github.com/gdcrisp",
    avatar: "https://avatars.githubusercontent.com/u/171501478?s=50&u=a880a62a5cc8a8a26e6fcc79255698660c4c78f0&v=4",
  ),
  Sponsor(
    name: "George",
    url: "https://github.com/george-grec",
    avatar: "https://avatars.githubusercontent.com/u/28739561?s=50&u=9aff51a58cd5129a1c50992f96c8625ea71804b5&v=4",
  ),
  Sponsor(
    name: "ggobbe",
    url: "https://github.com/ggobbe",
    avatar: "https://avatars.githubusercontent.com/u/2607273?s=50&u=79ba5419e131102768a102292fc518bcd986453f&v=4",
  ),
  Sponsor(
    name: "Guillaume Hivert",
    url: "https://github.com/ghivert",
    avatar: "https://avatars.githubusercontent.com/u/7314118?s=50&u=357a18cb8a00b4ba24380636f445c2f0f9604927&v=4",
  ),
  Sponsor(
    name: "Giacomo Cavalieri",
    url: "https://github.com/giacomocavalieri",
    avatar: "https://avatars.githubusercontent.com/u/20598369?s=50&u=3ba1ad4894b381626b5aa8503bcd9b06f02554cc&v=4",
  ),
  Sponsor(
    name: "Giovanni Kock Bonetti",
    url: "https://github.com/giovannibonetti",
    avatar: "https://avatars.githubusercontent.com/u/3451581?s=50&u=739da1d4c233cd5a5fe0880cff4bed9461fdb66d&v=4",
  ),
  Sponsor(
    name: "Georgi Martsenkov",
    url: "https://github.com/gmartsenkov",
    avatar: "https://avatars.githubusercontent.com/u/7080637?s=50&u=d62c4e5c3c3a554ea80aaaa1b42610930ad4dde6&v=4",
  ),
  Sponsor(
    name: "Dima Utkin",
    url: "https://github.com/gothy",
    avatar: "https://avatars.githubusercontent.com/u/131037?s=50&v=4",
  ),
  Sponsor(
    name: "Isaac",
    url: "https://github.com/graphiteisaac",
    avatar: "https://avatars.githubusercontent.com/u/11805258?s=50&u=5d04d393bc24484eabc9e946fd061b6b8e550b03&v=4",
  ),
  Sponsor(
    name: "Guillaume Heu",
    url: "https://github.com/guillheu",
    avatar: "https://avatars.githubusercontent.com/u/72808144?s=50&u=6d453ca5761275459dd29e8b77c39bde4b19018f&v=4",
  ),
  Sponsor(
    name: "G-J van Rooyen",
    url: "https://github.com/gvrooyen",
    avatar: "https://avatars.githubusercontent.com/u/965960?s=50&u=82e770f3b739f6759d1cafafd98046e862d49419&v=4",
  ),
  Sponsor(
    name: "Hammad Javed",
    url: "https://github.com/hammad-r-javed",
    avatar: "https://avatars.githubusercontent.com/u/128047144?s=50&u=9d372b54c5da4d0db1ec8eb71c7b77c811b22030&v=4",
  ),
  Sponsor(
    name: "Kramer Hampton",
    url: "https://github.com/hamptokr",
    avatar: "https://avatars.githubusercontent.com/u/22182349?s=50&u=9195fbf5a0dbd6a31add20cf8ab8189eda6f6bb6&v=4",
  ),
  Sponsor(
    name: "Matt Champagne",
    url: "https://github.com/han-tyumi",
    avatar: "https://avatars.githubusercontent.com/u/13040345?s=50&u=c35f32e3dc4cf30c96cdd23d6156054d1d9bcbbc&v=4",
  ),
  Sponsor(
    name: "Hayleigh Thompson",
    url: "https://github.com/hayleigh-dot-dev",
    avatar: "https://avatars.githubusercontent.com/u/9001354?s=50&u=47844e1a4b528ff411eda269dada4dae0629e009&v=4",
  ),
  Sponsor(
    name: "Henning Dahlheim",
    url: "https://github.com/hdahlheim",
    avatar: "https://avatars.githubusercontent.com/u/16597280?s=50&u=cb4fbbcece55df20084132fa5544424d7af33fd3&v=4",
  ),
  Sponsor(
    name: "Henry Warren",
    url: "https://github.com/henrysdev",
    avatar: "https://avatars.githubusercontent.com/u/14046865?s=50&u=8a051bed74cc5f9d516a57bf7de4c91a50f48f8b&v=4",
  ),
  Sponsor(
    name: "Hazel Bachrach",
    url: "https://github.com/hibachrach",
    avatar: "https://avatars.githubusercontent.com/u/8454804?s=50&u=ba78ed06d1714fb4a5df9ff997b60f362e2d1837&v=4",
  ),
  Sponsor(
    name: "Shuqian Hon",
    url: "https://github.com/honsq90",
    avatar: "https://avatars.githubusercontent.com/u/1791439?s=50&u=3de7f249a698c500064294b4972defa3aa0399b6&v=4",
  ),
  Sponsor(
    name: "Hubert Małkowski",
    url: "https://github.com/hubertmalkowski",
    avatar: "https://avatars.githubusercontent.com/u/61802095?s=50&v=4",
  ),
  Sponsor(
    name: "human154",
    url: "https://github.com/human154",
    avatar: "https://avatars.githubusercontent.com/u/46430360?s=50&v=4",
  ),
  Sponsor(
    name: "Jimpjorps™",
    url: "https://github.com/hunkyjimpjorps",
    avatar: "https://avatars.githubusercontent.com/u/5170341?s=50&v=4",
  ),
  Sponsor(
    name: "Jean Niklas L'orange",
    url: "https://github.com/hypirion",
    avatar: "https://avatars.githubusercontent.com/u/504876?s=50&u=9370cb4e417becb06fa4ee34fae7b79afb8b7523&v=4",
  ),
  Sponsor(
    name: "Iain H",
    url: "https://github.com/iainh",
    avatar: "https://avatars.githubusercontent.com/u/519512?s=50&u=a2d55b8a6a8fd0b4f807113b5e326377cc1cc94c&v=4",
  ),
  Sponsor(
    name: "Ian M. Jones",
    url: "https://github.com/ianmjones",
    avatar: "https://avatars.githubusercontent.com/u/4710?s=50&u=5c2933133f865193c8409a736811c80eb5a3c332&v=4",
  ),
  Sponsor(
    name: "Marcos",
    url: "https://github.com/ideaMarcos",
    avatar: "https://avatars.githubusercontent.com/u/571086?s=50&u=783a2cecfb87b7161b8a6b1a9cf6969b8443eab6&v=4",
  ),
  Sponsor(
    name: "Jonas E. P",
    url: "https://github.com/igern",
    avatar: "https://avatars.githubusercontent.com/u/26411661?s=50&v=4",
  ),
  Sponsor(
    name: "Igor Montagner",
    url: "https://github.com/igordsm",
    avatar: "https://avatars.githubusercontent.com/u/221446?s=50&u=ef67fa5b1153d298b02b1e4aea5f1241582dd56a&v=4",
  ),
  Sponsor(
    name: "Hannes Schnaitter",
    url: "https://github.com/ildorn",
    avatar: "https://avatars.githubusercontent.com/u/277070?s=50&u=1f4612b0d29ffee4021bc8024bd24a748c7c5fe3&v=4",
  ),
  Sponsor(
    name: "Isaac McQueen",
    url: "https://github.com/imcquee",
    avatar: "https://avatars.githubusercontent.com/u/18041916?s=50&u=fde49d6f7f5be557dd70e308651ff7789e58c471&v=4",
  ),
  Sponsor(
    name: "inoas",
    url: "https://github.com/inoas",
    avatar: "https://avatars.githubusercontent.com/u/20972207?s=50&u=886cccd641cbc44d3657b12bac4e42206e46416c&v=4",
  ),
  Sponsor(
    name: "Colin",
    url: "https://github.com/insanitybit",
    avatar: "https://avatars.githubusercontent.com/u/4956357?s=50&v=4",
  ),
  Sponsor(
    name: "Isaac Harris-Holt",
    url: "https://github.com/isaacharrisholt",
    avatar: "https://avatars.githubusercontent.com/u/47423046?s=50&u=2f967bd888efd962f41319abb72cc4c9a347a147&v=4",
  ),
  Sponsor(
    name: "Ivar Vong",
    url: "https://github.com/ivarvong",
    avatar: "https://avatars.githubusercontent.com/u/183226?s=50&u=c1d9eb6a4c6947d16bf573be1276b3c743df1d0b&v=4",
  ),
  Sponsor(
    name: "Jacob Lamb",
    url: "https://github.com/jacobdalamb",
    avatar: "https://avatars.githubusercontent.com/u/44789941?s=50&u=0f85ea0e3de87bddb991c423d1279cceb28edda9&v=4",
  ),
  Sponsor(
    name: "Jake Cleary",
    url: "https://github.com/jakecleary",
    avatar: "https://avatars.githubusercontent.com/u/4572429?s=50&u=ed22a6f6ed072e99c2d585119209852ee3be8bef&v=4",
  ),
  Sponsor(
    name: "Jakob Ladegaard Møller",
    url: "https://github.com/jakob753951",
    avatar: "https://avatars.githubusercontent.com/u/14878661?s=50&v=4",
  ),
  Sponsor(
    name: "James Birtles",
    url: "https://github.com/jamesbirtles",
    avatar: "https://avatars.githubusercontent.com/u/3743418?s=50&u=573108bf43be669fd94fad00180ae3ddb60b510f&v=4",
  ),
  Sponsor(
    name: "James MacAulay",
    url: "https://github.com/jamesmacaulay",
    avatar: "https://avatars.githubusercontent.com/u/340?s=50&v=4",
  ),
  Sponsor(
    name: "Jan Pieper",
    url: "https://github.com/janpieper",
    avatar: "https://avatars.githubusercontent.com/u/426371?s=50&u=dcb59566a30815fbfcb21fbb33c09f2ce65ff84f&v=4",
  ),
  Sponsor(
    name: "Corentin J.",
    url: "https://github.com/jcorentin",
    avatar: "https://avatars.githubusercontent.com/u/10003192?s=50&v=4",
  ),
  Sponsor(
    name: "jiangplus",
    url: "https://github.com/jiangplus",
    avatar: "https://avatars.githubusercontent.com/u/2041398?s=50&u=1469d2056e81dc3a0bb876bd0c29e6e7c39000e1&v=4",
  ),
  Sponsor(
    name: "Jean-Marc QUERE",
    url: "https://github.com/jihem",
    avatar: "https://avatars.githubusercontent.com/u/106965?s=50&u=e86fdefc126de9bb8e9fc9d6e0ce0f63f19d6f66&v=4",
  ),
  Sponsor(
    name: "Kemp Brinson",
    url: "https://github.com/jkbrinso",
    avatar: "https://avatars.githubusercontent.com/u/12465330?s=50&u=9175e8798ec5a4fcee5d46e9ce5cc0a9d8571bfc&v=4",
  ),
  Sponsor(
    name: "Jean-Luc Geering",
    url: "https://github.com/jlgeering",
    avatar: "https://avatars.githubusercontent.com/u/388658?s=50&u=f3b1f85d7c3ac2b29944b7a762d7cca64336d256&v=4",
  ),
  Sponsor(
    name: "John Pavlick",
    url: "https://github.com/jmpavlick",
    avatar: "https://avatars.githubusercontent.com/u/431497?s=50&u=a3a06d79d5c7d5f78dafb5df080551cb292959b4&v=4",
  ),
  Sponsor(
    name: "Joey Kilpatrick",
    url: "https://github.com/joeykilpatrick",
    avatar: "https://avatars.githubusercontent.com/u/29028840?s=50&u=50b50261c180b7d4f1d8bbfb7088e331ecd6c982&v=4",
  ),
  Sponsor(
    name: "Joey Trapp",
    url: "https://github.com/joeytrapp",
    avatar: "https://avatars.githubusercontent.com/u/283946?s=50&v=4",
  ),
  Sponsor(
    name: "Johan Strand",
    url: "https://github.com/johan-st",
    avatar: "https://avatars.githubusercontent.com/u/53336235?s=50&u=552f8e1e16c4e8e3d160b3dfc6b7a061f8bb0f79&v=4",
  ),
  Sponsor(
    name: "Jon Lambert",
    url: "https://github.com/jonlambert",
    avatar: "https://avatars.githubusercontent.com/u/856225?s=50&u=1992a93d5a2580f730f9991edbd08d2f1acd2e31&v=4",
  ),
  Sponsor(
    name: "jooaf",
    url: "https://github.com/jooaf",
    avatar: "https://avatars.githubusercontent.com/u/160784190?s=50&u=9b41becf2003d7693e70c87af7f82ab174dc2c82&v=4",
  ),
  Sponsor(
    name: "Joseph Lozano",
    url: "https://github.com/joseph-lozano",
    avatar: "https://avatars.githubusercontent.com/u/12260694?s=50&u=ff3b7d8dd83573506fc866e4581d916544ee15e8&v=4",
  ),
  Sponsor(
    name: "Joshua Steele",
    url: "https://github.com/joshocalico",
    avatar: "https://avatars.githubusercontent.com/u/35418916?s=50&u=c9f593616491294e2b03f792b9f221b735cd31be&v=4",
  ),
  Sponsor(
    name: "John Strunk",
    url: "https://github.com/jrstrunk",
    avatar: "https://avatars.githubusercontent.com/u/56702592?s=50&u=d5ff1d019aa28c1885bd259ebba0f0e3b45d3d69&v=4",
  ),
  Sponsor(
    name: "Justin Lubin",
    url: "https://github.com/justinlubin",
    avatar: "https://avatars.githubusercontent.com/u/1222034?s=50&u=29d8c4416eb86ce574d202be43f9ec7ada2320fb&v=4",
  ),
  Sponsor(
    name: "Jake Wood",
    url: "https://github.com/jzwood",
    avatar: "https://avatars.githubusercontent.com/u/13749324?s=50&u=1b648d2d4535dbea1b2ef81534c80b796b0d7a84&v=4",
  ),
  Sponsor(
    name: "Mikael Karlsson",
    url: "https://github.com/karlsson",
    avatar: "https://avatars.githubusercontent.com/u/305638?s=50&u=6c1d565b849a0ea69ebfc55f1809246e3ef299df&v=4",
  ),
  Sponsor(
    name: "Kero van Gelder",
    url: "https://github.com/keroami",
    avatar: "https://avatars.githubusercontent.com/u/204938?s=50&u=6bd6f7d1307c35c668149a1e4dd8c1a69fe6dfd3&v=4",
  ),
  Sponsor(
    name: "Kevin Schweikert",
    url: "https://github.com/kevinschweikert",
    avatar: "https://avatars.githubusercontent.com/u/54439512?s=50&u=fdd6d8eaaeb85d4aa35d76195be89848a3f3c6db&v=4",
  ),
  Sponsor(
    name: "Kryštof Řezáč",
    url: "https://github.com/krystofrezac",
    avatar: "https://avatars.githubusercontent.com/u/39591095?s=50&u=7da7d921986b69d6081501f38fb963a902d33bce&v=4",
  ),
  Sponsor(
    name: "Krzysztof Gasienica-Bednarz",
    url: "https://github.com/krzysztofgb",
    avatar: "https://avatars.githubusercontent.com/u/24556218?s=50&u=1e57abc07c4171c3408380515587e702dabe6282&v=4",
  ),
  Sponsor(
    name: "Hannes Nevalainen",
    url: "https://github.com/kwando",
    avatar: "https://avatars.githubusercontent.com/u/891566?s=50&u=ada205321160d641e3968fb79905312cd77a1396&v=4",
  ),
  Sponsor(
    name: "Luke Amdor",
    url: "https://github.com/lamdor",
    avatar: "https://avatars.githubusercontent.com/u/1580?s=50&u=a766174cc0229b5ab2309f3820f61f883ee3a09c&v=4",
  ),
  Sponsor(
    name: "Lukas Bjarre",
    url: "https://github.com/lbjarre",
    avatar: "https://avatars.githubusercontent.com/u/31847966?s=50&u=37c5787bc6dc02a81355bff5df2dcdb9f8dfa8bc&v=4",
  ),
  Sponsor(
    name: "Lee Jarvis",
    url: "https://github.com/leejarvis",
    avatar: "https://avatars.githubusercontent.com/u/197567?s=50&u=0f27bb255b8cafa82c4bcc62b2a3884aa61e7d75&v=4",
  ),
  Sponsor(
    name: "Leon Qadirie",
    url: "https://github.com/leonqadirie",
    avatar: "https://avatars.githubusercontent.com/u/39130739?s=50&u=334ef35279398d7ae83adb27190bba0e1cef7e95&v=4",
  ),
  Sponsor(
    name: "Leandro Ostera",
    url: "https://github.com/leostera",
    avatar: "https://avatars.githubusercontent.com/u/854222?s=50&u=54efbe6d872eefca0cb1d64a9e9db6085f113729&v=4",
  ),
  Sponsor(
    name: "Lexx",
    url: "https://github.com/lexx27",
    avatar: "https://avatars.githubusercontent.com/u/696146?s=50&u=819dd4f87e0ffa21a5acf0d9f4004277176d584c&v=4",
  ),
  Sponsor(
    name: "Heyang Zhou",
    url: "https://github.com/losfair",
    avatar: "https://avatars.githubusercontent.com/u/6104981?s=50&u=6463c569f9f38a409ce1923b2c2c7240fc304661&v=4",
  ),
  Sponsor(
    name: "Tudor Luca",
    url: "https://github.com/lucamtudor",
    avatar: "https://avatars.githubusercontent.com/u/3036785?s=50&u=0564946f5f1483a15f357bfe1da8aaba413d7f84&v=4",
  ),
  Sponsor(
    name: "Lucas Pellegrinelli",
    url: "https://github.com/lucaspellegrinelli",
    avatar: "https://avatars.githubusercontent.com/u/19651296?s=50&u=8243937d62b608293d64a8f297b572962dd46d51&v=4",
  ),
  Sponsor(
    name: "Matt Mullenweg",
    url: "https://github.com/m",
    avatar: "https://avatars.githubusercontent.com/u/48685?s=50&v=4",
  ),
  Sponsor(
    name: "Robert Malko",
    url: "https://github.com/malkomalko",
    avatar: "https://avatars.githubusercontent.com/u/763?s=50&u=404005e973404d3b6d3fcb835e19584577811f55&v=4",
  ),
  Sponsor(
    name: "Manuel Rubio",
    url: "https://github.com/manuel-rubio",
    avatar: "https://avatars.githubusercontent.com/u/2188638?s=50&u=846b8f6bde5511898e384d5d9ceab0cfaac505fd&v=4",
  ),
  Sponsor(
    name: "marcusandre",
    url: "https://github.com/marcusandre",
    avatar: "https://avatars.githubusercontent.com/u/102828?s=50&v=4",
  ),
  Sponsor(
    name: "Marius Kalvø",
    url: "https://github.com/mariuskalvo",
    avatar: "https://avatars.githubusercontent.com/u/5960745?s=50&u=2775476bcdd3e1fb96129ad777dd2e30fef76baf&v=4",
  ),
  Sponsor(
    name: "Mark Holmes",
    url: "https://github.com/markholmes",
    avatar: "https://avatars.githubusercontent.com/u/921826?s=50&u=315e6483dbe88494b733647492faadcbfe77b041&v=4",
  ),
  Sponsor(
    name: "Mark Markaryan",
    url: "https://github.com/markmark206",
    avatar: "https://avatars.githubusercontent.com/u/218696?s=50&u=06ddfe39562f21d97e7278b8fa687e494e40fa79&v=4",
  ),
  Sponsor(
    name: "martonkaufmann",
    url: "https://github.com/martonkaufmann",
    avatar: "https://avatars.githubusercontent.com/u/53054243?s=50&v=4",
  ),
  Sponsor(
    name: "Matt Savoia",
    url: "https://github.com/matt-savvy",
    avatar: "https://avatars.githubusercontent.com/u/6637105?s=50&u=13bf3c171573bae76a4671125ca1f9fc95f35fba&v=4",
  ),
  Sponsor(
    name: "Matthew Jackson",
    url: "https://github.com/matthewj-dev",
    avatar: "https://avatars.githubusercontent.com/u/13512861?s=50&u=302c005476d3d94629683e1b8c2ffc4f0108c3d6&v=4",
  ),
  Sponsor(
    name: "Matt Robinson",
    url: "https://github.com/matthewrobinsondev",
    avatar: "https://avatars.githubusercontent.com/u/50462255?s=50&u=ac27bc6343fe1b6a40b5a84ffe8c954f97e77a3d&v=4",
  ),
  Sponsor(
    name: "Matt Van Horn",
    url: "https://github.com/mattvanhorn",
    avatar: "https://avatars.githubusercontent.com/u/20461?s=50&v=4",
  ),
  Sponsor(
    name: "Max McDonnell",
    url: "https://github.com/maxmcd",
    avatar: "https://avatars.githubusercontent.com/u/283903?s=50&u=7267840cc5a5e268b9a10a0547bada4cba1eb34e&v=4",
  ),
  Sponsor(
    name: "metame",
    url: "https://github.com/metame",
    avatar: "https://avatars.githubusercontent.com/u/5567561?s=50&u=5858f5db5f30b5a8003a7256fe9d83d0a4ca2001&v=4",
  ),
  Sponsor(
    name: "METATEXX GmbH",
    url: "https://github.com/metatexx",
    avatar: "https://avatars.githubusercontent.com/u/10522448?s=50&v=4",
  ),
  Sponsor(
    name: "Sam Zanca",
    url: "https://github.com/metruzanca",
    avatar: "https://avatars.githubusercontent.com/u/32832892?s=50&u=d8147eab1323d98f5968e48185b8d1e209349a23&v=4",
  ),
  Sponsor(
    name: "Matt Heise",
    url: "https://github.com/mhheise",
    avatar: "https://avatars.githubusercontent.com/u/17503914?s=50&u=098deaa0c3f459f0039a610ba54ca61c5f3d645f&v=4",
  ),
  Sponsor(
    name: "Michael Jones",
    url: "https://github.com/michaeljones",
    avatar: "https://avatars.githubusercontent.com/u/5390?s=50&u=7c017ec72f57d09b5b3b43fe52f243d9f2df7765&v=4",
  ),
  Sponsor(
    name: "Michael Mazurczak",
    url: "https://github.com/monocursive",
    avatar: "https://avatars.githubusercontent.com/u/2698317?s=50&u=5f4e314f8b7b93520c318a338d2c1dae642fee82&v=4",
  ),
  Sponsor(
    name: "Jan Skriver Sørensen",
    url: "https://github.com/monzool",
    avatar: "https://avatars.githubusercontent.com/u/2856927?s=50&u=0b997b23cf44fbddd231cc911515da593d9dccd1&v=4",
  ),
  Sponsor(
    name: "Ryan Moore",
    url: "https://github.com/mooreryan",
    avatar: "https://avatars.githubusercontent.com/u/3172014?s=50&u=5efa6914e7730fa3b9e743d9030575bc6b48ebee&v=4",
  ),
  Sponsor(
    name: "Michael McClintock",
    url: "https://github.com/mrmcc3",
    avatar: "https://avatars.githubusercontent.com/u/4220099?s=50&u=bda7dcd5af806f09623dd020f25bd05087857882&v=4",
  ),
  Sponsor(
    name: "Niket Shah",
    url: "https://github.com/mrniket",
    avatar: "https://avatars.githubusercontent.com/u/2016308?s=50&u=4e7d3322e9c77a1e705317b773985ac3798fc32d&v=4",
  ),
  Sponsor(
    name: "Mike Roach",
    url: "https://github.com/mroach",
    avatar: "https://avatars.githubusercontent.com/u/79006?s=50&u=c9afda3a9a7b694e8ef7f1c70184559add8d8655&v=4",
  ),
  Sponsor(
    name: "Alexander Stensrud",
    url: "https://github.com/muonoum",
    avatar: "https://avatars.githubusercontent.com/u/3189?s=50&v=4",
  ),
  Sponsor(
    name: "Mat Warger",
    url: "https://github.com/mwarger",
    avatar: "https://avatars.githubusercontent.com/u/686823?s=50&u=77d733dbd3fadfa97ce921113dc14d5955f2d7b8&v=4",
  ),
  Sponsor(
    name: "Matthew Whitworth",
    url: "https://github.com/mwhitworth",
    avatar: "https://avatars.githubusercontent.com/u/3876709?s=50&u=4dfb7388b3e132890d3692cd735fbbd37a934a33&v=4",
  ),
  Sponsor(
    name: "n8n - Workflow Automation",
    url: "https://github.com/n8nio",
    avatar: "https://avatars.githubusercontent.com/u/52133374?s=50&v=4",
  ),
  Sponsor(
    name: "Fernando Farias",
    url: "https://github.com/nandofarias",
    avatar: "https://avatars.githubusercontent.com/u/1944560?s=50&u=16ea7e154a7738b24c0d8c5ba013b87b7677091a&v=4",
  ),
  Sponsor(
    name: "Natanael Sirqueira",
    url: "https://github.com/natanaelsirqueira",
    avatar: "https://avatars.githubusercontent.com/u/13697898?s=50&u=2aedada2b840e9a047fbec5b49fc8e0d3e5f7236&v=4",
  ),
  Sponsor(
    name: "Nathaniel Knight",
    url: "https://github.com/nathanielknight",
    avatar: "https://avatars.githubusercontent.com/u/1239091?s=50&u=6fb38af8299220ff444f5080aa2c67085132cd50&v=4",
  ),
  Sponsor(
    name: "Nick Chapman",
    url: "https://github.com/nchapman",
    avatar: "https://avatars.githubusercontent.com/u/3095?s=50&u=1c0038e3305d41b5911a005d818f8f4f10c2af4e&v=4",
  ),
  Sponsor(
    name: "Nick Reynolds",
    url: "https://github.com/ndreynolds",
    avatar: "https://avatars.githubusercontent.com/u/670471?s=50&u=f026d956aac0c35b8077d5ab0fb455eea886d18c&v=4",
  ),
  Sponsor(
    name: "Guilherme de Maio",
    url: "https://github.com/nirev",
    avatar: "https://avatars.githubusercontent.com/u/686510?s=50&u=abb24e34725b5f0390f1fded181e4e56f92146cc&v=4",
  ),
  Sponsor(
    name: "ollie",
    url: "https://github.com/nnuuvv",
    avatar: "https://avatars.githubusercontent.com/u/79169882?s=50&u=60da141a24463197233a3892a04e05242079d899&v=4",
  ),
  Sponsor(
    name: "Nomio",
    url: "https://github.com/nomio",
    avatar: "https://avatars.githubusercontent.com/u/47601243?s=50&v=4",
  ),
  Sponsor(
    name: "Bruno Michel",
    url: "https://github.com/nono",
    avatar: "https://avatars.githubusercontent.com/u/2767?s=50&u=ff72b1ad63026e0729acc2dd41378e28ab704a3f&v=4",
  ),
  Sponsor(
    name: "Ernesto Malave",
    url: "https://github.com/oberernst",
    avatar: "https://avatars.githubusercontent.com/u/98632774?s=50&u=b24987a18b8d7af92a41905689dccae77d50f450&v=4",
  ),
  Sponsor(
    name: "Ocean",
    url: "https://github.com/oceanlewis",
    avatar: "https://avatars.githubusercontent.com/u/6754950?s=50&u=b61052ec461e5b92f74f86313b7dbee6ab466afc&v=4",
  ),
  Sponsor(
    name: "Hans Raaf",
    url: "https://github.com/oderwat",
    avatar: "https://avatars.githubusercontent.com/u/719156?s=50&v=4",
  ),
  Sponsor(
    name: "Jen Stehlik",
    url: "https://github.com/okkdev",
    avatar: "https://avatars.githubusercontent.com/u/20144629?s=50&u=a7cc738c98e454d194d6c445d423724da9cbedd3&v=4",
  ),
  Sponsor(
    name: "optizio",
    url: "https://github.com/optizio",
    avatar: "https://avatars.githubusercontent.com/u/65961177?s=50&v=4",
  ),
  Sponsor(
    name: "Olaf Sebelin",
    url: "https://github.com/osebelin",
    avatar: "https://avatars.githubusercontent.com/u/578127?s=50&u=eb8d7fbedf9de34898062b66035534246258d33b&v=4",
  ),
  Sponsor(
    name: "Oliver Tosky",
    url: "https://github.com/otosky",
    avatar: "https://avatars.githubusercontent.com/u/42260747?s=50&u=69d089387c743d89427aa4ad8740cfb34045a9e0&v=4",
  ),
  Sponsor(
    name: "Pete Jodo",
    url: "https://github.com/petejodo",
    avatar: "https://avatars.githubusercontent.com/u/1938892?s=50&u=5a78046101d2b51614045e214aa1545a9dc792a2&v=4",
  ),
  Sponsor(
    name: "Paul Guse",
    url: "https://github.com/pguse",
    avatar: "https://avatars.githubusercontent.com/u/9814538?s=50&u=3cb89966ac6755daca993799d9e275d9f8c7bd24&v=4",
  ),
  Sponsor(
    name: "Philpax",
    url: "https://github.com/philpax",
    avatar: "https://avatars.githubusercontent.com/u/707827?s=50&u=099bc9db5cc0304b118a081ac6e05246fbf612df&v=4",
  ),
  Sponsor(
    name: "Pierrot",
    url: "https://github.com/pierrot-lc",
    avatar: "https://avatars.githubusercontent.com/u/25549037?s=50&u=e1497004cf68c741c4db8f6d2200cef6f7b147ac&v=4",
  ),
  Sponsor(
    name: "Danny Arnold",
    url: "https://github.com/pinnet",
    avatar: "https://avatars.githubusercontent.com/u/5225217?s=50&u=fc4c4c9067182f77a10a04c53f913ee4bb7cb316&v=4",
  ),
  Sponsor(
    name: "Martin Poelstra",
    url: "https://github.com/poelstra",
    avatar: "https://avatars.githubusercontent.com/u/1025628?s=50&u=34690bffb12e46348ce0433a1e250a16bfddb52e&v=4",
  ),
  Sponsor(
    name: "Peter Rice",
    url: "https://github.com/pvsr",
    avatar: "https://avatars.githubusercontent.com/u/12705140?s=50&v=4",
  ),
  Sponsor(
    name: "Qdentity",
    url: "https://github.com/qdentity",
    avatar: "https://avatars.githubusercontent.com/u/1351994?s=50&v=4",
  ),
  Sponsor(
    name: "Race Williams",
    url: "https://github.com/raquentin",
    avatar: "https://avatars.githubusercontent.com/u/63271957?s=50&u=b88c6c61afd3eab849afdb1224111c6304aec822&v=4",
  ),
  Sponsor(
    name: "Alex Manning",
    url: "https://github.com/rawhat",
    avatar: "https://avatars.githubusercontent.com/u/2095509?s=50&u=c891c779ec80e181e60772b4adfdc8be1ee84d2d&v=4",
  ),
  Sponsor(
    name: "Lennon Day-Reynolds",
    url: "https://github.com/rcoder",
    avatar: "https://avatars.githubusercontent.com/u/15941?s=50&u=5eae6fb18c631516fd508b915afa1a3ac5e396af&v=4",
  ),
  Sponsor(
    name: "Martin Rechsteiner ",
    url: "https://github.com/rechsteiner",
    avatar: "https://avatars.githubusercontent.com/u/1238984?s=50&u=d04c9285d9e6d35d8aa864b31b68bc8fcc26eb32&v=4",
  ),
  Sponsor(
    name: "Redmar Kerkhoff",
    url: "https://github.com/redmar",
    avatar: "https://avatars.githubusercontent.com/u/1473?s=50&v=4",
  ),
  Sponsor(
    name: "Reilly Tucker Siemens",
    url: "https://github.com/reillysiemens",
    avatar: "https://avatars.githubusercontent.com/u/3084059?s=50&u=6674b1fc0435cadb369931c1ab82aebeb520fd58&v=4",
  ),
  Sponsor(
    name: "Rupus Reinefjord",
    url: "https://github.com/reinefjord",
    avatar: "https://avatars.githubusercontent.com/u/1427359?s=50&u=b09966df87201581b307e6e25f50678aa3879906&v=4",
  ),
  Sponsor(
    name: "Robert Ellen",
    url: "https://github.com/rellen",
    avatar: "https://avatars.githubusercontent.com/u/459086?s=50&u=dae9051904e95a8c27d3c732d7e1be1127c7cc93&v=4",
  ),
  Sponsor(
    name: "re.natillas",
    url: "https://github.com/renatillas",
    avatar: "https://avatars.githubusercontent.com/u/114509577?s=50&u=5cf38507a836eed1c42c806c8305d85e976df65f&v=4",
  ),
  Sponsor(
    name: "Renato Massaro",
    url: "https://github.com/renatomassaro",
    avatar: "https://avatars.githubusercontent.com/u/5695464?s=50&u=b097a791f1e088c27f0c0426c6733c6bbc2a40ed&v=4",
  ),
  Sponsor(
    name: "Renovator",
    url: "https://github.com/renovatorruler",
    avatar: "https://avatars.githubusercontent.com/u/101647?s=50&u=575944b8f11d7f942392a670ae910dc931c111f0&v=4",
  ),
  Sponsor(
    name: "Ben Martin",
    url: "https://github.com/requestben",
    avatar: "https://avatars.githubusercontent.com/u/89737671?s=50&u=c9009b9ef9fe5cd6d03c232b2a75ae39c56885f7&v=4",
  ),
  Sponsor(
    name: "Richard Viney",
    url: "https://github.com/richard-viney",
    avatar: "https://avatars.githubusercontent.com/u/236550?s=50&v=4",
  ),
  Sponsor(
    name: "Rico Leuthold",
    url: "https://github.com/rico",
    avatar: "https://avatars.githubusercontent.com/u/92818?s=50&u=14f235610bc0087faf2253c5980590db6c7907da&v=4",
  ),
  Sponsor(
    name: "Rintaro Okamura",
    url: "https://github.com/rinx",
    avatar: "https://avatars.githubusercontent.com/u/1588935?s=50&u=1ae205f1c9e4d5dfac56a797f9e7083a6db8999d&v=4",
  ),
  Sponsor(
    name: "Ripta Pasay",
    url: "https://github.com/ripta",
    avatar: "https://avatars.githubusercontent.com/u/9858?s=50&u=861ceb726209b5c4cd0231bb5fb0554ee3a7da03&v=4",
  ),
  Sponsor(
    name: "Victor Rodrigues",
    url: "https://github.com/rodrigues",
    avatar: "https://avatars.githubusercontent.com/u/128147?s=50&u=ca06210e8377eb67b9420a79233bcb7820f14b33&v=4",
  ),
  Sponsor(
    name: "Rotabull",
    url: "https://github.com/rotabull",
    avatar: "https://avatars.githubusercontent.com/u/48396327?s=50&v=4",
  ),
  Sponsor(
    name: "MzRyuKa",
    url: "https://github.com/rykawamu",
    avatar: "https://avatars.githubusercontent.com/u/38804392?s=50&v=4",
  ),
  Sponsor(
    name: "Sam Aaron",
    url: "https://github.com/samaaron",
    avatar: "https://avatars.githubusercontent.com/u/369?s=50&u=33067a56bf0f4e3fc7b5e498ed1bd1d5f386de25&v=4",
  ),
  Sponsor(
    name: "Vic Valenzuela",
    url: "https://github.com/sandsower",
    avatar: "https://avatars.githubusercontent.com/u/302322?s=50&u=d0dfb89c55fb48d78b05f737ddb52d1585715abd&v=4",
  ),
  Sponsor(
    name: "Saša Jurić",
    url: "https://github.com/sasa1977",
    avatar: "https://avatars.githubusercontent.com/u/202498?s=50&u=71c741d8bb7e45e98f9bed3adb51c98575fee650&v=4",
  ),
  Sponsor(
    name: "Julian Schurhammer",
    url: "https://github.com/schurhammer",
    avatar: "https://avatars.githubusercontent.com/u/2063443?s=50&u=5f64508b50279abc8980866a468458d0247eea7e&v=4",
  ),
  Sponsor(
    name: "Scott Trinh",
    url: "https://github.com/scotttrinh",
    avatar: "https://avatars.githubusercontent.com/u/1682194?s=50&u=120233eb27f98f574a4ad36891d7ea3f6e578928&v=4",
  ),
  Sponsor(
    name: "Scott Wey",
    url: "https://github.com/scottwey",
    avatar: "https://avatars.githubusercontent.com/u/15810260?s=50&u=8affe6b0b2bf506998a3a28b6be70255bd46c51f&v=4",
  ),
  Sponsor(
    name: "Daigo Shitara",
    url: "https://github.com/sdaigo",
    avatar: "https://avatars.githubusercontent.com/u/25382291?s=50&u=1f31c04c42b96d48be02e72ba538d5ac91626cd8&v=4",
  ),
  Sponsor(
    name: "Sean Cribbs",
    url: "https://github.com/seancribbs",
    avatar: "https://avatars.githubusercontent.com/u/1772?s=50&u=189f1701cdae594c5a52011cca824ae7d84a6118&v=4",
  ),
  Sponsor(
    name: "Sean Jensen-Grey",
    url: "https://github.com/seanjensengrey",
    avatar: "https://avatars.githubusercontent.com/u/128454?s=50&v=4",
  ),
  Sponsor(
    name: "sekun",
    url: "https://github.com/sekunho",
    avatar: "https://avatars.githubusercontent.com/u/20364796?s=50&u=fd39390d4459f7094e7d1da5e3a27d430507bfc3&v=4",
  ),
  Sponsor(
    name: "Jerred Shepherd",
    url: "https://github.com/shepherdjerred",
    avatar: "https://avatars.githubusercontent.com/u/3904778?s=50&u=0abe1e5c0de7f62093d204d4991906c95eb601c7&v=4",
  ),
  Sponsor(
    name: "Sigma",
    url: "https://github.com/sigmasternchen",
    avatar: "https://avatars.githubusercontent.com/u/4953645?s=50&u=a07f24aeddc81e55650551b0a5880d56a22aa80f&v=4",
  ),
  Sponsor(
    name: "simone",
    url: "https://github.com/simonewebdesign",
    avatar: "https://avatars.githubusercontent.com/u/2126073?s=50&v=4",
  ),
  Sponsor(
    name: "Sławomir Ehlert",
    url: "https://github.com/slafs",
    avatar: "https://avatars.githubusercontent.com/u/210173?s=50&v=4",
  ),
  Sponsor(
    name: "sambit",
    url: "https://github.com/soulsam480",
    avatar: "https://avatars.githubusercontent.com/u/35460828?s=50&u=60890a553d1e207ef3901f18a4ac19ab7dff58b5&v=4",
  ),
  Sponsor(
    name: "CJ Salem",
    url: "https://github.com/specialblend",
    avatar: "https://avatars.githubusercontent.com/u/16548845?s=50&u=f47c4e6dd9391796c2ad0044868e429ed7a591b5&v=4",
  ),
  Sponsor(
    name: "Sebastian Porto",
    url: "https://github.com/sporto",
    avatar: "https://avatars.githubusercontent.com/u/1005498?s=50&u=b6689026e304fa7106e101d5a5e60158a8e4b619&v=4",
  ),
  Sponsor(
    name: "Scott Zhu Reeves",
    url: "https://github.com/star-szr",
    avatar: "https://avatars.githubusercontent.com/u/327943?s=50&v=4",
  ),
  Sponsor(
    name: "Steinar Eliassen",
    url: "https://github.com/steinareliassen",
    avatar: "https://avatars.githubusercontent.com/u/205248?s=50&u=645730e54d51183f170e7f7e20136bce9190ba4a&v=4",
  ),
  Sponsor(
    name: "Stefan Hagen",
    url: "https://github.com/sthagen",
    avatar: "https://avatars.githubusercontent.com/u/450800?s=50&u=40afa5125d883ed9aa5d368202fd9bd27d2f20f1&v=4",
  ),
  Sponsor(
    name: "Rasmus",
    url: "https://github.com/stoft",
    avatar: "https://avatars.githubusercontent.com/u/5726993?s=50&u=629012220f611c734a96689c3e4703c77eab154f&v=4",
  ),
  Sponsor(
    name: "Dan Strong",
    url: "https://github.com/strongoose",
    avatar: "https://avatars.githubusercontent.com/u/6664881?s=50&u=f85941f6f8c259e07c904285102e4526bd8ec314&v=4",
  ),
  Sponsor(
    name: "Michael Duffy",
    url: "https://github.com/stunthamster",
    avatar: "https://avatars.githubusercontent.com/u/1030138?s=50&u=0b94eab83ae023f4539fd5ac0b82f67dacf520d5&v=4",
  ),
  Sponsor(
    name: "Thomas Coopman",
    url: "https://github.com/tcoopman",
    avatar: "https://avatars.githubusercontent.com/u/45546?s=50&u=8dd6825c7270cd0e553b7d4134e4e05f3de0c50c&v=4",
  ),
  Sponsor(
    name: "Alembic",
    url: "https://github.com/team-alembic",
    avatar: "https://avatars.githubusercontent.com/u/25500012?s=50&v=4",
  ),
  Sponsor(
    name: "Seve Salazar",
    url: "https://github.com/tehprofessor",
    avatar: "https://avatars.githubusercontent.com/u/995086?s=50&u=a6f421a92217f34de47433c1eb57e198b8b9bdd1&v=4",
  ),
  Sponsor(
    name: "Adi Iyengar",
    url: "https://github.com/thebugcatcher",
    avatar: "https://avatars.githubusercontent.com/u/10440910?s=50&u=15493fb3a073935b9e9e41eebbd32e1cca53dc0b&v=4",
  ),
  Sponsor(
    name: "Thomas",
    url: "https://github.com/thomaswhyyou",
    avatar: "https://avatars.githubusercontent.com/u/4471723?s=50&u=6a062819c093b612fede974a29356686ba3b2ac2&v=4",
  ),
  Sponsor(
    name: "Timo Sulg",
    url: "https://github.com/timgluz",
    avatar: "https://avatars.githubusercontent.com/u/1223889?s=50&u=a13c54a9e52d336ac32a11b23e4295e47c6caf4c&v=4",
  ),
  Sponsor(
    name: "Tim Brown",
    url: "https://github.com/tmbrwn",
    avatar: "https://avatars.githubusercontent.com/u/7737081?s=50&u=cd7c415ad6d0e32f4b7a48b4d92abf952e07695e&v=4",
  ),
  Sponsor(
    name: "Tomasz Kowal",
    url: "https://github.com/tomekowal",
    avatar: "https://avatars.githubusercontent.com/u/907415?s=50&v=4",
  ),
  Sponsor(
    name: "Tom Schuster",
    url: "https://github.com/tomjschuster",
    avatar: "https://avatars.githubusercontent.com/u/19388254?s=50&u=ec7783d90c6098292e7de55491404cc887b95063&v=4",
  ),
  Sponsor(
    name: "tommaisey",
    url: "https://github.com/tommaisey",
    avatar: "https://avatars.githubusercontent.com/u/2369921?s=50&u=49a3c8c923d3ba5e4dbf0b1a876c9ec7fa7df555&v=4",
  ),
  Sponsor(
    name: "Tristan Sloughter",
    url: "https://github.com/tsloughter",
    avatar: "https://avatars.githubusercontent.com/u/36227?s=50&v=4",
  ),
  Sponsor(
    name: "Henrik Tudborg",
    url: "https://github.com/tudborg",
    avatar: "https://avatars.githubusercontent.com/u/195468?s=50&u=77d98d348b2671614f15b70aa0489debb96c8036&v=4",
  ),
  Sponsor(
    name: "tymak",
    url: "https://github.com/tymak",
    avatar: "https://avatars.githubusercontent.com/u/26909416?s=50&v=4",
  ),
  Sponsor(
    name: "upsidedowncake",
    url: "https://github.com/upsidedownsweetfood",
    avatar: "https://avatars.githubusercontent.com/u/152233509?s=50&u=02a3e51780be8c54062f48b56defdc9d225c7606&v=4",
  ),
  Sponsor(
    name: "Ruslan Ustitc",
    url: "https://github.com/ustitc",
    avatar: "https://avatars.githubusercontent.com/u/7880921?s=50&u=e5f2d71f89a012f68047328c0ac18fdf92e1e8ea&v=4",
  ),
  Sponsor(
    name: "Chris Ohk",
    url: "https://github.com/utilForever",
    avatar: "https://avatars.githubusercontent.com/u/5622661?s=50&u=65b5479604e3264a2ab06ffde42d5ff3d1011bab&v=4",
  ),
  Sponsor(
    name: "Andrew Varner",
    url: "https://github.com/varnerac",
    avatar: "https://avatars.githubusercontent.com/u/4692391?s=50&v=4",
  ),
  Sponsor(
    name: "Valerio Viperino",
    url: "https://github.com/vvzen",
    avatar: "https://avatars.githubusercontent.com/u/10340139?s=50&u=6385427dad9d1b7f3981ec12c4c8716423cb72fc&v=4",
  ),
  Sponsor(
    name: "Weizheng Liu",
    url: "https://github.com/weizhliu",
    avatar: "https://avatars.githubusercontent.com/u/60593974?s=50&u=0ce23ad23896110ac595b7c0b40eaec6ab8d034c&v=4",
  ),
  Sponsor(
    name: "Wilson Silva",
    url: "https://github.com/wilsonsilva",
    avatar: "https://avatars.githubusercontent.com/u/645203?s=50&v=4",
  ),
  Sponsor(
    name: "Karan Rajeshbhai Mungara",
    url: "https://github.com/withkarann",
    avatar: "https://avatars.githubusercontent.com/u/31102185?s=50&u=504a0920c5d6778c67bf8600ac04b1f3218eef4e&v=4",
  ),
  Sponsor(
    name: "Jojor",
    url: "https://github.com/xjojorx",
    avatar: "https://avatars.githubusercontent.com/u/9108577?s=50&v=4",
  ),
  Sponsor(
    name: "Yamen Sader",
    url: "https://github.com/yamen",
    avatar: "https://avatars.githubusercontent.com/u/350695?s=50&u=6a7a00d535d933b556b569ca46bd71a210956e7d&v=4",
  ),
  Sponsor(
    name: "Endo Shogo",
    url: "https://github.com/yellowsman",
    avatar: "https://avatars.githubusercontent.com/u/5958101?s=50&u=f28fbb09b2a5ca90f1996fe17716816811d0167e&v=4",
  ),
  Sponsor(
    name: "Volker Rabe",
    url: "https://github.com/yelps",
    avatar: "https://avatars.githubusercontent.com/u/172129?s=50&v=4",
  ),
  Sponsor(
    name: "Felix",
    url: "https://github.com/yerTools",
    avatar: "https://avatars.githubusercontent.com/u/31420747?s=50&u=dc0eaae8f8f1467f8c1322525c6efe6ff6fe2827&v=4",
  ),
  Sponsor(
    name: "yoshi~ ",
    url: "https://github.com/yoshi-monster",
    avatar: "https://avatars.githubusercontent.com/u/84042103?s=50&u=b2c981809c143d5835bd92996420d9273e0d0207&v=4",
  ),
  Sponsor(
    name: "ZWubs",
    url: "https://github.com/zwubs",
    avatar: "https://avatars.githubusercontent.com/u/26174688?s=50&v=4",
  ),
]
