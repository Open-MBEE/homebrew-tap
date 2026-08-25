class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.1/opensysml-darwin-arm64.tar.gz"
      sha256 "dbdf21291d2ef6cb5f3a9500d8a10d3748cc0085c2711291b6b28035fd3a63a8"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.1/opensysml-darwin-amd64.tar.gz"
      sha256 "361888f1e0e689dd097a84e9abb0a7725dae72b792605cf14a01b6e457cd5324"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.1/opensysml-linux-arm64.tar.gz"
      sha256 "1edd3fd754f10c2ed7b9ede1d008517dd791906d70bd43a547c61564d0101413"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.1/opensysml-linux-amd64.tar.gz"
      sha256 "0594ef45b6cf1085654d88ed7aa02d00ff245f92a3edca673feb16818303c46a"
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

    # The z3 dependency is the solver %check/%explain discover on PATH: it must
    # be there and answer SMT-LIB2 on standard input.
    assert_match "sat", pipe_output("z3 -smt2 -in", "(declare-const x Int)\n(assert (> x 5))\n(check-sat)\n", 0)
  end
end
