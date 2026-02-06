# EverClaw runner - runs OpenClaw from source with custom state dir
$env:OPENCLAW_STATE_DIR = "C:\Users\fabio\.everclaw"
$env:OPENCLAW_CONFIG_PATH = "C:\Users\fabio\.everclaw\everclaw.json"

Set-Location C:\vscode\EverClaw
pnpm tsx src/cli/gateway-cli/run.ts --dev
