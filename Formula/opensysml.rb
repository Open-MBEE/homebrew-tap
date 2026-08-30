class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.1/opensysml-darwin-arm64.tar.gz"
      sha256 "e79d5c883bdabe10d27042bee394e454c31713ab1dc5f166d92e4c03796f49bb"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.1/opensysml-darwin-amd64.tar.gz"
      sha256 "d08eff2370a789e00c03acf675f80add7bcab386efb5e048eb3ac73735084f0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.1/opensysml-linux-arm64.tar.gz"
      sha256 "a42a3bec4f7e306426e0ae6558363e7ec606fdda540648cf1febcefc76f68aef"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.1/opensysml-linux-amd64.tar.gz"
      sha256 "d354a673925101eea0cf257c39b526e2a4d6646bea219fd737e320cd049310ac"
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
