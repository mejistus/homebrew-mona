class Oplire < Formula
  desc "OpenCode limit reset and Anthropic proxy bridge via Cloudflare WARP"
  homepage "https://github.com/mejistus/oplire"
  url "https://github.com/mejistus/oplire.git",
      tag:      "v2.5.0",
      revision: "c213600d8f58db23dbc1a99be6d0a6c6807fcfa5"
  license "MIT"
  head "https://github.com/mejistus/oplire.git", branch: "master"

  depends_on "rust" => :build

  def install
    # A user-wide CARGO_TARGET_DIR would send the build output somewhere
    # outside the Homebrew build directory, so pin it to the source tree.
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"

    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      The rate limit reset feature needs the Cloudflare WARP client.

      On macOS:
        brew install --cask cloudflare-warp

      oplire drives warp-cli from inside the Cloudflare WARP application
      bundle on macOS, so no PATH changes are required.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oplire --version")
    assert_match "Usage:", shell_output("#{bin}/oplire --help")
    assert_match "Tunnel:", shell_output("#{bin}/oplire status")
  end
end
