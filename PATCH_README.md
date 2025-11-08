# n8n Development License Bypass - Portable Patch

This package contains a portable patch system to enable all enterprise features in n8n during development.

## What's Included

- `dev-license-bypass.patch` - Git patch file with all code changes
- `apply-dev-bypass.sh` - Automated setup script for Linux/macOS/Git Bash
- `apply-dev-bypass.ps1` - Automated setup script for Windows PowerShell
- `DEV_LICENSE_BYPASS.md` - Full documentation

## Quick Start

### Option 1: Automated (Recommended)

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

The script will:
1. Apply the patch to your code
2. Create environment configuration files
3. Install dependencies
4. Build n8n

### Option 2: Manual Application

```bash
# Apply the patch
git apply dev-license-bypass.patch

# Create .env file in root
echo 'N8N_DEV_LICENSE_BYPASS=true' > .env
echo 'NODE_OPTIONS=--max-old-space-size=8192' >> .env

# Create frontend .env.local
echo 'VITE_DEV_LICENSE_BYPASS=true' > packages/frontend/editor-ui/.env.local

# Install and build
pnpm install
NODE_OPTIONS="--max-old-space-size=8192" pnpm build
```

## Running n8n with Enterprise Features

After setup, start n8n:

```bash
# Production mode
pnpm start

# Development mode (backend only)
pnpm dev:be
```

All enterprise features will be automatically enabled:
- ✅ Advanced Execution Filters
- ✅ Sharing, LDAP, SAML, OIDC
- ✅ Log Streaming
- ✅ Variables & External Secrets
- ✅ Audit Logs
- ✅ Debug In Editor
- ✅ Workflow History
- ✅ Advanced Permissions
- ✅ And all other enterprise features

## Files Modified

The patch modifies these files:
- `packages/cli/src/license.ts` - License bypass logic
- `packages/cli/src/services/ai.service.ts` - Restored license service usage
- `packages/frontend/editor-ui/src/app/components/EnterpriseEdition.ee.vue` - Frontend bypass
- `packages/frontend/editor-ui/src/app/stores/settings.store.ts` - Feature flag proxy
- `packages/frontend/editor-ui/src/shims.d.ts` - TypeScript types
- `packages/@n8n/backend-common/src/logging/logger.ts` - TypeScript fix
- `packages/@n8n/node-cli/src/configs/eslint.ts` - TypeScript fix

## Reverting Changes

To remove the bypass and restore original code:

```bash
git checkout -- .
rm .env packages/frontend/editor-ui/.env.local
```

## Transferring to Another n8n Installation

1. Copy these files to the target n8n root directory:
   - `dev-license-bypass.patch`
   - `apply-dev-bypass.sh` (or `apply-dev-bypass.ps1`)
   - `DEV_LICENSE_BYPASS.md` (optional documentation)

2. Run the appropriate setup script

3. Done!

## Requirements

- Git
- Node.js 20.x - 24.x
- pnpm 10.x
- At least 8GB RAM for building

## Troubleshooting

**Build fails:**
```bash
# Increase memory limit
export NODE_OPTIONS="--max-old-space-size=12288"
pnpm build
```

**Patch conflicts:**
If you get conflicts when applying the patch, your n8n version may differ. Either:
1. Checkout to a compatible version
2. Apply changes manually using `DEV_LICENSE_BYPASS.md` as reference

**Frontend crash on dev mode:**
Run backend only: `pnpm dev:be` or use production mode: `pnpm start`

## Notes

- This bypass is for **development purposes only**
- Never deploy to production with this enabled
- The bypass only works when `N8N_DEV_LICENSE_BYPASS=true` is set
- Without the env var, normal license checks apply

## Support

For issues or questions, see the full documentation in `DEV_LICENSE_BYPASS.md`.
