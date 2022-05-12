# Enviando arquivos para um Amazon S3 com PowerShell

Para maquinas (VMs ou EC2) que rodam Windows e não tem ou não podem ter o AWS CLI instalado, é possível utilizar o PowerShell para criar scripts de envio de arquivos para um Amazon S3.
Isso é útil quando você precisa garantir que aquele arquivo de backup gerado diariamente no disco local da maquina, seja armazenado em um bucket.

Para VMs que estão rodando em ambiente on premisses pode ser necessário criar regras de liberação de acesso da VM para a AWS. 
Para o envio de arquivos muito grandes, também é necessário que este seja feito via Direct Connect, isso para não onerar os links de internet dos data centers.
Temos um exemplo de como fazer isso em: 
https://aws.amazon.com/pt/blogs/aws-brasil/como-usar-amazon-s3-com-aws-site-to-site-vpn-ou-aws-direct-connect/

Para EC2 que já estão na AWS, não é necessário a liberação de regras ou rotas de acesso, é necessário apenas a criação de uma conta no IAM da AWS para que esta seja utilizada no script para gravar no S3.
Aqui está um exemplo de como fazer isso: 
https://bobbyhadz.com/blog/aws-cli-access-key-id-not-exist-in-our-records
https://aws.amazon.com/pt/premiumsupport/knowledge-center/s3-access-key-error/


## Este é um exemplo de script em PowerShell que pode ser utilizado para o envio de um arquivo de backup de um banco SQL (arquivo .bak) para um Amazon S3.

###### **NOTA:** Basta acertar o valor de algumas variáveis nele e executar. 
Salve o arquivo com a extensão “.ps1” - exemplo: *Send-Files-S3-Powershell.ps1*

##  Variáveis que precisam ser preenchidas

###### **NOTA:** Linhas que começam com *“#”* são comentários no arquivo


**- Chave de acesso na AWS (Evitar o compartilhamento destas chaves)**
```
# Chave de acesso na AWS (Evitar o compartilhamento destas chaves)
$accessKeyID="xptoxpto"
$accessKeyID="xptoxpto"
```
Trocar o “xptoxpto" pelas respectivas chaves geradas na AWS no momento da criação do usuário.

**- Dados do Bucket S3**
```
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
```

**- Diretório onde está sendo gerado o arquivo que deseja enviar para a AWS**
```
# Diretorio onde estao os arquivos no servidor de origem
$source = "C:\BACKUP\"  #Caminho de origem do arquivo na EC2
```

**- Diretório onde está sendo gerado o arquivo que deseja enviar para a AWS**
```
# Diretorio onde estao os arquivos no servidor de origem
$source = "C:\BACKUP\"  #Caminho de origem do arquivo na EC2
```

**- Extensão do arquivo de backup gerado**
```
# Extensao do arquivo que quer enviar - faz um filtro pela Extensao
# Exemplo: *.txt ou *.csv ou *.bak
# clocar a extensao entre aspas simples
$FileExtension = '*.bak'
```

**- Arquivo de Log**
O Scritpt gera um Log minimo com os arquivos identificados e data e hora da execução
Se não existir o arquivo ele cria, se existir, ele vai adicionando informações no arquivo já existente.

```
# Nome do arquivo de log
# Vai ficar salvo no mesmo diretorio dos arquivos que quer enviar para o S3. "$source"
# clocar o nome do arquivo entre aspas simples
$LogFile = 'Arquivos_S3.log'
```

## Arquivos de Exemplo

**- Send-Files-S3-Powershell.ps1**

Script em PowerShell para a copia dos arquivos


**- BKP-TESTE_20220509.bak**

**- BKP-TESTE_20220512.bak**

Arquivos de testes utilizados para os testes durante a construção do script


**- Arquivos_S3.log**

Arquivo de Log gerado pelo Script.

