# Rename OpenClaw to EverClaw throughout the codebase
# Preserves: upstream URLs (github.com/openclaw, docs.openclaw.ai), licenses, copyright

$root = "C:\vscode\EverClaw"

# Patterns to EXCLUDE (upstream references)
$excludePatterns = @(
    'github.com/openclaw',
    'docs.openclaw.ai',
    'openclaw.ai',
    'LICENSE',
    'Copyright'
)

# File extensions to process
$extensions = @('*.ts', '*.tsx', '*.js', '*.mjs', '*.json', '*.md', '*.mdx', '*.yaml', '*.yml', '*.sh', '*.ps1', '*.swift', '*.kt', '*.java', '*.gradle', '*.html', '*.css')

# Get all files
$files = Get-ChildItem -Path $root -Recurse -Include $extensions -File | Where-Object {
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.FullName -notmatch '\\dist\\' -and
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\\.pnpm\\'
}

$totalFiles = $files.Count
$processedFiles = 0
$changedFiles = 0

foreach ($file in $files) {
    $processedFiles++
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $original = $content
    
    # Skip files that are primarily license/copyright
    if ($file.Name -match '^LICENSE' -or $file.Name -match '^NOTICE') {
        continue
    }
    
    # Replacements (order matters - do specific patterns first)
    
    # Preserve upstream URLs by temporarily replacing them
    $content = $content -replace 'github\.com/openclaw/openclaw', '___GITHUB_UPSTREAM___'
    $content = $content -replace 'github\.com/openclaw', '___GITHUB_ORG___'
    $content = $content -replace 'docs\.openclaw\.ai', '___DOCS_UPSTREAM___'
    $content = $content -replace 'openclaw\.ai', '___DOMAIN_UPSTREAM___'
    
    # Now do the replacements
    # UPPERCASE
    $content = $content -replace 'OPENCLAW_', 'EVERCLAW_'
    $content = $content -replace 'OPENCLAW', 'EVERCLAW'
    
    # CamelCase
    $content = $content -replace 'OpenClaw', 'EverClaw'
    
    # lowercase
    $content = $content -replace '\.openclaw', '.everclaw'
    $content = $content -replace 'openclaw', 'everclaw'
    
    # Restore upstream URLs
    $content = $content -replace '___GITHUB_UPSTREAM___', 'github.com/openclaw/openclaw'
    $content = $content -replace '___GITHUB_ORG___', 'github.com/openclaw'
    $content = $content -replace '___DOCS_UPSTREAM___', 'docs.openclaw.ai'
    $content = $content -replace '___DOMAIN_UPSTREAM___', 'openclaw.ai'
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        $changedFiles++
        Write-Host "Changed: $($file.FullName -replace [regex]::Escape($root), '')"
    }
}

Write-Host ""
Write-Host "Processed $processedFiles files, changed $changedFiles files"
