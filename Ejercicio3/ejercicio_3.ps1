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


if ( $args.Count -lt 1){
    echo "Parametros insuficientes. Utilice Get-help para conocer funcionamiento"
    exit
}
else {
    $extn = [IO.Path]::GetExtension($args[0])
    if ( $extn -ne ".csv" ){
        echo "El archivo de entrada debe ser un .csv"
        exit
    }else{

        if( -not (Test-Path  $args[0])){
            echo "El archivo de entrada no existe"
            exit
        }
    }
}


if ( -not  ( Test-Path log_salida.csv ) ) {
    Add-Content -Path log_salida.csv  -Value '"archivo","fecha"'    
}

$cant_movimientos = 0;
$archivo_entrada = $args[0]
$headers_csv="origen,destino"
foreach($line in Get-Content "${archivo_entrada}"){
   if ( $line -ne  $headers_csv){
        $fields = $line -split ","
        $origen = $fields[0]
        $destino = $fields[1]
        $date = Get-Date
        if( (Test-Path "${origen}")){
            if( -not (Test-Path "${destino}")){
                New-Item -Path "${destino}" -ItemType Directory -Force | Out-Null    
            }
            Move-Item "${origen}" "${destino}" -Force
            $output = "${destino},$date"
            add-Content log_salida.csv $output 
            $cant_movimientos++;
        }else{
            echo "No existe el archivo ${origen}"
        }        
   }
}

if($cant_movimientos -gt 1){
   echo "Se añadieron ${cant_movimientos} movimientos al log :"
   echo "log_salida.csv"    
}


if($cant_movimientos -eq 1){
   echo "Se añadio ${cant_movimientos} movimiento al log :"
   echo "log_salida.csv"    
}

