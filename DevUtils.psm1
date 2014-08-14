function Clear-VSSolutionFolder
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$solutionDir,

        [parameter(Mandatory=$false)]
        [switch]$clearNugetPackages,

        [parameter(Mandatory=$false)]
        [switch]$restoreNugetPackages
    )

    process 
    {
        if($pscmdlet.ShouldProcess($solutionDir))
        {
            if (not (Test-Path "$solutionDir\*.sln"))
            {
                "$solutionDir does not contain a solution, skipping"
            }
            else 
            {
                pushd $solutionDir

                "Clearing $solutionDir"    
                ls -LiteralPath obj -Recurse | % { $_.Parent.FullName + "\" + $_.Name } | rmdir -force -recurse
                ls -LiteralPath bin -Recurse | % { $_.Parent.FullName + "\" + $_.Name } | rmdir -force -recurse

                if ($clearNugetPackages)
                {
                    ls -LiteralPath packages -Recurse | % { $_.Parent.FullName + "\" + $_.Name } | rmdir -force -recurse
                }

                popd
            }
        }
    }
}

# set up
pushd 'c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC'
cmd /c "vcvarsall.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd

Write-Host "VS dev environment loaded"
