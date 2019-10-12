#################################################
#			  Sistemas Operativos		        #       
#		Trabajo Práctico 2 - Ejericio 2		    #
#		Nombre del Script: ejercicio2.ps1		#
#							                    #
#				Integrantes:		            #
#       Di Tommaso, Giuliano     38695645		#
#       Handley, Tomas           39210894		#
#       Imperatori, Nicolas      38622912		#
#							                    #
#		 Instancia de Entrega: Entrega		    #
#							                    #
#################################################

<#
.Synopsis
El script listara los procesos que tengan mas de N (siendo N un numero pasado por parametro) cantidad de instancias corriendo a la vez.
.DESCRIPTION
Este script recibe un solo parametro, que indica la cantidad de instancias minimas que un proceso debe tener para ser reportado
.Parameter -Cantidad   
     Indica la cantidad minima de instancias que debe tener un proceso para ser reportado. 
     Este parámetro debe ser obligatorio y mayor a 1.
.EXAMPLE
.\ejercicio6.ps1 -Cantidad 3 
#>

#Validaciones
Param(
    [Parameter(Mandatory = $true, ParameterSetName = "Cantidad")]
    [int]
    $cantidad
)

$procesos = @();

if ($cantidad -le 1) {
    Write-Error "Las instancias especificadas en el parametro -Cantidad debe ser mayor a 1"
} else {
    $count=0;
    $procesos=Get-Process | Select-Object ProcessName -Unique;

    Write-Host "#### Procesos con mas de $cantidad instancias ####"

    foreach($proceso in $procesos) {
        $instances=(Get-Process -Name $proceso.ProcessName).Count
        if($instances -gt $cantidad) {
            $count=1;
            Write-Host $proceso.ProcessName;
        }
    }

    if($count -eq 0) {
        Write-Host "No hay procesos con esa cantidad de instancias."
    }

}