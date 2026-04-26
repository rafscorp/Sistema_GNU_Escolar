#!/bin/bash

# ==========================================
# AUTO-GIT PROTOCOL // KYLOS SYSTEM
# ==========================================

# Cores futuristas para o terminal
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem Cor
BOLD='\033[1m'

clear
echo -e "${CYAN}${BOLD}"
echo "========================================="
echo "      KYLOS // AUTO-GIT PROTOCOL         "
echo "=========================================${NC}"
echo ""

# Pega o status do git e joga numa lista (ignorando arquivos intactos)
# O --porcelain traz um output perfeito para scripts
mapfile -t changed_files < <(git status --porcelain | sed 's/^...//')

# Verifica se há algo para commitar
if [ ${#changed_files[@]} -eq 0 ]; then
    echo -e "${GREEN}[✔] Repositório sincronizado. Nenhum arquivo alterado.${NC}"
    exit 0
fi

# Mostra os arquivos alterados com numeração
echo -e "${YELLOW}[!] Arquivos Modificados / Não Rastreados detectados:${NC}"
for i in "${!changed_files[@]}"; do
    echo -e "  [${CYAN}$((i+1))${NC}] ${changed_files[$i]}"
done

echo ""
echo -e "${YELLOW}:: Digite os números para adicionar (ex: 1 3 4)${NC}"
echo -e "${YELLOW}:: Ou digite ${GREEN}all${YELLOW} para adicionar TUDO.${NC}"
read -p ">> " selection

# Lógica de adição
if [[ "$selection" == "all" || "$selection" == "ALL" ]]; then
    git add .
    echo -e "${GREEN}[+] Todos os arquivos foram jogados na Staging Area.${NC}"
else
    # Separa os números digitados e adiciona um por um
    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#changed_files[@]}" ]; then
            idx=$((num-1))
            file_to_add="${changed_files[$idx]}"
            git add "$file_to_add"
            echo -e "${CYAN}[+] Adicionado:${NC} $file_to_add"
        else
            echo -e "${RED}[X] Seleção inválida ignorada: $num${NC}"
        fi
    done
fi

# Verifica se realmente algo foi pra staging (evita commits vazios)
if git diff --cached --quiet; then
    echo -e "${RED}[!] Nenhum arquivo foi selecionado. Abortando protocolo.${NC}"
    exit 1
fi

echo ""
# Pega a mensagem do commit
echo -e "${YELLOW}:: Digite a mensagem do Commit:${NC}"
read -p ">> " commit_msg

# Se der Enter sem digitar nada, coloca uma mensagem padrão
if [ -z "$commit_msg" ]; then
    commit_msg="Update via Auto-Git Protocol"
    echo -e "${CYAN}[i] Mensagem vazia. Usando padrão: '$commit_msg'${NC}"
fi

# Faz o Commit
git commit -m "$commit_msg"

echo ""
echo -e "${YELLOW}:: Iniciando Up-link (Push)...${NC}"
# Como sua chave SSH já tá configurada, ele vai empurrar direto
git push

echo ""
echo -e "${GREEN}${BOLD}[✔] Sincronização concluída com sucesso! Servidores atualizados.${NC}"
