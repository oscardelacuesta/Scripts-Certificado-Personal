<#
.SYNOPSIS
    Este programa crea un certificado autofirmado y lo exporta a una ubicación especificada.
.DESCRIPTION
    Solicita al usuario la información necesaria para crear un certificado autofirmado con detalles adicionales como propietario, correo electrónico y dominio, y lo exporta a una ubicación especificada.
.NOTES
    Creado por palentino.es > Oscar de la Cuesta.
#>

# Limpia la pantalla antes de ejecutar el resto del script
Clear-Host

# Muestra la descripción de lo que hace el programa
Write-Host "Este programa crea un certificado autofirmado con detalles adicionales y lo exporta a una ubicación especificada."

# Solicita los detalles del certificado al usuario
$nombreCertificado = Read-Host "Introduce el nombre común del certificado (ejemplo: 'MiCertificado')"
$ubicacionCertificado = Read-Host "Introduce la ruta completa donde deseas guardar el certificado (ejemplo: 'C:\Certificados')"
$longitudClave = Read-Host "Introduce la longitud de la clave en bits (ejemplo: 2048, opciones válidas: 2048 o 4096)"
$duracionAnos = Read-Host "Introduce el número de años de validez del certificado (ejemplo: 10, mínimo 1 año)"
$email = Read-Host "Introduce el correo electrónico del propietario del certificado (ejemplo: 'correo@ejemplo.com')"
$organizacion = Read-Host "Introduce el nombre de la organización o propietario (ejemplo: 'Mi Empresa')"
$organizationalUnit = Read-Host "Introduce la unidad organizativa (ejemplo: 'Desarrollo')"
$locality = Read-Host "Introduce la localidad (ejemplo: 'Madrid')"
$state = Read-Host "Introduce el estado o provincia (ejemplo: 'Madrid')"
$country = Read-Host "Introduce el código de país (2 letras, ejemplo: 'ES')"
$domain = Read-Host "Introduce el dominio asociado al certificado (ejemplo: 'tudominio.com')"

# Verifica que la carpeta de destino existe, si no, la crea
if (-Not (Test-Path -Path $ubicacionCertificado)) {
    New-Item -ItemType Directory -Path $ubicacionCertificado | Out-Null
    Write-Host "Creada carpeta de destino: $ubicacionCertificado"
}

# Construye la cadena de sujeto del certificado con los detalles adicionales
$subject = "CN=$nombreCertificado, O=$organizacion, OU=$organizationalUnit, L=$locality, S=$state, C=$country, E=$email, D=$domain"

# Crea un nuevo certificado autofirmado
$certificate = New-SelfSignedCertificate `
    -Subject $subject `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyExportPolicy Exportable `
    -KeySpec Signature `
    -KeyLength $longitudClave `
    -KeyAlgorithm RSA `
    -HashAlgorithm SHA256 `
    -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
    -NotAfter (Get-Date).AddYears($duracionAnos) `
    -Verbose

# Muestra los detalles del certificado
Write-Host "Certificado creado: " $certificate

# Ruta completa donde se guardará el certificado
$rutaCertificado = Join-Path -Path $ubicacionCertificado -ChildPath "$nombreCertificado.cer"

# Exporta el certificado
Export-Certificate -Cert $certificate -FilePath $rutaCertificado -Verbose

# Mensaje final
Write-Host "Certificado exportado exitosamente a: $rutaCertificado"
