class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.1/opensysml-darwin-arm64.tar.gz"
      sha256 "172b40494625072d8f14b5359bfdbc04c794066fb01c1f7989c4e4004e48ed6d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.1/opensysml-darwin-amd64.tar.gz"
      sha256 "c18ef267c25b44f41326ed14fdcef698f2855743d5455fee1a667f927c2bdd96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.1/opensysml-linux-arm64.tar.gz"
      sha256 "97137b5e105ec875f30fafbda8d0e719fc9b8fb59e9cd77beaa6a7897d534b1d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.1/opensysml-linux-amd64.tar.gz"
      sha256 "83a7234c0add99935b2dedea53ad596457daa19c47fb4ffd5d91db28e8ddb451"
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
