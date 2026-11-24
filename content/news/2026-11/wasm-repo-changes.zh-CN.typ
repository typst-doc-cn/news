#import "/typ/templates/news.typ": link-news, news-template

#show: news-template.with(
  date: "2026-11-14",
  title: "wasm-minimal-protocol 仓库最近的变化",
  lang: "zh",
  region: "CN",
  tags: ("wasm-minimal-protocol",),
  description: "wasm-minimal-protocol 仓库在最近几个月更新了。开发 Typst Wasm 插件比以往更简单了。",
)

#show ref: it => {
  let el = it.element
  if el != none and el.func() == heading {
    link(el.location(), el.body)
  } else {
    it
  }
}

大家好！#link("https://github.com/typst-community/wasm-minimal-protocol")[wasm-minimal-protocol 仓库]在最近几个月更新了。开发 #link("https://typst.app/docs/reference/foundations/plugin/")[Typst Wasm 插件]比以往更简单了。

不过我发现很多人仍在使用之前的复杂方法，所以想介绍一下新方法（尽管旧方法一直能用）。为了完整，我也会提一下上游 Wasm 编译器的变化。

#quote(block: true)[
  注：

  - 此仓库虽然被 Typst 官方文档#link("https://typst.app/docs/reference/foundations/plugin/#resources")[链接]，但并非 Typst GmbH 官方项目。
  - Wasm 接口协议本身无变化，只是那个仓库有变化。
  - 如果你是第一次开发插件，建议参考#link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/README.md")[最新版 README] 而忽略本文。
]

此仓库分为以下三部分。各部分涉及的编程语言范围不同，读者可直接跳到感兴趣的小节阅读。

- @macro——封装 Typst 插件接口的 Rust 宏

  （仅涉及 Rust）

- @wasi-stub——将 WASI 函数替换为空函数的命令行工具

  （C、Haskell 必需，Rust、Zig、Go 有时也得用）

- @examples——各种编程语言实现的示例插件

  （Rust、C、Zig、Go、Haskell、MoonBit）

== 宏 <macro>
+ 将包*发布到了 crates.io*。

  之前此包只能作为 git 依赖项或 git submodule 使用。现在此包已经合理控制版本，并将最新版#link("https://crates.io/crates/wasm-minimal-protocol")[发布到 crates.io]。

  更新时请如下修改`Cargo.toml`：

  ```diff
  - wasm-minimal-protocol = { git = "https://github.com/astrale-sharp/wasm-minimal-protocol" }
  + wasm-minimal-protocol = "0.2"
  ```

+ *替代方案*已恢复开发。

  封装 Typst 插件接口的宏一直有个替代方案，即 #link("https://crates.io/crates/typst-wasm-protocol")[typst-wasm-protocol]。它提供的包装更全面，例如将参数按`Json(point): Json<Point>`声明就能自动实现格式转换；wasm-minimal-protocol 并不支持格式转换。

  此前该包的作者 sjfhsjfh 由于被 GitHub 错误封禁，一度无法继续开发。最近一阵 GitHub 终于响应了申诉，这才恢复。

== wasi-stub <wasi-stub>
+ GitHub Releases 提供了*编译好的可执行文件*。

  此前必须克隆仓库自行编译，而现在可从 #link("https://github.com/typst-community/wasm-minimal-protocol/releases")[GitHub Releases] 直接下载编译好的可执行文件了。本地使用时，如需自动按平台选择要下载的文件，可运行#link("https://crates.io/crates/cargo-binstall")[`cargo binstall wasi-stub`]；在 CI 使用时，可使用 #link("https://github.com/marketplace/actions/install-development-tools")[taiki-e/install-action]：

  ```diff
  - - name: Compile wasi-stub
  -   run: |
  -     git clone … && git sparse-checkout … && cargo install --path . && rm -rf … 
  + - uses: taiki-e/install-action@v2
  +   with:
  +     tool: wasi-stub
  ```

+ 修复了 *Windows 权限错误*。

  此前 wasi-stub 在 Windows 上能用，但一直会报告权限错误；最近 #link("https://github.com/typst-community/wasm-minimal-protocol/pull/85")[msallin 修复了该问题]。

+ *控制返回值*更容易了。

  有时需把不同的 WASI 函数替换成返回值不同的空函数（例如#link("https://github.com/peng1999/typst-pyrunner/blob/f6370d1b4b81c9e2c14c24e44d3439bb8cd22ec9/Makefile#L14-L17")[构建 pyrunner 时]）。

  此前实现这种需求要自行 fork wasi-stub，而现在只要多次调用 wasi-stub 即可，例如：

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

  这其实是个*破坏性*更改：指定`--stub-module`或`--stub-function`参数时，不再默认处理 WASI 模块。如需保持旧版行为，请指定`--stub-module wasi_snapshot_preview1,other_module`。

== 示例 <examples>
=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_rust", `hello_rust`)
+ 添加了*`no_std` Rust*示例。

  宏的实现里一直有针对`no_std` Rust 的特殊代码，不过此前并未展示如何使用。现在添加了#link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_rust_no_std", `hello_rust_no_std`)示例。

+ 改进了*`Cargo.toml`中的注释*。

  具体而言，现在注释#link("https://github.com/typst-community/wasm-minimal-protocol/blob/d1626031077bda4d32c04aadc8d4ddafad213bd5/examples/hello_rust/Cargo.toml#L19")[特别提到]性能在设定`opt-level = 3`时会更好。不过默认仍然是`opt-level = 'z'`，即让生成的文件尽可能小，避免 Typst Universe 太膨胀。

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_c", `hello_c`)
+ *CI action*被官方收编了。

  迁移了仓库地址：#link("https://github.com/emscripten-core/setup-emsdk", `{mymindstorm → emscripten-core}/setup-emsdk`)。

+ Emscripten 发布#strong[版本更激进]了。

  Emscripten v1.x.y 持续了八年，而 v6.x.y 只持续了五个月。不过 Emscripten 本身相当稳定，`hello_c`示例不用修改就能从 v1 更新到 v7。

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_zig", `hello_zig`)
+ 现在*支持 CBOR* 了。

  Typst 的#link("https://typst.app/docs/reference/data-loading/cbor/")[`cbor`和`cbor.encode`]函数可与插件交换结构化数据。现在`hello_zig`示例展示了具体做法。

  不过缺点是 #link("https://codeberg.org/r4gus/zbor")[zbor 库]很挑 Zig 版本。使用前注意检查 Zig 版本与 zbor 版本的#link("https://codeberg.org/r4gus/zbor/src/branch/HEAD/README.md#getting-started")[兼容性]。

+ 出现了两个*高层封装*。

  详见 #link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_zig/README.md#high-level-wrappers")[README 的 High-level wrappers 一节]。

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_go", `hello_go`)
+ 对于 TinyGo v0.43.0 及更新版本，CBOR 功能针对 WASI 编译时，必须加上*`-scheduler=none`参数*。

  否则会遇到 error: plugin panicked: wasm `unreachable` instruction executed。详见 #link("https://github.com/typst-community/wasm-minimal-protocol/tree/main/examples/hello_go/README.md#the-none-scheduler")[README 的 The none scheduler 一节]。

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_haskell", `hello_haskell`)
无变化。

=== #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit", `hello_moonbit`)
+ 从 moonc v0.9.2+bbe2b338f (2026-05-13) 之后的某一版本开始，bytes 不再有#strong[八字节的头]。

  `hello_moonbit`示例之前的`_as_ptr`函数已失效，需修改为`"%identity"`。更多分析请移步 #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit/README.md#unstable-interface")[README 的 Unstable interface 一节]。

+ MoonBit 0.10.17+d971670cd (2026-10-23) 及更新版本编译出的 Wasm 文件#strong[依赖 SIMD]。

  Typst 从 0.8.0 起支持不依赖 SIMD 的 Wasm 文件，而从 0.14.0 开始才支持依赖 SIMD 的 Wasm 文件。详见 #link("https://github.com/typst-community/wasm-minimal-protocol/blob/main/examples/hello_moonbit/README.md#simd")[README 的 SIMD 一节]。

== 欢迎反馈与贡献！
wasm-minimal-protocol 仓库已从 #link("https://github.com/astrale-sharp/", "@astrale-sharp") #link("https://github.com/typst/typst/pull/7917")[交接]到 #link("https://github.com/typst-community/", "@typst-community")，目前会被动维护。

该仓库涉及多种技术栈，且 Wasm 技术整体尚未成熟，所以仓库的贡献者来源一直比较多样。历史上有六个时区共十七人参与贡献（未计入机器人与人工智能）。

目前仍有一些未解之谜：wasi-stub 在 ARM 设备上能用吗？goroutine 协程用于 Typst 插件是否有优势？为何 Haskell 生成的 Wasm 比其它编程语言的慢？MoonBit 工具链的版本到底是怎么管理的？……

因此反馈与贡献都十分欢迎！（可在论坛原帖或 GitHub 上评论）

---

_本页由 #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] 于论坛#link("https://forum.typst.app/t/recent-changes-to-the-wasm-minimal-protocol-repo/10236")[最初发布]。_
