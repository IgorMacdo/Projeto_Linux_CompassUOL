# Projeto Linux e AWS Compass UOL 2025

Projeto desenvolvido em ambiente Linux com o objetivo de:

- Criar um script que verifica se um site está online;
- Notificar via Discord/Telegram em caso de instabilidade;
- Criar uma página HTML simples servida por NGINX;
- Automatizar os serviços com `cron` e `systemd`.

## Sumário

- [Etapa 1: Configuração do Ambiente](#etapa-1-configuração-do-ambiente)
- [Etapa 2: Servidor Web (NGINX)](#etapa-2-instalação-e-configuração-do-servidor-web)
- [Etapa 3: Script de Monitoramento](#etapa-3-script-de-monitoramento--webhook)
- [Etapa 4: Testes e Documentação](#etapa-4-automacao-e-testes)

---

## Etapa 1: Configuração do Ambiente

### 1.1 - Criação da VPC



Configure duas sub-redes (pública e privada) conforme as imagens abaixo, depois clique em "Criar VPC":

&#x20;

Para o Gateway de Internet:&#x20;

### 1.2 - Criação de Instância EC2

Acesse a aba EC2 e clique em "Executar Instância":



Selecione o sistema operacional conforme instruções:&#x20;

Na etapa de configuração de rede:

&#x20;

Permita as portas HTTP (80) e SSH (22):&#x20;

### 1.3 - Acesso via SSH (PuTTY)

Insira o IP público da instância:&#x20;

Configure o caminho da chave privada:&#x20;

---

## Etapa 2: Instalação e Configuração do Servidor Web

Servidor NGINX configurado em Ubuntu 22.04. Foi criada uma página HTML personalizada e configurado o systemd para reinício automático do serviço.

### 2.1 - Instalação do NGINX

```bash
sudo apt-get update
sudo apt-get install nginx
sudo systemctl start nginx
sudo systemctl status nginx
```

### 2.2 - Criar página HTML personalizada

```bash
mkdir -p /var/www/meusite/html
nano /var/www/meusite/html/index.html
```

### 2.3 - Configuração do NGINX

Navegue até o diretório de configuração:



Edite o arquivo:

```bash
nano /etc/nginx/sites-available/default
```

Altere o caminho do `root` para a nova pasta:



Reinicie o NGINX:

```bash
sudo systemctl restart nginx
```

### 2.4 - Systemd para reinício automático

```bash
sudo nano /lib/systemd/system/nginx.service
```

Adicione:

```bash
Restart=on-failure
RestartSec=5s
```



Finalize com:

```bash
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

Para testar:

```bash
ps aux | grep nginx
sudo kill -9 <PID>
```

---

## Etapa 3: Script de Monitoramento + Webhook

### 3.1 - Criação do Script Bash

```bash
nano seu_script.sh
```

### 3.2 - Código Principal

```bash
#!/bin/bash

URL="Sua_URL"
TIMEOUT=10
EXPECTED_STATUS=200
DISCORD_WEBHOOK_URL="Seu_Link_Webhook"
LOG_FILE="/var/log/monitoramento.log"

TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S")
```

### Função de Notificação

```bash
send_discord_notification() {
    local message="$1"
    JSON_PAYLOAD=$(cat <<EOF
{
  "content": "${TIMESTAMP} - ${message}"
}
EOF
)
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "$JSON_PAYLOAD" \
         "$DISCORD_WEBHOOK_URL" > /dev/null 2>&1
}
```

### Logs e Status HTTP

```bash
echo "--- Verificação iniciada em: $TIMESTAMP ---" >> "$LOG_FILE"
echo "Verificando: $URL" >> "$LOG_FILE"
echo "Tempo limite: $TIMEOUT" >> "$LOG_FILE"
echo "Status esperado: $EXPECTED_STATUS" >> "$LOG_FILE"
```

```bash
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time "$TIMEOUT" --retry 3 --retry-max-time 30 "$URL")
CURL_EXIT_CODE=$?
```

### Verificação de Status

```bash
if [ "$CURL_EXIT_CODE" -eq 0 ]; then
    if [ "$HTTP_STATUS" -eq "$EXPECTED_STATUS" ]; then
        MESSAGE="✅ Site ONLINE com status $HTTP_STATUS."
        send_discord_notification "$MESSAGE"
    fi
else
    MESSAGE="❌ Site OFFLINE. Erro curl code: $CURL_EXIT_CODE."
    send_discord_notification "$MESSAGE"
fi
```

### Finalização

```bash
echo "$MESSAGE" >> "$LOG_FILE"
echo "Verificação finalizada: $TIMESTAMP" >> "$LOG_FILE"
```

### 3.3 - Agendamento com `cron`

```bash
chmod +x /caminho/para/seu_script.sh
crontab -e
```

Insira:

```bash
* * * * * /caminho/para/seu_script.sh
```

---

## Etapa 4: Automação e Testes

Com o `cron` configurado, o script é executado automaticamente a cada minuto.

### Testes Visuais:

- Visualização da página:&#x20;

- Notificação recebida via Discord:&#x20;

- Interrupção do NGINX:

```bash
sudo systemctl stop nginx
```

- Reinício do NGINX:

```bash
sudo systemctl start nginx
```

---

> Documentação criada com base em experiência prática no uso de Linux, EC2, NGINX e automação com Shell Script. Projeto educacional para a Compass UOL 2025.

