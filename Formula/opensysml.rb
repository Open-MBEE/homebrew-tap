class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.2/opensysml-darwin-arm64.tar.gz"
      sha256 "9c3340de4b1d9864ac5471a0121491f9e36230ad4231d08585d58f743ba43663"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.2/opensysml-darwin-amd64.tar.gz"
      sha256 "43f9770ca43c1b64a3d4709be1bc175b2e7b16ed406b6be78ec7af50c0a9c8b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.2/opensysml-linux-arm64.tar.gz"
      sha256 "bd7286410c041f54188f0b0aee2d8124188d16a551ccd41401638c90845b4703"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.2/opensysml-linux-amd64.tar.gz"
      sha256 "d8901383473621d93e6c1fc1a7e31690f5f51668c4563c9f2fc9d4d5fc2cefec"
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
