#!/bin/sh
# xpdf-tools mirror -- copy the signed Xpdf command line tools and their source to a GitHub release
#
# Usage: [VER=4.06] ./mirror.sh   (needs curl, jq, gpg, gpgv, gh)
# Without VER the version comes from the Homebrew xpdf formula: www.xpdfreader.com sends an
# incomplete TLS chain, dl.xpdfreader.com has no index. The signature check makes the version
# source untrusted input only.
set -eu

repo="${GITHUB_REPOSITORY:-rdslw/xpdf-tools}"
ver="${VER:-$(curl -fsS https://formulae.brew.sh/api/formula/xpdf.json | jq -r .versions.stable)}"
case "$ver" in *[!0-9.]* | "") echo "Error: bad version: $ver" >&2; exit 1 ;; esac
! gh release view "v$ver" -R "$repo" >/dev/null 2>&1 || { echo "Unchanged: v$ver"; exit 0; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
gpg --dearmor <xpdf.asc >"$tmp/keyring.gpg"

# The source tarball goes along with the binaries: GPL v2 §3(a) and v3 §6(a).
files="xpdf-tools-linux-$ver.tar.gz xpdf-tools-mac-$ver.tar.gz xpdf-$ver.tar.gz"
for f in $files; do
  echo "Downloading $f"
  curl -fsSLR -o "$tmp/$f" "https://dl.xpdfreader.com/$f"
  curl -fsSLR -o "$tmp/$f.sig" "https://dl.xpdfreader.com/$f.sig"
  gpgv --keyring "$tmp/keyring.gpg" "$tmp/$f.sig" "$tmp/$f"
done

cd "$tmp"
gh release create "v$ver" -R "$repo" --title "Xpdf tools $ver" --notes "Unmodified Xpdf $ver command line tools and source from https://dl.xpdfreader.com, by Glyph & Cog, LLC. Unofficial mirror.
Each tarball verified with its .sig against key A56006CA75CF8B13FA2F120DF4825F5397271342 (-Xpdf- <xpdf@xpdfreader.com>).
License: GPL-2.0-only OR GPL-3.0-only (COPYING and COPYING3 in each tarball)." \
  ./*.tar.gz ./*.sig
echo "Released: v$ver -> https://github.com/$repo/releases/tag/v$ver"
