class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.1/opensysml-darwin-arm64.tar.gz"
      sha256 "2095cd9142ca7ed35c50e0a8f333874451de360539db721583336df008d88092"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.1/opensysml-darwin-amd64.tar.gz"
      sha256 "895e3e6538b9a7d49794cbc00674ac9305921db761234c61d44e371f433c994d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.1/opensysml-linux-arm64.tar.gz"
      sha256 "a02aa03fee68b34ce48f352173e87e29f0009821f5b46894344bf9d0ec5afcd8"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.1/opensysml-linux-amd64.tar.gz"
      sha256 "7f8051c13c8b2811f656dc14901a9ad292eb2493e71528bbc2bc9862e45ac818"
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
