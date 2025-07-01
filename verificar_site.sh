#!/bin/bash

URL="Sua_URL"
TIMEOUT=10
EXPECTED_STATUS=200
DISCORD_WEBHOOK_URL="Sua_URL_Webhook"


TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

send_discord_notification() {
    local message="$1"
    local color="$2"

    local decimal_color=$((color))

    JSON_PAYLOAD=$(cat <<EOF
{
  "username": "Monitoramento de Site",
  "avatar_url": "https://i.imgur.com/your_bot_avatar.png",
  "embeds": [
    {
      "title": "Status do Site: $URL",
      "description": "$message",
      "color": $decimal_color,
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
      "footer": {
        "text": "Verificação automatizada por Bash Script"
      }
    }
  ]
}
EOF
)

    curl -H "Content-Type: application/json" \
         -X POST \
         -d "$JSON_PAYLOAD" \
         "$DISCORD_WEBHOOK_URL" > /dev/null 2>&1
}




echo "Verificando a disponibilidade HTTP de $URL"
echo "--------------------------------------------------"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time "$TIMEOUT" --retry 3 --retry-max-time 30 "$URL")
CURL_EXIT_CODE=$?

 if [ "$CURL_EXIT_CODE" -eq 0 ]; then
    if [ "$HTTP_STATUS" -eq "$EXPECTED_STATUS" ]; then
        MESSAGE="✅ Site está ONLINE e respondeu com status HTTP $HTTP_STATUS (esperado)."

    elif [[ "$HTTP_STATUS" =~ ^2 ]]; then
        MESSAGE="⚠️ Site está ONLINE, mas respondeu com status HTTP $HTTP_STATUS (esperado $EXPECTED_STATUS)."
    else
        MESSAGE="❌ Site está ONLINE, mas respondeu com status HTTP $HTTP_STATUS (erro no servidor ou página)."

    fi
else
    MESSAGE="❌ Site está OFFLINE ou inacessível. Erro de conexão (curl exit code: $CURL_EXIT_CODE)."
    MESSAGE+=" Causas: Host não encontrado, timeout de conexão, problema de DNS."

fi

echo "$MESSAGE"

send_discord_notification "$MESSAGE"

echo "--------------------------------------------------"
echo "Verificacao realizada em: $TIMESTAMP"
echo "--------------------------------------------------"
