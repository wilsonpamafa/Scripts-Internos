#!/bin/bash
#Arquivo de instalação automática para programas normalmente usados no Windows Ubuntu.

# Efetua a atualização dos pacotes já existentes na máquina.
echo "Executando Atualizacao dos pacotes atualmente instalados."
sudo apt update && sudo apt upgrade -y
sudo apt update -y

# Efetua adição do repositório de drivers de vídeo NVidea
echo "Executando adicao do pacote de drivers Nvidea."
sudo add-apt-repository ppa:kelebek333/nvidia-legacy
sudo apt update -y

# Remoção dos pacotes powershell , Wine e Onedrive, desnecessários
echo "Removendo pacotes Powershell, Wine e Onedrive."
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

# Adiciona chave GPG do Anydesk
sudo apt update
sudo apt install -y ca-certificates curl apt-transport-https
echo "Adicionando chaves GPG do Anydesk"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc

# Adiciona o repositorio Anydesk
echo "Adicionando repositorio Anydesk"
echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null

# Update apt caches and install the AnyDesk client
sudo apt update
echo "Instalando Anydesk"
sudo apt install -y anydesk

# Instalaçao do Xorg Fix para não ter problemas de resoluções de tela ao usar saída VGA:
echo "Instalando módulo Xorg Fix para resolver problemas de resoluções na saida VGA"
sudo apt install -y xorg-modulepath-fix

# Instalação do Antivirus:
echo "Instalando antivirus ClamAV"
sudo apt install -y clamav clamtk clamav-daemon

# Instalação do conjunto de "pacotes essenciais" para o chrome
echo "Efetuando instalacao de pacotes essenciais para instalação do Google Chrome"
sudo apt install -y curl apt-transport-https gdebi
# Download do Chrome Stable
echo "Efetuando Download do Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Instalação do chrome e após a instalação, a remoção do arquivo
echo "Efetuando Instalação do Google Chrome"
sudo gdebi google-chrome* -y
echo "Removendo instalador"
rm google-chrome-stable_current_amd64.deb

# Instalação do Firefox
echo "Instalando Firefox"
sudo apt install -y firefox
