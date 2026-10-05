class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.2/opensysml-darwin-arm64.tar.gz"
      sha256 "824fb518517da0f2ef2722305a252f7f54869103c8b3a97d76934b1c97bec0ec"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.2/opensysml-darwin-amd64.tar.gz"
      sha256 "1faf975b9883ca649afb830357c667d567547d69705ad85adf9fae824bc31f3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.2/opensysml-linux-arm64.tar.gz"
      sha256 "f2e24f955b3d19a2bba2eef7404c0080ae72269d3feb412537264c15ab67b261"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.2/opensysml-linux-amd64.tar.gz"
      sha256 "ebd9d99039009156a85f98a49d0713d8ed427e2c8e8d38c5619acfbee2458544"
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
