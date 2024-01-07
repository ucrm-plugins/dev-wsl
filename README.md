# dev-wsl
Instructions and scripts for setting up our development environment in WSL.

1.  Edit the `%SystemDir%\System32\drivers\etc\hosts` file to include the following:
    ```text
    127.0.0.1 uisp
    127.0.0.1 uisp.dev
    ```
    IMPORTANT: This step must be completed before the WSL boots, so the hosts information can be generated in `/etc/hosts`.

2.  Ubuntu 22.04 (WSL)
    From withing Windows PowerShell, run the following to completely reset any existing Ubuntu installations:
    ```powershell
    wsl --unregister Ubuntu
    wsl --install Ubuntu
    wsl --set-default Ubuntu
    wsl -u root bash -c "echo 'root:password' | chpasswd"
    ```
    IMPORTANT: We set the default here, so that the Docker Desktop integrations work without further intervention!
    NOTE: During the above process, you will be prompted to enter a username and password.  We then also configure the
    password for the root user, in case we need it.

3.  Generate Development SSL Certificates
    IMPORTANT: All of the following commands should be run from within WSL
    NOTE: We install the mkcert binary for Windows, as it will need to execute on the host machine!
    ```bash
    sudo wget -q --show-progress "https://dl.filippo.io/mkcert/latest?for=windows/amd64" -O /usr/bin/mkcert.exe \
    && sudo chmod +x /usr/bin/mkcert.exe
    ```
    Then we install the local CA, and generate the certificates
    ```bash
    sudo mkcert.exe -install \
    && sudo mkcert.exe -cert-file uisp.crt -key-file uisp.key uisp uisp.dev localhost \
    && sudo mv uisp.crt /etc/ssl/certs \
    && sudo mv uisp.key /etc/ssl/certs \
    && sudo chown root:root /etc/ssl/certs/uisp.*
    ```

4.  Install UISP for the first time with an optional `--version VERSION` flag.
    ```bash
    sudo curl -fsSL https://github.com/ucrm-plugins/dev-wsl/raw/main/bin/uisp_inst.sh > /tmp/uisp_inst.sh \
    && sudo bash /tmp/uisp_inst.sh \
    --ssl-cert-dir /etc/ssl/certs \
    --ssl-cert uisp.crt \
    --ssl-cert-key uisp.key
    ```

5.  Users
    ```bash
    sudo chmod 775 -R /home/unms/
    ```

6.  Tooling
    ```bash
    # PHP 8.1
    sudo apt-get update
    sudo apt-get install -y ca-certificates apt-transport-https software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    sudo apt install -y php8.1-cli php8.1-curl php8.1-xml php8.1-yaml php8.1-zip unzip

    # Composer (Latest)
    sudo curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
    echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
    source ~/.bashrc

    # PHP CS Fixer
    composer global require --dev friendsofphp/php-cs-fixer

    composer global require --dev squizlabs/php_codesniffer
    ```
7.  GitHub CLI
    ```bash
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

    echo "export GH_TOKEN=<GitHub Token>" >> ~/.bashrc
    source ~/.bashrc
    ```

8.  Repos
    ```bash
    mkdir -p ~/spaethtech && cd ~/spaethtech && \
    gh repo clone spaethtech/php-monorepo -- --recurse-submodules

    mkdir -p ~/ucrm-plugins && cd ~/ucrm-plugins && \
    gh repo clone ucrm-plugins/monorepo -- --recurse-submodules
    ```





Updates
```bash
sudo curl -fsSL https://github.com/ucrm-plugins/dev-wsl/raw/main/bin/uisp_inst.sh > /tmp/uisp_inst.sh \
&& sudo bash /tmp/uisp_inst.sh --version 2.4.60 --update
```
