#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  SCRIPT PARA ENVIO DE ARQUIVOS PARA UM BUCKET S3 NA AWS                      #
#  Versao 1 - 12/05/2022                                                       # 
#  Ricardo Santana                                                             #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Chave de acesso na AWS - NAO COMPARTILHAR
$accessKeyID="xptoxpto"
$secretAccessKey="xptoxpto"

# Dados do Bucket S3
# Exemplo: 
#  URI do S3
#  s3://bucket-name-sp-aplication-x/BKP/
#
# Região da AWS
# América do Sul (São Paulo) sa-east-1

$RegionEndpoint = 'sa-east-1'
$BucketRead = "bucket-name-sp-aplication-x"
$BucketDir = "BKP"  #Sub-diretorio do bucket sem o "/" no final

# Diretorio onde estao os arquivos no servidor de origem
$source = "C:\BACKUP\"  #Caminho de origem do arquivo na EC2

# Extensao do arquivo que quer enviar - faz um filtro pela Extensao
# Exemplo: *.txt ou *.csv ou *.bak
# clocar a extensao entre aspas simples
$FileExtension = '*.bak'

# Nome do arquivo de log
# Vai ficar salvo no mesmo diretorio dos arquivos que quer enviar para o S3. "$source"
# clocar o nome do arquivo entre aspas simples
$LogFile = 'Arquivos_S3.log'

#============================================================================
# NAO MEXER DAQUI PRA BAIXO
#============================================================================


$BucketWrite = $bucket+ "/" +$BucketDir # Caminho completo do bucket - Endereco e pastas 
$DateStr = Get-Date -Format "dd/MM/yyyy HH:mm:ss"  #Valida a data atual para colocar no log


#============================================================================
# Verifica os arquivos no S3 Antes de Enviar os novos Arquivos
#============================================================================
$DateStr + " ### ARQUIVOS DISPONIVEIS ANTES DO UPLOAD ### " | Out-File -Append $source$LogFile  -Encoding UTF8

$S3Files =  Get-S3Object -BucketName $BucketRead -KeyPrefix $BucketDir -AccessKey $accessKey -SecretKey $secretKey -Region $region

foreach($object in $S3Files) {
	$localFileName = $object.Key -replace $keyPrefix, ''
    Write-Host "Arquivos Disponiveis no S3 : " $localFileName
    $DateStr + " - " + $localFileName | Out-File -Append $source$LogFile  -Encoding UTF8
    } 

#============================================================================
# Faz uma busca local dos arquivos que devem ser enviados ao S3 e Ja faz o envio
#============================================================================
$DateStr + " ### ARQUIVOS DISPONIVEIS PARA O UPLOAD ### " | Out-File -Append $source$LogFile  -Encoding UTF8

$LocalFiles = Get-ChildItem $source -include $FileExtension -recurse -force | Select-Object -Property Name

foreach($file in $LocalFiles) {
    if(Get-S3Object -BucketName $BucketRead -keyPrefix $BucketDir | Select-Object -Property key) { ## verify if exist
        Write-Host "Arquivos Para envio ao S3 : " $file.Name
        $DateStr + " - " + $file.Name | Out-File -Append $source$LogFile -Encoding UTF8
        # Faz o upload dos arquivos
        Write-S3Object -BucketName $BucketWrite -File $file.Name -AccessKey $accessKeyID -SecretKey $secretAccessKey -Region $RegionEndpoint  -CannedACLName private
        }
}

#============================================================================
# Verifica os arquivos ATUAIS no S3
#============================================================================
$DateStr + " ### ARQUIVOS DISPONIVEIS DEPOIS DO UPLOAD ### " | Out-File -Append  $source$LogFile  -Encoding UTF8

$S3Files =  Get-S3Object -BucketName $BucketRead -KeyPrefix $BucketDir -AccessKey $accessKey -SecretKey $secretKey -Region $region

foreach($object in $S3Files) {
	$localFileName = $object.Key -replace $keyPrefix, ''
    Write-Host "Arquivos Disponiveis no S3 : " $localFileName
    $DateStr + " - " + $localFileName | Out-File -Append  $source$LogFile  -Encoding UTF8
    } 


#============================================================================
# FIM
#============================================================================

