class Systemica < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/Systemica"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-darwin-arm64.tar.gz"
      sha256 "177e3e49f8b53016cd464f514835dab94a75b4d880ae72b115b07b1f48e447a8"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-darwin-amd64.tar.gz"
      sha256 "28344c8f785a3b4b6a1d077ad0979b93953a15416f7fb1d793f99910a735e50c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-linux-arm64.tar.gz"
      sha256 "38c3494c38106b348a5f6088c940eaeb768f61ed14806c7b1da8cdd3927ffa30"
    end
    on_intel do
      url "https://github.com/Open-MBEE/Systemica/releases/download/v0.0.6/systemica-linux-amd64.tar.gz"
      sha256 "e72919d3110f43c99ef73d9894eaaf27a4c5077311cfa0fbd44414be5bc0db42"
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
