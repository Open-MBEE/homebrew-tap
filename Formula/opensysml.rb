class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.0/opensysml-darwin-arm64.tar.gz"
      sha256 "3fd6bbe6e296d788e7f1c6dd90491a9dec82b210da9731af52c47f2ec41be47c"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.0/opensysml-darwin-amd64.tar.gz"
      sha256 "3fe43e7fd3f432a6ea1547f7f76aac94408bf6b860730c119a9b8a363b58b202"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.0/opensysml-linux-arm64.tar.gz"
      sha256 "7bb5afd2d3a6beb11191a4ea99ba57c3eb5aace52106685430c5fa4b4bd68b1e"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.10.0/opensysml-linux-amd64.tar.gz"
      sha256 "e0d2bd3d0cb8217b7a7dc4e981d3fd5bfeb9fca160b29f3af582e7b83d0c47a6"
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
