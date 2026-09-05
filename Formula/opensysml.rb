class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.0/opensysml-darwin-arm64.tar.gz"
      sha256 "a23a92fc4d5761aa6826523c30735bd1b7e877095d7a743b67dc359a15e501fc"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.0/opensysml-darwin-amd64.tar.gz"
      sha256 "ef32ad981d91a756426020c4e375bd13e8826ccfacf3cec0f91ea1be793fffe6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.0/opensysml-linux-arm64.tar.gz"
      sha256 "7f972352a8b8e4a524068d567f06cd80ef1ec5fbc12c5916292c5190203ba61a"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.0/opensysml-linux-amd64.tar.gz"
      sha256 "899ce5408bd4e3df1bac82dbe2f1d203c2606a1fb45f5e4377e3f4c7bc547452"
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
