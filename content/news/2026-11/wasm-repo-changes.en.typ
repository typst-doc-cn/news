#import "/typ/templates/news.typ": link-news, news-template

#show: news-template.with(
  date: "2026-11-14",
  title: "Recent changes to the wasm-minimal-protocol repo",
  lang: "en",
  tags: ("wasm-minimal-protocol",),
  description: "The wasm-minimal-protocol repository has been updated in the past few months to make it easier to develop Typst Wasm plugins.",
)

#show ref: it => {
  let el = it.element
  if el != none and el.func() == heading {
    link(el.location(), el.body)
  } else {
    it
  }
}

Hi all! The #link("https://github.com/typst-community/wasm-minimal-protocol")[wasm-minimal-protocol repository] has been updated in the past few months to make it easier to develop #link("https://typst.app/docs/reference/foundations/plugin/")[Typst Wasm plugins].

However, I noticed that many people are still struggling with the old complex approaches (they still work, though), so I would like to introduce the new approaches. For completeness, I will also mention changes to the upstream Wasm compilers.

#quote(block: true)[
  Notes:

  - The repository is #link("https://typst.app/docs/reference/foundations/plugin/#resources")[linked] in the Typst Documentation, but it is not affiliated with the Typst GmbH.
  - The protocol remains unchanged; it is just the repository that has been changed.
  - If you are developing a plugin for the first time, you can ignore this post and start from the #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/README.md")[latest README].
]

The repository contains the following three parts. You can jump to the sections you are interested.

- @macro — the Rust macro wrapper library for writing Typst plugins

  (only relevant to Rust)

- @wasi-stub — the CLI tool for stubbing WASI-related functions

  (always required for C and Haskell, and sometimes required for Rust, Zig, Go)

- @examples — example plugin implementations in various programming languages

  (Rust, C, Zig, Go, Haskell, MoonBit)

== macro <macro>
+ The crate has been *published to crates.io*.

  Previously, the crate could only be used as a git dependency or a git submodule. Now the crate is properly versioned, and an up-to-date version has been #link("https://crates.io/crates/wasm-minimal-protocol")[published to crates.io].

  Edit your `Cargo.toml`:

  ```diff
  - wasm-minimal-protocol = { git = "https://github.com/astrale-sharp/wasm-minimal-protocol" }
  + wasm-minimal-protocol = "0.2"
  ```

+ The *alternative crate* has revived.

  There is an alternative macro wrapper called #link("https://crates.io/crates/typst-wasm-protocol")[typst-wasm-protocol]. It provides a more comprehensive wrapper. For instance, you can declare an argument as `Json(point): Json<Point>`, and that wrapper will do the deserialization. In contrast, the wasm-minimal-protocol wrapper does not take care of deserialization.

  Previously, sjfhsjfh, the author of that wrapper, was mistakenly banned by GitHub, preventing him from developing the wrapper. Recently, GitHub finally handled his appeal request. Therefore, he has resumed the development.

== wasi-stub <wasi-stub>
+ *Pre-built binaries* have been available in GitHub Releases.

  Previously, you had to clone the repo and compile on your own. Now you can download pre-built binaries from #link("https://github.com/typst-community/wasm-minimal-protocol/releases")[GitHub Releases]. To select the correct binary for your local machine, run #link("https://crates.io/crates/cargo-binstall")[`cargo binstall wasi-stub`]. To use on CI, use #link("https://github.com/marketplace/actions/install-development-tools")[taiki-e/install-action]:

  ```diff
  - - name: Compile wasi-stub
  -   run: |
  -     git clone … && git sparse-checkout … && cargo install --path . && rm -rf … 
  + - uses: taiki-e/install-action@v2
  +   with:
  +     tool: wasi-stub
  ```

+ The *permission error on Windows* no longer exists.

  Previously, wasi-stub works on Windows, but it always reports a permission error. #link("https://github.com/typst-community/wasm-minimal-protocol/pull/85")[Thanks to msallin], this has been resolved.

+ Now it is easier to *control return values*.

  Sometimes it is needed to stub different functions with different return values (e.g., in #link("https://github.com/peng1999/typst-pyrunner/blob/f6370d1b4b81c9e2c14c24e44d3439bb8cd22ec9/Makefile#L14-L17")[pyrunner build steps]).

  Previously, you had to fork wasi-stub. Now you can achieve that by calling wasi-stub multiple times. For example:

  ```sh
  wasi-stub pyrunner.wasm -o pyrunner.wasm \
    --stub-function wasi_snapshot_preview1:random_get,wasi_snapshot_preview1:environ_get,wasi_snapshot_preview1:environ_sizes_get,wasi_snapshot_preview1:clock_time_get \
    --return-value 0

  wasi-stub pyrunner.wasm -o pyrunner.wasm \
    --stub-function wasi_snapshot_preview1:fd_prestat_get \
    --return-value 8

  wasi-stub pyrunner.wasm -o pyrunner.wasm \
    --stub-module wasi_snapshot_preview1
  ```

  Behind the scene is a *breaking* change: the WASI module is no longer stubbed by default when `--stub-module` or `--stub-function` is given. If you want to restore the old behavior, please pass `--stub-module wasi_snapshot_preview1,other_module`.

== examples <examples>
=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_rust", `hello_rust`)
+ A *`no_std` Rust* example has been added.

  The macro wrapper always has special treatment to support `no_std` Rust. However, there was no example explaining how to use that. Now, the #link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_rust_no_std", `hello_rust_no_std`) example has been added.

+ *Notes in `Cargo.toml`* have been elaborated.

  In particular, it is now #link("https://github.com/typst-community/wasm-minimal-protocol/blob/d1626031077bda4d32c04aadc8d4ddafad213bd5/examples/hello_rust/Cargo.toml#L19")[mentioned] that `opt-level = 3` can be specified for better performance. The default is still `opt-level = 'z'`, which optimizes for size to avoid bloating the Typst Universe.

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_c", `hello_c`)
+ The *CI action* has become official.

  The repo was moved: #link("https://github.com/emscripten-core/setup-emsdk", `{mymindstorm → emscripten-core}/setup-emsdk`).

+ Emscripten has adopted a more *radical version policy*.

  Emscripten v1.x.y lasted for eight years, while v6.x.y lasted for only five months. However, Empscriten is quite stable. Updating from v1 to v7 does not require any change to the `hello_c` example.

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_zig", `hello_zig`)
+ *CBOR support* has been added.

  The Typst functions #link("https://typst.app/docs/reference/data-loading/cbor/")[`cbor` and `cbor.encode`] can be used to exchange structured data to the plugin. Now the `hello_zig` example covers how it is done.

  The downside is that the #link("https://codeberg.org/r4gus/zbor")[zbor library] is quite sensitive to the Zig version. Check the #link("https://codeberg.org/r4gus/zbor/src/branch/HEAD/README.md#getting-started")[compatibility] between Zig versions and zbor versions before using.

+ Two *high-level wrappers* have been created.

  See #link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_zig/README.md#high-level-wrappers")[_High-level wrappers_ in the README] for the details.

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_go", `hello_go`)
+ *Passing `-scheduler=none`* is required for CBOR when targeting WASI since TinyGo v0.43.0.

  Otherwise you will encounter _error: plugin panicked: wasm `unreachable` instruction executed_. See #link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_go/README.md#the-none-scheduler")[_The none scheduler_ in the README] for the details.

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_haskell", `hello_haskell`)
No change.

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit", `hello_moonbit`)
+ The *8-byte header* for bytes has been removed after moonc v0.9.2+bbe2b338f (2026-05-13).

  The old `_as_ptr` function in the `hello_moonbit` example no longer works. It should be replaced with `"%identity"`. Further analysis can be found in #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit/README.md#unstable-interface")[_Unstable interface_ in the README].

+ Wasm files compiled from MoonBit 0.10.17+d971670cd (2026-10-23) *require SIMD*.

  Wasm files not using SIMD can be used with Typst 0.8.0 and above, but Wasm files using SIMD can only be used with Typst 0.14.0 and above. Refer to #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit/README.md#simd")[_SIMD_ in the README] for the details.

== Feedback and contributions are welcome!
The wasm-minimal-protocol repository was #link("https://github.com/typst/typst/pull/7917")[transferred] from #link("https://github.com/astrale-sharp/", "@astrale-sharp") to #link("https://github.com/typst-community/", "@typst-community"). It is now passively maintained.

Since this repository mixes multiple toolchains and the Wasm technology is still relatively new in general, the repository has gotten diverse contributions from various people. There have been 17 different contributors from 6 time zones in its history. (not counting robots and AI agents)

There are still some mysteries at present: Can wasi-stub function properly on ARM machines? Are Go routines relevant to Typst plugins? Why is the Wasm produced by Haskell slower than that of other programming languages? How is the MoonBit toolchain versioned? …

So feedback and contributions are welcome! (commenting either in the original topic on the forum or on GitHub is acceptable)

---

_This page was #link("https://forum.typst.app/t/recent-changes-to-the-wasm-minimal-protocol-repo/10236")[originally posted] by #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] on the forum._
