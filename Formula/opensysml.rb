class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.6.0/opensysml-darwin-arm64.tar.gz"
      sha256 "9303998953b837bc39b50226c3d4d64a00c4e33ce655fa161daf058be22f04a7"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.6.0/opensysml-darwin-amd64.tar.gz"
      sha256 "e7ae3543f8f62b15ed435b6126f3765019f4f372faede77a6f05a2a205bda7b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.6.0/opensysml-linux-arm64.tar.gz"
      sha256 "1f2acb0ab680ccb49b1b4dc6824d598691308fb47e4f58c04593078db74ba5ee"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.6.0/opensysml-linux-amd64.tar.gz"
      sha256 "15d4a2d12a0adaadcbb1ed53946061a113c793e60a9e159b790936938323fc38"
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
