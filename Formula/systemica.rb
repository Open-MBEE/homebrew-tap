class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.8/systemica-darwin-arm64.tar.gz"
      sha256 "d9d446334866306eb7bf7806ab43618958b856c4515a20fb14c94dad4fd0b35a"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.8/systemica-darwin-amd64.tar.gz"
      sha256 "5bd2adfe545a0ad40224aefeeb2c1408ae4bd614b29813911e5605d5fb5edc1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.8/systemica-linux-arm64.tar.gz"
      sha256 "9a2fddbbc11b2db069ef8fcbd07a56c0ca25a05656d1155124abf604d5ed4067"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.8/systemica-linux-amd64.tar.gz"
      sha256 "de343759e42c51b2bba66e6a0fb34d663f62e076d77827adace7d431d87e50a1"
    end
  end

  def install
    bin.install "sysml", "sysml-lsp"
  end

  test do
    # Release binaries embed the tag (e.g. "sysml v0.0.4") via ldflags; `version`
    # is that tag without the leading "v", scanned from the URL.
    assert_match version.to_s, shell_output("#{bin}/sysml --version")
    assert_match version.to_s, shell_output("#{bin}/sysml-lsp --version")

    # Evaluate an expression non-interactively: exercises lexer, parser, and runtime.
    assert_match "= 8", shell_output("#{bin}/sysml -e '5 + 3'")
  end
end
