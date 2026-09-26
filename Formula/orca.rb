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
  version "0.3.0"

  # The self-contained build carries its own runtime and needs nothing installed to run,
  # with one exception: the macOS host links Homebrew's Brotli at an absolute path
  # (`otool -L` names /opt/homebrew/opt/brotli). Without it the install succeeds and the
  # first run dies in dyld. OpenSSL is NOT in that list -- macOS uses Security.framework.
  depends_on "brotli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-arm64.tar.gz"
      sha256 "3d08ab357f95273d087de3ea50d38bf2466d8ad518378e2f2e27c473988afa55"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-x64.tar.gz"
      sha256 "122c019069b9578e41bb6e390c76453778afc1b4a577326fee9e34abb197f3bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-arm64.tar.gz"
      sha256 "fce5e5eeb63d96f490afef18bf5a9512d9276587857b3b4409efecd21fcc6229"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-x64.tar.gz"
      sha256 "bf06c29e5b832e7ea440d248fb444ab1f489d8d4ad528cf0495fda06d64e764f"
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
