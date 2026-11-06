class Opensysml < Formula
  desc "SysML v2 toolchain: interactive REPL, language server and MCP server"
  homepage "https://github.com/Open-MBEE/OpenSysML"
  license "Apache-2.0"

  # z3 makes the experimental %check/%explain solver path work out of the box;
  # the solver stays optional at runtime, discovered on PATH or via OPENSYSML_SMT.
  depends_on "z3"

  on_macos do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/opensysml-darwin-arm64.tar.gz"
      sha256 "0f16d282ec50bfda916e74ef102e5b257bf2c9964f6e44df9db495db4fc96210"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/sysml-mcp-darwin-arm64.tar.gz"
        sha256 "3735e126dc4a38c6d95d0f5ee9d7402acc2c6e7df96d7ec1fa752a9d51070ed2"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/opensysml-darwin-amd64.tar.gz"
      sha256 "ec9a94bacb0da8fe8dea4936d8af8fabc053b7835d190982dccf0984a2610986"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/sysml-mcp-darwin-amd64.tar.gz"
        sha256 "a667a9ae8d555954b950627011f4549f8e5aba63f9e24dc1be34797fffa1600b"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/opensysml-linux-arm64.tar.gz"
      sha256 "49bc21ae340b1a65f35613b9f63bc10118b4e0392abace9b26924c625b1ca647"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/sysml-mcp-linux-arm64.tar.gz"
        sha256 "1b7b43e00734a41216543df43ad4e6244543c3209ed7d40344433934800b76ed"
      end
    end
    on_intel do
      url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/opensysml-linux-amd64.tar.gz"
      sha256 "a091d9a110c4757357b093f2103f5a0fd04c5369490eda75b74cae8c466b5b5f"
      resource "sysml-mcp" do
        url "https://github.com/Open-MBEE/OpenSysML/releases/download/v0.12.1/sysml-mcp-linux-amd64.tar.gz"
        sha256 "1118f37207b3fc5a67ad8bcd76c46e6ff349ec2d64d2df5412dc067677e169f8"
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
