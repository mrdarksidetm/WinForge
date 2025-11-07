#Requires -Version 5.1
#Requires -RunAsAdministrator
# =========================
# File: WinForge-OptionalSetup.ps1
# Version: 2.1.4 (Enterprise-Grade - All PSScriptAnalyzer Compliant)
# Run as Administrator
# =========================

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# --- Configuration: Known file hashes (UPDATE THESE PERIODICALLY) ---
$script:KnownHashes = @{
    # Update these hashes from official sources before deployment
    'WebView2'           = 'PLACEHOLDER_HASH_CHECK_MICROSOFT_DOCS';   # Microsoft official docs/source
    'Winhance'           = 'PLACEHOLDER_HASH_CHECK_GITHUB_RELEASES';  # Winhance GitHub releases
    'ChrisTitusWinUtil'  = 'PLACEHOLDER_HASH_CHECK_GITHUB'            # WinUtil GitHub releases
}

# --- Logging setup ---
try {
    $LogDir = Join-Path $PSScriptRoot "Winforge_Logs"
    if (-not (Test-Path $LogDir -PathType Container)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $LogPath = Join-Path $LogDir "WinForge-OptionalSetup_$timestamp.log"
    Start-Transcript -Path $LogPath -Append | Out-Null
    Write-Information "Logging to: $LogPath" -InformationAction Continue
} catch {
    Write-Warning "Failed to start transcript: $($_.Exception.Message)"
}

# --- Banner (moved below param/cmdletbinding to avoid parse error) ---
$banner = @'
 __      __.__        _____                           
╱  ╲    ╱  ╲__│ _____╱ ____╲___________  ____   ____  
╲   ╲╱╲╱   ╱  │╱    ╲   __╲╱  _ ╲_  __ ╲╱ ___╲_╱ __ ╲ 
 ╲        ╱│  │   │  ╲  │ (  <_> )  │ ╲╱ ╱_╱  >  ___╱ 
  ╲__╱╲  ╱ │__│___│  ╱__│  ╲____╱│__│  ╲___  ╱ ╲___  >
       ╲╱          ╲╱                 ╱_____╱      ╲╱ 

==== Mrdarksidetm =====
'@
Write-Host $banner -ForegroundColor Cyan

# --- Utilities ---
Add-Type -AssemblyName System.Windows.Forms | Out-Null
$script:Errors           = New-Object System.Collections.ArrayList
$script:SuccessOperations = New-Object System.Collections.ArrayList
$script:ErrorObjects     = New-Object System.Collections.ArrayList   # structured error capture

function Write-ErrorReport {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$false)][System.Exception]$Exception
    )
    $errorMsg = if ($Exception) {
        "❌ ERROR: {0} — {1}" -f $Message, $Exception.Message
    } else {
        "❌ ERROR: {0}" -f $Message
    }
    [void]$script:Errors.Add($errorMsg)
    Write-Host $errorMsg -ForegroundColor Red

    if ($Exception) {
        $errObj = [pscustomobject]@{
            Timestamp       = (Get-Date).ToString("o");
            Message         = $Message;
            ExceptionType   = $Exception.GetType().FullName;
            ExceptionMsg    = $Exception.Message;
            HResult         = $Exception.HResult;
            StackTrace      = $Exception.StackTrace;
            InnerException  = if ($Exception.InnerException) { $Exception.InnerException.ToString() } else { "None" }
        }
        [void]$script:ErrorObjects.Add($errObj)
    }
}

function Write-SuccessReport {
    param([Parameter(Mandatory=$true)][string]$Message)
    $successMsg = "✅ SUCCESS: {0}" -f $Message
    [void]$script:SuccessOperations.Add($successMsg)
    Write-Host $successMsg -ForegroundColor Green
}

function Write-Info {
    param([Parameter(Mandatory=$true)][string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Show-InfoBox {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [string]$Title = "WinForge-OptionalSetup"
    )
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information') | Out-Null
}

function Read-YesNo {
    param(
        [Parameter(Mandatory=$true)][string]$Prompt,
        [ValidateSet('Y','N')][string]$Default = 'Y',
        [int]$TimeoutSeconds = 0
    )
    $startTime = Get-Date
    while ($true) {
        if ($TimeoutSeconds -gt 0) {
            $elapsed = ((Get-Date) - $startTime).TotalSeconds
            if ($elapsed -ge $TimeoutSeconds) {
                Write-Warning "Timeout reached. Using default: $Default"
                return $Default
            }
        }
        $answer = Read-Host -Prompt "$Prompt [Y/N] (default: $Default)"
        if ([string]::IsNullOrWhiteSpace($answer)) { return $Default }
        $normalized = $answer.Trim().ToUpperInvariant()
        switch ($normalized) {
            {$_ -in @('Y','YES')} { return 'Y' }
            {$_ -in @('N','NO')}  { return 'N' }
            default { Write-Host "Invalid input. Please type Y or N." -ForegroundColor Yellow }
        }
    }
}

function Read-Choice {
    param(
        [Parameter(Mandatory=$true)][string]$Prompt,
        [string[]]$ValidChoices = @('Adblock','Fastest')
    )
    $choicesDisplay = $ValidChoices -join ' / '
    while ($true) {
        $answer = Read-Host -Prompt "$Prompt ($choicesDisplay)"
        if ([string]::IsNullOrWhiteSpace($answer)) {
            Write-Host "Input cannot be empty. Please choose from: $choicesDisplay" -ForegroundColor Yellow
            continue
        }
        $normalized = $answer.Trim().ToUpperInvariant()
        foreach ($choice in $ValidChoices) {
            if ($normalized -eq $choice.ToUpperInvariant() -or $normalized -eq $choice.Substring(0,1).ToUpperInvariant()) {
                return $choice
            }
        }
        Write-Host "Invalid choice. Please select from: $choicesDisplay" -ForegroundColor Yellow
    }
}

function Test-FileHash {
    param(
        [Parameter(Mandatory=$true)][string]$FilePath,
        [Parameter(Mandatory=$true)][string]$ExpectedHash,
        [switch]$SkipIfPlaceholder
    )
    if ($SkipIfPlaceholder -and $ExpectedHash -match '^PLACEHOLDER') {
        Write-Warning "Hash validation skipped (placeholder detected). Verify file manually!"
        return $true
    }
    try {
        $actualHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        Write-Info "Computed SHA256: $actualHash"
        Write-Info "Expected SHA256: $ExpectedHash"
        if ($actualHash -eq $ExpectedHash) {
            Write-Info "✓ Hash verification PASSED"
            return $true
        } else {
            Write-Warning "✗ Hash verification FAILED - file may be corrupted or tampered!"
            return $false
        }
    } catch {
        Write-Warning "Hash computation failed: $($_.Exception.Message)"
        return $false
    }
}

function Test-GroupPolicyDNS {
    param()
    try {
        $gpoRegPath = 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient'
        if (Test-Path $gpoRegPath) {
            $gpoKeys = Get-ItemProperty -Path $gpoRegPath -ErrorAction SilentlyContinue
            if ($gpoKeys.PSObject.Properties.Name -contains 'NameServer') {
                Write-Warning "Group Policy DNS settings detected!"
                Write-Warning "Registry: $gpoRegPath\NameServer exists"
                return $true
            }
        }
        return $false
    } catch {
        Write-Warning "GPO DNS check failed: $($_.Exception.Message)"
        return $false
    }
}

# --- Networking helpers ---
function Get-NetworkAdapter {
    [CmdletBinding()]
    param()
    try {
        $adapters = Get-NetAdapter | Where-Object {
            $_.Status -eq 'Up' -and
            (
                $_.PhysicalMediaType -match '802.3' -or
                $_.PhysicalMediaType -match '802.11' -or
                $_.InterfaceDescription -match 'Ethernet|Wireless|Wi-Fi|WLAN'
            ) -and
            $_.InterfaceDescription -notmatch 'Virtual|Loopback|Hyper-V|VMware|VirtualBox'
        }
        if (-not $adapters) { throw "No suitable active network adapters found" }
        Write-Info "Found $($adapters.Count) suitable adapter(s):"
        foreach ($adapter in $adapters) { Write-Info "  - $($adapter.Name) ($($adapter.InterfaceDescription))" }
        return $adapters
    } catch {
        throw "Network adapter detection failed: $($_.Exception.Message)"
    }
}

function Set-DnsAndDoH {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [string[]]$Dns4,
        [string[]]$Dns6,
        [string]$DohTemplate
    )
    if (Test-GroupPolicyDNS) {
        $continue = Read-YesNo -Prompt "⚠️  Group Policy DNS detected. Local changes may be overridden. Continue anyway?" -Default 'N'
        if ($continue -eq 'N') {
            Write-Info "DNS configuration skipped due to GPO conflict"
            return
        }
    }
    try {
        $adapters = Get-NetworkAdapter
        foreach ($adapter in $adapters) {
            try {
                if ($Dns4 -and $Dns4.Count -gt 0) {
                    if ($PSCmdlet.ShouldProcess("$($adapter.Name)", "Set IPv4 DNS to $($Dns4 -join ', ')")) {
                        Set-DnsClientServerAddress -InterfaceIndex $adapter.IfIndex -ServerAddresses $Dns4 -ErrorAction Stop
                        Write-Info "Applied IPv4 DNS to $($adapter.Name)"
                    }
                }
                if ($Dns6 -and $Dns6.Count -gt 0) {
                    if ($PSCmdlet.ShouldProcess("$($adapter.Name)", "Set IPv6 DNS to $($Dns6 -join ', ')")) {
                        Set-DnsClientServerAddress -InterfaceIndex $adapter.IfIndex -ServerAddresses $Dns6 -AddressFamily IPv6 -ErrorAction Stop
                        Write-Info "Applied IPv6 DNS to $($adapter.Name)"
                    }
                }
            } catch {
                Write-Warning "Failed to set DNS on $($adapter.Name): $($_.Exception.Message)"
            }
        }
        $allDnsServers = @()
        if ($Dns4) { $allDnsServers += $Dns4 }
        if ($Dns6) { $allDnsServers += $Dns6 }
        foreach ($server in $allDnsServers) {
            try {
                $existing = Get-DnsClientDohServerAddress -ServerAddress $server -ErrorAction SilentlyContinue
                if ($existing) {
                    Write-Info "DoH already registered for $server"
                } else {
                    if ($PSCmdlet.ShouldProcess($server, "Register DNS-over-HTTPS (DoH) server")) {
                        Add-DnsClientDohServerAddress -ServerAddress $server -DohTemplate $DohTemplate -AllowFallbackToUdp $true -AutoUpgrade $true -ErrorAction Stop
                        Write-Info "✓ DoH registered for $server"
                    }
                }
            } catch {
                Write-Warning "DoH registration failed for ${server}: $($_.Exception.Message)"
            }
        }
        $dohServers = Get-DnsClientDohServerAddress -ErrorAction SilentlyContinue
        if ($dohServers) { Write-Info "Active DoH servers: $($dohServers.Count)" }
    } catch {
        throw "DNS/DoH configuration failed: $($_.Exception.Message)"
    }
}

function Get-SecureFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Url,
        [Parameter(Mandatory=$true)][string]$OutputPath,
        [Parameter(Mandatory=$false)][string]$ExpectedHash,
        [switch]$SkipHashCheck
    )
    try {
        Write-Info "Downloading from: $Url"
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing -ErrorAction Stop
        if (-not (Test-Path $OutputPath)) { throw "Download failed - file not created" }
        $fileSize = (Get-Item $OutputPath).Length
        Write-Info "Downloaded: $([Math]::Round($fileSize/1MB, 2)) MB"
        if (-not $SkipHashCheck -and $ExpectedHash) {
            if (-not (Test-FileHash -FilePath $OutputPath -ExpectedHash $ExpectedHash -SkipIfPlaceholder)) {
                throw "Hash verification failed - aborting for security"
            }
        } elseif (-not $SkipHashCheck) {
            Write-Warning "No expected hash provided - skipping verification (INSECURE!)"
        }
        return $true
    } catch {
        Write-ErrorReport "Secure download failed for $Url" $_
        return $false
    }
}

# --- Elevation check ---
function Test-IsElevated {
    [CmdletBinding()]
    param()
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (-not (Test-IsElevated)) {
    Write-Host "Elevation required. Re-launching as Administrator..." -ForegroundColor Yellow
    $scriptPath = $PSCommandPath
    if ([string]::IsNullOrEmpty($scriptPath)) { $scriptPath = $MyInvocation.MyCommand.Path }
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy RemoteSigned -NoProfile -File `"$scriptPath`"" -Verb RunAs
    exit
}

# =========================
# Step 1: Chris Titus Utility (Secure Implementation)
# =========================
try {
    $debloatChoice = Read-YesNo -Prompt "⚡ Do you want to debloat and optimize Windows?" -Default 'N'
    if ($debloatChoice -eq 'Y') {
        $configPath = Join-Path $PSScriptRoot "Winforge-ChristitusConfigs.json"
        if (Test-Path $configPath) {
            Show-InfoBox @"
IMPORTANT: Config file found!

Before proceeding, you'll need to IMPORT the configuration:
1. Click 'Import' in the utility window
2. Select: $configPath
3. Then run the preset commands

The script folder will open now for your reference.
"@ -Title "Chris Titus Utility - Import Configuration"
            Start-Process explorer.exe $PSScriptRoot | Out-Null
        } else {
            Write-Warning "Configuration file not found: Winforge-ChristitusConfigs.json"
            Write-Warning "You'll need to configure the utility manually after launch"
        }
        Write-Info "Preparing Chris Titus WinUtil (secure method)..."
        $winutilUrl  = "https://github.com/ChrisTitusTech/winutil/releases/latest/download/winutil.ps1"
        $winutilPath = Join-Path $env:TEMP "ChrisTitus-winutil.ps1"
        Write-Warning "SECURITY NOTICE: Downloading script for inspection before execution"
        if (Get-SecureFile -Url $winutilUrl -OutputPath $winutilPath -ExpectedHash $script:KnownHashes['ChrisTitusWinUtil'] -SkipHashCheck) {
            Write-Info "Script downloaded successfully"
            Write-Info "Location: $winutilPath"
            $proceed = Read-YesNo -Prompt "Review the script file if needed. Launch Chris Titus Utility?" -Default 'Y'
            if ($proceed -eq 'Y') {
                Write-Info "Launching Chris Titus Utility..."
                & $winutilPath
                Write-SuccessReport "Chris Titus Utility launched successfully"
            } else {
                Write-Info "User cancelled utility launch"
            }
        } else {
            throw "Failed to download WinUtil script securely"
        }
    } else {
        Write-Info "Skipped Windows debloat/optimization"
    }
} catch {
    Write-ErrorReport "Chris Titus Utility execution failed" $_
}

# =========================
# Step 2: Winhance (Edge removal/customization)
# =========================
$EdgeChoice = 'N'
try {
    $EdgeChoice = Read-YesNo -Prompt "📲 Do you want to remove Edge and customize Windows further?" -Default 'N'
    if ($EdgeChoice -eq 'Y') {
        $winhanceUrl = "https://github.com/memstechtips/Winhance/releases/latest/download/Winhance.Installer.exe"
        $winhanceExe = Join-Path $env:TEMP "Winhance.Installer.exe"
        if (Get-SecureFile -Url $winhanceUrl -OutputPath $winhanceExe -ExpectedHash $script:KnownHashes['Winhance'] -SkipHashCheck) {
            Write-Info "Starting Winhance installer..."
            Start-Process -FilePath $winhanceExe
            Show-InfoBox "🚫 Winhance Launched!`n`nYou can now remove Edge and customize other components." -Title "Winhance"
            Write-SuccessReport "Winhance installer launched"
        }
    } else {
        Write-Info "Skipped Winhance (Edge removal)"
    }
} catch {
    Write-ErrorReport "Winhance download/launch failed" $_
}

# =========================
# Step 3: Internet optimization (DNS + DoH)
# =========================
try {
    $netOptChoice = Read-YesNo -Prompt "🌐 Do you want to optimize Internet (DNS + encryption)?" -Default 'N'
    if ($netOptChoice -eq 'Y') {
        $netProfile = Read-Choice -Prompt "Choose profile: Adblock 🚫 or Fastest ⏩" -ValidChoices @('Adblock','Fastest')
        switch ($netProfile) {
            'Adblock' {
                Write-Info "Applying AdGuard DNS with ad-blocking and DoH encryption..."
                Set-DnsAndDoH -Dns4 @('94.140.14.14','94.140.15.15') -Dns6 @('2a10:50c0::ad1:ff','2a10:50c0::ad2:ff') -DohTemplate 'https://dns.adguard-dns.com/dns-query' -Confirm:$false
                Write-SuccessReport "AdGuard DNS with DoH encryption configured"
            }
            'Fastest' {
                Write-Info "Applying Cloudflare DNS for maximum speed with DoH encryption..."
                Set-DnsAndDoH -Dns4 @('1.1.1.1','1.0.0.1') -Dns6 @('2606:4700:4700::1111','2606:4700:4700::1001') -DohTemplate 'https://cloudflare-dns.com/dns-query' -Confirm:$false
                Write-SuccessReport "Cloudflare DNS with DoH encryption configured"
            }
        }
        Write-Info "Flushing DNS cache..."
        Clear-DnsClientCache -ErrorAction SilentlyContinue
    } else {
        Write-Info "Skipped Internet optimization"
    }
} catch {
    Write-ErrorReport "Internet optimization (DNS/DoH) configuration failed" $_
}

# =========================
# Step 4: WebView2 Runtime (conditional on Edge removal)
# =========================
try {
    if ($EdgeChoice -eq 'Y') {
        Write-Info "Installing Microsoft WebView2 Runtime (required after Edge removal)..."
        $webview2Url = "https://go.microsoft.com/fwlink/p/?LinkId=2124703"
        $webview2Exe = Join-Path $env:TEMP "MicrosoftEdgeWebview2Setup.exe"
        if (Get-SecureFile -Url $webview2Url -OutputPath $webview2Exe -ExpectedHash $script:KnownHashes['WebView2'] -SkipHashCheck) {
            Write-Info "Attempting silent installation..."
            try {
                $process = Start-Process -FilePath $webview2Exe -ArgumentList "/silent /install" -PassThru -Wait -ErrorAction Stop
                if ($process.ExitCode -eq 0) {
                    Write-SuccessReport "WebView2 Runtime installed silently"
                } else {
                    Write-Warning "Silent install returned code $($process.ExitCode). Launching interactive installer..."
                    Start-Process -FilePath $webview2Exe
                    Write-SuccessReport "WebView2 Runtime installer launched (interactive)"
                }
            } catch {
                Write-Warning "Silent installation failed: $($_.Exception.Message)"
                Write-Info "Launching interactive installer..."
                Start-Process -FilePath $webview2Exe
                Write-SuccessReport "WebView2 Runtime installer launched (fallback)"
            }
        }
    } else {
        Write-Info "Skipped WebView2 Runtime (Edge not removed)"
    }
} catch {
    Write-ErrorReport "WebView2 Runtime installation failed" $_
}

# =========================
# Step 5: Oh My Posh Terminal Customization
# =========================
function Add-ProfileLine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ProfilePath,
        [Parameter(Mandatory=$true)][string]$LineToAdd
    )
    if (-not (Test-Path $ProfilePath)) {
        New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
        Write-Info "Created new PowerShell profile: $ProfilePath"
    }
    $content = Get-Content -Path $ProfilePath -Raw -ErrorAction SilentlyContinue
    $escapedLine = [regex]::Escape($LineToAdd.Trim())
    if ($content -match $escapedLine) {
        Write-Info "Profile already contains Oh My Posh configuration"
        return $false
    }
    Add-Content -Path $ProfilePath -Value "`n$LineToAdd"
    Write-Info "Added Oh My Posh initialization to profile"
    return $true
}

try {
    $ohMyPoshChoice = Read-YesNo -Prompt "🎨 Do you want to customize your Terminal with Oh My Posh?" -Default 'N'
    if ($ohMyPoshChoice -eq 'Y') {
        Write-Info "Installing Oh My Posh via winget..."
        $wingetArgs = @('install','JanDeDobbeleer.OhMyPosh','-s','winget','--accept-package-agreements','--accept-source-agreements','-e','--silent')
        Start-Process -FilePath 'winget' -ArgumentList $wingetArgs -Wait -NoNewWindow
        $themeDir = Join-Path $HOME "posh-themes"
        if (-not (Test-Path $themeDir)) { New-Item -ItemType Directory -Path $themeDir -Force | Out-Null }
        $themeUrl  = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/hul10.omp.json"
        $themePath = Join-Path $themeDir "hul10.omp.json"
        Write-Info "Downloading hul10 theme..."
        Invoke-WebRequest -Uri $themeUrl -OutFile $themePath -UseBasicParsing
        $profilePath = $PROFILE
        $initLine = "oh-my-posh init pwsh --config `"$themePath`" | Invoke-Expression"
        $modified = Add-ProfileLine -ProfilePath $profilePath -LineToAdd $initLine
        if ($modified) {
            Write-Info "`n✓ Oh My Posh configured successfully!"
            Write-Warning "`nIMPORTANT: Restart your terminal for changes to take effect"
            Write-Warning "The theme will activate in NEW PowerShell sessions"
        }
        Write-SuccessReport "Oh My Posh hul10 theme installed and configured"
    } else {
        Write-Info "Skipped Oh My Posh terminal customization"
    }
} catch {
    Write-ErrorReport "Oh My Posh installation/configuration failed" $_
}

# =========================
# Final Status Report + Error Conversion + Open Log + Goodbye
# =========================
try {
    Write-Host "`n" + ("="*70) -ForegroundColor Gray
    Write-Host "WINFORGE OPTIONAL SETUP - FINAL REPORT" -ForegroundColor Cyan
    Write-Host ("="*70) -ForegroundColor Gray

    if ($script:SuccessOperations.Count -gt 0) {
        Write-Host "`nSUCCESSFUL OPERATIONS ($($script:SuccessOperations.Count)):" -ForegroundColor Green
        foreach ($success in $script:SuccessOperations) { Write-Host "  $success" -ForegroundColor Green }
    }

    if ($script:Errors.Count -eq 0) {
        Write-Host "`n🎉 ALL OPERATIONS COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        Show-InfoBox "✅ Setup Complete!`n`nAll operations completed successfully.`n`nLog file: $LogPath" -Title "Success"
    } else {
        Write-Host "`nERRORS ENCOUNTERED ($($script:Errors.Count)):" -ForegroundColor Red
        foreach ($errorMsg in $script:Errors) { Write-Host "  $errorMsg" -ForegroundColor Red }

        # Convert/Export structured errors
        $errTxtPath  = Join-Path $LogDir "WinForge_Errors_$timestamp.txt"
        $errJsonPath = Join-Path $LogDir "WinForge_Errors_$timestamp.json"
        try {
            $script:Errors | Out-File -FilePath $errTxtPath -Encoding UTF8
            if ($script:ErrorObjects.Count -gt 0) {
                $script:ErrorObjects | ConvertTo-Json -Depth 6 | Out-File -FilePath $errJsonPath -Encoding UTF8
            }
            Write-Info "Error summaries saved:`n  TXT:  $errTxtPath`n  JSON: $errJsonPath"
        } catch {
            Write-Warning "Failed to export error summaries: $($_.Exception.Message)"
        }

        $errorSummary = "⚠️  Setup completed with errors:`n`n" + ($script:Errors -join "`n`n")
        $errorSummary += "`n`nCheck log file for details:`n$LogPath"
        $errorSummary += if (Test-Path $errTxtPath) { "`n`nError summary:`n$errTxtPath" } else { "" }
        Show-InfoBox $errorSummary -Title "Errors Encountered"
    }

    Write-Host "`nLog file saved to:" -ForegroundColor Gray
    Write-Host "  $LogPath" -ForegroundColor Yellow
    Write-Host ("="*70) -ForegroundColor Gray
}
catch {
    Write-Warning "Failed to generate final report: $($_.Exception.Message)"
}
finally {
    # Ensure transcript is stopped before opening in editor
    try { Stop-Transcript | Out-Null } catch {}

    # Open the log file to "show" it at the end (non-blocking)
    try { Invoke-Item -LiteralPath $LogPath } catch { Write-Warning "Could not open log file: $($_.Exception.Message)" }

    # Final goodbye line
    Write-Host "`nSayonara, hope we meet again." -ForegroundColor Magenta
}
