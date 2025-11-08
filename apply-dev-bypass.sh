#!/bin/bash
# Apply Development License Bypass for n8n
# This script applies the dev license bypass patch, installs dependencies, and builds n8n

set -e  # Exit on any error

echo "========================================="
echo "n8n Development License Bypass Setup"
echo "========================================="
echo ""

# Check if patch file exists
if [ ! -f "dev-license-bypass.patch" ]; then
    echo "Error: dev-license-bypass.patch not found!"
    echo "Make sure you're running this from the n8n root directory."
    exit 1
fi

# Apply the patch
echo "Step 1/4: Applying license bypass patch..."
if git apply --check dev-license-bypass.patch 2>/dev/null; then
    git apply dev-license-bypass.patch
    echo "✓ Patch applied successfully"
else
    echo "⚠ Patch already applied or conflicts detected. Continuing..."
fi

# Create environment files
echo ""
echo "Step 2/4: Creating environment configuration files..."

# Root .env
cat > .env << 'EOF'
# Development environment configuration
# Enable enterprise features bypass during local development
N8N_DEV_LICENSE_BYPASS=true

# Increase Node.js memory limit for builds
NODE_OPTIONS=--max-old-space-size=8192
EOF
echo "✓ Created .env"

# Frontend .env.local
cat > packages/frontend/editor-ui/.env.local << 'EOF'
# Development environment configuration
# Enable enterprise features bypass during local development
VITE_DEV_LICENSE_BYPASS=true
EOF
echo "✓ Created packages/frontend/editor-ui/.env.local"

# Install dependencies
echo ""
echo "Step 3/4: Installing dependencies..."
echo "This may take 15-20 minutes depending on your connection..."
pnpm install --verbose

# Build
echo ""
echo "Step 4/4: Building n8n..."
echo "This may take 20-30 minutes..."
export NODE_OPTIONS="--max-old-space-size=8192"
pnpm build > build.log 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Build completed successfully"
else
    echo "✗ Build failed. Check build.log for details"
    exit 1
fi

echo ""
echo "========================================="
echo "✓ Setup Complete!"
echo "========================================="
echo ""
echo "All enterprise features are now enabled for development."
echo ""
echo "To start n8n with enterprise features:"
echo "  export N8N_DEV_LICENSE_BYPASS=true"
echo "  export NODE_OPTIONS='--max-old-space-size=8192'"
echo "  pnpm start"
echo ""
echo "Or for development mode:"
echo "  pnpm dev:be  # Backend only"
echo ""
echo "See DEV_LICENSE_BYPASS.md for more details."
