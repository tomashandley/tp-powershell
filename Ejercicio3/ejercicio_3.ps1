#################################################
#       Sistemas Operativos           #       
#   Trabajo Práctico 2 - Ejericio 3       #
#   Nombre del Script: ejercicio3.ps1   #
#                                 #
#       Integrantes:                #
#       Di Tommaso, Giuliano     38695645   #
#       Handley, Tomas           39210894   #
#       Imperatori, Nicolas      38622912   #
#                                 #
#    Instancia de Entrega: Entrega        #
#                                 #
#################################################

<#
.Synopsis
   Movimiento de archivos
.DESCRIPTION
   Este script mueve los archivos indicados en origen a la ruta destino.
   Recibe como parametro un archivo csv con las columnas descriptas anteriormente.
   Al finalizar los movimientos escribe en el archivo log_salida.csv la ruta final y la hora
   en que se hizo el movimiento.
.EXAMPLE
   ./ejercicio_3.ps1 log_movimiento.csv
#>

param(
  [Parameter(Mandatory=$True,Position=1)]
  [validateNotNullOrEmpty()]
  [validatePattern('.*\.csv$')]
  [string]$entrada,
  [Parameter(Mandatory=$True,Position=2)]
  [validateNotNullOrEmpty()]
  [validatePattern('.*\.csv$')]
  [string]$salida
)



if( -not (Test-Path  "$entrada")){
    echo "El archivo de entrada no existe"
    exit
}



if ( -not  ( Test-Path "$salida" ) ) {
    $headers = "" | select "archivo","fecha"
    $headers | Export-csv -Path "$salida" -NoTypeInformation 
}

$cant_movimientos = 0
foreach($line in Import-csv -Path "${entrada}" -Header 'origen','destino'){
   $origen = $line.Origen
   if ( $line.Origen -ne  "origen"){
        $destino = $line.Destino
        $date = Get-Date
        if( (Test-Path "${origen}")){
            if( -not (Test-Path "${destino}")){
                New-Item -Path "${destino}" -ItemType Directory -Force | Out-Null    
            }
            Move-Item "${origen}" "${destino}" -Force
            $reg = @{
                        archivo = "${destino}"
                        fecha = "$date"
                      }
            $output = New-Object PSObject -Property $reg
            $output | export-csv -Path "$salida" -NoTypeInformation -Append 
            $cant_movimientos++;
        }else{
            echo "No existe el archivo ${origen}"
        }        
   }
}

if($cant_movimientos -gt 1){
   echo "Se añadieron ${cant_movimientos} movimientos al log :"
   echo "$salida"    
}


if($cant_movimientos -eq 1){
   echo "Se añadio ${cant_movimientos} movimiento al log :"
   echo "$salida"    
}

