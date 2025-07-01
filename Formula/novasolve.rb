class Novasolve < Formula
  desc "AI teammate that fixes failing tests fast"
  homepage "https://joinnova.com"
  version "1.0.0"
  
  # For production release
  # For local testing
  url "https://github.com/novasolve/homebrew-novasolve/raw/main/releases/nova-1.0.0.tar.gz", __FILE__)}"
  sha256 "1b6b4b8d4e06a125b7285c5f7064c975826febbfd14388280ab64d6e9c4a0794"

  depends_on "python@3.12"
  depends_on "redis" => :recommended  # For Upstash/Redis support

  def install
    # Create virtual environment
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    
    # Upgrade pip
    system venv/"bin/pip", "install", "--upgrade", "pip"
    
    # Install Nova and dependencies
    system venv/"bin/pip", "install", "-e", "."
    
    # Create wrapper script
    (bin/"nova").write <<~EOS
      #!/bin/bash
      # Nova launcher script
      
      # Set up environment
      export PYTHONPATH="#{libexec}/venv/lib/python3.12/site-packages:$PYTHONPATH"
      export NOVA_HOME="#{prefix}"
      export NOVA_DEMO_PATH="#{pkgshare}/demo_repo"
      
      # Check for Redis/Upstash
      if [ -z "$UPSTASH_REDIS_URL" ] && [ -z "$REDIS_URL" ]; then
        echo "⚠️  No Redis URL found. Nova will use local storage."
        echo "   For full features, set UPSTASH_REDIS_URL or REDIS_URL"
        echo ""
      fi
      
      # Run Nova
      exec "#{venv}/bin/python" -m nova.cli.main "$@"
    EOS
    
    # Make executable
    chmod 0755, bin/"nova"
    
    # Install demo repository
    pkgshare.install "demo_repo"
    
    # Install environment template
    pkgshare.install "env.example" if File.exist?("env.example")
  end

  def post_install
    # Create Nova config directory
    nova_dir = var/"nova"
    nova_dir.mkpath
  end

  test do
    # Test that nova runs and shows help
    assert_match "Nova", shell_output("#{bin}/nova --help 2>&1", 1)
    
    # Test Python can import nova
    system "python3.12", "-c", "import sys; sys.path.insert(0, '#{libexec}/venv/lib/python3.12/site-packages'); import nova"
  end
  
  def caveats
    <<~EOS
      🚀 Nova has been installed!
      
      To get started:
        nova
      
      For GitHub integration, you'll need:
        export GITHUB_CLIENT_ID="your_client_id"
        export GITHUB_CLIENT_SECRET="your_client_secret"
      
      For Upstash Redis (recommended):
        export UPSTASH_REDIS_URL="your_upstash_url"
      
      To reset and start fresh:
        nova --reset
        
      For debugging:
        export NOVA_DEBUG=1
    EOS
  end
end 