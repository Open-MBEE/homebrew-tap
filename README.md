# homebrew-tap

Homebrew tap for [Open-MBEE](https://github.com/Open-MBEE) tools.

```bash
brew tap Open-MBEE/tap
brew install opensysml
```

`opensysml` installs the [OpenSysML](https://github.com/Open-MBEE/OpenSysML) SysML v2
toolchain: the `sysml` REPL and the `sysml-lsp` language server.

## Maintenance

`Formula/opensysml.rb` is generated, and nothing here bumps it by hand. The
[`Update opensysml formula`](.github/workflows/update-formula.yml) workflow runs hourly: it
resolves the latest Open-MBEE/OpenSysML release, fetches `scripts/render-homebrew-formula.sh`
and `packaging/homebrew/Formula/opensysml.rb` at that tag, renders the formula from the
release's `SHA256SUMS.txt`, and commits it as `opensysml <tag>` if it changed. A new release is
therefore tapped within the hour; `workflow_dispatch` re-runs it on demand, optionally against
a specific tag.

Because the template and the render script are read from the release tag, a formula defect is
fixed in Open-MBEE/OpenSysML rather than here — an edit to `Formula/opensysml.rb` in this
repository is overwritten by the next scheduled run. Verify a change through a throwaway local
tap before the tag is cut:

```bash
brew install --verbose Open-MBEE/tap/opensysml
brew test Open-MBEE/tap/opensysml
brew audit --strict --online Open-MBEE/tap/opensysml
```

See `packaging/homebrew/README.md` in Open-MBEE/OpenSysML for details.
