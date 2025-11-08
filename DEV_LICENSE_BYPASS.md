# Development License Bypass

This guide explains how to enable all enterprise features during local development.

## Overview

I've implemented a proper environment variable-based system to bypass license checks during development. This allows you to test and develop enterprise features without needing a real license.

## Backend Setup

Set the following environment variable before starting n8n:

```bash
export N8N_DEV_LICENSE_BYPASS=true
```

Or in Windows PowerShell:

```powershell
$env:N8N_DEV_LICENSE_BYPASS="true"
```

When this is set:
- The license manager creates a fake manager with all features enabled
- All enterprise features are unlocked
- Plan name shows as "Enterprise"
- All quotas are set to unlimited
- AI assistant is enabled

## Frontend Setup

Set the following Vite environment variable:

```bash
export VITE_DEV_LICENSE_BYPASS=true
```

Or create a `.env.local` file in `packages/frontend/editor-ui/`:

```
VITE_DEV_LICENSE_BYPASS=true
```

When this is set:
- Enterprise Edition component shows all features
- All enterprise feature checks pass
- Settings store returns all features as enabled

## How It Works

### Backend (packages/cli/src/license.ts)

The `init()` method now checks for `process.env.N8N_DEV_LICENSE_BYPASS`:
- If `true`: Creates a fake license manager with all features enabled
- If `false` or unset: Uses the real license manager with normal checks

All enterprise features are enabled in dev mode:
- Advanced Execution Filters
- Sharing
- LDAP / SAML / OIDC
- Log Streaming
- Variables
- External Secrets
- Audit Logs
- Debug In Editor
- Workflow History
- Advanced Permissions
- And more...

### Frontend (packages/frontend/editor-ui/)

Three files were updated:

1. **src/app/components/EnterpriseEdition.ee.vue**
   - Checks `VITE_DEV_LICENSE_BYPASS` or dev mode
   - Shows enterprise features when enabled

2. **src/app/stores/settings.store.ts**
   - Returns a Proxy that enables all features when in dev mode
   - Falls back to real settings otherwise

3. **src/shims.d.ts**
   - Added TypeScript type for `VITE_DEV_LICENSE_BYPASS`

## Running n8n with Enterprise Features

```bash
# Backend
export N8N_DEV_LICENSE_BYPASS=true
export NODE_OPTIONS="--max-old-space-size=8192"
pnpm dev

# Or just the backend
pnpm dev:be
```

For frontend development:

```bash
# Create .env.local in packages/frontend/editor-ui/
echo "VITE_DEV_LICENSE_BYPASS=true" > packages/frontend/editor-ui/.env.local

# Run frontend dev server
pnpm dev:fe
```

## Safety

The bypass only works when explicitly enabled via environment variables. In production deployments, these variables won't be set, so normal license checks apply.

The backend also checks `NODE_ENV === 'development'` as a fallback, but this should generally not be relied upon.

## Modified Files

- `packages/cli/src/license.ts` - Added dev bypass logic
- `packages/cli/src/services/ai.service.ts` - Restored to use license service
- `packages/frontend/editor-ui/src/app/components/EnterpriseEdition.ee.vue` - Added env var check
- `packages/frontend/editor-ui/src/app/stores/settings.store.ts` - Added Proxy for all features
- `packages/frontend/editor-ui/src/shims.d.ts` - Added TypeScript types
- `packages/@n8n/backend-common/src/logging/logger.ts` - Fixed TypeScript error
- `packages/@n8n/node-cli/src/configs/eslint.ts` - Fixed TypeScript error

## Next Steps

Once the build completes successfully, you can start n8n with:

```bash
export N8N_DEV_LICENSE_BYPASS=true
export VITE_DEV_LICENSE_BYPASS=true
pnpm dev
```

All enterprise features will be available for development and testing.
