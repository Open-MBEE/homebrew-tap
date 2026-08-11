class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.4/systemica-darwin-arm64.tar.gz"
      sha256 "75a2d591d09a387530b3d6c0fbe34e70f24eeb21b2e324d674ade93fd3fb0acf"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.4/systemica-darwin-amd64.tar.gz"
      sha256 "c27c2bee206d362141c2e45b00f9ee1bac94153e60292d6a81ab53d91c62fe41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.4/systemica-linux-arm64.tar.gz"
      sha256 "65e628836ad668e1b69e728ea61f1a71d8a768d8eb55b425d2f66ac76b6daaeb"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.4/systemica-linux-amd64.tar.gz"
      sha256 "86f72c93bea60f1519b435f4050cb1106f9726063a3c6657dd8393104686b696"
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
