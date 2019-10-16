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
El script realiza una de dos acciones cada cierto tiempo:
   - Indicar el numero de procesos corriendo en el momento.
   - Indicar el tamanio de un directorio.
.DESCRIPTION
El script puede recibir los siguientes parametros:
.Parameter -Procesos   
   Parametro de tipo switch que indica que se mostrará la cantidad de procesos
   corriendo al momento de ejecutar el script.
.Parameter -Peso 
   Parametro de tipo switch que indica que se mostrara el peso de un directorio.
.Parameter -Directorio 
   Solo se puede usar si se pasó “-Peso”. Indica el directorio a evaluar.
.EXAMPLE
./ejercicio5.ps1 -Procesos 8
.EXAMPLE
./ejercicio5.ps1 -Peso -Directorio "C:\Users\Tomas"
#>

#Validaciones
Param(
   [Parameter(Mandatory = $true, ParameterSetName = "Procesos")]
   [switch]
   $Procesos,

   [Parameter(Mandatory=$true, ParameterSetName='Peso')]
   [switch]$Peso,
   [Parameter(Mandatory=$true, ParameterSetName='Peso')]
   [string]$Directorio

)

#Loop infito que al realizar una operacion, queda esperando 3 segundos  
while(1) {
    if($Procesos) {
        Write-Host "#### Cantidad de procesos corriendo ####"
        $cantidadDeProcesos=(Get-Process).Count;
        Write-Host "$cantidadDeProcesos"
        Write-Host "########################################"
    } else {
         if($Peso) {
            if(($Directorio) -and (Test-Path "$Directorio")) {
               #Obtengo el tamanio de un directorio en Bytes   
            $pesoDirectorio = "{0}" -f ((Get-ChildItem "$Directorio" -Recurse -Force | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum)

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

            Write-Host "#########################################"
            }else {
               Write-Error "El valor de -Directorio no es un directorio valido."
               exit;
            }
        }
    }
    start-sleep -seconds 3
}