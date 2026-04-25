---
doc_type: checklist
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - publishing-plan.md
  - git-workflow.md
  - runbook.md
tags:
  - docs
  - security
  - release
---

# Public Release Checklist

## Objetivo

Garantir que o repositorio pode ficar publico sem expor tokens, certificados, chaves de assinatura ou dados privados.

## Como Continuar

- Atualize os checkboxes no mesmo commit da verificacao.
- Marque `[x]` apenas para verificacao executada, nao para intencao.
- Antes de tornar o repositorio publico, todos os itens de `Checklist Antes de Tornar Publico` devem estar marcados.
- Proximo foco recomendado: instalar/rodar `gitleaks` ou ferramenta equivalente.

## Status Atual

- [x] Varredura manual rapida nao encontrou tokens obvios nos arquivos rastreados.
- [x] Rodar varredura especializada com `gitleaks`.
- [x] `gitleaks` nao estava instalado no ambiente desta checagem.
- [ ] Revisar mudancas locais do Obsidian antes de publicar.

## Nunca Versionar

- [x] `.env` e variantes locais.
- [x] Tokens de GitHub, itch.io, Cloudflare, Google, Apple ou qualquer servico externo.
- [x] `*.keystore` e `*.jks`.
- [x] `*.p12`, `*.pfx`, `*.pem`, `*.key`, certificados e provisioning profiles.
- [x] `*.mobileprovision` e `*.provisionprofile`.
- [x] Senhas de assinatura Android/iOS.
- [x] Builds exportados: APK, AAB, IPA, executaveis, ZIPs e PCKs.
- [x] Logs e dumps locais.

## Arquivos que Exigem Revisao Antes de Commit

- [ ] `export_presets.cfg`.
- [ ] Qualquer arquivo de configuracao de loja.
- [ ] Qualquer script de deploy.
- [ ] Configuracoes do Obsidian em `docs/.obsidian/`.
- [ ] Novos plugins do Obsidian.
- [ ] Arquivos adicionados por Xcode ou Android Studio.

## Godot Export

- [ ] Pode versionar presets somente se estiverem sanitizados.
- [x] Nao versionar senha de keystore.
- [ ] Nao versionar caminho local com nome de usuario se isso puder expor informacao pessoal.
- [ ] Preferir placeholders documentados para signing.
- [ ] Se necessario, criar `export_presets.example.cfg` e manter `export_presets.cfg` local.

## Android

- [ ] Gerar keystore fora do repo.
- [ ] Guardar senha em password manager ou Keychain.
- [x] Usar caminho local ignorado pelo Git para keystore.
- [x] Nao commitar `local.properties`, `keystore.properties` ou `signing.properties`.

## iOS

- [x] Nao commitar certificados Apple.
- [x] Nao commitar provisioning profiles.
- [x] Nao commitar exports Xcode gerados se contiverem assinatura local.
- [x] Bundle identifier publico e aceitavel; credenciais nao.

## Web

- [x] Nao commitar tokens de deploy.
- [x] Build exportado deve ir para `build/`, `dist/`, `exports/` ou pasta ignorada.
- [ ] Se usar CI, configurar tokens como secrets do provedor.
- [x] CI inicial nao usa tokens.

## Obsidian

- [x] Tema e preferencias podem ser versionados se forem intencionais.
- [ ] Revisar `workspace.json` antes de publicar, pois pode expor nomes de arquivos locais, abas abertas ou estado de trabalho.
- [ ] Revisar plugins novos antes de commit.
- [ ] Evitar qualquer plugin config com conta, token ou path pessoal.

## GitHub

- [ ] Ativar Secret Scanning.
- [ ] Ativar Push Protection.
- [x] Revisar `git diff --cached` antes de commitar.
- [x] Evitar `git add .` em mudancas que envolvam export, signing ou lojas.
- [x] Se um segredo ja foi commitado, revogar/rotacionar primeiro. Reescrever historico vem depois.

## Checklist Antes de Tornar Publico

1. [x] Rodar varredura com ferramenta especializada, como `gitleaks`.
2. [x] Revisar `git ls-files`.
3. [ ] Revisar historico para nomes sensiveis de arquivos.
4. [x] Confirmar que `.gitignore` cobre signing, env e exports.
5. [ ] Confirmar que `export_presets.cfg`, se existir, esta sanitizado.
6. [x] Confirmar que nao ha certificados ou keystores rastreados nos arquivos rastreados atuais.
7. [ ] Confirmar que docs nao expõem informacao pessoal desnecessaria.
8. [ ] Ativar Secret Scanning e Push Protection no GitHub.
9. [ ] Criar README publico com status de prototipo e licenca.

## Comandos Uteis

```bash
git status --short
git ls-files
git grep -n -I -E "(token|secret|password|api_key|apikey|client_secret|keystore|mobileprovision|BEGIN .*PRIVATE KEY)"
```

Se `gitleaks` estiver instalado:

```bash
gitleaks detect --source /Users/dairan/Public/Dev/Games/FugaDoLeao --verbose
```
