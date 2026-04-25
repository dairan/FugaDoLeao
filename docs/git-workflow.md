# Git Workflow

## Modelo

Este projeto usa trunk-based development simples.

- `main` e o tronco.
- `main` deve estar sempre jogavel e exportavel.
- Branches sao curtas e existem para uma tarefa pequena.
- Commits usam Conventional Commits em portugues.

## Branches

Use branches curtas quando a tarefa tiver mais de um commit ou puder quebrar o jogo temporariamente:

```bash
git switch -c feat/controle-touch
git switch -c fix/spawn-itens
git switch -c docs/publicacao-web
```

Para tarefas pequenas e seguras, commitar direto em `main` e aceitavel enquanto o projeto estiver solo/local.

## Antes de Integrar

Rode a validacao minima:

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --scene res://scenes/menu/MainMenu.tscn --quit-after 5
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --scene res://scenes/main/Main.tscn --quit-after 30
```

Quando mexer em assets, exports ou scripts novos, rode tambem:

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --import
```

## Mensagens de Commit

Exemplos:

- `feat: adiciona controle por swipe`
- `fix: evita spawn injusto de itens ruins`
- `refactor: centraliza comportamento dos itens fiscais`
- `docs: planeja publicacao web`
- `build: adiciona preset de export web`

## Regras

- Nao deixe feature quebrada em `main`.
- Nao acumule branch longa.
- Nao misture gameplay, export e docs no mesmo commit sem motivo.
- Prefira commits pequenos que possam ser revertidos isoladamente.
- Se uma mudanca precisar ficar incompleta, esconda por configuracao ou deixe fora do fluxo principal.
