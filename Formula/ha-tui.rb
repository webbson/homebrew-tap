class HaTui < Formula
  desc "Terminal UI for Home Assistant — multi-instance dashboards with mouse + keyboard"
  homepage "https://github.com/webbson/homeassistant-tui"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.5.3/ha-tui-aarch64-apple-darwin.tar.xz"
      sha256 "a4dcd3e4a5d58493cafe329e513f9dd218da7333efe514eaeff5809c3921fbff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.5.3/ha-tui-x86_64-apple-darwin.tar.xz"
      sha256 "b3c7246be415558c518b6567b001c94cf15bc92c753363d402d6e2c993c481f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.5.3/ha-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3260772f54fb223000c2a0e7d29477974e1b638a91f341535bab5505003e7875"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webbson/homeassistant-tui/releases/download/v0.5.3/ha-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "173444e041ad762839c339e1d930cc52b60d429bb0845bc3f3602510fc2cc9ab"
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
