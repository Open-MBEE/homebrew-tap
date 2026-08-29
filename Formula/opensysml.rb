class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.0/opensysml-darwin-arm64.tar.gz"
      sha256 "2cf7ddcf00b0f1db1a968f369265665f7aafbf1645fcb9d4694c0b3e3e358e98"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.0/opensysml-darwin-amd64.tar.gz"
      sha256 "16ca56630a63b43d3fa2ec190e835d6b65c65d4e5246c2474b6da93ef3168822"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.0/opensysml-linux-arm64.tar.gz"
      sha256 "36b63a294c0624634854874c019e1524e67644fed97cde4c2da37441cc84e754"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.4.0/opensysml-linux-amd64.tar.gz"
      sha256 "1575373f45b5ff8727923c25e4c961fc0211a60fb7849759a5b8ca7651acff29"
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
