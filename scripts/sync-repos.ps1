# SessionStart hook: keep local repos in sync with GitHub across both PCs.
# Fetches ~/.claude/skills and every git repo directly under C:\dev
# (including the ai-stack vault at C:\dev\_ai_vault), then fast-forward
# pulls any repo that is behind and has a clean working tree.
# Never rebases, merges, or touches dirty trees - it only reports those.

$env:GIT_TERMINAL_PROMPT = '0'

$repos = @()
$skills = Join-Path $HOME '.claude\skills'
if (Test-Path (Join-Path $skills '.git')) { $repos += $skills }
if (Test-Path 'C:\dev') {
    $repos += Get-ChildItem 'C:\dev' -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName '.git') } |
        ForEach-Object { $_.FullName }
}

$lines = @()
foreach ($r in $repos) {
    $name = Split-Path $r -Leaf
    git -C $r fetch --quiet 2>$null
    if ($LASTEXITCODE -ne 0) { $lines += "$name`: fetch failed (offline or SSH agent locked?)"; continue }

    $counts = git -C $r rev-list --left-right --count 'HEAD...@{u}' 2>$null
    if ($LASTEXITCODE -ne 0) { continue }  # no upstream configured
    $behind = [int](($counts -split '\s+')[1])
    if ($behind -eq 0) { continue }

    if (git -C $r status --porcelain --untracked-files=no) {
        $lines += "$name`: $behind commit(s) behind, working tree dirty - NOT pulled"
        continue
    }

    git -C $r pull --ff-only --quiet 2>$null
    if ($LASTEXITCODE -eq 0) { $lines += "$name`: pulled $behind commit(s)" }
    else { $lines += "$name`: $behind behind but fast-forward failed (diverged - resolve manually)" }
}

if ($lines) {
    @{ systemMessage = 'Repo sync: ' + ($lines -join ' | ') } | ConvertTo-Json -Compress
}
