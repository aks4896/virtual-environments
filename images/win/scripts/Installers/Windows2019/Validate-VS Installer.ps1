################################################################################
##  File:  Validate-VS Installer.ps1
##  Team:  CI-Build
##  Desc:  Validate Microsoft Visual Studio Installer Projects VSIX Package.
################################################################################

Import-Module -Name ImageHelpers -Force

#Gets the extension details from state.json
function Get-ExtensionPackage {
    $vsProgramData = Get-Item -Path "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances"
    $instanceFolders = Get-ChildItem -Path $vsProgramData.FullName

    if($instanceFolders -is [array])
    {
        Write-Host "More than one instance installed"
        exit 1
    }


    $stateContent = Get-Content -Path ($instanceFolders.FullName + '\state.packages.json')
    $state = $stateContent | ConvertFrom-Json
    $Package = $state.packages | where { $_.id -eq "VSInstallerProjects" }

    return $Package
}


$Package = Get-ExtensionPackage

if($Package) {
    Write-Host "Microsoft Visual Studio Installer Projects Extension version" $WixPackage.version "installed"
}
else {
    Write-Host "Microsoft Visual Studio Installer Projects Extension is not installed"
    exit 1
}

# Adding description of the software to Markdown
$SoftwareName = "Microsoft Visual Studio Installer Projects"

$Description = @"
_Toolset Version:_ $ToolSetVersion<br/>
_Microsoft Visual Studio Installer Projects Version:_ $($Package.version)<br/>
"@

Add-SoftwareDetailsToMarkdown -SoftwareName $SoftwareName -DescriptionMarkdown $Description
