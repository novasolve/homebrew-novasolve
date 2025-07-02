class Novasolve < Formula
  desc "AI-powered Python test fixer"
  homepage "https://joinnova.com"
  url "https://github.com/novasolve/homebrew-novasolve/raw/main/releases/nova-1.0.1.tar.gz"
  sha256 "60665234028815ab541df7e243cbd70c14e9c5dbb426d3974d1b2c4af4ebafc3"
  version "1.0.1"

  depends_on "python@3.12"

  def install
    # Create a virtual environment
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    venv_pip = venv/"bin/pip"
    
    # Install dependencies
    system venv_pip, "install", "--upgrade", "pip"
    system venv_pip, "install", "-r", "requirements.txt"
    
    # Copy the nova package directly instead of editable install
    site_packages = venv/"lib/python3.12/site-packages"
    cp_r "nova", site_packages
    # Also copy novasolve package if it exists
    cp_r "novasolve", site_packages if File.exist?("novasolve")
    # Copy novasolve_compat package for compatibility
    cp_r "novasolve_compat", site_packages if File.exist?("novasolve_compat")
    
    # Install other dependencies
    system venv_pip, "install", "rich>=13.0.0", "redis>=5.0.0", "httpx>=0.24.0"
    
    # Copy demo repo
    (share/"novasolve").install "demo_repo"
    
    # Create wrapper script
    (bin/"nova").write <<~EOS
      #!/bin/bash
      # Nova launcher script
      
      # Set up environment
      export PYTHONPATH="#{venv}/lib/python3.12/site-packages:$PYTHONPATH"
      export NOVA_HOME="#{opt_prefix}"
      export NOVA_DEMO_PATH="#{share}/novasolve/demo_repo"
      
      # Use Railway backend - no Redis check needed
      export NOVA_USE_BACKEND="true"
      export NOVA_BACKEND_URL="${NOVA_BACKEND_URL:-https://api.joinnova.com}"
      
      # Run Nova
      exec "#{venv}/bin/python" -m nova.cli.main "$@"
    EOS
    
    chmod 0755, bin/"nova"
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
      
      Nova handles all authentication automatically.
      No API keys needed!
    EOS
  end
end 