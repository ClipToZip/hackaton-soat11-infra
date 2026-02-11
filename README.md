# Hackaton SOAT11 - Infraestrutura ClipToZip

> Infraestrutura AWS provisionada com Terraform para aplicação de processamento de vídeos.  
> Projeto acadêmico - Faculdade FIAP - Pós Tech SOAT 11

## 📋 Recursos Provisionados

### 🌐 Networking
- **VPC** com CIDR 10.0.0.0/16
- **3 Subnets Públicas** (multi-AZ para alta disponibilidade)
- **3 Subnets Privadas** (multi-AZ para recursos internos)
- **Internet Gateway** (conectividade à internet)
- **NAT Gateway** (permite recursos privados acessarem a internet)
- **Route Tables** configuradas automaticamente

### 💾 Armazenamento e Dados
- **S3 Bucket** para armazenamento de vídeos
  - Versionamento habilitado
  - Block public access configurado
  - Tags organizacionais
  
- **RDS PostgreSQL 15.4**
  - Instância: db.t3.micro
  - Storage: 20GB gp3
  - Publicly accessible (para testes locais)
  - Backup retention: 7 dias
  - Multi-AZ: Desabilitado (ambiente de testes)
  
- **ElastiCache Redis 7.0**
  - Tipo de nó: cache.t3.micro
  - Número de nós: 1
  - Engine version: 7.0

### 📨 Mensageria (SQS)
- **Fila: cliptozip-events**
  - Recebe notificações de upload de vídeos
  - Visibility timeout: 5 minutos
  - Message retention: 4 dias
  - Long polling: 10 segundos
  - DLQ: cliptozip-events-dlq (3 tentativas)
  
- **Fila: cliptozip-notifications**
  - Recebe notificações de processamento concluído
  - Visibility timeout: 10 minutos
  - Message retention: 4 dias
  - Long polling: 10 segundos
  - DLQ: cliptozip-notifications-dlq (3 tentativas)

### 🔒 Security Groups
- **RDS Security Group**: Porta 5432 (PostgreSQL)
- **Redis Security Group**: Porta 6379

---

## 🚀 Guia de Uso

### Pré-requisitos

1. **Terraform instalado**
   ```powershell
   # Windows (com Chocolatey)
   choco install terraform
   
   # Verificar instalação
   terraform version
   ```

2. **AWS CLI configurado**
   ```powershell
   # Instalar AWS CLI
   # Download: https://aws.amazon.com/cli/
   
   # Configurar credenciais
   aws configure
   ```

3. **Conta AWS** com permissões para criar recursos

---

### 📝 Passo a Passo

#### 1️⃣ Preparar Variáveis

```powershell
# Copiar arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars
notepad terraform.tfvars
```

**Variáveis importantes:**
- `db_password`: Trocar senha padrão
- `my_ip`: Seu IP público (descubra em https://ifconfig.me)

#### 2️⃣ Inicializar Terraform

```powershell
cd terraform
terraform init
```

#### 3️⃣ Validar Configuração

```powershell
terraform validate
terraform fmt -recursive
```

#### 4️⃣ Planejar Infraestrutura

```powershell
terraform plan
```

Revise o que será criado antes de aplicar.

#### 5️⃣ Provisionar Recursos

```powershell
terraform apply
```

Digite `yes` quando solicitado.

⏱️ **Tempo estimado:** 10-15 minutos  
💰 **Custo durante provisionamento:** ~$0.05-0.10

#### 6️⃣ Obter Informações de Conexão

```powershell
# Ver todos os outputs
terraform output

# Salvar em arquivo JSON
terraform output -json > outputs.json

# Usar script auxiliar
cd ..
.\show-connection-info.ps1
```

---

## 🔌 Informações de Conexão

### PostgreSQL (RDS)

```powershell
# Obter endpoint
terraform output rds_address

# Conectar com psql
$RDS_HOST = terraform output -raw rds_address
psql -h $RDS_HOST -U admin -d videodb -W
```

**Connection String:**
```
postgresql://admin:<senha>@<endpoint>:5432/videodb
```

### Redis (ElastiCache)

```powershell
# Obter endpoint
terraform output redis_endpoint

# Conectar com redis-cli
$REDIS_HOST = terraform output -raw redis_endpoint
redis-cli -h $REDIS_HOST
```

**Connection String:**
```
redis://<endpoint>:6379
```

### SQS (Filas)

```powershell
# Obter URLs das filas
terraform output video_event_queue_url
terraform output video_processed_queue_url

# Enviar mensagem de teste
$QUEUE_URL = terraform output -raw video_event_queue_url
aws sqs send-message --queue-url $QUEUE_URL --message-body "test message"

# Receber mensagens
aws sqs receive-message --queue-url $QUEUE_URL --max-number-of-messages 10
```

### S3 (Bucket)

```powershell
# Obter nome do bucket
terraform output s3_bucket_name

# Listar conteúdo
$BUCKET_NAME = terraform output -raw s3_bucket_name
aws s3 ls s3://$BUCKET_NAME/

# Upload de arquivo
aws s3 cp video.mp4 s3://$BUCKET_NAME/uploads/
```

---

## 🧪 Testes

### Script Automatizado de Testes SQS

Execute o script para testar as filas:

```powershell
.\test-sqs-queues.ps1
```

Este script irá:
- ✅ Verificar conectividade
- ✅ Enviar mensagens de teste
- ✅ Receber e processar mensagens
- ✅ Deletar mensagens
- ✅ Verificar estatísticas das filas

### Testes Manuais

**PostgreSQL:**
```powershell
$RDS_HOST = terraform output -raw rds_address

# Testar conexão
psql -h $RDS_HOST -U admin -d videodb -c "SELECT version();"

# Criar tabela de teste
psql -h $RDS_HOST -U admin -d videodb -c "CREATE TABLE test (id SERIAL PRIMARY KEY, name VARCHAR(50));"
```

**Redis:**
```powershell
$REDIS_HOST = terraform output -raw redis_endpoint

# Testar conexão
redis-cli -h $REDIS_HOST PING

# Set e Get
redis-cli -h $REDIS_HOST SET test "Hello World"
redis-cli -h $REDIS_HOST GET test
```

**S3:**
```powershell
$BUCKET_NAME = terraform output -raw s3_bucket_name

# Upload
echo "test content" > test.txt
aws s3 cp test.txt s3://$BUCKET_NAME/test/

# Download
aws s3 cp s3://$BUCKET_NAME/test/test.txt downloaded.txt

# Listar
aws s3 ls s3://$BUCKET_NAME/test/ --recursive
```

---

## 💰 Análise de Custos

### Custo Mensal Estimado

| Recurso | Configuração | Custo/Mês | Free Tier |
|---------|-------------|-----------|-----------|
| **RDS PostgreSQL** | db.t3.micro, 20GB | $17.74 | -$14.98 (1º ano) |
| **ElastiCache Redis** | cache.t3.micro | $12.41 | -$12.41 (1º ano) |
| **SQS** | 2 filas + DLQs | $0.40-5.00 | Até 1M requests |
| **S3** | Storage + requests | $5-15 | 5GB + 20k requests |
| **NAT Gateway** | 1 instância | $32.85 | - |
| **Data Transfer** | Estimado | $5-10 | 100GB OUT |
| **CloudWatch Logs** | Logs SQS | $1-3 | 5GB ingest |
| **TOTAL** | | **~$76/mês** | **~$45/mês (1º ano)** |

### 💡 Dicas para Reduzir Custos

**Para desenvolvimento:**
1. ✅ Destruir infraestrutura quando não estiver usando
2. ✅ Aproveitar o Free Tier (750h/mês RDS e Redis)
3. ✅ Limitar região a us-east-1 (mais barata)
4. ❌ Evitar deixar recursos rodando 24/7

**Comandos úteis:**
```powershell
# Destruir infraestrutura
terraform destroy

# Recriar rapidamente (10-15 min)
terraform apply -auto-approve
```

---

## 🗑️ Destruir Infraestrutura

### Opção 1: Planejamento

```powershell
# Ver o que será destruído
terraform plan -destroy

# Confirmar e destruir
terraform destroy
```

### Opção 2: Forçar Destruição

```powershell
# Pular confirmação (cuidado!)
terraform destroy -auto-approve
```

⏱️ **Tempo de destruição:** 8-10 minutos

⚠️ **ATENÇÃO:** 
- Dados no S3 serão preservados (buckets não são deletados com dados)
- Snapshots do RDS podem gerar custos residuais
- Verifique no console AWS se tudo foi removido

---

## 🏗️ Estrutura do Projeto

```
hackaton-soat11-infra/
├── terraform/
│   ├── main.tf                    # Orquestração dos módulos
│   ├── variables.tf               # Variáveis globais
│   ├── outputs.tf                 # Outputs consolidados
│   ├── providers.tf               # Configuração AWS
│   ├── backend.tf                 # Backend S3
│   ├── MODULES.md                 # Documentação dos módulos
│   │
│   └── modules/
│       ├── networking/            # VPC, Subnets, IGW, NAT
│       ├── security-groups/       # Security Groups
│       ├── s3/                    # Bucket S3
│       ├── rds/                   # PostgreSQL
│       ├── redis/                 # ElastiCache
│       └── sqs/                   # Filas SQS
│
├── README.md                      # Este arquivo
├── terraform.tfvars.example       # Template de variáveis
├── show-connection-info.ps1       # Script de conexões
└── test-sqs-queues.ps1           # Script de testes SQS
```

---

## 🔒 Segurança

### ⚠️ Para Ambiente de Produção

**Mudanças obrigatórias:**

1. **IP Público Restrito**
   ```hcl
   my_ip = "SEU_IP_PUBLICO/32"  # Não usar 0.0.0.0/0
   ```

2. **Senha Forte**
   ```powershell
   # Usar AWS Secrets Manager
   aws secretsmanager create-secret \
     --name /hackaton/db/password \
     --secret-string "SenhaForte123!@#"
   ```

3. **RDS Privado**
   ```hcl
   publicly_accessible = false
   ```

4. **Encryption**
   ```hcl
   # S3 encryption
   storage_encrypted = true
   kms_key_id        = "arn:aws:kms:..."
   ```

5. **Multi-AZ**
   ```hcl
   multi_az = true
   ```

### 🔐 Boas Práticas

- ✅ Nunca commite `terraform.tfvars` com senhas
- ✅ Use `.gitignore` para arquivos sensíveis
- ✅ Rotacione credenciais regularmente
- ✅ Habilite MFA na conta AWS
- ✅ Use IAM Roles em vez de access keys
- ✅ Revise Security Groups periodicamente
- ✅ Habilite AWS CloudTrail

---

## 🐛 Troubleshooting

### Erro: "Error creating DB Instance: DBSubnetGroupDoesNotCoverEnoughAZs"

**Causa:** RDS precisa de pelo menos 2 AZs

**Solução:**
```hcl
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
```

### Erro: Timeout conectando no RDS/Redis

**Verificar:**
1. ✅ `my_ip` está correto no `terraform.tfvars`
2. ✅ Security Groups permitem seu IP
3. ✅ RDS/Redis estão em subnet pública (para testes)
4. ✅ Sua rede não bloqueia portas 5432/6379

**Comando de diagnóstico:**
```powershell
# Testar conectividade
Test-NetConnection -ComputerName $RDS_HOST -Port 5432
Test-NetConnection -ComputerName $REDIS_HOST -Port 6379
```

### Erro: "AccessDenied" no SQS

**Solução:**
```powershell
# Verificar permissões AWS
aws sts get-caller-identity

# Verificar políticas da fila
aws sqs get-queue-attributes \
  --queue-url $QUEUE_URL \
  --attribute-names Policy
```

### Erro: Terraform State Lock

**Causa:** Outro processo está usando o state

**Solução:**
```powershell
# Forçar unlock (cuidado!)
terraform force-unlock <LOCK_ID>
```

### Performance lenta do RDS

**Otimizações:**
1. Trocar para db.t3.small (mais CPU)
2. Aumentar storage
3. Habilitar Performance Insights
4. Revisar queries lentas

---

## 📚 Referências

### Documentação Oficial
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon RDS PostgreSQL](https://docs.aws.amazon.com/rds/postgresql/)
- [Amazon ElastiCache Redis](https://docs.aws.amazon.com/elasticache/redis/)
- [Amazon SQS](https://docs.aws.amazon.com/sqs/)
- [Amazon S3](https://docs.aws.amazon.com/s3/)

### Tutoriais
- [AWS Free Tier](https://aws.amazon.com/free/)
- [Terraform Getting Started](https://learn.hashicorp.com/terraform)
- [AWS CLI Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html)

---

## 👥 Contribuindo

Este é um projeto acadêmico, mas contribuições são bem-vindas!

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 📧 Contato

**Projeto Acadêmico - FIAP Pós Tech SOAT 11**

Para dúvidas ou problemas:
- Abra uma [issue](../../issues)
- Consulte a documentação da AWS
- Verifique os logs do Terraform

---

**Última atualização:** Fevereiro 2026  
**Versão:** 2.0.0 (SQS)