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
descomprimir el archivo .zip
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

   [Parameter(Mandatory = $true, ParameterSetName = "ComprimirDescomprimir")]
   [string]
   $directorio,

   [Parameter(Mandatory = $false, ParameterSetName = "ComprimirDescomprimir")]
   [ValidateScript({-not ($comprimir -or $informar)})]
   [switch]
   $descomprimir,

   [Parameter(Mandatory = $false, ParameterSetName = "ComprimirDescomprimir")]
   [ValidateScript({-not ($descomprimir -or $informar)})]
   [switch]
   $comprimir,

   [Parameter(Mandatory = $false, ParameterSetName = "Informar")]
   [ValidateScript({-not ($comprimir -or $descomprimir)})]
   [switch]
   $informar
)

function ValidarPathZip {
    param (
        [string]$pathZip,
        [string]$nombreZip
    )
    if((Test-Path "$pathZip/$nombreZip") -eq $false){
        Write-Host "El archivo $pathZip/$nombreZip no existe"
        exit
    }
}

$nombreZip = [System.IO.Path]::GetFileName("$pathZip")

$pathZip = [System.IO.Path]::GetDirectoryName("$pathZip")

if($descomprimir){
    $pathZip = Resolve-Path $pathZip
    ValidarPathZip "$pathZip" "$nombreZip"

    #si no existe creo el directorio donde se va a descomprimir
    $directorioValido = Test-Path $directorio
    if($directorioValido -eq $false){
        New-Item -Path "$PSScriptRoot/" -Name "$directorio" -ItemType "directory"
    }
    $directorio = Resolve-Path $directorio

    [System.IO.Compression.ZipFile]::ExtractToDirectory("$pathZip/$nombreZip","$directorio")
    Write-Host "La descompresion del archivo $pathZip/$nombreZip en $directorio se realizo correctamente"
}
elseif($comprimir){
    $directorioValido = Test-Path "$directorio"
    #verifico que exista el directorio a comprimir
    if($directorioValido -eq $false){
        Write-Host "Error en parametro -Directorio, $directorio no existe el directorio a comprimir."
        exit
    }
    $directorio = Resolve-Path $directorio
    
    $pathZipValido = Test-Path "$pathZip"
    #si no existe creo el directorio donde se va a guardar el zip
    if($pathZipValido -eq $false){
        New-Item -Path "$PSScriptRoot/" -Name "$pathZip" -ItemType "directory"
    }
    $pathZip = Resolve-Path $pathZip
    
    #si ya existe un zip con ese nombre en el directorio de destino, le agrego un numero random al final del nombre
    $testPath = test-path "$pathZip/$nombreZip"
    while($testPath -eq $true){
        $rnd = Get-Random -Minimum 1000 -Maximum 9999
        $nombreSinExtension = [System.IO.Path]::GetFileNameWithoutExtension("$nombreZip")
        $extension = [System.IO.Path]::GetExtension("$nombreZip")
        $nombreZip = $nombreSinExtension + $rnd + $extension
        $testPath = test-path "$pathZip/$nombreZip"
    }

    [System.IO.Compression.ZipFile]::CreateFromDirectory("$directorio", "$pathZip/$nombreZip")
    Write-Host "El archivo $pathZip/$nombreZip se ha creado correctamente"
}
elseif($informar){
    $pathZip = Resolve-Path $pathZip
    ValidarPathZip "$pathZip" "$nombreZip"
    [System.IO.Compression.ZipFile]::OpenRead("$pathZip/$nombreZip").Entries | Format-Table @{L='Nombre del archivo';E={$_.FullName}},
                                                                                                @{L='Peso';E={$_.Length}},
                                                                                                @{L='Relacion de compresion';E={$_.CompressedLength}}
}