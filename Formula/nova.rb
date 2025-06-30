class Nova < Formula
  desc "AI-powered Python test fixer"
  homepage "https://joinnova.com"
  version "1.0.0"
  
  # Platform-specific downloads
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/novasolve/homebrew-novasolve/releases/download/v1.0.0/nova-1.0.0-darwin-arm64.tar.gz"
      sha256 "4a64ad75759674ec1202e1bbec9cc684bb4925d9839c9a19bf595712edb84911"
    else
      url "https://github.com/novasolve/homebrew-novasolve/releases/download/v1.0.0/nova-1.0.0-darwin-x86_64.tar.gz"
      sha256 "YOUR_INTEL_MAC_SHA256_HERE"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/novasolve/homebrew-novasolve/releases/download/v1.0.0/nova-1.0.0-linux-arm64.tar.gz"
      sha256 "YOUR_LINUX_ARM64_SHA256_HERE"
    else
      url "https://github.com/novasolve/homebrew-novasolve/releases/download/v1.0.0/nova-1.0.0-linux-x86_64.tar.gz"
      sha256 "YOUR_LINUX_X86_64_SHA256_HERE"
    end
  end

  def install
    bin.install "nova"
    
    # Post-install telemetry (optional, respects HOMEBREW_NO_ANALYTICS)
    return if ENV["HOMEBREW_NO_ANALYTICS"]
    
    ohai "Nova installed successfully!"
    
    # Send anonymous telemetry ping
    begin
      require "net/http"
      require "json"
      
      telemetry_data = {
        event: "install_ok",
        version: version.to_s,
        os: OS.kernel_name.downcase,
        arch: Hardware::CPU.arch.to_s,
        homebrew_version: HOMEBREW_VERSION,
        timestamp: Time.now.utc.iso8601
      }
      
      # This should be configured to your actual telemetry endpoint
      if ENV["NOVA_TELEMETRY_ENDPOINT"]
        uri = URI(ENV["NOVA_TELEMETRY_ENDPOINT"] + "/install_ok")
        Net::HTTP.post(uri, telemetry_data.to_json, "Content-Type" => "application/json")
      end
    rescue => e
      # Silently fail - don't break installation due to telemetry
      opoo "Telemetry ping failed: #{e.message}" if ENV["HOMEBREW_DEVELOPER"]
    end
  end

  test do
    assert_match "Nova V2", shell_output("#{bin}/nova --help")
    assert_match version.to_s, shell_output("#{bin}/nova --version")
  end
  
  # Fallback installation method documentation
  def caveats
    <<~EOS
      Nova has been installed! Run 'nova --help' to get started.
      
      If you encounter issues, you can also install Nova using:
        curl -fsSL https://joinnova.com/install.sh | bash
    EOS
  end
end 