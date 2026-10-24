class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL, language server and MCP server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/opensysml-darwin-arm64.tar.gz"
      sha256 "cebb47b292affab06275cccfe98621658d7ab2b10a71dc9be18079f2cfdef356"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/sysml-mcp-darwin-arm64.tar.gz"
        sha256 "6b703d87a59b315961060909e89e951f287b883fc3c5d67cb32968c76d9cae95"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/opensysml-darwin-amd64.tar.gz"
      sha256 "0721ab21709870e61065b1b1e2d7f6a5ccb5accabb19a82c9793990bb0db517d"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/sysml-mcp-darwin-amd64.tar.gz"
        sha256 "13d99ed43f823c7f426519f4ff4e13237c369a6f4737403356930863d94e8c99"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/opensysml-linux-arm64.tar.gz"
      sha256 "7f9fe6525d5ebd61902185924df36882a5c1aa66cc8004c7bd3ae164df31959b"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/sysml-mcp-linux-arm64.tar.gz"
        sha256 "8e90d4868e6bff271163c975f7d85b3d8e5b7c856dd952d680df6c71082de4c3"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/opensysml-linux-amd64.tar.gz"
      sha256 "f8457e47266c6bb0bb4f07a77af3a88e257edffe2420ddc9312a7dcc0b64771e"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.11.0/sysml-mcp-linux-amd64.tar.gz"
        sha256 "ee79cbc159f792dc48b1fa4d40c0952644721a1dcc889bd845fae0aff64c10b3"
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
