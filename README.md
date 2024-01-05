# dev-wsl
Instructions and scripts for setting up our development environment in WSL.



Install UISP for the first time
```bash
curl -fsSL https://github.com/ucrm-plugins/raw/main/bin/uisp_inst.sh > /tmp/uisp_inst.sh \
&& sudo bash /tmp/uisp_inst.sh \
--ssl-cert-dir /etc/ssl/certs \
--ssl-cert uisp.crt \
--ssl-cert-key uisp.key
```
Optionally `--version VERSION`


Update UISP
```bash
curl -fsSL https://github.com/ucrm-plugins/raw/main/uisp_inst.sh > /tmp/uisp_inst.sh \
&& sudo bash /tmp/uisp_inst.sh \
--update
```
