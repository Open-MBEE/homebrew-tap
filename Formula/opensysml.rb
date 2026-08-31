class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.2/opensysml-darwin-arm64.tar.gz"
      sha256 "d19742c3fedd5a417710f66b784e68dd9832f9e0eddf79fbedbcc939920f5fa8"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.2/opensysml-darwin-amd64.tar.gz"
      sha256 "f407bff47716d0943d8975a92679ab987bbe3c864220a588cae4036229997ff1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.2/opensysml-linux-arm64.tar.gz"
      sha256 "b2650d68cca61c84d2e8912327b5f20ea4d563ac7eb4018b7111f8a810ecbd28"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.2/opensysml-linux-amd64.tar.gz"
      sha256 "b25a64110ed5835fa7d70acee3d1d847ff03a61127f77ad7929753dd138c9a3e"
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
