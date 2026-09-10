class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.7.0/opensysml-darwin-arm64.tar.gz"
      sha256 "3e360582950b1d68213b2fe2762678636d3741c32eae66331dba730d57bc5627"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.7.0/opensysml-darwin-amd64.tar.gz"
      sha256 "c44cd0c9e56691ea2dfe60cf2425ef3afb6e93ca199cfef4e70a6aae24bdadb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.7.0/opensysml-linux-arm64.tar.gz"
      sha256 "76bb2e12c569abb785a8681653fb8976c93cae3446559466c23ee95e790805be"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.7.0/opensysml-linux-amd64.tar.gz"
      sha256 "78958c4121e79043e21f1a8f73399fb0f85226f6bf81996264c0cba1f11a27cd"
    end
  end

  def install
    bin.install "sysml", "sysml-lsp"
    man1.install Dir["share/man/man1/*.1"]
  end

  test do
    # Release binaries embed the tag (e.g. "sysml v0.0.4") via ldflags; `version`
    # is that tag without the leading "v", scanned from the URL.
    assert_match version.to_s, shell_output("#{bin}/sysml --version")
    assert_match version.to_s, shell_output("#{bin}/sysml-lsp --version")

    # The manual pages ship in the bundle archive, so `man sysml` works.
    assert_path_exists man1/"sysml.1"

    # Evaluate an expression non-interactively: exercises lexer, parser, and runtime.
    assert_match "= 8", shell_output("#{bin}/sysml -e '5 + 3'")

    # The z3 dependency is the solver %check/%explain discover on PATH: it must
    # be there and answer SMT-LIB2 on standard input.
    assert_match "sat", pipe_output("z3 -smt2 -in", "(declare-const x Int)\n(assert (> x 5))\n(check-sat)\n", 0)
  end
end
