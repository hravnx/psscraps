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


# "Removing bin and obj folders from $pwd"

# if (not (Test-Path *.sln))
# {
#     ""

# }
# ls -LiteralPath obj -Recurse | % { $_.Parent.FullName + "\" + $_.Name } | rmdir -force -recurse
# ls -LiteralPath bin -Recurse | % { $_.Parent.FullName + "\" + $_.Name } | rmdir -force -recurse
