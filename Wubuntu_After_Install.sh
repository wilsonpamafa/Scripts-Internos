#!/bin/bash
#Arquivo de instalação automática para programas normalmente usados no Windows Ubuntu.

# Efetua a atualização dos pacotes já existentes na máquina.
echo Executando Atualizacao dos pacotes atualmente instalados.
sudo apt update && sudo apt upgrade -y
sudo apt update -y

# Efetua adição do repositório de drivers de vídeo NVidea
echo Executando adicao do pacote de drivers Nvidea
sudo add-apt-repository ppa:kelebek333/nvidia-legacy
sudo apt update -y

# Remoção dos pacotes powershell , Wine e Onedrive, desnecessários
sudo apt purge powershell wine-stable winetricks onedrive -y
sudo apt autoremove -y
sudo apt update

# Verifica se o sistema já possui o "Curl" instalado
if ! command -v curl &> /dev/null; then
    sudo apt install -y curl
fi

# Efetua verificação do Teamviewer mais recente e após isto efetua instalação do mesmo.
echo "Verificando a versão mais recente do TeamViewer..."
TV_URL="https://www.teamviewer.com/pt-br/download/linux/"
TV_VERSION=$(curl -s "$TV_URL" | grep -oP 'Versão\s+\K\d+\.\d+\.\d+' | head -n 1)

if [ -z "$TV_VERSION" ]; then
    echo "Não foi possível obter a versão. Usando URL genérica..."
    DEB_URL="https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
else
    echo "Versão encontrada: $TV_VERSION"
    DEB_URL="https://download.teamviewer.com/download/linux/teamviewer_${TV_VERSION}_amd64.deb"
fi

# Download e instalação
echo "Baixando TeamViewer..."
wget -O teamviewer.deb "$DEB_URL" || {
    echo "Falha no download, tentando URL alternativa..."
    wget -O teamviewer.deb "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
}

sudo apt install -y ./teamviewer.deb
rm teamviewer.deb
echo "TeamViewer instalado com sucesso!"

