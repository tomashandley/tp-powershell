#################################################
#			Sistemas Operativos		            #
#		Trabajo Práctico 2 - Ejericio 1		    #
#		Nombre del Script: ejercicio1.ps1		#
#							                    #
#				Integrantes:		            #
#         Di Tommaso, Giuliano     38695645		#
#         Handley, Tomas           39210894		#
#         Imperatori, Nicolas      38622912		#
#							                    #
#		Instancia de Entrega: Entrega		    #
#							                    #
#################################################

Param(
    [Parameter(Position = 1, Mandatory = $false)]
    [String] $pathSalida = "./procesos.txt",
    [int] $cantidad = 3
)
$existe = Test-Path $pathSalida
if ($existe -eq $true){
    $listaproceso = Get-Process
    foreach ($proceso in $listaproceso) {
        $proceso | Format-List -Property Id,Name >> $pathSalida
    }
    for ($i = 0; $i -lt $cantidad; $i++) {
        Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
    }
} else {
    Write-Host "El path no existe"
}

<#
1- ¿Cual es el objetivo del script?
    El objetivo de este script es guardar en un archivo en pid y 
    nombre de los procesos que se estan ejecutando y mostrar por
    pantalla pid y nombre de los primeros 3 procesos que se estan
    ejecutando.

2- ¿Agregaria alguna otra validacion a los parametros?
    Agregaria [ValidateScript({Test-Path $_ })] para validar el path
    del archivo de salida para ahorrar el if de validacion dentro del
    script.

3- ¿Que sucede si se ejecuta el script sin ningun parametro?
    Si se ejecuta y no existe el archivo de salida indica por pantalla
    que "El path no existe", en caso de que exista el archivo agrega al
    final del archivo el resultado de la nueva ejecucion.
#>