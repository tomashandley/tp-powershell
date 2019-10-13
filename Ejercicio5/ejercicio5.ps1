#################################################
#			  Sistemas Operativos		            #
#		Trabajo Práctico 5 - Ejericio 5		      #
#		Nombre del Script: ejercicio5.ps1		   #
#							                           #
#				Integrantes:		                  #
#       Di Tommaso, Giuliano     38695645		   #
#       Handley, Tomas           39210894		   #
#       Imperatori, Nicolas      38622912		   #
#							                           #
#		   Instancia de Entrega: Entrega		      #
#							                           #
#################################################

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

#Validaciones
Param(
   [Parameter(Mandatory = $true, ParameterSetName = "Procesos")]
   [switch]
   $procesos,

   [Parameter(Mandatory = $true, ParameterSetName = "Peso")]
   [Parameter(Mandatory = $false, ParameterSetName = "Directorio")]
   [switch]
   $peso,

   [Parameter(Mandatory = $false, ParameterSetName = "Directorio")]
   [string]
   $directorio
)

#Loop infito que al realizar una operacion, queda esperando 3 segundos  
while(1) {
    if($procesos) {
        Write-Host "#### Cantidad de procesos corriendo ####"
        $cantidadDeProcesos=(Get-Process).Count;
        Write-Host "$cantidadDeProcesos"
        Write-Host "########################################"
    } else {
         if($peso) {

            #Obtengo el tamanio de un directorio en Bytes   
            $pesoDirectorio = "{0}" -f ((Get-ChildItem $directorio -Recurse -Force | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum)

            Write-Host "Peso Directorio en Bytes: $pesoDirectorio"

            if([System.Numerics.BigInteger]$pesoDirectorio -ge 1000000000) {
               #Muestro el tamanio en GB
               $pesoDirectorioMb=$pesoDirectorio / 1Gb;
               #Redondeo a 2 digitos
               $pesoDirectorioRedondeado=[math]::Round($pesoDirectorioMb,2); 
               Write-Host "$pesoDirectorioRedondeado GB"
            } else {
               if([System.Numerics.BigInteger]$pesoDirectorio -ge 1000000) {
                  #Muestro el tamanio en MB
                  $pesoDirectorioMb=$pesoDirectorio / 1Mb;
                  #Redondeo a 2 digitos
                  $pesoDirectorioRedondeado=[math]::Round($pesoDirectorioMb,2); 
                  Write-Host "$pesoDirectorioRedondeado MB"
               }else {
                  #Muestro el tamanio en KB
                  $pesoDirectorioMb=$pesoDirectorio / 1Kb;
                  #Redondeo a 2 digitos
                  $pesoDirectorioRedondeado=[math]::Round($pesoDirectorioMb,2); 
                  Write-Host "$pesoDirectorioRedondeado KB"   
               }
            }

            # $pesoDirectorioMb=$pesoDirectorio / 1Kb;
            # $pesoDirectorioRedondeado=[math]::Round($pesoDirectorioMb,2); 
            # Write-Host "#### Tamanio directorio: $directorio ####"
            # Write-Host "$pesoDirectorioRedondeado KB"
            Write-Host "#########################################"
        }
    }
    start-sleep -seconds 3
}