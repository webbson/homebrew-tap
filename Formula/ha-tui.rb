class HaTui < Formula
  desc "Terminal UI for Home Assistant — multi-instance dashboards with mouse + keyboard"
  homepage "https://github.com/webbson/homeassistant-tui"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.3/ha-tui-aarch64-apple-darwin.tar.xz"
      sha256 "44564986b9d1687ed00e5c6e16eee5c1a0d62decfc00823f479f486cb9b4fe4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.3/ha-tui-x86_64-apple-darwin.tar.xz"
      sha256 "355c702ad99fd619a5345782ffb3522ae31b98fa5aebd8f474e46ee720ca5a7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.3/ha-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6cf567a1aac512ee3ba5094e31e153ca41aee2ece775da9f0d5b6b3dc55b9d94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.3/ha-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c88f1a8844c47258059cbe96cd1aea52c7dba14e188b998f9cb96d2762c605d4"
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
