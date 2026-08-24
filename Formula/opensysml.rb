class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.0/opensysml-darwin-arm64.tar.gz"
      sha256 "d42808ec146bd128b27dd59d62b6e9f67d7bca99b5e12b7e8861f9c599ed6a83"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.0/opensysml-darwin-amd64.tar.gz"
      sha256 "8f2f84b0e68ed30b4c82e4e1f5fd1aa7c23b34df08eafda5dde109fd804110db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.0/opensysml-linux-arm64.tar.gz"
      sha256 "ec6ef1446b888c8f4cfa5fcb80854dc56c5680fad82e1bda209f4fa6f0c37add"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.2.0/opensysml-linux-amd64.tar.gz"
      sha256 "e3cffaea3448588ee3dbe6cae39c12646f2fc71651b5ff8eee6929f6317709da"
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
