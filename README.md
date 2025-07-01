# Nova Installation Guide

Nova is an AI teammate that fixes failing tests fast. This guide shows you how to install and run Nova.

## Prerequisites

- macOS with Homebrew installed
- Python 3.12 or later
- GitHub account

## Installation

### 1. Install Nova via Homebrew

```bash
# First, update brew and untap if needed
brew update
brew untap novasolve/novasolve 2>/dev/null || true

# Install Nova
brew tap novasolve/novasolve
brew install novasolve
```

### 2. Set Environment Variables

Nova requires some environment variables to function properly:

```bash
# Required for GitHub OAuth
export GITHUB_CLIENT_ID="Iv23liiZaWy61CvjQQdz"
export GITHUB_CLIENT_SECRET="f3c8e3b4e50877c9a4b8b0c9aee3a8a31e7c8a3f"

# Optional but recommended - Upstash Redis URL
export UPSTASH_REDIS_URL="rediss://your-redis-url-here"
```

Add these to your shell profile (`~/.zshrc` or `~/.bash_profile`) to make them permanent.

## Running Nova

### First Run

```bash
nova
```

On first run, Nova will:
1. Show a demo fixing an email validation regex bug
2. Open your browser for GitHub authentication
3. Scan your repositories for failing tests
4. Offer to fix them by creating pull requests

### Demo Mode

To run Nova in demo mode without connecting to GitHub:

```bash
cd /path/to/nova/source  # if you have the source
NOVA_DEMO_MODE=1 python3 nova_1_0.py
```

Or with the installed version:
```bash
NOVA_DEMO_MODE=1 nova
```

## Troubleshooting

### Command not found

If you get "command not found: nova", make sure Homebrew's bin directory is in your PATH:

```bash
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Old version conflicts

If you have an old version of Nova installed:

```bash
# Check what's installed
which nova
ls -la $(which nova)

# Remove old versions
sudo rm -f /usr/local/bin/nova
brew uninstall novasolve 2>/dev/null || true
brew untap novasolve/novasolve 2>/dev/null || true

# Reinstall
brew tap novasolve/novasolve
brew install novasolve
```

### GitHub authentication issues

If GitHub OAuth fails:
1. Make sure `GITHUB_CLIENT_SECRET` is set correctly
2. Check that your browser allows popups from localhost
3. Try running `nova` again

### Redis warnings

If you see Redis warnings, Nova will still work using local storage. For full features, sign up for a free Upstash Redis instance at https://upstash.com

## Support

- Website: https://joinnova.com
- Issues: Contact team@joinnova.com

## License

Nova is proprietary software. © 2024 JoinNova.com - All Rights Reserved. 