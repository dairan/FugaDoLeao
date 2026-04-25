---
doc_type: runbook
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - git-workflow.md
  - public-release-checklist.md
  - publishing-plan.md
  - testing-strategy.md
tags:
  - docs
  - runbook
  - ci
---

# Runbook

## Abrir no Editor

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot -e --path /Users/dairan/Public/Dev/Games/FugaDoLeao
```

## Importar/Validar Assets

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --import
```

## Rodar Cena Principal em Headless

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --scene res://scenes/main/Main.tscn --quit-after 30
```

## Rodar Menu em Headless

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --scene res://scenes/menu/MainMenu.tscn --quit-after 5
```

## Rodar com Janela

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --path /Users/dairan/Public/Dev/Games/FugaDoLeao
```

## Instalar GUT Localmente

GUT nao e versionado no repo. Instale via Godot Asset Library no editor (busque "GUT") ou baixe manualmente:

```bash
GUT_VERSION="9.3.0"
curl -L "https://github.com/bitwes/Gut/releases/download/v${GUT_VERSION}/gut_v${GUT_VERSION}.zip" -o /tmp/gut.zip
unzip -q /tmp/gut.zip -d /tmp/gut_extracted
mkdir -p /Users/dairan/Public/Dev/Games/FugaDoLeao/addons
cp -r /tmp/gut_extracted/addons/gut /Users/dairan/Public/Dev/Games/FugaDoLeao/addons/gut
```

## Rodar Testes

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao -s res://addons/gut/gut_cmdln.gd -- -gdir=res://tests -gexit -glog=1
```

## Exportar para Web

```bash
mkdir -p /Users/dairan/Public/Dev/Games/FugaDoLeao/build/web
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --export-release "Web" build/web/index.html
```

Para validar no navegador (requer servidor HTTP por causa de SharedArrayBuffer):

```bash
cd /Users/dairan/Public/Dev/Games/FugaDoLeao/build/web && python3 -m http.server 8080
```

Abra `http://localhost:8080` no browser.

## Observacoes

- O binario `godot` em `/opt/homebrew/bin/godot` pode apontar para `/Applications/Godot.app`, que e a versao sem Mono.
- Para consistencia neste repo, use explicitamente `/Applications/Godot_mono.app/Contents/MacOS/Godot`.
- `.godot/` e cache local do editor e nao deve ser versionado.
- `.import` de assets Godot deve continuar versionado quando fizer parte do projeto.

## Checklist Antes de Commit

1. Rode importacao headless.
2. Rode `MainMenu.tscn` em headless.
3. Rode `Main.tscn` em headless.
4. Rode testes GUT quando o runner estiver instalado.
5. Revise `git status --short`.
6. Separe mudancas de docs, testes, gameplay e arte em commits pequenos quando fizer sentido.
7. Nao altere assertions de teste no mesmo commit da implementacao quando a task for refactor.

## CI

O GitHub Actions roda a validacao headless em `.github/workflows/ci.yml`:

- baixa Godot Mono 4.6.2 para Linux;
- roda importacao do projeto;
- carrega `MainMenu.tscn`;
- carrega `Main.tscn`.
- deve rodar GUT depois que o runner for instalado.

Antes de alterar o workflow, valide localmente com `actionlint` quando disponivel:

```bash
actionlint .github/workflows/ci.yml
```
