class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.1/opensysml-darwin-arm64.tar.gz"
      sha256 "03135d9a8acd297036173871b52db163135371030d5b6af479f55570e559f089"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.1/opensysml-darwin-amd64.tar.gz"
      sha256 "66e2c6de0170ec7de7a213a14a67e6b70c8e4519db6b551d60875faaa2703399"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.1/opensysml-linux-arm64.tar.gz"
      sha256 "abb6b1e924c6195f479edb699d590bf01395544881105ddf62abe7033fb6caff"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.5.1/opensysml-linux-amd64.tar.gz"
      sha256 "d330c60ec6612aab32d047b6b922ba41a393b08c12c49d448259c1149ed40e00"
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
