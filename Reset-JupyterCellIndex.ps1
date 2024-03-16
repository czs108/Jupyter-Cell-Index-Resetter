<#
.SYNOPSIS
    Reset a Jupyter notebook's execution cell indexes, making them increase from 1.
.DESCRIPTION
    Reset a Jupyter notebook's execution cell indexes, making them increase from 1.
    Variable values in cells may be different according to execution order. Users should make sure variables are correct by themselves.
.PARAMETER InputPath
    The path of the original Jupyter notebook.
.PARAMETER OutputPath
    The path of the new Jupyter notebook.
.EXAMPLE
    PS> .\Reset-JupyterCellIndex.ps1 -InputPath 'origin.ipynb' -OutputPath 'new.ipynb'
#>
[CmdletBinding()]
param (
    [ValidateNotNullOrEmpty()]
    [String]$InputPath,
    [ValidateNotNullOrEmpty()]
    [String]$OutputPath
)

Write-Warning 'Variable values in cells might be different according to execution order. Users should make sure variables are correct by themselves.'

# A Jupyter notebook is a JSON object.
$json = Get-Content -Path $InputPath -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json
$cell_idx = 1
foreach ($cell in $json.cells) {
    # Markdown cells don't have execution count.
    if (($cell | Get-Member).Name -contains 'execution_count') {
        $cell.execution_count = $cell_idx
        $cell_idx += 1
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