#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 2 - Ejericio 6		    #
#		Nombre del Script: ejercicio6.ps1		#
#							                    #
#				Integrantes:		            #
#         Di Tommaso, Giuliano     38695645		#
#         Handley, Tomas           39210894		#
#         Imperatori, Nicolas      38622912		#
#							                    #
#		Instancia de Entrega: Entrega		    #
#							                    #
#################################################

<#
.Synopsis
El script retorna el producto escalar o la suma de dos matrices
.DESCRIPTION
Este script recibe dos parametros a la vez:
    - El primero indica el path al archivo de texto sobre el cual se va a realizar la operacion.
    - El segundo determina la accion a realizar (producto escalar o suma de matrices)
.Parameter -Entrada   
    Path del archivo de texto de entrada. No se realizan validaciones por extension de archivo. 
    Se asume que todos los archivos de entrada tienen matrices válidas. 
.Parameter -Producto 
    De tipo entero, recibe el escalar a ser utilizado en el producto escalar. No se puede usar junto con “-Suma”. 
.Parameter -Suma 
     Path del archivo de la matriz a sumar a la indicada en “-Entrada”. No se puede usar junto con “-Producto” 
.EXAMPLE
.\ejercicio6.ps1 -Entrada '.\Entrada\matriz1.txt' -Suma '.\Entrada\matriz2.txt' 
.EXAMPLE
.\ejercicio6.ps1 -Entrada '.\Entrada\matriz.txt' -Producto 5
#>

#Validaciones
Param(

    [Parameter(Mandatory = $true, ParameterSetName = "Suma")]
    [Parameter(Mandatory = $true, ParameterSetName = "Producto")]
    [Parameter(Mandatory = $true, ParameterSetName = "Entrada")]
    [string]
    $entrada,

    [Parameter(Mandatory = $true,
    ParameterSetName = "Producto")]
    [int]
    $producto,

    [Parameter(Mandatory = $true,
    ParameterSetName = "Suma")]
    [string]
    $suma

)

#Variables
$control=$true;
$arrayNros = @();
$filas = 0
$columnas = 0

#Logica
if ($null -eq (Get-Content $entrada)) {
    return "El archivo esta vacio"
}

#Hago el parseo de los datos del archivo de entrada
foreach($line in Get-Content $entrada) {
    $spliteado = $line.split("|");
    if($control) {
        $columnas = $spliteado.Length; #Cuento las columnas
        $control = $false;
    }
    foreach($s in $spliteado) {
        $arrayNros += ,$s; #Ingreso los datos de la matriz a un array
    }
    $filas++; #Cuento las filas
}

#Armo esta matriz con filas*columnas espacios
$matrizAImprimir = @(0) * ($filas*$columnas);

if (!([string]::IsNullOrEmpty($suma))) {
    #Suma de matrices
    
    #Logica
    if ($null -eq (Get-Content $suma)) {
        return "El archivo proveniente del parámetro -Suma está vacio"
    }
    
    $control2 = $true;
    $arrayNros2 = @();
    $filas2 = 0
    $columnas2 = 0

    #Hago el parseo de los datos del archivo de la segunda matriz
    foreach($line in Get-Content $suma) {
        $spliteado = $line.split("|");
        if($control2) {
            $columnas2 = $spliteado.Length; #Cuento las columnas
            $control2 = $false;
        }
        foreach($s in $spliteado) {
            $arrayNros2 += ,$s; #Ingreso los datos de la matriz a un array
        }
        $filas2++; #Cuento las filas
    }
    
    #Si las matrices no tienen el mismo ancho y el mismo largo, entonces no pueden sumarse
    if (($filas -eq $filas2) -and ($columnas -eq $columnas2)) {
        for($i=0; $i -lt $filas; $i++) {
            for($j=0; $j -lt $columnas; $j++) {
                $indice = ($j+$columnas*$i);
                $matrizAImprimir[$indice] = (([float]$arrayNros[$indice]) + ([float]$arrayNros2[$indice]));
            }
        } 
        Write-Host "Suma de matrices realizada con exito!"   
    } else {
        Write-Error "ERROR AL SUMAR!!! Las matrices no son compatibles"
    }
} else {
    #Producto Escalar
    for($i=0; $i -lt $filas; $i++) {
        for($j=0; $j -lt $columnas; $j++) {
            $indice = ($j+$columnas*$i);
            $matrizAImprimir[$indice] = (([float]$arrayNros[$indice]) * $producto);
        }
    }
    Write-Host "Producto escalar realizado con exito!"
}

#Obtengo nombre del archivo de entrada
$splitFileName = Split-Path $Entrada -leaf;
#Genero nombre del archivo de salida
$outputFileName = "./Salida/salida." + $splitFileName;

#Guardo la matriz (suma o de producto escalar) al archivo de salida 
for($i=0; $i -lt $filas; $i++) {
    for($j=0; $j -lt $columnas; $j++) {
        if($j -eq ($columnas-1)) {
            $char = "`n";
        } else {
            $char = "|";
        }
        $writeToFile += ([string]$matrizAImprimir[($j+$columnas*$i)]) + $char; 
    }
    $writeToFile | Set-Content $outputFileName;
}
