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
  version "0.1.0"

  # The self-contained build carries its own runtime and needs nothing installed to run,
  # with one exception: the macOS host links Homebrew's Brotli at an absolute path
  # (`otool -L` names /opt/homebrew/opt/brotli). Without it the install succeeds and the
  # first run dies in dyld. OpenSSL is NOT in that list -- macOS uses Security.framework.
  depends_on "brotli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-arm64.tar.gz"
      sha256 "a7335d6302e9dd0355106c7f6293da591471fb43a1234ccd2762e4c80fa79ae4"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-osx-x64.tar.gz"
      sha256 "d6156dea95e4dc5d3580903fae8f198fcb62d574c735a0d893f08ea1eda7f57d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-arm64.tar.gz"
      sha256 "9b4fa2309ce24eaef0462a29f177a44d0a7dcf87d94cad5e6fd5434dd1b7d1e8"
    else
      url "https://github.com/bluepawlabs/homebrew-orca/releases/download/v#{version}/orca-#{version}-linux-x64.tar.gz"
      sha256 "c957cbcbc91a86b6f5aca77b9695393c02a34100726c5c33e9f70eaeca21fa1e"
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
