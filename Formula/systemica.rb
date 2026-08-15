class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.7/systemica-darwin-arm64.tar.gz"
      sha256 "61d4f1a1da1156045312b2613e64f84a9bf61cbdeb49da3fefeecf8cb413fbb5"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.7/systemica-darwin-amd64.tar.gz"
      sha256 "fab68308e40285e18f2ab6ea164897fda92f62f39a0d9e80097d308004c75ef5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.7/systemica-linux-arm64.tar.gz"
      sha256 "a682fd26106bda38c16079df5d925afba49da40f4973c1257143c730984d863d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.7/systemica-linux-amd64.tar.gz"
      sha256 "1709518ccf6892c0423642b68d7df1db7004b9ed6f96f1056ca404f315e1f2c2"
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
