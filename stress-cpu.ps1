# Run it with `powershell -ExecutionPolicy Bypass -File stress-cpu.ps1`

$jobs = 1..4 | ForEach-Object {
    Start-Job {
        $end = (Get-Date).AddSeconds(45)
        while ((Get-Date) -lt $end) {
            [Math]::Sqrt((Get-Random)) | Out-Null
        }
    }
}

# Wait for all background jobs to finish their 45-second duration
$jobs | Wait-Job

# Clean up the job objects from memory
$jobs | Remove-Job
