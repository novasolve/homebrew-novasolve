class Nova < Formula
  desc "AI-powered Python test fixer"
  homepage "https://joinnova.com"
  version "1.0.0"
  
  url "https://github.com/novasolve/homebrew-novasolve/releases/download/v1.0.0/nova-1.0.0-arm64.tar.gz"
  sha256 "4a64ad75759674ec1202e1bbec9cc684bb4925d9839c9a19bf595712edb84911"

  def install
    bin.install "nova"
  end

  test do
    assert_match "Nova V2", shell_output("#{bin}/nova --help")
  end
end 