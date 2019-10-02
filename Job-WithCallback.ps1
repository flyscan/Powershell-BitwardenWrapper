
$job = Start-Job -Name "ExampleJob" -ScriptBlock {
  Start-Sleep -Seconds 15
  Write-Output "Hello from a job"
}

Register-ObjectEvent -SourceIdentifier "EventHandlerExample" `
  -InputObject $job -EventName StateChanged `
  -Action {
  # Do things here
  Write-Host "Hello from the handler"

  # Cleanup resources
  if ($Sender.HasMoreData) {
    Write-Host "job $($Sender.Name) says:`n$(Receive-Job $Sender)"
  }
  Remove-Job $Sender.Id

  # XXX this is hardcoded. And a job named "EventHandlerExample remains listed by Get-Job cmdlet
  Unregister-Event -SourceIdentifier "EventHandlerExample"
}