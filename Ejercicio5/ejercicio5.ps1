<#
.Synopsis
   Ejercicio 5
.DESCRIPTION
   Este script mueve los archivos indicados en origen a la ruta destino.
   Recibe como parametro un archivo csv con las columnas descriptas anteriormente.
   Al finalizar los movimientos escribe en el archivo log_salida.csv la ruta final y la hora
   en que se hizo el movimiento.
.EXAMPLE
   ./ejercicio_3.ps1 log_movimiento.csv
#>


Change this to suite your needs

## Create an Timer instance
$timer = New-Object Timers.Timer

## Now setup the Timer instance to fire events
$timer.Interval = 2000     # fire every 2s
$timer.AutoReset = $false  # do not enable the event again after its been fired
$timer.Enabled = $true

## register your event
## $args[0] Timer object
## $args[1] Elapsed event properties
Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier Notepad  -Action {notepad.exe}



switch($args[0]) {
    Procesos {
        echo (get-process).Count 
      break; 
    }Peso {echo "peso"
      break; 
    }

}



