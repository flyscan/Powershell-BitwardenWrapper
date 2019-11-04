
function Install-Scoop {
  # # Set scoop install location via environment variable
  # $env:SCOOP = 'C:/Tools/scoop'
  # [environment]::setEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

  # # Install scoop
  # Invoke-Expression (New-Object net.webclient).downloadstring('https://get.scoop.sh')

  # # Add buckets & Install my stuff
  # # TODO parse scoopedprograms.json and run commands!

  # If you want to have an advanced installation. You can download the installer and manually execute it with parameters.

  Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1' -OutFile install.ps1

  .\install.ps1 -ScoopDir 'C:/Tools/scoop' -NoProxy -RunAsAdmin

  Remove-Item .\install.ps1
}

function Install-Pipx {
  $env:PIPX_HOME = 'C:/Tools/pipx'
  [environment]::setEnvironmentVariable('PIPX_HOME', $env:PIPX_HOME, 'User')
  $env:PIPX_BIN_DIR = 'C:/Tools/pipx/bin'
  [environment]::setEnvironmentVariable('PIPX_BIN_DIR', $env:PIPX_BIN_DIR, 'User')

  python3 -m pip install pipx
  python3 -m pipx ensurepath
}

function Export-Pipx {
  # TODO which packages were installed globally?
}
