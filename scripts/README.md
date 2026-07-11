# scripts/

## sync-repos.ps1

Claude Code SessionStart hook: fetches `~/.claude/skills` and every git repo
directly under `C:\dev`, then fast-forward pulls any repo that is behind and
has no tracked local changes. Dirty or diverged repos are reported, never touched.

To enable on a machine, add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "& \"$env:USERPROFILE/.claude/skills/scripts/sync-repos.ps1\"",
            "shell": "powershell",
            "timeout": 90,
            "statusMessage": "Syncing repos from GitHub..."
          }
        ]
      }
    ]
  }
}
```
