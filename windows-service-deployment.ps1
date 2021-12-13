$ServiceName = 'SampleService'
$arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue


#$service = Get-Service -Name MSSQLSERVER -ErrorAction SilentlyContinue
if ($null -eq $arrService) {
    # Build the code
    dotnet build --no-restore

    #Copy Executable file from source to destination path
    Copy-Item -Path "C:\actions-runner\_work\SampleWindowsService\SampleWindowsService\bin\Debug\SampleWindowsService.exe" -Destination "C:\Users\mshaik07\source\repos\SampleWindowsService\bin\Debug" -Recurse -force
    
    #Install the service
    New-Service -Name $ServiceName -BinaryPathName "C:\Users\mshaik07\source\repos\SampleWindowsService\bin\Debug\SampleWindowsService.exe"

    $arrService = Get-Service -Name $ServiceName

    write-host 'Service is installed successfully'

    write-host $arrService.status
    #Start the Service
    if ($arrService.Status -ne 'Running') {
        Start-Service $ServiceName
        write-host $arrService.status
        write-host 'Service started'
        $arrService = Get-Service -Name $ServiceName 
    }
    
}
else {
    # Service does exist

    #Stop the Service if it is running
    if ($arrService.status -eq 'Running') {
        Stop-Service $ServiceName
        write-host $arrService.status
        write-host 'Service stopped'
        #Start-Sleep -seconds 60
        $arrService = Get-Service -Name $ServiceName 
        
    }

    # Build the code
    dotnet build --no-restore
    
    #Copy Executable file from source to destination path
    Copy-Item -Path "C:\actions-runner\_work\SampleWindowsService\SampleWindowsService\bin\Debug\SampleWindowsService.exe" -Destination "C:\Users\mshaik07\source\repos\SampleWindowsService\bin\Debug" -Recurse -force

    #Start the Service
    if ($arrService.Status -ne 'Running') {
        Start-Service $ServiceName
        write-host $arrService.status
        write-host 'Service started'
        #Start-Sleep -seconds 60
        $arrService = Get-Service -Name $ServiceName 
       
    }

}


