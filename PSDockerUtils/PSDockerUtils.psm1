function Switch-DockerHost {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('local', 'erclu-server')]
    [string]
    $dockerHost,
    [switch]
    $persist
  )

  switch ($dockerHost) {
    local {
      Write-Verbose "switching to local docker host"
      $targetDockerMachine = "default"

      # & "C:\Program Files\Git\bin\bash.exe" --login -i "C:\Program Files\Docker Toolbox\start.sh"
    }

    erclu-server {
      Write-Verbose "switching DOCKER_HOST to erclu-server via ssh"
      $targetDockerMachine = "erclu-server"

      # $env:DOCKER_HOST = "ssh://erclu@192.168.1.81"
    }
    Default {
      $hereString = @"
CURRENT DOCKER ENVIRONMENT VARIABLES:

DOCKER_HOST=$($env:DOCKER_HOST)

DOCKER_CERT_PATH=$($env:DOCKER_CERT_PATH)
DOCKER_TLS_VERIFY=$($env:DOCKER_TLS_VERIFY) - this should never change
DOCKER_MACHINE_NAME=$($env:DOCKER_MACHINE_NAME)
MACHINE_STORAGE_PATH=$($env:MACHINE_STORAGE_PATH) - this should never change
COMPOSE_CONVERT_WINDOWS_PATHS=$($env:COMPOSE_CONVERT_WINDOWS_PATHS) - this should never change
"@

      Write-Output $hereString

      return 0
    }
  }

  docker-machine env $targetDockerMachine --shell powershell | Invoke-Expression

  docker-machine start $targetDockerMachine

  if ($persist) {
    [environment]::setEnvironmentVariable('DOCKER_TLS_VERIFY', $env:DOCKER_TLS_VERIFY, 'User')
    [environment]::setEnvironmentVariable('DOCKER_HOST', $env:DOCKER_HOST, 'User')
    [environment]::setEnvironmentVariable('DOCKER_CERT_PATH', $env:DOCKER_CERT_PATH, 'User')
    [environment]::setEnvironmentVariable('DOCKER_MACHINE_NAME', $env:DOCKER_MACHINE_NAME, 'User')
    [environment]::setEnvironmentVariable('COMPOSE_CONVERT_WINDOWS_PATHS', $env:COMPOSE_CONVERT_WINDOWS_PATHS, 'User')

    if (Get-Process "code" -ErrorAction SilentlyContinue) {
      Write-Warning "you probably need to restart vscode"
      Write-Warning "!!! remember that vscode explorer does NOT work on remote host"
    }
  }
}

function Start-DockerToolbox {
  [CmdletBinding()]
  param (
    [Parameter()]
    [Switch]
    $RegenerateCerts
  )
  docker-machine start default

  if ($RegenerateCerts) {
    Start-Sleep -Seconds 1

    "y" | docker-machine regenerate-certs
  }
}

function Stop-DockerToolbox {
  docker-machine stop default
}


function ForwardDockerMachine {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory)]
    [string]
    $port
  )

  docker-machine ssh default -N -L "$($port):localhost:$($port)"
}
