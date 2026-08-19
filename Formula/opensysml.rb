class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.0/opensysml-darwin-arm64.tar.gz"
      sha256 "35990612bad6e03f288040b6fad5083c9dc20421a46e73abd7905fa717d497ad"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.0/opensysml-darwin-amd64.tar.gz"
      sha256 "de934828c8703c7c5c488d7076dd0954b6e1c55d90610345346a741b68b5025f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.0/opensysml-linux-arm64.tar.gz"
      sha256 "92ea28c67557f17f579be542737e1fcae20c72b979c5eae44fe405e18cb4a50f"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.1.0/opensysml-linux-amd64.tar.gz"
      sha256 "83424276d8810e6446aec102f7c51ac5c59ddf4e1be6b657bcf2a7a283d98d42"
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
