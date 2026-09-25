class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.0/opensysml-darwin-arm64.tar.gz"
      sha256 "1113b045cea8bb3e6bcb6f9d8683ee910c847a6eac73f47480a26a6b2bbcf77d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.0/opensysml-darwin-amd64.tar.gz"
      sha256 "2694c28c94214dd81268f8247ec2e2ffda7d6ec885a48cbc1ff48c18b7ca79a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.0/opensysml-linux-arm64.tar.gz"
      sha256 "2329b3aaa3725aaeb740d8066a04777a1d7ea31794c7b784f79594469965659d"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.9.0/opensysml-linux-amd64.tar.gz"
      sha256 "d49bf08d2185038c0595852e3ccfb7007716e3aba5e1048d5ede7c8cf426f97f"
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
