################################################################################
##  File:  Install-VS Installer.ps1
##  Team:  CI-Build
##  Desc:  Install: Visual Studio Installer Projects Extension.
################################################################################
function Install-VsixExtension
{
    Param
    (
        [String]$Url,
        [String]$Name
    )

    $ReleaseInPath = 'Enterprise'
    $exitCode = -1

    try
    {
        Write-Host "Downloading $Name..."
        $FilePath = "${env:Temp}\$Name"

        Invoke-WebRequest -Uri $Url -OutFile $FilePath

        $ArgumentList = ('/quiet', $FilePath)

        Write-Host "Starting Install $Name..."
        $process = Start-Process -FilePath "C:\Program Files (x86)\Microsoft Visual Studio\2019\$ReleaseInPath\Common7\IDE\VSIXInstaller.exe" -ArgumentList $ArgumentList -Wait -PassThru
        $exitCode = $process.ExitCode

        if ($exitCode -eq 0 -or $exitCode -eq 3010)
        {
            Write-Host -Object 'Installation successful'
            return $exitCode
        }
        else
        {
            Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
            return $exitCode
        }
    }
    catch
    {
        Write-Host -Object "Failed to install the Extension $Name"
        Write-Host -Object $_.Exception.Message
        return -1
    }
}

#Installing VS extension 'Visual Studio Installer Projects Extension'
$exitCode = Install-VsixExtension -Url 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioClient/vsextensions/MicrosoftVisualStudio2017InstallerProjects/0.9.4/vspackage' -Name 'InstallerProject.vsix'
#return $exitCode
