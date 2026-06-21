<#
.SYNOPSIS
    Package each skill folder into a .skill zip for upload to claude.ai.

.DESCRIPTION
    Hub-and-spoke source-of-truth model: this git repo is canonical. Editing
    happens here; claude.ai is a downstream consumer. Run this script to
    regenerate upload-ready .skill artifacts in ./dist, then drag each into
    claude.ai -> Settings -> Capabilities -> Skills (replacing the old version).

    A .skill file is just a zip whose top-level folder is the skill name,
    e.g. python-dev-style/SKILL.md  (+ optional references/).

.EXAMPLE
    pwsh ./package.ps1
    pwsh ./package.ps1 -Only career-path,de-slop
#>
[CmdletBinding()]
param(
    # Optional: package only these skills (folder names). Default: all.
    [string[]]$Only
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem

$skills = Get-ChildItem -Path $root -Directory | Where-Object {
    $_.Name -notin @('dist', '.git') -and
    (Test-Path (Join-Path $_.FullName 'SKILL.md'))
}

if ($Only) {
    $skills = $skills | Where-Object { $_.Name -in $Only }
}

if (-not $skills) {
    Write-Warning 'No matching skill folders found.'
    return
}

foreach ($s in $skills) {
    $zip = Join-Path $dist ($s.Name + '.skill')
    if (Test-Path $zip) { Remove-Item $zip -Force }
    # includeBaseDirectory = $true -> zip contains <skill>/SKILL.md
    [System.IO.Compression.ZipFile]::CreateFromDirectory(
        $s.FullName, $zip,
        [System.IO.Compression.CompressionLevel]::Optimal, $true)
    Write-Host ("packaged {0,-26} -> dist/{1}.skill" -f $s.Name, $s.Name)
}

Write-Host ("`nDone. {0} artifact(s) in {1}" -f $skills.Count, $dist)
