# homebrew-tap

Homebrew tap for [Open-MBEE](https://github.com/Open-MBEE) tools.

```bash
brew tap Open-MBEE/tap
brew install opensysml
```

`opensysml` installs the [OpenSysML](https://github.com/Open-MBEE/OpenSysML) SysML v2
toolchain: the `sysml` REPL and the `sysml-lsp` language server.

## Maintenance

`Formula/opensysml.rb` is generated, not hand-edited. Per release, render it from the
release's `SHA256SUMS.txt` in a clone of Open-MBEE/OpenSysML and commit the result here:

```bash
# in Open-MBEE/OpenSysML
./scripts/render-homebrew-formula.sh vX.Y.Z > /path/to/homebrew-tap/Formula/opensysml.rb
```

Then verify before pushing:

```bash
brew install --verbose Open-MBEE/tap/opensysml
brew test Open-MBEE/tap/opensysml
brew audit --strict --online Open-MBEE/tap/opensysml
```

See `packaging/homebrew/README.md` in Open-MBEE/OpenSysML for details.
