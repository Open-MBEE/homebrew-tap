class OpenSysML < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.0.9/opensysml-darwin-arm64.tar.gz"
      sha256 "671e652235e1ff54d47f3432c6d93035b45495d4653fcca4852880ebe311cb79"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.0.9/opensysml-darwin-amd64.tar.gz"
      sha256 "47453dd72f3ac2cf47e4c9119992ab08c8ac8d27f57d239009903bca91f69b4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.0.9/opensysml-linux-arm64.tar.gz"
      sha256 "8e1a1550e77f19d9399d2e4732c9d4379a2097641ed53f43373c01f62fab0f63"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.0.9/opensysml-linux-amd64.tar.gz"
      sha256 "875bb6b678711cb631257ddce1b5cb8e0af58220f6d8c11c8838dc54a2e7574b"
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
