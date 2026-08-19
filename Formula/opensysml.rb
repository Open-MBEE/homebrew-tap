class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.1/opensysml-darwin-arm64.tar.gz"
      sha256 "7599fd7360816ffbf4dc594d44226a00275bfa04ec8689a93c9e429fcae5ee98"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.1/opensysml-darwin-amd64.tar.gz"
      sha256 "6f195a0986598c05f0c92cea8572a4caa5000d6875f38e000d17ae489f2d37e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.1/opensysml-linux-arm64.tar.gz"
      sha256 "0329a82b4989b915213b4b8d07269c8f28d91fc6192ff7e8eaa91b4b2e2079e2"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.1/opensysml-linux-amd64.tar.gz"
      sha256 "912b199153266b077ca5be70d0c4f9b5ad6e6cd09ff904294da05968f4eeeaa1"
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
