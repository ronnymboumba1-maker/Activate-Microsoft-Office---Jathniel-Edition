Oui. Je te le mets **en un seul bloc**, sans texte autour, pour un copier-coller direct dans ton fichier `.md` :

````markdown
# J4 ACTIVATOR - JATHNIEL EDITION v3.1.0

> **Documentation technique** — Script PowerShell d'activation KMS pour environnement de laboratoire académique isolé.

---

## 📋 Table des matières

1. Description
2. Prérequis
3. Installation
4. Utilisation
5. Paramètres
6. Architecture du script
7. Dépannage
8. Avertissements
9. Journal des modifications

---

## 📖 Description

**J4 Activator** est un script PowerShell qui automatise l'activation via KMS de :

- **Microsoft Office** 2016 / 2019 / 2021 / 2024 (ProPlus)
- **Windows** 10 / 11 (Pro, Enterprise, Education) et Server 2016/2019/2022
- **Visio** et **Project** (via OSPP)

Le script propose :

- ✅ Détection automatique de la version Office installée
- ✅ Recherche automatique d'un serveur KMS disponible
- ✅ Conversion de licence Retail → Volume
- ✅ Désactivation de la télémétrie Microsoft
- ✅ Rollback optionnel de version Office
- ✅ Menu interactif et mode silencieux
- ✅ Journalisation fichier optionnelle

**Version** : 3.1.0  
**Auteur** : Jathniel  
**Usage prévu** : laboratoire académique, environnement isolé, tests personnels légaux.

---

## ⚙️ Prérequis

| Élément | Requis | Notes |
|---|---|---|
| Système | Windows 8.1 / 10 / 11 / Server 2016+ | x64 ou x86 |
| PowerShell | **5.1 minimum** | Fourni avec Windows 10+ |
| Droits | **Administrateur** | Obligatoire |
| Office | Version Click-to-Run (C2R) installée | Pas la version UWP/Store |
| Réseau | Accès TCP/1688 vers un serveur KMS | Ou KMS local sur le LAN |
| ExecutionPolicy | `RemoteSigned` ou `Bypass` | Voir Installation |

### Versions Office supportées

| Version | Identifiant OSPP | Clé KMS par défaut |
|---|---|---|
| Office 2024 | `ProPlus2024` | `XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB` |
| Office 2021 | `ProPlus2021` | `FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH` |
| Office 2019 | `ProPlus2019` | `NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP` |
| Office 2016 | `ProPlus` | `XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99` |

### Versions Windows supportées

| Version | Clé KMS |
|---|---|
| Windows 10/11 Pro | `W269N-WFGWX-YVC9B-4J6C9-T83GX` |
| Windows 10/11 Enterprise | `NPPR9-FWDCX-D2C8J-H872K-2YT43` |
| Windows 10/11 Education | `NW6C2-QMPVW-D7KKK-3GKT6-VCFB2` |
| Windows Server 2022 | `VDYBN-27WPP-V4HQT-9VMD4-VMK7H` |
| Windows Server 2019 | `N69G4-B89J2-4G8F4-WWYCC-J464C` |
| Windows Server 2016 | `WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY` |

---

## 📥 Installation

### 1. Enregistrer le script

1. Ouvrir le **Bloc-notes** ou **VS Code**
2. Coller le contenu du script `J4-Activator.ps1`
3. Enregistrer sous : `C:\J4\J4-Activator.ps1`
   - **Type** : « Tous les fichiers (`*.*`) »
   - **Encodage** : **UTF-8 avec BOM** (obligatoire pour les caractères accentués)

### 2. Autoriser l'exécution des scripts

Ouvrir **PowerShell en administrateur** et lancer :

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
````

Répondre `O` (Oui).

> **Alternative temporaire** (pour une seule session) :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### 3. Vérifier l'installation

```powershell
Get-ExecutionPolicy -List
Test-Path C:\J4\J4-Activator.ps1
```

---

## 🚀 Utilisation

### Méthode A — Menu interactif (recommandé)

```powershell
cd C:\J4
.\J4-Activator.ps1
```

Le menu principal s'affiche avec les options suivantes :

```text
=====================================================
  J4 ACTIVATOR - JATHNIEL EDITION v3.1.0
  Usage : laboratoire academique isole
=====================================================

  [1] Activer Office (detection auto)
  [2] Activer Windows
  [3] Activer Visio
  [4] Activer Project
  [5] Tout activer
  [6] Tester les serveurs KMS
  [7] Informations systeme
  [0] Quitter
```

### Méthode B — Appel direct d'une fonction

> ⚠️ Le script lance automatiquement le menu à la fin. Pour un appel direct, **commenter la boucle finale** :

```powershell
# while ($true) { Show-MainMenu }
```

Puis dans une session PowerShell admin :

```powershell
. C:\J4\J4-Activator.ps1
J4-Activator -ActivateWindows -ActivateVisio
```

### Méthode C — Mode silencieux (déploiement)

```powershell
$GLOBAL:J4Silent = $true
J4-Activator -ActivateWindows -KMSserver 'kms.monlabo.local' -KMSport 1688
```

### Méthode D — Avec journalisation

```powershell
J4-Activator -Log -ActivateWindows
# → crée .\office_activation.log dans le répertoire courant
```

---

## 🎛️ Paramètres

### `J4-Activator`

| Paramètre          | Type     | Défaut | Description                               |
| ------------------ | -------- | ------ | ----------------------------------------- |
| `-KMSserver`       | `string` | (auto) | Serveur KMS spécifique                    |
| `-KMSport`         | `int`    | `1688` | Port du serveur KMS                       |
| `-Office2024`      | `switch` | —      | Forcer la détection Office 2024           |
| `-DontRollback`    | `switch` | —      | Désactiver le rollback Office             |
| `-Silent`          | `switch` | —      | Aucune sortie console                     |
| `-Log`             | `switch` | —      | Écrire un fichier `office_activation.log` |
| `-ActivateWindows` | `switch` | —      | Activer Windows également                 |
| `-ActivateVisio`   | `switch` | —      | Activer Visio également                   |
| `-ActivateProject` | `switch` | —      | Activer Project également                 |
| `-Help`            | `switch` | —      | Afficher l'aide                           |

### Exemples

```powershell
# Activation Office uniquement (auto-détection)
J4-Activator

# Activation complète avec KMS spécifique
J4-Activator -KMSserver 192.168.1.10 -KMSport 1688 `
             -ActivateWindows -ActivateVisio -ActivateProject

# Mode silencieux + log, sans rollback
J4-Activator -Silent -Log -DontRollback -ActivateWindows

# Forcer Office 2024
J4-Activator -Office2024
```

---

## 🏗️ Architecture du script

```text
J4-Activator.ps1
│
├── En-tête (#Requires, StrictMode)
│
├── Fonctions utilitaires globales
│   ├── Write-J4Log          → log console + fichier
│   ├── Test-KMSServer       → test TCP rapide (1.5s)
│   ├── Find-KMSServer       → parcourt la liste KMS
│   └── Get-OfficeRoot       → localise ospp.vbs
│
├── Install-Dependencies
│   └── Vérifie PSReadLine / NuGet (non bloquant)
│
├── J4-Activator (fonction principale)
│   ├── Vérification admin
│   ├── Détection version Office
│   ├── Sélection clé KMS
│   ├── Activation Office via ospp.vbs
│   ├── Vérification post-activation
│   ├── Activation Windows (optionnel)
│   ├── Activation Visio/Project (optionnel)
│   └── Rollback Office (optionnel)
│
├── Données globales
│   ├── $GLOBAL:KMSServers
│   ├── $GLOBAL:OfficeKeys
│   ├── $GLOBAL:WindowsKeys
│   ├── $GLOBAL:VisioKeys
│   └── $GLOBAL:ProjectKeys
│
├── Menus
│   ├── Show-MainMenu
│   ├── Show-KMSTest
│   ├── Show-SystemInfo
│   └── Pause-Menu
│
└── Lancement
    ├── Install-Dependencies
    └── while ($true) { Show-MainMenu }
```

### Flux d'activation Office

```text
[1] Localisation ospp.vbs
      ↓
[2] cscript ospp.vbs /dstatus → détection version
      ↓
[3] Sélection clé KMS correspondante
      ↓
[4] Recherche serveur KMS disponible
      ↓
[5] cscript ospp.vbs /sethst:<kms>
      ↓
[6] cscript ospp.vbs /setprt:1688
      ↓
[7] cscript ospp.vbs /inslic:<licence VL>
      ↓
[8] cscript ospp.vbs /inpkey:<clé>
      ↓
[9] cscript ospp.vbs /act
      ↓
[10] Vérification : LICENSE STATUS = LICENSED ?
      ↓
[11] Rollback optionnel + désactivation MAJ
```

---

## 🔧 Dépannage

### Erreurs courantes

| Erreur                                                 | Cause                       | Solution                                    |
| ------------------------------------------------------ | --------------------------- | ------------------------------------------- |
| `... n'est pas reconnu`                                | ExecutionPolicy restrictive | `Set-ExecutionPolicy RemoteSigned`          |
| `Accès refusé`                                         | PowerShell non admin        | Relancer en administrateur                  |
| `Microsoft Office introuvable`                         | `ospp.vbs` absent           | Vérifier l'install Office C2R               |
| `Aucun serveur KMS disponible`                         | Firewall / DNS / réseau     | Menu `[6]` pour tester                      |
| `Version Office non detectee`                          | Version non standard        | Essayer `-Office2024`                       |
| `cannot be loaded because running scripts is disabled` | Politique machine           | `Set-ExecutionPolicy -Scope Process Bypass` |

### Vérification manuelle de l'activation

**Office** :

```powershell
cd "C:\Program Files\Microsoft Office\Office16"
cscript /nologo ospp.vbs /dstatus
```

Chercher :

```text
LICENSE STATUS: ---LICENSED---
```

**Windows** :

```powershell
slmgr.vbs /xpr
slmgr.vbs /dli
```

### Forcer la réinitialisation Office

```powershell
cd "C:\Program Files\Microsoft Office\Office16"
cscript /nologo ospp.vbs /remhst
cscript /nologo ospp.vbs /rearm
```

### Tester un serveur KMS manuellement

```powershell
Test-NetConnection -ComputerName kms8.msguides.com -Port 1688
```

### Logs

Si `-Log` est activé :

```powershell
Get-Content .\office_activation.log -Tail 50
```

```
```
