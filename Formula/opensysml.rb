class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL and language server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.0/opensysml-darwin-arm64.tar.gz"
      sha256 "6baf56228ad3f076b5a83c5cd62397e5da932fd4746656296a97294cec9f1afb"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.0/opensysml-darwin-amd64.tar.gz"
      sha256 "ba779ebd0ec8ec3998dd1ebbf13039ef01c620bf05d90e9ca3342ee525aff793"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.0/opensysml-linux-arm64.tar.gz"
      sha256 "ca33677325912fbe785a16b91ef290a68bde4c99454074dc42e0b65dbdfe4944"
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.8.0/opensysml-linux-amd64.tar.gz"
      sha256 "8d925a1d8c9be9b4fa89e0aa7fb0ba4d3911c2b6a0456803d4b798ec9e6c367d"
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
