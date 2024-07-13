#!/bin/bash

# Solicita los detalles del certificado al usuario
echo "Este programa crea un certificado autofirmado con detalles adicionales y lo exporta a una ubicación especificada."

read -p "Introduce el nombre común del certificado (ejemplo: 'MiCertificado'): " nombreCertificado
read -p "Introduce la ruta completa donde deseas guardar el certificado (ejemplo: '/home/usuario/certificados'): " ubicacionCertificado
read -p "Introduce la longitud de la clave en bits (ejemplo: 2048, opciones válidas: 2048 o 4096): " longitudClave
read -p "Introduce el número de años de validez del certificado (ejemplo: 10, mínimo 1 año): " duracionAnos
read -p "Introduce el correo electrónico del propietario del certificado (ejemplo: 'correo@ejemplo.com'): " email
read -p "Introduce el nombre de la organización o propietario (ejemplo: 'Mi Empresa'): " organizacion
read -p "Introduce la unidad organizativa (ejemplo: 'Desarrollo'): " organizationalUnit
read -p "Introduce la localidad (ejemplo: 'Madrid'): " locality
read -p "Introduce el estado o provincia (ejemplo: 'Madrid'): " state
read -p "Introduce el código de país (2 letras, ejemplo: 'ES'): " country
read -p "Introduce el dominio asociado al certificado (ejemplo: 'tudominio.com'): " domain

# Verifica que la carpeta de destino existe, si no, la crea
mkdir -p "$ubicacionCertificado"

# Construir el comando de extensión de sujeto
subject="/CN=$nombreCertificado/O=$organizacion/OU=$organizationalUnit/L=$locality/ST=$state/C=$country/emailAddress=$email"

# Si el dominio no está vacío, agregar subjectAltName
if [ -n "$domain" ]; then
    extensions="-addext subjectAltName=DNS:$domain -addext keyUsage=digitalSignature,keyEncipherment"
else
    extensions="-addext keyUsage=digitalSignature,keyEncipherment"
fi

# Genera la clave privada y el certificado
openssl req -x509 -newkey rsa:$longitudClave -sha256 -nodes \
    -keyout "$ubicacionCertificado/$nombreCertificado.key" \
    -out "$ubicacionCertificado/$nombreCertificado.crt" \
    -days $((duracionAnos * 365)) \
    -subj "$subject" \
    $extensions

# Genera el archivo PEM para compatibilidad con iPhone
cat "$ubicacionCertificado/$nombreCertificado.crt" "$ubicacionCertificado/$nombreCertificado.key" > "$ubicacionCertificado/$nombreCertificado.pem"

echo "Certificado y clave privada guardados en $ubicacionCertificado"
echo "Certificado: $ubicacionCertificado/$nombreCertificado.crt"
echo "Clave Privada: $ubicacionCertificado/$nombreCertificado.key"
echo "Archivo PEM: $ubicacionCertificado/$nombreCertificado.pem"

