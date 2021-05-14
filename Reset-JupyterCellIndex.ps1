<#
.SYNOPSIS
    Reset a Jupyter notebook's execution cell indexes, making them increase from 1.

.DESCRIPTION
    Reset a Jupyter notebook's execution cell indexes, making them increase from 1.
    Variable values in cells might be different according to execution order. Users should make sure variables are correct by themselves.

.PARAMETER InputPath
    An input Jupyter file name.

.PARAMETER OutputPath
    An output Jupyter file name.

.EXAMPLE
    PS> .\Reset-JupyterCellIndex.ps1 -InputPath .\origin.ipynb -OutputPath .\new.ipynb

.LINK
    Jupyter: https://jupyter.org

.NOTES
    Author: Chen Zhenshuo
    GitHub: https://github.com/czs108
    E-Mail: chenzs108@outlook.com
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]$InputPath,

    [Parameter(Mandatory)]
    [String]$OutputPath
)

try {

    Write-Host 'Warning: Variable values in cells might be different according to execution order. Users should make sure variables are correct by themselves.' -ForegroundColor Yellow

    # A Jupyter notebook is a JSON object.
    $json = Get-Content -Path $InputPath -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json
    $cellIdx = 1
    foreach ($cell in $json.cells) {
        # Markdown cells don't have execution count.
        if (($cell | Get-Member).Name -contains 'execution_count') {
            $cell.execution_count = $cellIdx
            $cellIdx += 1
        }

        # Not all code cells have the output.
        if (($cell | Get-Member).Name -contains 'outputs') {
            foreach ($output in $cell.outputs) {
                if (($output | Get-Member).Name -contains 'execution_count') {
                    $output.execution_count = $cell.execution_count
                }
            }
        }
    }

    $json | ConvertTo-Json -Depth 100 | Out-File -FilePath $OutputPath -Encoding UTF8 -Force

} catch {
    Write-Host "Exception: $PSItem" -ForegroundColor Red
}