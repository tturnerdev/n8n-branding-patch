# n8n Development License Bypass

A portable patch system to enable all enterprise features in n8n during local development.

## 🎯 Purpose

This patch allows developers to test and develop n8n enterprise features locally without requiring a license, using environment variables to control the bypass.

## 📦 Contents

- `dev-license-bypass.patch` - Git patch file with all code modifications
- `apply-dev-bypass.sh` - Automated setup script (Linux/macOS/Git Bash)
- `apply-dev-bypass.ps1` - Automated setup script (Windows PowerShell)
- `PATCH_README.md` - Quick start guide
- `DEV_LICENSE_BYPASS.md` - Full documentation

## 🚀 Quick Start

### Prerequisites

- n8n repository cloned locally
- Git installed
- Node.js 20.x - 24.x
- pnpm 10.x
- 8GB+ RAM

### Installation

1. **Download files** from this repository to your n8n root directory

2. **Run the setup script:**

   **Linux / macOS / Git Bash:**
   ```bash
   chmod +x apply-dev-bypass.sh
   ./apply-dev-bypass.sh
   ```

   **Windows PowerShell:**
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\apply-dev-bypass.ps1
   ```

3. **Start n8n** with enterprise features enabled:
   ```bash
   pnpm start
   # or for development:
   pnpm dev:be
   ```

## ✨ Features Unlocked

When `N8N_DEV_LICENSE_BYPASS=true` is set, all enterprise features are enabled:

- ✅ Advanced Execution Filters
- ✅ Sharing (Workflows, Credentials, etc.)
- ✅ LDAP, SAML, OIDC Authentication
- ✅ Log Streaming
- ✅ Variables Management
- ✅ External Secrets
- ✅ Audit Logs
- ✅ Debug In Editor
- ✅ Workflow History
- ✅ Worker View
- ✅ Advanced Permissions
- ✅ API Key Scopes
- ✅ Enforce MFA
- ✅ User Provisioning
- ✅ AI Assistant

## 🔧 How It Works

### Backend
- Checks `N8N_DEV_LICENSE_BYPASS` environment variable
- Creates a fake license manager with all features enabled
- Falls back to real license manager when disabled

### Frontend
- Checks `VITE_DEV_LICENSE_BYPASS` environment variable
- Uses Proxy to enable all enterprise feature flags
- Shows enterprise components unconditionally in dev mode

## 📝 Manual Application

If you prefer to apply manually:

```bash
# Apply patch
git apply dev-license-bypass.patch

# Create .env in root
cat > .env << 'EOF'
N8N_DEV_LICENSE_BYPASS=true
NODE_OPTIONS=--max-old-space-size=8192
EOF

# Create frontend .env.local
cat > packages/frontend/editor-ui/.env.local << 'EOF'
VITE_DEV_LICENSE_BYPASS=true
EOF

# Install and build
pnpm install
pnpm build
```

## 🔄 Reverting

To remove the bypass:

```bash
git checkout -- .
rm .env packages/frontend/editor-ui/.env.local
```

## ⚠️ Important Notes

- **Development only** - Never use in production
- Bypass only works when environment variable is explicitly set
- Without the env var, normal license checks apply
- Safe to commit the patch to your fork for team use

## 📚 Documentation

See `PATCH_README.md` for quick start guide and `DEV_LICENSE_BYPASS.md` for detailed documentation.

## 🛠️ Troubleshooting

**Build fails:**
```bash
export NODE_OPTIONS="--max-old-space-size=12288"
pnpm build
```

**Patch conflicts:**
Your n8n version may differ from the patch. Try:
- Checkout to a compatible commit
- Apply changes manually using docs as reference

**Frontend dev mode crashes:**
Use backend only: `pnpm dev:be` or production mode: `pnpm start`

## 📜 License

This patch modifies n8n code. Refer to n8n's license for usage terms.

## 🤝 Contributing

This is a private repository for development use. For n8n contributions, see the official n8n repository.

---

**Version:** 1.0.0  
**Compatible with:** n8n v1.119.0  
**Last updated:** November 2025
