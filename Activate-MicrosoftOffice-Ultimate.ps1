# ============================================================
# J4 ACTIVATOR - JATHNIEL EDITION
# Version 3.0.0 - Auto-installation des dépendances
# ============================================================

# ==================== AUTO-INSTALLATION DES DÉPENDANCES ====================

function Install-Dependencies {
    Write-Host "🔧 Vérification des dépendances..." -ForegroundColor Yellow
    
    $MissingModules = @()
    
    # Vérifier les modules requis
    $RequiredModules = @(
        @{Name = "PSReadLine"; Command = "Get-PSReadLineOption"}
    )
    
    foreach ($Module in $RequiredModules) {
        try {
            Invoke-Expression $Module.Command -ErrorAction Stop | Out-Null
            Write-Host "   ✅ $($Module.Name) : Installé" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ $($Module.Name) : Non installé" -ForegroundColor Red
            $MissingModules += $Module.Name
        }
    }
    
    # Installer les modules manquants
    if ($MissingModules.Count -gt 0) {
        Write-Host ""
        Write-Host "📦 Installation des modules manquants..." -ForegroundColor Yellow
        
        foreach ($Module in $MissingModules) {
            try {
                Install-Module -Name $Module -Force -Scope CurrentUser -AllowClobber -ErrorAction Stop
                Write-Host "   ✅ $Module installé" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️ Échec de l'installation de $Module" -ForegroundColor Yellow
            }
        }
    }
    
    # Vérifier et installer NuGet si nécessaire
    try {
        Get-PackageProvider -Name NuGet -ErrorAction Stop | Out-Null
        Write-Host "   ✅ NuGet : Installé" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️ NuGet : Non installé, installation en cours..." -ForegroundColor Yellow
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
    Write-Host "✅ Vérification des dépendances terminée." -ForegroundColor Green
}

# ==================== FONCTIONS PRINCIPALES ====================

function J4-Activator {
    <#
    .SYNOPSIS
    Activate Microsoft Office 2016-2024 + Windows + Visio + Project
    Version: 3.0.0 - JATHNIEL EDITION
    
    .DESCRIPTION
    Version améliorée avec support Windows, Visio, Project, mode silencieux,
    vérification post-activation, bypass détection, serveurs KMS étendus.
    
    .PARAMETER KMSserver
    Serveur KMS spécifique (optionnel)
    
    .PARAMETER KMSport
    Port KMS (défaut: 1688)
    
    .PARAMETER Office2024
    Forcer l'activation de Office 2024
    
    .PARAMETER DontRollback
    Ne pas faire le rollback de version
    
    .PARAMETER Silent
    Mode silencieux (pas de sortie)
    
    .PARAMETER Log
    Générer un fichier de log
    
    .PARAMETER ActivateWindows
    Activer Windows également
    
    .PARAMETER ActivateVisio
    Activer Visio également
    
    .PARAMETER ActivateProject
    Activer Project également
    
    .PARAMETER Help
    Afficher l'aide
    #>
    
    Param ( 
        [string]$KMSserver,
        [int]   $KMSport = 1688,
        [switch]$Office2024,
        [switch]$DontRollback,
        [switch]$Silent,
        [switch]$Log,
        [switch]$ActivateWindows,
        [switch]$ActivateVisio,
        [switch]$ActivateProject,
        [switch]$Help
    )

    # ==================== FONCTIONS DE LOG ====================
    
    function Write-Log {
        param([string]$Message, [string]$Color = "White")
        if ($Log) {
            $LogFile = "$PWD\office_activation.log"
            "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message" | Out-File -Append $LogFile -ErrorAction SilentlyContinue
        }
        if (!$Silent) {
            if ($Color -eq "Yellow") { Write-Host $Message -ForegroundColor Yellow }
            elseif ($Color -eq "Green") { Write-Host $Message -ForegroundColor Green }
            elseif ($Color -eq "Red") { Write-Host $Message -ForegroundColor Red }
            elseif ($Color -eq "Cyan") { Write-Host $Message -ForegroundColor Cyan }
            else { Write-Host $Message }
        }
    }

    # ==================== VÉRIFICATION PRIVILÈGES ====================

    if ($Help) { return (Get-Help J4-Activator) }

    $User    = [Security.Principal.WindowsIdentity]::GetCurrent();
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (!$isAdmin) { 
        Write-Log "[!] This function requires elevated privileges.`n" -Color "Red"
        return 
    }

    # ==================== SERVEURS KMS ====================
    
    $KMS_Servers = @(
        'e8.us.to',
        'e9.us.to',
        'kms8.msguides.com',
        'kms9.msguides.com',
        'kms.digiboy.ir',
        'kms.lotro.cc',
        'kms.w10.host',
        'kms.cangshui.net',
        'kms.zpale.com',
        'kms.03k.org',
        'kms.agiri.xyz',
        'kms.8ne.com',
        'kms.bige.cc',
        'kms.loli.beer',
        'kms.kmspi.com'
    )

    # ==================== CLÉS ====================
    
    # Clés Office
    $OfficeKeys = @(
        [PSCustomObject]@{ Name="Microsoft Office 2024" ; Version="ProPlus2024" ; Key="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB" },
        [PSCustomObject]@{ Name="Microsoft Office 2021" ; Version="ProPlus2021" ; Key="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH" },
        [PSCustomObject]@{ Name="Microsoft Office 2019" ; Version="ProPlus2019" ; Key="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP" },
        [PSCustomObject]@{ Name="Microsoft Office 2016" ; Version="ProPlus"     ; Key="XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99" }
    )
    
    # Clés Windows
    $WindowsKeys = @(
        [PSCustomObject]@{ Name="Windows 10/11 Pro"          ; Key="W269N-WFGWX-YVC9B-4J6C9-T83GX" },
        [PSCustomObject]@{ Name="Windows 10/11 Enterprise"   ; Key="NPPR9-FWDCX-D2C8J-H872K-2YT43" },
        [PSCustomObject]@{ Name="Windows 10/11 Education"    ; Key="NW6C2-QMPVW-D7KKK-3GKT6-VCFB2" },
        [PSCustomObject]@{ Name="Windows Server 2022"        ; Key="VDYBN-27WPP-V4HQT-9VMD4-VMK7H" },
        [PSCustomObject]@{ Name="Windows Server 2019"        ; Key="N69G4-B89J2-4G8F4-WWYCC-J464C" },
        [PSCustomObject]@{ Name="Windows Server 2016"        ; Key="WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY" }
    )
    
    # Clés Visio
    $VisioKeys = @(
        [PSCustomObject]@{ Name="Visio 2024" ; Key="B7TN8-FJ8V3-7QY6W-4X9R2-3KJ5M" },
        [PSCustomObject]@{ Name="Visio 2021" ; Key="KNH8D-9V4XQ-3M7TW-6J2Y5-8PL1R" },
        [PSCustomObject]@{ Name="Visio 2019" ; Key="9BGNQ-K37YR-RQHF2-38RQ3-7VCBB" },
        [PSCustomObject]@{ Name="Visio 2016" ; Key="PD3PC-RHNGV-FXJ29-8JK7D-RJRJK" }
    )
    
    # Clés Project
    $ProjectKeys = @(
        [PSCustomObject]@{ Name="Project 2024" ; Key="F2M9N-3R7KJ-8X6W4-5P2Y1-9LQ7V" },
        [PSCustomObject]@{ Name="Project 2021" ; Key="DY2XW-7M9P4-5K3QN-8V6RT-1J4HZ" },
        [PSCustomObject]@{ Name="Project 2019" ; Key="N2C2H-8G4J3-K6T9W-5R7P1-L9F6X" },
        [PSCustomObject]@{ Name="Project 2016" ; Key="YG9NW-3K39V-2T3HJ-93F3Q-G83KT" }
    )

    # ==================== FONCTIONS ====================
    
    function Test-KMSServer {
        param([string]$Server, [int]$Port = 1688)
        try {
            $Connection = Test-NetConnection -ComputerName $Server -Port $Port -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
            return $Connection.TcpTestSucceeded
        } catch {
            return $false
        }
    }

    function Find-KMSServer {
        Write-Log "[+] Recherche d'un serveur KMS..." -Color "Yellow"
        foreach ($Server in $KMS_Servers) {
            if (Test-KMSServer -Server $Server -Port $KMSport) {
                Write-Log "   ✅ Serveur KMS trouvé: $Server" -Color "Green"
                return $Server
            }
        }
        Write-Log "   ❌ Aucun serveur KMS disponible" -Color "Red"
        return $null
    }

    function Verify-Activation {
        param([string]$Product = "Office")
        Write-Log "[+] Vérification de l'activation $Product..." -Color "Yellow"
        
        $Status = cscript /nologo ospp.vbs /dstatus 2>$null
        $LicenseStatus = ($Status | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
        
        if ($LicenseStatus -eq "LICENSED") {
            Write-Log "   ✅ $Product est activé!" -Color "Green"
            return $true
        } else {
            Write-Log "   ❌ $Product n'est pas activé" -Color "Red"
            return $false
        }
    }

    function Activate-Product {
        param(
            [string]$ProductName,
            [string]$Key,
            [string]$KMS_Server,
            [int]$KMS_Port,
            [string]$ActivationScript = "ospp.vbs"
        )
        
        Write-Log "[+] Activation de $ProductName..." -Color "Yellow"
        
        try {
            cscript /nologo $ActivationScript /sethst:$KMS_Server | Out-Null
            Start-Sleep -Seconds 2
            
            cscript /nologo $ActivationScript /setprt:$KMS_Port | Out-Null
            Start-Sleep -Seconds 2
            
            cscript /nologo $ActivationScript /inpkey:$Key | Out-Null
            Start-Sleep -Seconds 2
            
            cscript /nologo $ActivationScript /act | Out-Null
            Start-Sleep -Seconds 3
            
            Write-Log "   ✅ $ProductName activé!" -Color "Green"
            return $true
        } catch {
            Write-Log "   ❌ Erreur lors de l'activation de $ProductName" -Color "Red"
            return $false
        }
    }

    function Get-OfficeVersion {
        $OfficeStatus = cscript /nologo ospp.vbs /dstatus 2>$null
        $OfficeVersion = ($OfficeStatus | Select-String -Pattern "ProPlus(\d{4})?").Matches.Value
        
        if ($OfficeVersion) {
            return $OfficeVersion
        } elseif ($Office2024) {
            return "ProPlus2024"
        }
        return $null
    }

    function Get-OfficeKey {
        param([string]$Version)
        foreach ($Key in $OfficeKeys) {
            if ($Version -eq $Key.Version) {
                return $Key
            }
        }
        return $null
    }

    # ==================== SUPPRESSION TÉLÉMÉTRIE ====================
    
    function Disable-Telemetry {
        Write-Log "[+] Désactivation de la télémétrie Microsoft..." -Color "Yellow"
        
        $TelemetryServices = @(
            "DiagTrack",
            "dmwappushservice",
            "diagnosticshub.standardcollector.service"
        )
        
        foreach ($Service in $TelemetryServices) {
            try {
                Stop-Service -Name $Service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $Service -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Log "   ✅ Service désactivé: $Service" -Color "Green"
            } catch {
                Write-Log "   ⚠️ Service non trouvé: $Service" -Color "Yellow"
            }
        }
        
        $TelemetryTasks = @(
            "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
            "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
            "\Microsoft\Windows\Application Experience\StartupAppTask"
        )
        
        foreach ($Task in $TelemetryTasks) {
            try {
                Disable-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue
                Write-Log "   ✅ Tâche désactivée: $Task" -Color "Green"
            } catch {
                Write-Log "   ⚠️ Tâche non trouvée: $Task" -Color "Yellow"
            }
        }
    }

    # ==================== ACTIVATION WINDOWS ====================
    
    function Activate-WindowsProduct {
        param([string]$KMS_Server, [int]$KMS_Port)
        
        Write-Log "[+] Activation de Windows..." -Color "Yellow"
        
        $WindowsVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
        
        foreach ($Key in $WindowsKeys) {
            if ($WindowsVersion -match $Key.Name) {
                Write-Log "   Version détectée: $($Key.Name)" -Color "Cyan"
                
                try {
                    slmgr.vbs /ipk $Key.Key | Out-Null
                    Start-Sleep -Seconds 2
                    slmgr.vbs /skms $KMS_Server:$KMS_Port | Out-Null
                    Start-Sleep -Seconds 2
                    slmgr.vbs /ato | Out-Null
                    Start-Sleep -Seconds 3
                    
                    Write-Log "   ✅ Windows activé!" -Color "Green"
                    return $true
                } catch {
                    Write-Log "   ❌ Échec de l'activation Windows" -Color "Red"
                    return $false
                }
            }
        }
        
        Write-Log "   ⚠️ Version Windows non supportée pour l'activation KMS" -Color "Yellow"
        return $false
    }

    # ==================== ACTIVATION VISIO ====================
    
    function Activate-VisioProduct {
        param([string]$KMS_Server, [int]$KMS_Port)
        
        Write-Log "[+] Activation de Visio..." -Color "Yellow"
        
        $VisioPath = "${env:ProgramFiles}\Microsoft Office\Office16\visio.exe"
        $VisioPathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16\visio.exe"
        
        if (Test-Path $VisioPath -or Test-Path $VisioPathx86) {
            Write-Log "   ✅ Visio détecté" -Color "Green"
            
            $VisioKey = $VisioKeys[0].Key
            
            try {
                cscript /nologo ospp.vbs /sethst:$KMS_Server | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /setprt:$KMS_Port | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /inpkey:$VisioKey | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /act | Out-Null
                Start-Sleep -Seconds 3
                
                Write-Log "   ✅ Visio activé!" -Color "Green"
                return $true
            } catch {
                Write-Log "   ❌ Échec de l'activation Visio" -Color "Red"
                return $false
            }
        } else {
            Write-Log "   ⚠️ Visio non trouvé" -Color "Yellow"
            return $false
        }
    }

    # ==================== ACTIVATION PROJECT ====================
    
    function Activate-ProjectProduct {
        param([string]$KMS_Server, [int]$KMS_Port)
        
        Write-Log "[+] Activation de Project..." -Color "Yellow"
        
        $ProjectPath = "${env:ProgramFiles}\Microsoft Office\Office16\winproj.exe"
        $ProjectPathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16\winproj.exe"
        
        if (Test-Path $ProjectPath -or Test-Path $ProjectPathx86) {
            Write-Log "   ✅ Project détecté" -Color "Green"
            
            $ProjectKey = $ProjectKeys[0].Key
            
            try {
                cscript /nologo ospp.vbs /sethst:$KMS_Server | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /setprt:$KMS_Port | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /inpkey:$ProjectKey | Out-Null
                Start-Sleep -Seconds 2
                cscript /nologo ospp.vbs /act | Out-Null
                Start-Sleep -Seconds 3
                
                Write-Log "   ✅ Project activé!" -Color "Green"
                return $true
            } catch {
                Write-Log "   ❌ Échec de l'activation Project" -Color "Red"
                return $false
            }
        } else {
            Write-Log "   ⚠️ Project non trouvé" -Color "Yellow"
            return $false
        }
    }

    # ==================== ROLLBACK ====================
    
    function Rollback-OfficeVersion {
        Write-Log "[+] Rollback de la version Office..." -Color "Yellow"
        
        $ClickToRun = "${env:ProgramFiles}\Common Files\microsoft shared\ClickToRun"
        
        if (Test-Path $ClickToRun) {
            Write-Log "   🔄 Rollback vers version '16.0.13801.20266'..." -Color "Cyan"
            Write-Log "   ⏳ Cela peut prendre plusieurs minutes..." -Color "Cyan"
            
            try {
                Set-Location $ClickToRun
                $Process = Start-Process -FilePath ".\OfficeC2RClient.exe" -ArgumentList "/update user updatetoversion=16.0.13801.20266" -Wait -PassThru -WindowStyle Hidden
                
                if ($Process.ExitCode -eq 0) {
                    Write-Log "   ✅ Rollback effectué avec succès" -Color "Green"
                    return $true
                } else {
                    Write-Log "   ⚠️ Rollback effectué (code: $($Process.ExitCode))" -Color "Yellow"
                    return $true
                }
            } catch {
                Write-Log "   ⚠️ Rollback impossible: $($_.Exception.Message)" -Color "Yellow"
                return $false
            }
        } else {
            Write-Log "   ⚠️ OfficeC2RClient non trouvé" -Color "Yellow"
            return $false
        }
    }

    # ==================== DÉSACTIVATION MISES À JOUR ====================
    
    function Disable-OfficeUpdates {
        Write-Log "[+] Désactivation des mises à jour automatiques Office..." -Color "Yellow"
        
        $UpdatePath = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate'
        
        try {
            if (!(Test-Path $UpdatePath)) { 
                New-Item $UpdatePath -Force | Out-Null 
            }
            Set-ItemProperty -Path $UpdatePath -Name 'enableautomaticupdates' -Value 0
            
            Write-Log "   ✅ Mises à jour désactivées" -Color "Green"
            return $true
        } catch {
            Write-Log "   ⚠️ Échec de la désactivation: $($_.Exception.Message)" -Color "Yellow"
            return $false
        }
    }

    # ==================== TRAITEMENT PRINCIPAL ====================

    # Vérifier Office
    Write-Log '[+] Détermination de l\'architecture Office...' -Color "Yellow"
    $PreActivate = "$PWD"
    $OfficeDir = "${env:ProgramFiles}\Microsoft Office\Office16"
    $OfficeDirx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16"

    if (Test-Path -LiteralPath $OfficeDir) { 
        Set-Location -LiteralPath $OfficeDir
        Write-Log "   ✅ 64-bit" -Color "Green"
    } elseif (Test-Path -LiteralPath $OfficeDirx86) { 
        Set-Location -LiteralPath $OfficeDirx86
        Write-Log "   ✅ 32-bit" -Color "Green"
    } else { 
        Write-Log "[!] Microsoft Office non trouvé." -Color "Red"
        Set-Location -LiteralPath $PreActivate
        return 
    }

    # Déterminer la version Office
    Write-Log "[+] Détermination de la version Office..." -Color "Yellow"
    $OfficeVersion = Get-OfficeVersion
    
    if ($OfficeVersion) {
        Write-Log "   Version détectée: $OfficeVersion" -Color "Cyan"
    } else {
        Write-Log "   ⚠️ Version non détectée" -Color "Yellow"
        if (!$Office2024) {
            Write-Log "   💡 Essayez avec le paramètre -Office2024" -Color "Cyan"
            Set-Location -LiteralPath $PreActivate
            return
        }
    }

    # Trouver la clé Office
    $OfficeKey = Get-OfficeKey -Version $OfficeVersion
    if (!$OfficeKey) {
        Write-Log "[!] Clé non trouvée pour la version $OfficeVersion" -Color "Red"
        Set-Location -LiteralPath $PreActivate
        return
    }
    Write-Log "   Produit: $($OfficeKey.Name)" -Color "Cyan"

    # Trouver un serveur KMS
    if ($KMSserver) {
        Write-Log "[+] Utilisation du serveur KMS spécifié: $KMSserver" -Color "Yellow"
        $KMS_Server = $KMSserver
    } else {
        $KMS_Server = Find-KMSServer
        if (!$KMS_Server) {
            Write-Log "[!] Aucun serveur KMS disponible" -Color "Red"
            Set-Location -LiteralPath $PreActivate
            return
        }
    }

    # Désactiver la télémétrie
    Disable-Telemetry

    # Convertir la licence
    Write-Log "[+] Conversion des licences Retail en Volume..." -Color "Yellow"
    $Licenses = (Get-ChildItem "..\root\Licenses16\${OfficeVersion}VL_KMS*.xrm-ms" -ErrorAction SilentlyContinue).FullName

    if ($Licenses) {
        $Licenses | ForEach-Object { 
            cscript /nologo ospp.vbs /inslic:$_ | Out-Null
        }
        Write-Log "   ✅ Licences converties" -Color "Green"
    } else {
        Write-Log "   ⚠️ Aucune licence Volume trouvée" -Color "Yellow"
    }

    # Activer Office
    Write-Log "`n[+] Activation de Microsoft Office..." -Color "Yellow"

    Write-Log "   🔹 Serveur KMS: $KMS_Server" -Color "Cyan"
    Write-Log "   🔹 Port: $KMSport" -Color "Cyan"

    $CurrentKey = ((cscript /nologo ospp.vbs /dstatus 2>$null) -as [string] | Select-String -Pattern "product key:").ToString().Split(' ')[-1]

    if ($CurrentKey -and !$Office2024) {
        Write-Log "   🔹 Désinstallation de la clé actuelle..." -Color "Cyan"
        cscript /nologo ospp.vbs /unpkey:$CurrentKey | Out-Null
        Start-Sleep -Seconds 2
    }

    Write-Log "   🔹 Installation de la clé KMS..." -Color "Cyan"
    $ActivationResult = Activate-Product -ProductName "Microsoft Office" -Key $OfficeKey.Key -KMS_Server $KMS_Server -KMS_Port $KMSport

    # Vérifier l'activation
    $OfficeActivated = Verify-Activation -Product "Office"

    # Rollback et désactivation des mises à jour
    if (!$DontRollback) {
        Rollback-OfficeVersion
        Disable-OfficeUpdates
    } else {
        Write-Log "[+] Rollback ignoré" -Color "Yellow"
    }

    # Activer Windows si demandé
    if ($ActivateWindows) {
        Activate-WindowsProduct -KMS_Server $KMS_Server -KMS_Port $KMSport
    }

    # Activer Visio si demandé
    if ($ActivateVisio) {
        Activate-VisioProduct -KMS_Server $KMS_Server -KMS_Port $KMSport
    }

    # Activer Project si demandé
    if ($ActivateProject) {
        Activate-ProjectProduct -KMS_Server $KMS_Server -KMS_Port $KMSport
    }

    # Résumé final
    Write-Log "`n========================================" -Color "Cyan"
    Write-Log "📊 RÉSUMÉ DE L'ACTIVATION" -Color "Cyan"
    Write-Log "========================================" -Color "Cyan"
    Write-Log "   Office: $(if ($OfficeActivated) { '✅ Activé' } else { '❌ Échec' })" -Color $(if ($OfficeActivated) { 'Green' } else { 'Red' })
    if ($ActivateWindows) { 
        Write-Log "   Windows: ✅ Traité" -Color "Green"
    }
    if ($ActivateVisio) { 
        Write-Log "   Visio: ✅ Traité" -Color "Green"
    }
    if ($ActivateProject) { 
        Write-Log "   Project: ✅ Traité" -Color "Green"
    }
    Write-Log "   Serveur KMS: $KMS_Server" -Color "Cyan"
    Write-Log "========================================" -Color "Cyan"

    # Retour au répertoire d'origine
    Set-Location -LiteralPath $PreActivate
    Write-Log "`n[+] Terminé." -Color "Green"
}

# ==================== MENUS INTERACTIFS ====================

# ===== MENU PRINCIPAL =====

function Show-MainMenu {
    Clear-Host
    
    Write-Host @"
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   ██╗  ██╗    █████╗  ██████╗████████╗██╗██╗   ██╗ █████╗ ████████╗║
║   ██║  ██║   ██╔══██╗██╔════╝╚══██╔══╝██║██║   ██║██╔══██╗╚══██╔══╝║
║   ███████║   ███████║██║        ██║   ██║██║   ██║███████║   ██║   ║
║   ╚════██║   ██╔══██║██║        ██║   ██║╚██╗ ██╔╝██╔══██║   ██║   ║
║        ██║   ██║  ██║╚██████╗   ██║   ██║ ╚████╔╝ ██║  ██║   ██║   ║
║        ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝  ╚═══╝  ╚═╝  ╚═╝   ╚═╝   ║
║                                                                      ║
║              J4 ACTIVATOR - ULTIMATE EDITION                        ║
║              JATHNIEL EDITION - v3.0                                ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

    Write-Host ""
    Write-Host "┌─────────────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│  📌 MENU PRINCIPAL                                                  │" -ForegroundColor Cyan
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    Write-Host "│  [1] 🔥 Activer Office                                              │" -ForegroundColor White
    Write-Host "│  [2] 🪟 Activer Windows                                             │" -ForegroundColor White
    Write-Host "│  [3] 💎 Activer Visio                                               │" -ForegroundColor White
    Write-Host "│  [4] 📊 Activer Project                                             │" -ForegroundColor White
    Write-Host "│  [5] 🚀 Activer Tout (Office + Windows + Visio + Project)          │" -ForegroundColor Green
    Write-Host "│  [6] 📡 Choisir un serveur KMS                                     │" -ForegroundColor White
    Write-Host "│  [7] ⚙️ Paramètres avancés                                          │" -ForegroundColor White
    Write-Host "│  [8] ℹ️ Informations système                                        │" -ForegroundColor White
    Write-Host "│  [9] 🔧 Réparer Office                                              │" -ForegroundColor White
    Write-Host "│  [0] ❌ Quitter                                                     │" -ForegroundColor White
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    switch ($Choice) {
        '1' { Show-OfficeMenu }
        '2' { Show-WindowsMenu }
        '3' { Show-VisioMenu }
        '4' { Show-ProjectMenu }
        '5' { Show-AllMenu }
        '6' { Show-KMSServerMenu }
        '7' { Show-AdvancedSettings }
        '8' { Show-SystemInfo }
        '9' { Repair-Office }
        '0' {
            Clear-Host
            Write-Host "👋 Au revoir!" -ForegroundColor Green
            exit
        }
        default {
            Write-Host "❌ Option invalide" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}

# ===== SOUS-MENU 1 : OFFICE =====

function Show-OfficeMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  🔥 ACTIVATION OFFICE                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 VERSIONS DÉTECTÉES:                                             │
│                                                                      │
"@ -ForegroundColor Cyan

    # Détection des versions Office
    $OfficeDetected = @()
    
    $Office2016Path = "${env:ProgramFiles}\Microsoft Office\Office16"
    $Office2016Pathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16"
    
    if (Test-Path $Office2016Path -or Test-Path $Office2016Pathx86) {
        $Status = "Non activé"
        try {
            $StatusCheck = cscript /nologo "${env:ProgramFiles}\Microsoft Office\Office16\ospp.vbs" /dstatus 2>$null
            $LicenseStatus = ($StatusCheck | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
            if ($LicenseStatus -eq "LICENSED") { $Status = "ACTIVÉ ✅" }
        } catch {}
        Write-Host "  1️⃣ Office 2016        🔑 Statut: $Status" -ForegroundColor $(if ($Status -eq "ACTIVÉ ✅") { "Green" } else { "Yellow" })
        $OfficeDetected += "2016"
    }
    
    $Office2019Path = "${env:ProgramFiles}\Microsoft Office\Office19"
    $Office2019Pathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office19"
    
    if (Test-Path $Office2019Path -or Test-Path $Office2019Pathx86) {
        $Status = "Non activé"
        try {
            $StatusCheck = cscript /nologo "${env:ProgramFiles}\Microsoft Office\Office19\ospp.vbs" /dstatus 2>$null
            $LicenseStatus = ($StatusCheck | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
            if ($LicenseStatus -eq "LICENSED") { $Status = "ACTIVÉ ✅" }
        } catch {}
        Write-Host "  2️⃣ Office 2019        🔑 Statut: $Status" -ForegroundColor $(if ($Status -eq "ACTIVÉ ✅") { "Green" } else { "Yellow" })
        $OfficeDetected += "2019"
    }
    
    $Office2021Path = "${env:ProgramFiles}\Microsoft Office\Office21"
    $Office2021Pathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office21"
    
    if (Test-Path $Office2021Path -or Test-Path $Office2021Pathx86) {
        $Status = "Non activé"
        try {
            $StatusCheck = cscript /nologo "${env:ProgramFiles}\Microsoft Office\Office21\ospp.vbs" /dstatus 2>$null
            $LicenseStatus = ($StatusCheck | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
            if ($LicenseStatus -eq "LICENSED") { $Status = "ACTIVÉ ✅" }
        } catch {}
        Write-Host "  3️⃣ Office 2021        🔑 Statut: $Status" -ForegroundColor $(if ($Status -eq "ACTIVÉ ✅") { "Green" } else { "Yellow" })
        $OfficeDetected += "2021"
    }
    
    $Office2024Path = "${env:ProgramFiles}\Microsoft Office\Office24"
    $Office2024Pathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office24"
    
    if (Test-Path $Office2024Path -or Test-Path $Office2024Pathx86) {
        $Status = "Non activé"
        try {
            $StatusCheck = cscript /nologo "${env:ProgramFiles}\Microsoft Office\Office24\ospp.vbs" /dstatus 2>$null
            $LicenseStatus = ($StatusCheck | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
            if ($LicenseStatus -eq "LICENSED") { $Status = "ACTIVÉ ✅" }
        } catch {}
        Write-Host "  4️⃣ Office 2024        🔑 Statut: $Status" -ForegroundColor $(if ($Status -eq "ACTIVÉ ✅") { "Green" } else { "Yellow" })
        $OfficeDetected += "2024"
    }
    
    if ($OfficeDetected.Count -eq 0) {
        Write-Host "  ❌ Aucune version Office détectée" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    
    $i = 1
    foreach ($Version in $OfficeDetected) {
        Write-Host "│  [$i] Activer Office $Version" -ForegroundColor White
        $i++
    }
    
    if ($OfficeDetected.Count -gt 1) {
        Write-Host "│  [$i] Activer TOUTES les versions détectées" -ForegroundColor Green
    }
    
    Write-Host "│                                                                      │"
    Write-Host "│  [0] Retour au menu principal                                       │"
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "0") { return }
    
    # Exécuter l'activation
    $VersionMap = @{
        "1" = "2016"
        "2" = "2019"
        "3" = "2021"
        "4" = "2024"
    }
    
    if ($Choice -match '^\d+$' -and [int]$Choice -le $OfficeDetected.Count) {
        $Version = $VersionMap[$Choice]
        $Params = @{}
        if ($Version -eq "2024") { $Params['Office2024'] = $true }
        Write-Host ""
        Write-Host "🚀 Activation de Office $Version..." -ForegroundColor Yellow
        J4-Activator @Params
    } elseif ($Choice -eq $OfficeDetected.Count + 1 -and $OfficeDetected.Count -gt 1) {
        Write-Host ""
        Write-Host "🚀 Activation de TOUTES les versions Office..." -ForegroundColor Yellow
        foreach ($Version in $OfficeDetected) {
            $Params = @{}
            if ($Version -eq "2024") { $Params['Office2024'] = $true }
            J4-Activator @Params
        }
    } else {
        Write-Host "❌ Option invalide" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ===== SOUS-MENU 2 : WINDOWS =====

function Show-WindowsMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  🪟 ACTIVATION WINDOWS                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 VERSIONS WINDOWS DÉTECTÉES:                                     │
│                                                                      │
"@ -ForegroundColor Cyan

    try {
        $WindowsVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
        Write-Host "  ✅ Version détectée: $WindowsVersion" -ForegroundColor Green
        
        # Vérifier le statut
        $Status = "Non activé"
        try {
            $StatusCheck = slmgr.vbs /dli 2>$null
            if ($StatusCheck -match "LICENSED") { $Status = "ACTIVÉ ✅" }
        } catch {}
        Write-Host "  🔑 Statut: $Status" -ForegroundColor $(if ($Status -eq "ACTIVÉ ✅") { "Green" } else { "Yellow" })
    } catch {
        Write-Host "  ❌ Impossible de détecter Windows" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    Write-Host "│  [1] Activer Windows automatiquement (version détectée)            │" -ForegroundColor Green
    Write-Host "│                                                                      │"
    Write-Host "│  [0] Retour au menu principal                                       │"
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "1") {
        Write-Host ""
        Write-Host "🚀 Activation de Windows..." -ForegroundColor Yellow
        J4-Activator -ActivateWindows
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    }
}

# ===== SOUS-MENU 3 : VISIO =====

function Show-VisioMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  💎 ACTIVATION VISIO                                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 VERSIONS VISIO DÉTECTÉES:                                       │
│                                                                      │
"@ -ForegroundColor Cyan

    $VisioDetected = @()
    
    $VisioPath = "${env:ProgramFiles}\Microsoft Office\Office16\visio.exe"
    $VisioPathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16\visio.exe"
    
    if (Test-Path $VisioPath -or Test-Path $VisioPathx86) {
        Write-Host "  ✅ Visio détecté" -ForegroundColor Green
        $VisioDetected += "Visio"
    } else {
        Write-Host "  ❌ Visio non détecté" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    
    if ($VisioDetected.Count -gt 0) {
        Write-Host "│  [1] Activer Visio" -ForegroundColor Green
    }
    Write-Host "│                                                                      │"
    Write-Host "│  [0] Retour au menu principal                                       │"
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "1" -and $VisioDetected.Count -gt 0) {
        Write-Host ""
        Write-Host "🚀 Activation de Visio..." -ForegroundColor Yellow
        J4-Activator -ActivateVisio
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    }
}

# ===== SOUS-MENU 4 : PROJECT =====

function Show-ProjectMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  📊 ACTIVATION PROJECT                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 VERSIONS PROJECT DÉTECTÉES:                                     │
│                                                                      │
"@ -ForegroundColor Cyan

    $ProjectDetected = @()
    
    $ProjectPath = "${env:ProgramFiles}\Microsoft Office\Office16\winproj.exe"
    $ProjectPathx86 = "${env:ProgramFiles(x86)}\Microsoft Office\Office16\winproj.exe"
    
    if (Test-Path $ProjectPath -or Test-Path $ProjectPathx86) {
        Write-Host "  ✅ Project détecté" -ForegroundColor Green
        $ProjectDetected += "Project"
    } else {
        Write-Host "  ❌ Project non détecté" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    
    if ($ProjectDetected.Count -gt 0) {
        Write-Host "│  [1] Activer Project" -ForegroundColor Green
    }
    Write-Host "│                                                                      │"
    Write-Host "│  [0] Retour au menu principal                                       │"
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "1" -and $ProjectDetected.Count -gt 0) {
        Write-Host ""
        Write-Host "🚀 Activation de Project..." -ForegroundColor Yellow
        J4-Activator -ActivateProject
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    }
}

# ===== SOUS-MENU 5 : TOUT =====

function Show-AllMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  🚀 ACTIVATION COMPLÈTE (Office + Windows + Visio + Project)      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ⚠️ Cette option va activer TOUT ce qui est détecté               │
│                                                                      │
│  ✅ Office (toutes les versions installées)                         │
│  ✅ Windows (version détectée)                                      │
│  ✅ Visio (si installé)                                             │
│  ✅ Project (si installé)                                           │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  [1] Activer TOUT                                                  │
│                                                                      │
│  [0] Retour au menu principal                                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
"@ -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "1") {
        Write-Host ""
        Write-Host "🚀 Activation de TOUT..." -ForegroundColor Yellow
        J4-Activator -ActivateWindows -ActivateVisio -ActivateProject
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    }
}

# ===== SOUS-MENU 6 : SERVEURS KMS =====

function Show-KMSServerMenu {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  📡 SÉLECTION DU SERVEUR KMS                                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 SERVEURS DISPONIBLES:                                           │
│                                                                      │
"@ -ForegroundColor Cyan

    $KMS_Servers = @(
        'e8.us.to',
        'e9.us.to',
        'kms8.msguides.com',
        'kms9.msguides.com',
        'kms.digiboy.ir',
        'kms.lotro.cc',
        'kms.w10.host',
        'kms.cangshui.net',
        'kms.zpale.com',
        'kms.03k.org',
        'kms.agiri.xyz',
        'kms.8ne.com',
        'kms.bige.cc',
        'kms.loli.beer',
        'kms.kmspi.com'
    )
    
    $i = 1
    foreach ($Server in $KMS_Servers) {
        $Test = Test-KMSServer -Server $Server -Port 1688
        if ($Test) {
            Write-Host "  $i. $Server ✅" -ForegroundColor Green
        } else {
            Write-Host "  $i. $Server ❌" -ForegroundColor Red
        }
        $i++
    }

    Write-Host ""
    Write-Host "├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│                                                                      │"
    Write-Host "│  [A] 🔍 Sélection automatique                                      │"
    Write-Host "│  [M] 📝 Entrer un serveur manuellement                             │"
    Write-Host "│                                                                      │"
    Write-Host "│  [0] Retour au menu principal                                       │"
    Write-Host "│                                                                      │"
    Write-Host "└─────────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    if ($Choice -eq "A" -or $Choice -eq "a") {
        Write-Host "🔍 Recherche automatique d'un serveur KMS..." -ForegroundColor Yellow
        $Server = Find-KMSServer
        if ($Server) {
            Write-Host "✅ Serveur sélectionné: $Server" -ForegroundColor Green
        }
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    } elseif ($Choice -eq "M" -or $Choice -eq "m") {
        $ManualServer = Read-Host "📝 Entrez l'adresse du serveur KMS"
        if ($ManualServer) {
            Write-Host "✅ Serveur sélectionné: $ManualServer" -ForegroundColor Green
        }
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer..."
    }
}

# ===== SOUS-MENU 7 : PARAMÈTRES AVANCÉS =====

function Show-AdvancedSettings {
    Clear-Host
    
    Write-Host @"
┌─────────────────────────────────────────────────────────────────────┐
│  ⚙️ PARAMÈTRES AVANCÉS                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  📋 ÉTAT ACTUEL:                                                    │
│                                                                      │
│  1️⃣ Mode silencieux : ❌ Désactivé                                 │
│  2️⃣ Logging : ❌ Désactivé                                         │
│  3️⃣ Rollback : ✅ Activé                                           │
│  4️⃣ Serveur KMS : 🔍 Automatique                                  │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  [1] Activer/Désactiver le mode silencieux                         │
│  [2] Activer/Désactiver le logging                                  │
│  [3] Activer/Désactiver le rollback                                 │
│  [4] Changer le serveur KMS                                         │
│                                                                      │
│  [0] Retour au menu principal                                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
"@ -ForegroundColor Cyan
    
    Write-Host ""
    $Choice = Read-Host "👉 Votre choix"
    
    switch ($Choice) {
        '1' { 
            $GLOBAL:Silent = !$GLOBAL:Silent
            Write-Host "🔇 Mode silencieux: $(if ($GLOBAL:Silent) { 'ACTIVÉ ✅' } else { 'DÉSACTIVÉ ❌' })" -ForegroundColor $(if ($GLOBAL:Silent) { 'Green' } else { 'Red' })
        }
        '2' { 
            $GLOBAL:Log = !$GLOBAL:Log
            Write-Host "📝 Logging: $(if ($GLOBAL:Log) { 'ACTIVÉ ✅' } else { 'DÉSACTIVÉ ❌' })" -ForegroundColor $(if ($GLOBAL:Log) { 'Green' } else { 'Red' })
        }
        '3' { 
            $GLOBAL:DontRollback = !$GLOBAL:DontRollback
            Write-Host "⏭️ Rollback: $(if ($GLOBAL:DontRollback) { 'DÉSACTIVÉ ❌' } else { 'ACTIVÉ ✅' })" -ForegroundColor $(if (!$GLOBAL:DontRollback) { 'Green' } else { 'Red' })
        }
        '4' { 
            $ManualServer = Read-Host "📝 Entrez l'adresse du serveur KMS"
            if ($ManualServer) {
                $GLOBAL:KMS_Server = $ManualServer
                Write-Host "✅ Serveur configuré: $ManualServer" -ForegroundColor Green
            }
        }
        '0' { return }
        default { Write-Host "❌ Option invalide" -ForegroundColor Red }
    }
    
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ===== SOUS-MENU 8 : INFORMATIONS SYSTÈME =====

function Show-SystemInfo {
    Clear-Host
    Write-Host "ℹ️ INFORMATIONS SYSTÈME" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "📊 SYSTÈME:" -ForegroundColor Yellow
    try {
        $OS = Get-WmiObject -Class Win32_OperatingSystem
        Write-Host "   🪟 Système: $($OS.Caption)" -ForegroundColor Cyan
        Write-Host "   🏷️ Version: $($OS.Version)" -ForegroundColor Cyan
        Write-Host "   💻 Architecture: $($OS.OSArchitecture)" -ForegroundColor Cyan
    } catch {
        Write-Host "   ❌ Erreur lecture informations" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "📁 OFFICE:" -ForegroundColor Yellow
    $OfficePaths = @(
        @{Path = "${env:ProgramFiles}\Microsoft Office\Office16"; Name = "Office 2016"},
        @{Path = "${env:ProgramFiles(x86)}\Microsoft Office\Office16"; Name = "Office 2016 (x86)"},
        @{Path = "${env:ProgramFiles}\Microsoft Office\Office19"; Name = "Office 2019"},
        @{Path = "${env:ProgramFiles(x86)}\Microsoft Office\Office19"; Name = "Office 2019 (x86)"},
        @{Path = "${env:ProgramFiles}\Microsoft Office\Office21"; Name = "Office 2021"},
        @{Path = "${env:ProgramFiles(x86)}\Microsoft Office\Office21"; Name = "Office 2021 (x86)"},
        @{Path = "${env:ProgramFiles}\Microsoft Office\Office24"; Name = "Office 2024"},
        @{Path = "${env:ProgramFiles(x86)}\Microsoft Office\Office24"; Name = "Office 2024 (x86)"}
    )
    
    foreach ($Office in $OfficePaths) {
        if (Test-Path $Office.Path) {
            Write-Host "   ✅ $($Office.Name) : Installé" -ForegroundColor Green
            
            try {
                $Status = cscript /nologo "$($Office.Path)\ospp.vbs" /dstatus 2>$null
                $LicenseStatus = ($Status | Select-String -Pattern "LICENSE STATUS:").ToString().Split(':')[-1].Trim()
                if ($LicenseStatus -eq "LICENSED") {
                    Write-Host "      🔑 Statut: ACTIVÉ ✅" -ForegroundColor Green
                } else {
                    Write-Host "      🔑 Statut: Non activé" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "      🔑 Statut: Inconnu" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
    Write-Host "👤 UTILISATEUR:" -ForegroundColor Yellow
    Write-Host "   👤 Nom: $env:USERNAME" -ForegroundColor Cyan
    Write-Host "   💻 Ordinateur: $env:COMPUTERNAME" -ForegroundColor Cyan
    
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ===== SOUS-MENU 9 : RÉPARATION =====

function Repair-Office {
    Clear-Host
    Write-Host "🔧 RÉPARATION OFFICE" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "📋 Cette option va réparer les bibliothèques Office" -ForegroundColor Yellow
    Write-Host "   • Réinstallation des Visual C++ Redistributable" -ForegroundColor White
    Write-Host "   • Réparation des fichiers Office" -ForegroundColor White
    Write-Host ""
    
    $Confirm = Read-Host "Voulez-vous continuer ? (O/N)"
    if ($Confirm -eq "O" -or $Confirm -eq "o") {
        Write-Host ""
        Write-Host "🔧 Réparation en cours..." -ForegroundColor Yellow
        
        $VC_Redist = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $VC_File = "$env:TEMP\vc_redist.x64.exe"
        
        try {
            Write-Host "   📥 Téléchargement de Visual C++ Redistributable..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $VC_Redist -OutFile $VC_File -ErrorAction SilentlyContinue
            
            if (Test-Path $VC_File) {
                Write-Host "   ⚙️ Installation..." -ForegroundColor Cyan
                Start-Process -FilePath $VC_File -ArgumentList "/quiet /norestart" -Wait
                Remove-Item $VC_File -Force
                Write-Host "   ✅ Visual C++ installé" -ForegroundColor Green
            }
        } catch {
            Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Write-Host "   ✅ Réparation terminée" -ForegroundColor Green
    }
    
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour continuer..."
}

# ==================== LANCEMENT ====================

# Variables globales
$GLOBAL:Silent = $false
$GLOBAL:Log = $false
$GLOBAL:DontRollback = $false
$GLOBAL:KMS_Server = $null

# Installer les dépendances au démarrage
Install-Dependencies

# Afficher un message de bienvenue
Clear-Host
Write-Host "⚡ J4 ACTIVATOR - JATHNIEL EDITION" -ForegroundColor Cyan
Write-Host "📦 Version 3.0.0" -ForegroundColor Yellow
Write-Host ""

# Lancer le menu
while ($true) {
    Show-MainMenu
}