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
