# xpdf-tools

Unofficial mirror of the [Xpdf](https://www.xpdfreader.com/) command line tools by Glyph & Cog, LLC,
as GitHub releases. It exists so that insh (a POSIX sh installer) can install `pdftotext`,
`pdfinfo`, `pdftohtml` and `pdftopng` with the GitHub asset digest, the asset age guard and VirusTotal.
Not affiliated with Glyph & Cog. Report Xpdf bugs upstream, mirror problems here.

## Release contents

Each release `vX.YY` holds the files from `https://dl.xpdfreader.com/`, byte for byte:

| Asset | Content |
|---|---|
| `xpdf-tools-linux-X.YY.tar.gz` | Linux x86 (`bin32`) and x86_64 (`bin64`) binaries, dynamically linked |
| `xpdf-tools-mac-X.YY.tar.gz` | macOS x86_64 (`bin64`) and arm64 (`binARM`) binaries |
| `xpdf-X.YY.tar.gz` | Xpdf source code of the same version |
| `*.sig` | upstream GPG signatures |

`mirror.sh` checks every tarball against its `.sig` with the key in `xpdf.asc` before upload:

```
A560 06CA 75CF 8B13 FA2F  120D F482 5F53 9727 1342  -Xpdf- <xpdf@xpdfreader.com>
```

The `mirror` workflow runs weekly and takes the version from the Homebrew `xpdf` formula, or a
version given by hand. It does nothing when the release exists.

## License

Xpdf is licensed under GPL-2.0-only OR GPL-3.0-only (`COPYING` and `COPYING3` in each tarball).
The source of every mirrored version is in the same release. The macOS binaries also contain
statically linked FreeType ([freetype.org](https://freetype.org/download.html)) and libpng 1.6.40
([libpng.org](http://www.libpng.org/pub/png/libpng.html)).

XpdfReader, the closed-source viewer, is not mirrored.
