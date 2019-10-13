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