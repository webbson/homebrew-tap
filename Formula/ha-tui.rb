class HaTui < Formula
  desc "Terminal UI for Home Assistant — multi-instance dashboards with mouse + keyboard"
  homepage "https://github.com/webbson/homeassistant-tui"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.6.0/ha-tui-aarch64-apple-darwin.tar.xz"
      sha256 "f3977df4363c44b95174c18fb81ea02d6a5819c09dc6b2b86332ac5052b5e78e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.6.0/ha-tui-x86_64-apple-darwin.tar.xz"
      sha256 "fc5a695a62549f28c93686273d1b3763139232c8ae8a584ee4bb3efaaa27c8d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.6.0/ha-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8203039c5e992da19ed6e5ab1bee61e8c1bfcc6e2f2db1e22b3da859cb956871"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.6.0/ha-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d21c0577cb5b63da0ed9cc86dbb3009a012025318073f563c8af5e9fa638747"
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
