# Projeto Linux e AWS Compass UOL 2025
Projeto em Linux com o intuito fazer um script que verifique se um site está online e notifique através do Discord/Telegram, criar uma página HTML simples e usar o NGINX para armazenar

* Etapa 1: Configuração do Ambiente
* Etapa 2: Configuração do Servidor Web
* Etapa 3: Script de Monitoramento + Webhook
* Etapa 4: Testes e Documentação



# Etapa 1: Configuração do Ambiente
1.1 - Criação da VPC
![Criar VPC](Imagens/Criar_VPC.png)

Para conseguir a configuração das 2 sub redes públicas e privadas, é necessário seguir as mesmas configurações das imagens, após, basta pressionar o botão Criar VPC
![Configuração da VPC Parte 1](Imagens/Config_VPC_1.png)
![Configuração da VPC Parte 2](Imagens/Config_VPC_2.png)
Para a criação do Gateway, basta entrar na aba de Gateway e Clicar no botão de criação
![Gateway de Internet](Imagens/GATEWAY.png)

1.2 - Criação de uma instância EC2 na AWS
Basta entrar na aba EC2 e clicar no botão de executar instância
![Criação da Instância](Imagens/instancia.png)

# Etapa 2: Instalação e Configuração do Servidor Web

Nessa etapa foi instalado e configurado o servidor web Nginx na máquina virtual Ubuntu 22.04. Também foi criada uma página HTML personalizada para ser servida pelo Nginx, contendo informações sobre o projeto. E foi criado um serviço systemd para garantir que o Nginx reinicie automaticamente após 3 minutos se parar.

## 1. Instalação e verificação do Nginx

### 1.1. Atualização dos pacotes do sistema

```bash
sudo apt-get update
```
### 1.2. Instalação do NGINX

```bash
sudo apt-get install nginx
```

```bash
#!/bin/bash

URL="hotmail.com"
TIMEOUT=10
EXPECTED_STATUS=200
DISCORD_WEBHOOK_URL="Sua URL aqui"
LOG_FILE="/var/log/monitoramento.log"

TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S")
```

```bash
*     *     *   *   *     comando-a-ser-executado
│     │     │   │   │
│     │     │   │   └── Dia da semana (0 = domingo)
│     │     │   └────── Mês (1–12)
│     │     └────────── Dia do mês (1–31)
│     └─────────────── Hora (0–23)
└──────────────────── Minuto (0–59)
```
