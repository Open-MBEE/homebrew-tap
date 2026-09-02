class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.3/opensysml-darwin-arm64.tar.gz"
      sha256 "0927e2e7bbf86c6b6e546d275273c529808f98b6da9c525155e8a80bba4623bf"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.3/opensysml-darwin-amd64.tar.gz"
      sha256 "95bfa593d773a5fabe99402dec8e860163d0673299ef8b038dd7c0d2e6f97350"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.3/opensysml-linux-arm64.tar.gz"
      sha256 "ceba7303c9ffd391b2849b4ae4e15ec52d9ccb951e81b8dc47b7359ee07cdc96"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.3/opensysml-linux-amd64.tar.gz"
      sha256 "661df51718d8506fff925d7b89d0cc119c5c1247f389f9bd9b87d6443ac4553d"
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
