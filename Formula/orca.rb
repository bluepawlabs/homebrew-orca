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
  version "0.4.0"

  # The self-contained build carries its own runtime and needs nothing installed to run,
  # with one exception: the macOS host links Homebrew's Brotli at an absolute path
  # (`otool -L` names /opt/homebrew/opt/brotli). Without it the install succeeds and the
  # first run dies in dyld. OpenSSL is NOT in that list -- macOS uses Security.framework.
  depends_on "brotli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-arm64.tar.gz"
      sha256 "93ca2d477a9beff1b72d83fbe2dba118d22f82f76bdb8b1c5207a518e610272f"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-x64.tar.gz"
      sha256 "d85705c32a03755fc60f0ef67f811d008f93397e27770bc333a90e4c9ab2d5e7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-arm64.tar.gz"
      sha256 "8536db14ec24d1369443a2058cc6609f6c3317ec148f6feea83357c5e743c32e"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-x64.tar.gz"
      sha256 "52dee1e045521d4338bd513c30b21ce7dbf5c8c0ebae72da3dcd3e6bf7ff7e93"
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
