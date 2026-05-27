class HaTui < Formula
  desc "Terminal UI for Home Assistant — multi-instance dashboards with mouse + keyboard"
  homepage "https://github.com/webbson/homeassistant-tui"
  version "0.7.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.5/ha-tui-aarch64-apple-darwin.tar.xz"
      sha256 "7590107f5afb2b421a1a91b22a8f64fab7512d4ffe447fed6feae5851d03e4b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.5/ha-tui-x86_64-apple-darwin.tar.xz"
      sha256 "2b13d2588906232580a4a34dad8db9347d166e9b0d29e6bb183e91f0bf6758c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.5/ha-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "35239bff7818b36d317ac08810499ebb5dcbab8b2ef0ec553220de34eadd9425"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.7.5/ha-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0337d7d1f5f0b895c1adbd6f02c8e081b6e35b940d02b275755cec30d720b509"
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
