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
    $procesos
)

#infinite loop for calling connect function  
while(1) {
    if($procesos) {
        Write-Host "#### Cantidad de procesos corriendo ####"
        $cantidadDeProcesos=(Get-Process).Count;
        Write-Host "$cantidadDeProcesos"
        Write-Host "########################################"
    } else {
        
    }
    start-sleep -seconds 1
}