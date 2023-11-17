<#
.Synopsis
   .MP3 file Merger/Combiner
.DESCRIPTION
   This script combines any number of desired .mp3 files into a single .mp3 file
.EXAMPLE
   Load the MergeMP3 funtion then run:
   1. There will be a text promt for entering the mp3 output file name
   2. A pop-up for mp3's desired to be merged
   3. Another pop-up for what folder to save the output mp3 to. 
#>
function MergeMP3
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        #Name of the merged output mp3 file
        [Parameter(Mandatory=$true)]
        $OutputFileName
    )

    Begin
    {
        #Initial Prompt to chose .mp3 files to merge
        Add-Type -AssemblyName System.Windows.Forms
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.Filter = "Mp3 files (*.mp3)|*.mp3"
        $OpenFileDialog.InitialDirectory = "c:\\"
        $OpenFileDialog.Title = "Select all MP3 files to merge"
        $OpenFileDialog.Multiselect = $true
        if ($OpenFileDialog.ShowDialog() -eq "OK") {
    
            $mp3names = $OpenFileDialog.FileNames
        }
        #Initial Prompt to chose the final location for merged .mp3
        Add-Type -AssemblyName System.Windows.Forms
        $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        #$OpenFolderDialog.RootFolder = "MyComputer"
        $OpenFolderDialog.Description = "Select the destination folder for the merged MP3 File"
        if ($OpenFolderDialog.ShowDialog() -eq "OK") {
    
            $tolocation = $OpenFolderDialog.SelectedPath
        }

        #Combines all mp3paths/files with a deliminater of +, ex. *\1.mp3 + *\2.mp3
        $formattedMP3Names =  $mp3names -join "`" + `""

        #Sets the location of were the combined MP3 file saves to
        $formattedtolocation = "`" `"$tolocation\$OutputFileName.mp3`""

        #Merges the two variables from above to prep for the cmd copy command syntax of: copy <source> <destination>
        $final = $formattedMP3Names + $formattedtolocation
    }
    Process
    {
        #Runs the CMD copy command with the merged formatted body from above
        cmd /c copy /b $final
        Write-Output "MP3's merged to $tolocation\$OutputFileName.mp3"
    }
    End
    {
        Clear-Variable tolocation, formattedMP3Names, final, formattedtolocation, mp3names
    }
}

