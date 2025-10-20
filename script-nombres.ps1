# Solicitar al usuario que ingrese un string
$string = Read-Host "Introduce un texto"

# Convertir el texto a minÃºsculas y reemplazar los espacios por guiones
$resultado = $string.ToLower().Replace(" ", "-")

# Mostrar el resultado
Write-Host "Resultado: $resultado"

read-host