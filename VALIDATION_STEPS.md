# How to Validate Multi-Platform Support

## Prerequisites
1. Build nova binaries for all platforms
2. Upload them to GitHub releases
3. Update SHA256 hashes in Formula/nova.rb

## Step 1: Push to GitHub
```bash
cd NovaSolve/homebrew-novasolve
git add .
git commit -m "Add multi-platform support and CI testing"
git push origin main
```

## Step 2: Watch the CI Run
Go to: https://github.com/novasolve/homebrew-novasolve/actions

You'll see the test matrix running on:
- macOS Intel (x86_64) 
- macOS ARM (M1/M2) ✅ Already tested locally
- Linux x86_64
- Linux ARM64

## Step 3: Monitor Success Rate
The workflow will show:
```
Installation Success: 75.0%
3 out of 4 installations succeeded
```

If any platform fails, you'll see exactly which one and why.

## Step 4: Test Locally on Different Platforms

### On Intel Mac:
```bash
brew tap novasolve/novasolve
brew install nova
nova --help
```

### On Linux (Ubuntu/Debian):
```bash
# Install Homebrew on Linux first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then install Nova
brew tap novasolve/novasolve
brew install nova
nova --help
```

### Using Docker for Linux Testing:
```bash
# Test on Linux x86_64
docker run -it ubuntu:latest bash
# Inside container:
apt-get update && apt-get install -y curl git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew tap novasolve/novasolve
brew install nova
```

## Step 5: Fallback Method Testing
```bash
# Test the curl installation script
curl -fsSL https://raw.githubusercontent.com/novasolve/homebrew-novasolve/main/scripts/install.sh | bash
```

## What the Telemetry Shows
Each successful install sends:
```json
{
  "result": "success",
  "os": "macos",
  "arch": "arm64", 
  "install_time": 2,
  "timestamp": "2024-06-30T19:35:00Z"
}
```

## Grafana Alert Setup
When configured, you'll get alerts if:
- Any platform has >5% failure rate
- Installation time exceeds threshold
- Specific OS/arch combination consistently fails 