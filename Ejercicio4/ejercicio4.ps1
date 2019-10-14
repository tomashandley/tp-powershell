#################################################
#			Sistemas Operativos		            #
#		Trabajo Práctico 2 - Ejericio 4		    #
#		Nombre del Script: ejercicio4.ps1		#
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
.SYNOPSIS
El script permite comprimir un directorio, descomprimir un archivo .zip u obtener informacion sobre un archivo zip
.DESCRIPTION
Este script recibe el path del archivo .zip y el tipo de operacion a realizar sobre este, y dependiendo del 
tipo de operacion es comprimir o descomprimir, tambien recibe otro parametro con el directorio a comprimir o donde
descomprimir el archivo .zip:
.PARAMETER PathZip
    Path del archivo ZIP. Este parámetro se usará para cualquiera de los tres modos
de operación del script.
.PARAMETER Directorio
    Solo válido para los modos de compresión y descompresión. Indica el directorio a
comprimir o el destino de la descompresión del archivo ZIP.
.PARAMETER Descomprimir
    De tipo switch, indica que el modo de operación es "Descompresión".
.PARAMETER Comprimir
    De tipo switch, indica que el modo de operación es "Compresión".
.PARAMETER Informar
    De tipo switch, indica que el modo de operación es "Información".
.EXAMPLE
./ejercicio4.ps1 -Directorio "./mis archivos/" -PathZip ./salida.zip -Comprimir
.EXAMPLE
./ejercicio4.ps1 -Directorio "./salida/" -PathZip ./salida.zip -Descomprimir
.EXAMPLE
./ejercicio4.ps1 -PathZip ./salida.zip -Informar
#>

Param(
   [Parameter(Mandatory = $true)]
   [string]
   $pathZip,

   [Parameter(Mandatory = $false, ParameterSetName = "Directorio")]
   [string]
   $directorio,

   [Parameter(Mandatory = $false, ParameterSetName = "Tipo")]
   [Parameter(Mandatory = $false, ParameterSetName = "Directorio")]
   [switch]
   $descomprimir,

   [Parameter(Mandatory = $false, ParameterSetName = "Tipo")]
   [Parameter(Mandatory = $false, ParameterSetName = "Directorio")]
   [switch]
   $comprimir,

   [Parameter(Mandatory = $false, ParameterSetName = "Tipo")]
   [switch]
   $informar
)

$pathSalida = [System.IO.Path]::GetDirectoryName("$pathZip")
$pathSalida = Resolve-Path $pathSalida
Write-Host $pathSalida

$nombreZip = [System.IO.Path]::GetFileName("$pathZip")
Write-Host $nombreZip

if($descomprimir){
    Write-Host "descomprimir"
    $directorioValido = Test-Path $directorio
    if($directorioValido -eq $false){
        New-Item -Path "$PSScriptRoot/" -Name "$directorio" -ItemType "directory"
    }
    $directorio = Resolve-Path $directorio
    Write-Host $directorio

    [System.IO.Compression.ZipFile]::ExtractToDirectory("$pathSalida/$nombreZip","$directorio")
}
elseif($comprimir){
    Write-Host "comprimir"
    $directorioValido = Test-Path $directorio
    if($directorioValido -eq $false){
        Write-Host "Error en parametro -Directorio, $directorio no existe el directorio a comprimir."
        exit
    }
    $directorio = Resolve-Path $directorio
    Write-Host $directorio
    
    [System.IO.Compression.ZipFile]::CreateFromDirectory("$directorio", "$pathSalida/$nombreZip")
}
elseif($informar){
    Write-Host "informar"
    [System.IO.Compression.ZipFile]::OpenRead("$pathSalida/$nombreZip").Entries | Format-Table @{L='Nombre del archivo';E={$_.FullName}},
                                                                                                @{L='Peso';E={$_.Length}},
                                                                                                @{L='Relacion de compresion';E={$_.CompressedLength}}
}