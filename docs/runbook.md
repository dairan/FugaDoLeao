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

## Observacoes

- O binario `godot` em `/opt/homebrew/bin/godot` pode apontar para `/Applications/Godot.app`, que e a versao sem Mono.
- Para consistencia neste repo, use explicitamente `/Applications/Godot_mono.app/Contents/MacOS/Godot`.
- `.godot/` e cache local do editor e nao deve ser versionado.
- `.import` de assets Godot deve continuar versionado quando fizer parte do projeto.

## Checklist Antes de Commit

1. Rode importacao headless.
2. Rode `MainMenu.tscn` em headless.
3. Rode `Main.tscn` em headless.
4. Revise `git status --short`.
5. Separe mudancas de docs, gameplay e arte em commits pequenos quando fizer sentido.

## CI

O GitHub Actions roda a validacao headless em `.github/workflows/ci.yml`:

- baixa Godot Mono 4.6.2 para Linux;
- roda importacao do projeto;
- carrega `MainMenu.tscn`;
- carrega `Main.tscn`.

Antes de alterar o workflow, valide localmente com `actionlint` quando disponivel:

```bash
actionlint .github/workflows/ci.yml
```
