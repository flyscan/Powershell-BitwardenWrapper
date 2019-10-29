$job = Start-Job -Name "ExampleJob" -ScriptBlock {
  Start-Sleep -Seconds 15
  Write-Output "Hello from a job"
}

$cmdArgs = @{
  # XXX this needs to be hardcoded inside the scriptblock
  SourceIdentifier = "EventHandlerExample"
  InputObject      = $job
  EventName        = "StateChanged"
  Action           = {
    # Do things here
    Write-Host "Hello from the handler"

    # Cleanup resources
    if ($Sender.HasMoreData) {
      Write-Host "job $($Sender.Name) says:`n$(Receive-Job $Sender)"
    }
    Remove-Job $Sender.Id

    # XXX a job with this name remains listed by Get-Job cmdlet. why?
    Unregister-Event -SourceIdentifier "EventHandlerExample"
  }
}
Register-ObjectEvent @cmdArgs
