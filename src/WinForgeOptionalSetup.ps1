# =========================
# File: WInForge-OptionalSetup.ps1
# Run as Administrator
# made by - Mrdarksidetm (Abhijeet Yadav)
# =========================

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# --- Elevation check ---
function Test-IsElevated {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsElevated)) {
    Write-Host "Re-launching as Administrator..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# --- Logging ---
try {
    $Downloads = [Environment]::GetFolderPath('UserProfile') + '\Downloads'
    if (-not (Test-Path $Downloads)) { New-Item -ItemType Directory -Path $Downloads -Force | Out-Null }
    $LogPath = Join-Path $Downloads "WInForge-OptionalSetup.log"
    Start-Transcript -Path $LogPath -Append | Out-Null
} catch {
    Write-Warning "Failed to start transcript: $($_.Exception.Message)"
}

# --- Utilities ---
Add-Type -AssemblyName System.Windows.Forms | Out-Null
$Errors = New-Object System.Collections.ArrayList

function Report-Error {
    param([string]$Message, [System.Exception]$Exception)
    $msg = ("❌ Some error Occured!!!      {0} — {1}" -f $Message, $Exception.Message)
    [void]$Errors.Add($msg)
    Write-Host $msg -ForegroundColor Red
}

function Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Show-InfoBox {
    param([string]$Message, [string]$Title = "WInForge-OptionalSetup")
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information') | Out-Null
}

function Read-YesNo {
    param(
        [Parameter(Mandatory=$true)][string]$Prompt,
        [ValidateSet('Y','N')][string]$Default = 'Y'
    )
    while ($true) {
        $ans = Read-Host -Prompt "$Prompt [Y/N]"
        if ([string]::IsNullOrWhiteSpace($ans)) { $ans = $Default }
        $ans = $ans.Trim().ToUpperInvariant()
        if ($ans -in @('Y','YES')) { return 'Y' }
        if ($ans -in @('N','NO'))  { return 'N' }
        Write-Host "Please type Y or N." -ForegroundColor Yellow
    }
}

function Read-Choice {
    param(
        [Parameter(Mandatory=$true)][string]$Prompt,
        [string[]]$Allowed = @('Adblock','Fastest')
    )
    while ($true) {
        $ans = Read-Host -Prompt "$Prompt (Adblock / Fastest)"
        if ([string]::IsNullOrWhiteSpace($ans)) { continue }
        $ans = $ans.Trim()
        # Normalize to canonical values
        switch -Regex ($ans.ToUpperInvariant()) {
            '^(A(DBLOCK)?)$' { return 'Adblock' }
            '^(F(ASTEST)?)$' { return 'Fastest' }
            '^ADBLOCK$'      { return 'Adblock' }
            '^FASTEST$'      { return 'Fastest' }
        }
        if ($Allowed -contains $ans) { return $ans }
        Write-Host "Please type exactly Adblock or Fastest." -ForegroundColor Yellow
    }
}

# --- Networking helpers ---
function Get-NicTargets {
    Get-NetAdapter |
        Where-Object {
            $_.Status -eq 'Up' -and
            ($_.Name -match 'Wi-?Fi|WLAN|Wireless|Ethernet')
        }
}

function Set-Dns-And-DoH {
    param(
        [string[]]$Dns4,
        [string[]]$Dns6,
        [string]$DohTemplate
    )

    $ifaces = Get-NicTargets
    if (-not $ifaces) { throw "No active Wi‑Fi/Ethernet adapters found." }

    foreach ($nic in $ifaces) {
        if ($Dns4 -and $Dns4.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceIndex $nic.IfIndex -ServerAddresses $Dns4
        }
        if ($Dns6 -and $Dns6.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceIndex $nic.IfIndex -ServerAddresses $Dns6 -AddressFamily IPv6
        }
    }

    $allServers = @()
    if ($Dns4) { $allServers += $Dns4 }
    if ($Dns6) { $allServers += $Dns6 }

    foreach ($srv in $allServers) {
        try {
            $existing = Get-DnsClientDohServerAddress -ServerAddress $srv -ErrorAction SilentlyContinue
            if (-not $existing) {
                Add-DnsClientDohServerAddress -ServerAddress $srv -DohTemplate $DohTemplate -AllowFallbackToUdp $true -AutoUpgrade $true | Out-Null
            }
        } catch {
            # Fixed colon parsing by using composite formatting (-f)
            Write-Warning ("DoH registration failed for {0}: {1}" -f $srv, $_.Exception.Message)
        }
    }
}

# =========================
# Step 1: Chris Titus Utility
# =========================
try {
    $DebloatChoice = Read-YesNo -Prompt "⚡ Do you wanna debloat and Optimize your Windows?" -Default 'N'
    if ($DebloatChoice -eq 'Y') {
        Info "Launching Chris Titus Utility..."
        irm "https://christitus.com/win" | iex
        $configPath = Join-Path $PSScriptRoot "Winforge-ChristitusConfigs.json"
        if (Test-Path $configPath) {
            Show-InfoBox "In the Chris Titus Utility window, click Import and select:`n$configPath`nThen run the preset commands." "Chris Titus Utility"
            Start-Process explorer.exe $PSScriptRoot | Out-Null
        } else {
            Show-InfoBox "Winforge-ChristitusConfigs.json not found in:`n$PSScriptRoot`nPlace the JSON alongside this script or proceed manually."
        }
    } else {
        Info "Skipped Windows debloat/optimization."
    }
} catch {
    Report-Error "Chris Titus Utility failed" $_
}

# =========================
# Step 2: Winhance (Edge removal/customization)
# =========================
$EdgeChoice = 'N'
$WinhanceUrl = "https://github.com/memstechtips/Winhance/releases/latest/download/Winhance.Installer.exe"
$WinhanceExe = Join-Path $env:TEMP "Winhance.Installer.exe"
try {
    $EdgeChoice = Read-YesNo -Prompt "📲 Do you wanna remove Edge and customize more?" -Default 'N'
    if ($EdgeChoice -eq 'Y') {
        Info "Downloading Winhance..."
        Invoke-WebRequest -Uri $WinhanceUrl -OutFile $WinhanceExe -UseBasicParsing
        Info "Starting Winhance installer..."
        Start-Process -FilePath $WinhanceExe
        Show-InfoBox "🚫 You can now remove EDGE and other components in Winhance."
    } else {
        Info "Skipped Winhance."
    }
} catch {
    Report-Error "Winhance download/launch failed" $_
}

# =========================
# Step 3: Internet optimization (DNS + DoH)
# =========================
try {
    $NetOptChoice = Read-YesNo -Prompt "🌐 Do you wanna optimise Internet?" -Default 'N'
    if ($NetOptChoice -eq 'Y') {
        $NetProfile = Read-Choice -Prompt "Choose one: Adblock 🚫 or Fastest Speed ⏩"
        switch ($NetProfile) {
            'Adblock' {
                $dns4 = @('94.140.14.14','94.140.15.15')
                $dns6 = @('2a10:50c0::ad1:ff','2a10:50c0::ad2:ff')
                $template = 'https://dns.adguard-dns.com/dns-query'
                Set-Dns-And-DoH -Dns4 $dns4 -Dns6 $dns6 -DohTemplate $template
                Info "Applied Adblock DNS with DoH (automatic)."
            }
            'Fastest' {
                $dns4 = @('1.1.1.1','1.0.0.1')
                $dns6 = @('2606:4700:4700::1111','2606:4700:4700::1001')
                $template = 'https://cloudflare-dns.com/dns-query'
                Set-Dns-And-DoH -Dns4 $dns4 -Dns6 $dns6 -DohTemplate $template
                Info "Applied Fastest DNS with DoH (automatic)."
            }
        }
    } else {
        Info "Skipped Internet optimization."
    }
} catch {
    Report-Error "Internet optimization (DNS/DoH) failed" $_
}

# =========================
# Step 4: WebView2 Runtime (only if Step 2 chosen)
# =========================
$WebView2Url = "https://go.microsoft.com/fwlink/p/?LinkId=2124703"
$WebView2Exe = Join-Path $env:TEMP "MicrosoftEdgeWebview2Setup.exe"
try {
    if ($EdgeChoice -eq 'Y') {
        Info "Downloading Microsoft WebView2 Runtime..."
        Invoke-WebRequest -Uri $WebView2Url -OutFile $WebView2Exe -UseBasicParsing
        try {
            Info "Installing WebView2 Runtime silently..."
            $p = Start-Process -FilePath $WebView2Exe -ArgumentList "/silent /install" -PassThru -Wait
            if ($p.ExitCode -ne 0) {
                Write-Warning "Silent install exit code: $($p.ExitCode). Launching interactively..."
                Start-Process -FilePath $WebView2Exe
            }
        } catch {
            Write-Warning "Silent install failed; launching interactively"
            Start-Process -FilePath $WebView2Exe
        }
    } else {
        Info "Skipped WebView2 (Edge not removed)."
    }
} catch {
    Report-Error "WebView2 Runtime download/install failed" $_
}

# =========================
# Step 5: Oh My Posh hul10 theme
# =========================
function Ensure-Line-InFile {
    param([string]$Path,[string]$Line)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType File -Path $Path -Force | Out-Null
    }
    $content = Get-Content -Path $Path -ErrorAction SilentlyContinue
    if ($null -eq $content -or ($content -notcontains $Line)) {
        Add-Content -Path $Path -Value $Line
    }
}

try {
    $OhMyPoshChoice = Read-YesNo -Prompt "Do you wanna customize your Terminal 🎨" -Default 'N'
    if ($OhMyPoshChoice -eq 'Y') {
        Info "Installing Oh My Posh via winget..."
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements -e --silent

        $themeDir = Join-Path $HOME "posh-themes"
        if (-not (Test-Path $themeDir)) { New-Item -ItemType Directory -Path $themeDir -Force | Out-Null }

        $themeUrl = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/hul10.omp.json"
        $themePath = Join-Path $themeDir "hul10.omp.json"
        Info "Fetching hul10 theme..."
        Invoke-WebRequest -Uri $themeUrl -OutFile $themePath -UseBasicParsing

        $profilePath = $PROFILE
        $initLine = "oh-my-posh init pwsh --config `"$themePath`" | Invoke-Expression"
        Ensure-Line-InFile -Path $profilePath -Line $initLine

        . $profilePath

        Info "Oh My Posh hul10 theme applied."
    } else {
        Info "Skipped Oh My Posh."
    }
} catch {
    Report-Error "Oh My Posh setup failed" $_
}

# --- Final status ---
try {
    if ($Errors.Count -eq 0) {
        Show-InfoBox "✅ Everything is Succesful!"
        Write-Host "✅ Everything is Succesful!" -ForegroundColor Green
    } else {
        $joined = ($Errors -join "`r`n")
        Show-InfoBox $joined "Errors encountered"
        Write-Host $joined -ForegroundColor Red
    }
} finally {
    try { Stop-Transcript | Out-Null } catch {}
}
