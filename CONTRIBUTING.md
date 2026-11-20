# Contributing

Open an issue first for anything beyond a small fix. Say which host OS and hypervisor you tested on.

Before pushing, run what CI runs:

```bash
yamllint --strict .
ansible-playbook --syntax-check -i localhost, ansible/ubuntu.yml
ansible-playbook --syntax-check -i localhost, ansible/kali.yml
VM_TYPE=ubuntu vagrant validate --ignore-provider
VM_TYPE=kali vagrant validate --ignore-provider
shellcheck scripts/*.sh
```

Security issues: see [SECURITY.md](SECURITY.md). Contributions are licensed under [MIT](LICENSE).
