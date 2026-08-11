# homebrew-tap

Homebrew tap for [Open-MBEE](https://github.com/Open-MBEE) tools.

```bash
brew tap Open-MBEE/tap
brew install systemica
```

`systemica` installs the [Systemica](https://github.com/Open-MBEE/Systemica) SysML v2
toolchain: the `sysml` REPL and the `sysml-lsp` language server.

## Maintenance

`Formula/systemica.rb` is generated, not hand-edited. Per release, render it from the
release's `SHA256SUMS.txt` in a clone of Open-MBEE/Systemica and commit the result here:

```bash
# in Open-MBEE/Systemica
./scripts/render-homebrew-formula.sh vX.Y.Z > /path/to/homebrew-tap/Formula/systemica.rb
```

Then verify before pushing:

```bash
brew install --verbose Open-MBEE/tap/systemica
brew test Open-MBEE/tap/systemica
brew audit --strict --online Open-MBEE/tap/systemica
```

See `packaging/homebrew/README.md` in Open-MBEE/Systemica for details.
