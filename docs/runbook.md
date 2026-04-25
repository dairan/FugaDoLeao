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

## Rodar Testes

Ainda nao ha runner de unit tests instalado. O plano aprovado em `testing-strategy.md` e instalar GUT 9.x e adicionar o comando CLI aqui.

Enquanto isso, a validacao minima obrigatoria e:

1. Importacao headless.
2. `MainMenu.tscn` em headless.
3. `Main.tscn` em headless.

Quando GUT entrar no projeto, este runbook deve incluir:

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao -s res://addons/gut/gut_cmdln.gd
```

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
