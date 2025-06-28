class Nova < Formula
  desc "AI-powered Python test fixer"
  homepage "https://joinnova.com"
  version "1.0.0"
  
  # For now, let's create a simple test script
  url "https://github.com/novasolve/homebrew-novasolve/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "355d735c94537578d561f6dd2f580c609a704b3078f1a931ebedd28bf8f71962"

  def install
    # Create a simple test script for now
    (bin/"nova").write <<~EOS
      #!/usr/bin/env bash
      echo "⭐ Nova Solve v#{version}"
      echo "AI-powered test fixing"
      echo ""
      echo "Full version coming soon!"
      echo "Visit https://joinnova.com for updates"
    EOS
    
    # Make it executable
    chmod 0755, bin/"nova"
  end

  test do
    assert_match "Nova Solve v#{version}", shell_output("#{bin}/nova")
  end
end 