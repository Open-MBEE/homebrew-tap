class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-darwin-arm64.tar.gz"
      sha256 "3c74cdc42d8bb454c628305273ee56eb0c8da5d414b22dcd594b03876c7781ac"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-darwin-amd64.tar.gz"
      sha256 "a3712723512214f1eb72057a924b3e02c5d74da1e47b2ef024553fef4f84cf56"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-linux-arm64.tar.gz"
      sha256 "122c5aa3611cfae1ec457efc8632b096d75d116bc9c7d7317a864a37bda3baea"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-linux-amd64.tar.gz"
      sha256 "5277de4e2c6b9e59357a277b1f24612c72ee19314c76a37d5b21a4fbc3a74ff6"
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
