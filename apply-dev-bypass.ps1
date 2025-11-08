# Apply Development License Bypass for n8n
# This script applies the dev license bypass patch, installs dependencies, and builds n8n

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "n8n Development License Bypass Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if patch file exists
if (-not (Test-Path "dev-license-bypass.patch")) {
    Write-Host "Error: dev-license-bypass.patch not found!" -ForegroundColor Red
    Write-Host "Make sure you're running this from the n8n root directory."
    exit 1
}

# Apply the patch
Write-Host "Step 1/4: Applying license bypass patch..." -ForegroundColor Yellow
try {
    git apply --check dev-license-bypass.patch 2>$null
    if ($LASTEXITCODE -eq 0) {
        git apply dev-license-bypass.patch
        Write-Host "✓ Patch applied successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠ Patch already applied or conflicts detected. Continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Patch check failed. Continuing..." -ForegroundColor Yellow
}

# Create environment files
Write-Host ""
Write-Host "Step 2/4: Creating environment configuration files..." -ForegroundColor Yellow

# Root .env
$envContent = @"
# Development environment configuration
# Enable enterprise features bypass during local development
N8N_DEV_LICENSE_BYPASS=true

# Increase Node.js memory limit for builds
NODE_OPTIONS=--max-old-space-size=8192
"@
Set-Content -Path ".env" -Value $envContent
Write-Host "✓ Created .env" -ForegroundColor Green

# Frontend .env.local
$frontendEnvContent = @"
# Development environment configuration
# Enable enterprise features bypass during local development
VITE_DEV_LICENSE_BYPASS=true
"@
Set-Content -Path "packages/frontend/editor-ui/.env.local" -Value $frontendEnvContent
Write-Host "✓ Created packages/frontend/editor-ui/.env.local" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "Step 3/4: Installing dependencies..." -ForegroundColor Yellow
Write-Host "This may take 15-20 minutes depending on your connection..." -ForegroundColor Gray
pnpm install --verbose

# Build
Write-Host ""
Write-Host "Step 4/4: Building n8n..." -ForegroundColor Yellow
Write-Host "This may take 20-30 minutes..." -ForegroundColor Gray
$env:NODE_OPTIONS = "--max-old-space-size=8192"
pnpm build > build.log 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Build completed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Build failed. Check build.log for details" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✓ Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "All enterprise features are now enabled for development." -ForegroundColor Green
Write-Host ""
Write-Host "To start n8n with enterprise features:" -ForegroundColor White
Write-Host '  $env:N8N_DEV_LICENSE_BYPASS="true"' -ForegroundColor Gray
Write-Host '  $env:NODE_OPTIONS="--max-old-space-size=8192"' -ForegroundColor Gray
Write-Host "  pnpm start" -ForegroundColor Gray
Write-Host ""
Write-Host "Or for development mode:" -ForegroundColor White
Write-Host "  pnpm dev:be  # Backend only" -ForegroundColor Gray
Write-Host ""
Write-Host "See DEV_LICENSE_BYPASS.md for more details." -ForegroundColor White
