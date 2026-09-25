# The command line for OrcaKey, a secrets and token manager.
#
# This is a tap rather than homebrew-core: core will not take software whose source is
# not public, and orcakey.sh is private. The archives below are published to THIS
# repository's releases for the same reason -- Homebrew fetches them with no credentials.
#
#   brew tap bluepawlabs/orca
#   brew install orca
#
# Generated in full by the release that published the archives. Editing it by hand is how
# a formula ends up pointing at a version nobody is running.
class Orca < Formula
  desc "Command-line client for the OrcaKey secrets and token manager"
  homepage "https://orcakey.sh"
  version "0.2.0"

  # The self-contained build carries its own runtime and needs nothing installed to run,
  # with one exception: the macOS host links Homebrew's Brotli at an absolute path
  # (`otool -L` names /opt/homebrew/opt/brotli). Without it the install succeeds and the
  # first run dies in dyld. OpenSSL is NOT in that list -- macOS uses Security.framework.
  depends_on "brotli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-arm64.tar.gz"
      sha256 "15e56155b2346be1d0afd12459b0ca23ce09942cba5b197968c08cbbb50ddb6d"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-x64.tar.gz"
      sha256 "e14c4e5ba02794b2dc0668367492aa86260d9cea64fe2e5924a76a60ff33aef1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-arm64.tar.gz"
      sha256 "578d440d657e6148d027e1f2b1e24b6bf1d991d3d22aa452969ca6c4b7f8dc78"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-x64.tar.gz"
      sha256 "4dd817f0f7cecca5bf36332c75bc4e83c6b31ff3466f2ed2efe5104079bed093"
    end
  end

  def install
    bin.install "orca"
  end

  # The archive holds one already-linked binary, so there is nothing to check about the
  # build. What is worth checking is that the thing installed runs at all and is the
  # version the formula claims -- which catches a digest bumped without its version, and
  # a trimmed publish that lost something it needed and dies on first execution.
  test do
    assert_match version.to_s, shell_output("#{bin}/orca --version")
  end
end
