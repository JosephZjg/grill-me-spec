# Install grill-me-spec into an agent skills directory.
#
# Usage:
#   .\install.ps1 [-Tool claude|codex|zcode] [-Dest <path>]      # from a local clone
#   irm <raw-url>/install.ps1 | iex                               # one-liner
#
# Compatible with Windows PowerShell 5.1 and PowerShell 7+.
param(
  [string]$Tool = "",
  [string]$Dest = ""
)

$repo = $PSScriptRoot
if (-not $repo -or -not (Test-Path "$repo\SKILL.md")) {
  # Piped install (irm ... | iex): fetch the repo from GitHub instead.
  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("grill-me-spec-" + [IO.Path]::GetRandomFileName())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  $zip = Join-Path $tmp "grill-me-spec.zip"
  Invoke-WebRequest "https://github.com/JosephZjg/grill-me-spec/archive/refs/heads/main.zip" -OutFile $zip
  Expand-Archive $zip -DestinationPath $tmp -Force
  $repo = Join-Path $tmp "grill-me-spec-main"
}

if (-not $Dest) {
  if (-not $Tool) {
    if (Test-Path "$env:USERPROFILE\.claude\skills") { $Tool = "claude" }
    elseif (Test-Path "$env:USERPROFILE\.codex\skills") { $Tool = "codex" }
    elseif (Test-Path "$env:USERPROFILE\.zcode\skills") { $Tool = "zcode" }
  }
  $Dest = switch ($Tool.ToLower()) {
    "claude" { "$env:USERPROFILE\.claude\skills\grill-me-spec" }
    "codex"  { "$env:USERPROFILE\.codex\skills\grill-me-spec" }
    "zcode"  { "$env:USERPROFILE\.zcode\skills\grill-me-spec" }
    default  { "" }
  }
  if (-not $Dest) {
    Write-Error "Could not auto-detect a skills directory. Pass -Tool <claude|codex|zcode> or -Dest <path>."
    exit 1
  }
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item "$repo\SKILL.md", "$repo\reference.md" -Destination $Dest -Force
if (Test-Path "$repo\examples") {
  Copy-Item "$repo\examples" -Destination $Dest -Recurse -Force
}
Write-Host "installed grill-me-spec -> $Dest"
