class HaTui < Formula
  desc "Terminal UI for Home Assistant — multi-instance dashboards with mouse + keyboard"
  homepage "https://github.com/webbson/homeassistant-tui"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.4/ha-tui-aarch64-apple-darwin.tar.xz"
      sha256 "8c37d63452ee211277e6bd7e02e56784dbc3deba5b1f666d63978ea2247bc94c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.4/ha-tui-x86_64-apple-darwin.tar.xz"
      sha256 "bad725b17a631999eac175e6782c91a07cef780486c358d3aa9e1e63537f002a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.4/ha-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7dd9cb432f96ff4d367f2493c8461591236a66ed81d279ea404e6cc7095d961"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.4/ha-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af6530daba3c9ebd9a0e867be76d248661793d5c56e1d6c1f9e7541af1f50829"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ha-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "ha-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "ha-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "ha-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
