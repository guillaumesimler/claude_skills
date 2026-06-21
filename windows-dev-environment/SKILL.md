---
name: windows-dev-environment
description: Use this skill whenever Guillaume is setting up, configuring, or debugging anything on his Windows 11 development machines — CUDA/PyTorch/GPU setup, conda environments, secrets management via 1Password CLI (op run), SSH and git auth via the 1Password SSH agent, and PowerShell quirks. Trigger on mentions of his desktop (DESKTOP-GUI-PRI, RTX 3090) or laptop (Guillaume_XPS, RTX 4060), the Dev 1Password vault, op-env.txt, agent.toml, the marker project, pdf_to_md, or any error involving nvidia-smi, torch.cuda.is_available, Permission denied publickey, IdentityAgent, or the openssh-ssh-agent named pipe. Encodes 14+ documented landmines with known fixes — recognize the symptom and jump to the fix instead of rediscovering it. Do NOT use for general Windows usage, generic Python help, or work unrelated to Guillaume's machines.
---

# Windows Dev Environment — Guillaume's Setup

Operational reference for Guillaume's two Windows 11 development machines. This skill exists because environment setup on Windows has many known landmines, and rediscovering them costs hours each time. When in doubt, read the relevant section before suggesting a fix.

## Machine inventory

| | Desktop | Laptop |
|---|---|---|
| Hostname | `DESKTOP-GUI-PRI` | `Guillaume_XPS` (Dell XPS 16 9640) |
| Windows username | `User` | `simle` |
| CPU | AMD Ryzen 9 5950X (16C/32T) | Intel Core Ultra 9 185H |
| RAM | 64 GB | 32 GB |
| GPU | RTX 3090, 24 GB VRAM | RTX 4060 Laptop, 8 GB VRAM |
| Hybrid graphics | No (discrete only) | **Yes — Optimus** |
| OS | Windows 11 | Windows 11 |
| NVIDIA driver | Game Ready 596.x via NVIDIA app | Studio 596.x via NVIDIA app |
| PyTorch wheel | `cu124` | `cu124` |

**Always use `$HOME` in PowerShell paths**, not hardcoded `C:\Users\User\...`, because the username differs between machines (`User` vs `simle`).

## Standard stack

- **Python:** Anaconda, `conda` for env creation. Project envs are pip-installed inside (don't let conda install its own `cudatoolkit`).
- **One conda env per project, always.** Default behavior: create a fresh env named after the project (`conda create -n <project-name> python=3.11 -y`), activate it, then pip-install dependencies. Never install project dependencies into `base`. Only deviate if Guillaume explicitly says so (e.g., "use the existing X env" or "this is a quick one-off, just use base"). The cost of an extra env is trivial; the cost of base-env pollution is hours of "why does this break" later.
- **Default project env for `pdf_to_md`:** `marker` (Python 3.11).
- **Secrets:** stored in 1Password vault `Dev`, items named exactly: `Google AI Studio`, `Anthropic API`, `OpenAI API`, `GitHub - Desktop`, `GitHub - Laptop`. Each has a single concealed field named `api_key` (or for SSH keys, the standard fields).
- **Secret references:** projects use `op-env.txt` (committed to repo, not a `.env` file). Format: `VAR=op://Dev/Item Name/api_key`. Run scripts via `op run --env-file=op-env.txt -- python script.py`.
- **Git auth:** SSH only, never HTTPS. Keys are generated **inside 1Password** (Ed25519), separate item per machine (`GitHub - Desktop` / `GitHub - Laptop`), exposed via 1Password's SSH agent.
- **SSH client:** Microsoft OpenSSH installed via `winget install Microsoft.OpenSSH.Preview` — NOT the Windows Optional Capability.
- **GitHub username:** `guillaumesimler`.

## Known landmines (read these first when debugging)

These have all been encountered and solved before. Recognize the symptom, jump to the fix.

### LM-1: PyTorch wheel mismatch — `torch.cuda.is_available()` returns `False`

**Symptom:** CUDA appears installed (`nvidia-smi` works, driver is current), but `torch.cuda.is_available()` returns `False`.
**Most common cause:** wrong wheel installed. Either pip pulled the CPU build, or the cu-version doesn't match the toolkit.
**Fix:** check the version string. `python -c "import torch; print(torch.__version__)"` should end in `+cu124`. If it ends in `+cpu` or has no `+cuXXX` suffix, reinstall with the explicit index URL:
```powershell
pip uninstall -y torch torchvision
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124
```
**Important:** Guillaume does NOT install the NVIDIA CUDA Toolkit separately. PyTorch wheels ship their own runtime. Don't suggest installing the toolkit.

### LM-2: Laptop Optimus routing — Python lands on iGPU

**Symptom (laptop only):** `nvidia-smi` shows the dGPU exists, but `torch.cuda.is_available()` returns `False` or shows the iGPU.
**Cause:** Windows routed `python.exe` to the Intel iGPU instead of the NVIDIA dGPU.
**Fix:** Windows Settings → System → Display → Graphics → add `python.exe` (full path inside the conda env) → set to **High performance**. Also do this in NVIDIA Control Panel → Manage 3D settings → Program Settings.
**Diagnostic:** run `nvidia-smi` while the script is running. If `python.exe` doesn't appear in the Processes list at the bottom, the dGPU never engaged.

### LM-3: Laptop thermal throttling — slow but not broken

**Symptom (laptop only):** marker runs work but are 3–5× slower than expected.
**Cause:** Power profile (Quiet/Optimized) caps the 4060's TGP at ~35W instead of ~60W.
**Fix:** plug in AC, switch to Ultra Performance in MyDell or Best Performance on the Windows power slider. Don't benchmark on battery.

### LM-4: 1Password agent vault default is wrong

**Symptom:** The "Open SSH Agent Config File…" button in 1Password auto-adds an entry pointing at the `Private` vault, but Guillaume's keys are in `Dev`.
**Fix:** edit `agent.toml` manually. Replace the auto-added entry with:
```toml
[[ssh-keys]]
item = "GitHub - Desktop"   # or "GitHub - Laptop"
vault = "Dev"
```
Save; 1Password reloads automatically. Verify with `ssh-add -l`.

### LM-5: 1Password agent backslash parsing — `IdentityAgent` silently dropped

**Symptom:** `ssh-add -l` returns the key (so the agent is reachable), but `ssh -T git@github.com` fails with `Permission denied (publickey)`. Verbose output shows `get_agent_identities: ssh_get_authentication_socket: No such file or directory` even though `~/.ssh/config` contains the right `IdentityAgent` line.
**Cause:** Windows OpenSSH's argument parser eats one backslash from `\\.\pipe\openssh-ssh-agent` as an escape character, producing a malformed pipe path. Silent failure.
**Fix:** use **forward slashes** in the config:
```
Host *
    IdentityAgent //./pipe/openssh-ssh-agent
```
This bypasses backslash escaping entirely. Functionally equivalent to the `\\.\pipe\` form on Windows.

### LM-6: ~/.ssh/config not written correctly

**Symptom:** SSH says it can't find the config file, or the config exists but is silently ignored.
**Causes & fixes:**
- **Notepad saves as `config.txt`** — file must have NO extension. Use PowerShell's `[System.IO.File]::WriteAllText`, never Notepad.
- **UTF-8 BOM at file start** — corrupts parsing. Always write with `[System.Text.Encoding]::ASCII`.
- **Line endings** — use CRLF on Windows: `"Host *`r`n    IdentityAgent //./pipe/openssh-ssh-agent`r`n"`.
- **Permissions too loose** — must NOT be world-readable. Lock down with `icacls`.

Canonical command to write the config from scratch:
```powershell
mkdir $HOME\.ssh -Force
[System.IO.File]::WriteAllText("$HOME\.ssh\config", "Host *`r`n    IdentityAgent //./pipe/openssh-ssh-agent`r`n", [System.Text.Encoding]::ASCII)
icacls $HOME\.ssh\config /inheritance:r
icacls $HOME\.ssh\config /grant:r "${env:USERNAME}:F"
```

### LM-7: Windows OpenSSH Capability bug (laptop)

**Symptom:** `Get-WindowsCapability` reports `OpenSSH.Client` as `State : Installed`, but `C:\Windows\System32\OpenSSH\ssh.exe` doesn't exist (`Test-Path` returns `False`). The binary is staged in `WinSxS\` but never linked to `System32`.
**Cause:** Known Windows 11 bug — capability install doesn't always create the `System32` symlinks. Removing and re-adding the capability does NOT fix it on affected machines.
**Fix:** install via winget instead — this is the canonical path for Guillaume's laptop:
```powershell
winget install Microsoft.OpenSSH.Preview
```
(Despite the "Preview" name, this is Microsoft's current maintained build. Naming is a Microsoft mess.)
After install, **close all PowerShell windows and open fresh** so PATH refreshes. `where.exe ssh` should then show `C:\Program Files\OpenSSH\ssh.exe`.

### LM-8: Windows ssh-agent service conflicts with 1Password

**Symptom:** SSH connects but doesn't see 1Password's keys.
**Cause:** Windows' built-in `ssh-agent` service is competing with 1Password's agent for the named pipe.
**Fix (Administrator PowerShell):**
```powershell
Stop-Service ssh-agent
Set-Service ssh-agent -StartupType Disabled
```
Required on every machine running 1Password's SSH agent.

### LM-9: PowerShell x86 vs 64-bit confusion

**Symptom:** Commands work in one PowerShell window but not another, or `where.exe ssh` finds nothing despite SSH being installed.
**Cause:** Accidentally launched `Windows PowerShell (x86)` from the start menu — uses redirected `SysWOW64` paths.
**Fix:** check with `[Environment]::Is64BitProcess` (must be `True`). Open the regular `Windows PowerShell` (no `(x86)` suffix). Pin the 64-bit one to the taskbar to avoid this.

### LM-10: Anaconda PowerShell ships its own SSH

**Symptom:** SSH behaves differently inside conda env vs system shell.
**Cause:** Anaconda Prompt loads `C:\Users\User\anaconda3\Library\usr\bin\ssh.exe` (MSYS-bundled, older, may not support `IdentityAgent` named pipes properly) before Windows OpenSSH.
**Fix:** verify with `where.exe ssh`. If conda's SSH is first, either deactivate conda for git operations (`conda deactivate`), or call the Windows one explicitly via full path.

### LM-11: Standalone OpenSSH at `C:\Program Files\OpenSSH\` shadows the Windows one (laptop)

**Symptom (laptop):** `where.exe ssh` resolves to `C:\Program Files\OpenSSH\ssh.exe` instead of `C:\Windows\System32\OpenSSH\ssh.exe`. SSH appears to work but doesn't talk to 1Password's agent properly, or behaves subtly differently from the desktop.
**Cause:** A standalone OpenSSH build (often pulled in by another tool's installer, or a prior manual install) sits at `C:\Program Files\OpenSSH\` and comes before `System32\OpenSSH\` on PATH. When the Microsoft OpenSSH winget install (LM-7) hasn't been applied — or when the System32 symlinks are missing because of the WinSxS bug — there's nothing at `System32\OpenSSH\` to shadow it, and the standalone one silently wins.
**Fix:** Decide which one is canonical (Guillaume's stack: Microsoft OpenSSH from winget, at `C:\Program Files\OpenSSH\` IS the right one on the laptop because of LM-7 — confirm it's actually the Microsoft Preview build with `ssh -V`). If the standalone build is from somewhere else (older version, third-party packaging), uninstall it and rely on `winget install Microsoft.OpenSSH.Preview`. Don't mix builds.
**Diagnostic chain:**
```powershell
where.exe ssh           # which one is first on PATH
ssh -V                  # version string — Microsoft builds say "OpenSSH_for_Windows_X.Y"
Get-Command ssh | Format-List Source, Version
```

### LM-12: `core.sshCommand` breaks with spaces in path, and Git for Windows ships its own SSH

**Symptom (both machines):** Git operations over SSH fail despite `ssh -T git@github.com` working from PowerShell. Or: `git config --global core.sshCommand "C:\Program Files\OpenSSH\ssh.exe"` errors out with "ssh: command not found" or splits the path on the space.
**Two intertwined causes:**
1. **Git for Windows bundles its own SSH** at `C:\Program Files\Git\usr\bin\ssh.exe` (MSYS-based, similar problem to LM-10 but at the Git layer). When you run `git push`, Git calls *its own* SSH, not the Windows one — so all your `~/.ssh/config` and `IdentityAgent` setup is bypassed and 1Password's agent is never consulted.
2. **Spaces in `C:\Program Files\` break `core.sshCommand`** because Git parses the value as a shell-style command line; the space splits into two tokens.
**Fix:** Point Git explicitly at Windows OpenSSH using the **8.3 short name** to avoid the space:
```powershell
git config --global core.sshCommand "C:/PROGRA~1/OpenSSH/ssh.exe"
```
Forward slashes also help Git's parser. Verify:
```powershell
git config --global --get core.sshCommand
GIT_SSH_COMMAND= git -c core.sshCommand="C:/PROGRA~1/OpenSSH/ssh.exe" ls-remote git@github.com:guillaumesimler/<repo>.git
```
**Alternative if `PROGRA~1` doesn't resolve:** check with `cmd /c "dir /x C:\"` — on rare configs the short name is `PROGRA~2`. Don't assume.
**Why not just remove Git's bundled SSH:** it's part of the Git for Windows install and reinstalls itself; cleaner to override via `core.sshCommand`.

### LM-13: `IdentityAgent` must be explicitly written to `~/.ssh/config` — there is no default (laptop)

**Symptom (laptop):** `ssh-add -l` shows the 1Password key is loaded in the agent, but `ssh -T git@github.com` fails with `Permission denied (publickey)`. No errors, no warnings — just denial.
**Cause:** Windows OpenSSH does NOT default to `\\.\pipe\openssh-ssh-agent` for `IdentityAgent`. If `~/.ssh/config` doesn't have an explicit `IdentityAgent` line, ssh falls back to either no agent or the wrong socket, and 1Password's keys are invisible to it. The 1Password docs imply this is automatic; it is not.
**Fix:** Write the line explicitly (see LM-5 for the forward-slash form and LM-6 for the canonical file-write command). Minimum viable config:
```
Host *
    IdentityAgent //./pipe/openssh-ssh-agent
```
**Diagnostic:** `ssh -vT git@github.com 2>&1 | Select-String -Pattern "identity agent|authentication socket"` — if you see `no authentication socket`, the config is missing or not being read.

### LM-14: Windows Explorer "Extract All" flattens Linux zips — use `Expand-Archive` (desktop)

**Symptom (desktop, but applies anywhere):** Extracted a zip created on Linux/macOS via Windows Explorer's right-click → "Extract All", and the resulting folder structure is wrong — nested directories collapsed, files with the same basename overwritten, or symlinks turned into broken text files. Project won't build, imports fail, paths in code don't match what's on disk.
**Cause:** Windows Explorer's built-in extractor has long-standing bugs with archives that use Unix conventions: forward-slash paths, case-sensitive filenames (`README.md` and `readme.md` collide on Windows but Explorer doesn't warn), symlinks, and deep nesting. It silently flattens or drops files.
**Fix:** Use PowerShell's `Expand-Archive` instead. It respects the archive's directory structure and at least fails loudly on case conflicts:
```powershell
Expand-Archive -Path .\archive.zip -DestinationPath .\extracted -Force
```
**For tarballs or zips with symlinks/permissions you actually need preserved:** use `tar` (shipped with Windows 10+):
```powershell
tar -xf archive.zip -C .\extracted    # zip
tar -xzf archive.tar.gz -C .\extracted # gzipped tar
```
**Rule:** never use Explorer's "Extract All" for anything that originated outside Windows. The 30 seconds saved aren't worth the hour of "why is this project broken".

## Standard verification snippets

### CUDA / PyTorch verification (run inside activated conda env)
```python
import torch
assert torch.cuda.is_available(), "CUDA not available"
print(torch.cuda.get_device_name(0))
print(f"{torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB VRAM")
print("PyTorch:", torch.__version__)
print("CUDA runtime:", torch.version.cuda)
```
Expected: device name matches the machine, VRAM ~24 GB (desktop) or ~8 GB (laptop), version ends in `+cu124`, runtime `12.4`.

### 1Password secrets chain verification
```powershell
# From the project directory containing op-env.txt:
op run --env-file=op-env.txt -- python -c "import os; print('GOOGLE:', os.environ['GOOGLE_API_KEY'][:10] + '...'); print('ANTHROPIC:', os.environ['ANTHROPIC_API_KEY'][:10] + '...')"
```
Should print 10-character prefixes of each key. Failure modes: missing `op-env.txt`, wrong vault name in the references, item title typos.

### SSH agent + GitHub auth verification
```powershell
# Confirm 1Password agent serves the key:
$env:SSH_AUTH_SOCK = "\\.\pipe\openssh-ssh-agent"
ssh-add -l   # should show one Ed25519 key
# Then test GitHub:
ssh -T git@github.com   # should print "Hi guillaumesimler!"
```

## Operating principles when helping Guillaume

1. **Always verify before assuming.** Many failures look identical at the surface (`Permission denied`, `False`, `not recognized`). Don't guess — ask for `nvidia-smi`, `where.exe ssh`, `Format-Hex`, `ssh -vT`, `icacls`, etc., and reason from actual output.

2. **Two machines, separate state.** Vault metadata syncs, but generated material (SSH keypairs, PowerShell PATH, installed binaries) is per-machine. When something works on one and not the other, isolate the difference.

3. **Don't re-discover known landmines.** If the symptom matches LM-1 through LM-14 above, jump to the fix and explain why. Don't run the user through the full diagnostic tree if the answer is already known.

4. **Prefer the explicit invocation.** Guillaume's spec deliberately keeps `op run --env-file=op-env.txt --` un-aliased so failures are obvious. Don't suggest aliases or auto-relaunch wrappers.

5. **Honest stance on tradeoffs.** If a fix is fragile (e.g., relying on Git's bundled SSH instead of the proper Windows OpenSSH), say so and offer the cleaner path. Guillaume prefers correctness over expediency.

6. **Tone.** Direct, board-level, no jargon padding, no sycophancy. Disagree when warranted. Match the userPreferences profile (FR/DE/EN, language follows topic).

## File locations to remember

| What | Where |
|---|---|
| 1Password agent config | `~\.config\1Password\ssh\agent.toml` (or whatever 1Password's "Open SSH Agent Config File" opens) |
| SSH client config | `$HOME\.ssh\config` (no extension, ASCII, CRLF) |
| Project secret references | `<project-root>\op-env.txt` |
| Default project root pattern | `$HOME\Projects\<project-name>` |
| CUDA setup operational doc | Lives in repo at `docs/cuda_setup.md` |
| Per-project spec | Lives in repo at `docs/<project>_spec.md` |
