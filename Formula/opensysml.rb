class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.1/opensysml-darwin-arm64.tar.gz"
      sha256 "82ae3cc3aa3ffbb8bd8724436acd0d86bf30d5389879126e7d0e7c6c5f2ffe30"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.1/opensysml-darwin-amd64.tar.gz"
      sha256 "10a6b8ed7ab3d699172f3eb519ee087b31e0fe6812120e131a36799346fe25d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.1/opensysml-linux-arm64.tar.gz"
      sha256 "18756ea8f0e3dc2883cb130e879f70a191a86ef138aa58428830f89b823bf7b9"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.1/opensysml-linux-amd64.tar.gz"
      sha256 "5e638de489b31d40e1f7b50fae585e579b18146a78f0948410d6cf1674357bf9"
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
