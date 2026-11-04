class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL, language server and MCP server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/opensysml-darwin-arm64.tar.gz"
      sha256 "d73c030d490772de4b88d3b74dd7fd375bc06f6d0e548f2b3e513cb2849b6338"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/sysml-mcp-darwin-arm64.tar.gz"
        sha256 "4d0b1563a450f182bff4b554be3359ac65dd4757236b00c88ae287782c046086"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/opensysml-darwin-amd64.tar.gz"
      sha256 "64ef596fe10069fd6e6eed645b050d62d342a43b7d8650229d80114370d9d62e"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/sysml-mcp-darwin-amd64.tar.gz"
        sha256 "da5aca1942f4c3a5ea7ec729f67d58c1d39d43dcfb53b0b4db96ccb39d06079f"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/opensysml-linux-arm64.tar.gz"
      sha256 "34444081bd0789819ff7a0a355400ae5a2d9826d3aa4c0e2d477250c3c6ba04c"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/sysml-mcp-linux-arm64.tar.gz"
        sha256 "420a87208dfdc28ded5ccc5c6e8a607bddadab743c068d8ec34700d4faac80af"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/opensysml-linux-amd64.tar.gz"
      sha256 "98f60227b32485b8d209e58f0a15951e68ba27177d9f2374e97c6e8fdcde645b"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.0/sysml-mcp-linux-amd64.tar.gz"
        sha256 "465dbec23ec32827dd4e47c312e3f63b700d1b63a5fbbd928fde4d5b0c759739"
      end
    end
  end

  def install
    bin.install "sysml", "sysml-lsp"
    man1.install Dir["share/man/man1/*.1"]
    # sysml-mcp is released as its own archive, with its manual page, apart
    # from the bundle.
    resource("sysml-mcp").stage do
      bin.install "sysml-mcp"
      man1.install "share/man/man1/sysml-mcp.1"
    end
  end

  test do
    # Release binaries embed the tag (e.g. "sysml v0.0.4") via ldflags; `version`
    # is that tag without the leading "v", scanned from the URL.
    assert_match version.to_s, shell_output("#{bin}/sysml --version")
    assert_match version.to_s, shell_output("#{bin}/sysml-lsp --version")
    assert_match version.to_s, shell_output("#{bin}/sysml-mcp --version")

    # The MCP server writes a host's configuration naming its own installed path.
    assert_match "#{bin}/sysml-mcp", shell_output("#{bin}/sysml-mcp -print-config opencode")
    assert_path_exists man1/"sysml-mcp.1"

    # The manual pages ship in the bundle archive, so `man sysml` works.
    assert_path_exists man1/"sysml.1"

    # Evaluate an expression non-interactively: exercises lexer, parser, and runtime.
    assert_match "= 8", shell_output("#{bin}/sysml -e '5 + 3'")

    # The z3 dependency is the solver %check/%explain discover on PATH: it must
    # be there and answer SMT-LIB2 on standard input.
    assert_match "sat", pipe_output("z3 -smt2 -in", "(declare-const x Int)\n(assert (> x 5))\n(check-sat)\n", 0)
  end
end
