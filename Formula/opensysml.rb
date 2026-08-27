class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.0/opensysml-darwin-arm64.tar.gz"
      sha256 "89925a475bb439131ba5f45c00231aa8b3ec6c53496487c89febe15b5c0f520d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.0/opensysml-darwin-amd64.tar.gz"
      sha256 "d3c2a1ae3cc9c68486608156b75a92c6d34f490b418418a1df8080a801121778"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.0/opensysml-linux-arm64.tar.gz"
      sha256 "43c038b147d051d169b816b3d3276db13f679743542709ac6b170f71d1cfe765"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.3.0/opensysml-linux-amd64.tar.gz"
      sha256 "dc0d30e7d72b10197b9a8a357540b1ea980de639f45add8d3369882c878f0d96"
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
