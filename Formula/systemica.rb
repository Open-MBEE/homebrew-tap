class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.5/systemica-darwin-arm64.tar.gz"
      sha256 "6b3bb5ab638a2b799592cbdc1ee145314f8ec7f268f29aa87e5b0516c5f1be2d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.5/systemica-darwin-amd64.tar.gz"
      sha256 "bad4622ed86da10c83ce0a3f000f0b95c7e9361d1925da0f3f4b1c34f15d032d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.5/systemica-linux-arm64.tar.gz"
      sha256 "4fdd16c25b83d1039f8e4838207b942de4dec1ee860303e208296413e4324bb9"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.5/systemica-linux-amd64.tar.gz"
      sha256 "22507a2c53d98af0d0cc8a16123b5f910771b6edbf6fbff3ba316579199226f8"
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
