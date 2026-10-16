class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.1/opensysml-darwin-arm64.tar.gz"
      sha256 "82df881cd3edcaea052d2681e14e5e3977bbf7633f21d0f1cb2a4de9f9a73939"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.1/opensysml-darwin-amd64.tar.gz"
      sha256 "1734b42f96f866a42653174319d9eb66269a8b7e1c2ce7465a16e892b131d7f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.1/opensysml-linux-arm64.tar.gz"
      sha256 "5fb572abe573301ee656bdd07da5b7a2b59e5b6da270ec1522b1e97a165f31ef"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.1/opensysml-linux-amd64.tar.gz"
      sha256 "f5aaeafd49a66f5e9771eb02616fc0f88cc310dc96d242ba2dcf7cb43ede91d1"
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
