# AI Agent Rules - Foge Leao

Este arquivo orienta agentes de IA trabalhando neste repositorio Godot 4.

## Contexto

- Engine: Godot 4.6, projeto em GDScript.
- Genero: runner horizontal em 3 faixas.
- Tema: fuga do "Leao" do imposto de renda, com humor fiscal/tributario.
- Plataforma alvo inicial: mobile/iOS, mantendo desktop como ambiente de desenvolvimento.
- Cena inicial: `res://scenes/menu/MainMenu.tscn`.
- Cena principal: `res://scenes/main/Main.tscn`.

## Comunicacao

- Responda em portugues do Brasil no chat.
- Seja direto, pratico e tecnico.
- Nomes de variaveis, metodos, sinais, arquivos de codigo e comentarios no codigo devem ficar em ingles.
- Evite entusiasmo vazio e explicacoes genericas.

## Filosofia Tecnica

- Use "boring technology": solucoes simples, locais e previsiveis.
- Prefira melhorar o loop jogavel antes de criar sistemas grandes.
- Leia os arquivos reais antes de inferir estrutura, APIs ou comportamento.
- Nao alucine APIs Godot. Se a API exata for incerta, confira a documentacao Godot 4.

## Terminal e Git

- Use caminhos absolutos ao rodar comandos.
- Use `rg` para busca textual.
- Use `trash` em vez de `rm` quando precisar excluir arquivos.
- Nao reverta alteracoes existentes sem pedido explicito.
- Use trunk-based development simples: `main` e o tronco, branches curtas para tarefas pequenas e integracao rapida.
- Antes de integrar em `main`, valide `MainMenu.tscn` e `Main.tscn` em headless.
- Commits devem usar Conventional Commits em portugues, por exemplo:
  - `feat: adiciona controles por toque`
  - `fix: corrige colisao de itens`
  - `docs: organiza documentacao do jogo`

## Arquitetura Local

- `GameState` e o autoload global do projeto. Ele centraliza estado e sinais do ciclo principal.
- Use signals para comunicar eventos de jogo entre sistemas.
- Use groups para identificar papeis como `player`, evitando referencias rigidas desnecessarias.
- HUD e UI devem ler estado e reagir a eventos; nao devem gravar diretamente no `GameState`.
- Sistemas com criacao frequente de entidades devem usar object pooling.
- Itens spawnados devem ser reativados/desativados pela pool, nao destruidos a cada ciclo.

## Estrutura Relevante

- `project.godot`: configuracao do projeto, input map e autoload.
- `scripts/globals/game_state.gd`: score, divida, risco, distancia do leao, combo, pausa e game over.
- `scripts/main/main.gd`: loop da fase, spawn, dificuldade, parallax, audio e pools.
- `scripts/player/player.gd`: movimentacao do jogador em 3 faixas.
- `scripts/lion/lion.gd`: perseguicao do leao baseada em `GameState.lion_distance`.
- `scripts/items/*.gd`: comportamento de itens bons e ruins.
- `scripts/ui/hud.gd`: exibicao do estado de jogo.
- `docs/`: contexto de produto, arquitetura, runbook e roadmap.

## Validacao

Use o Godot Mono instalado localmente quando validar via terminal:

```bash
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --import
/Applications/Godot_mono.app/Contents/MacOS/Godot --headless --path /Users/dairan/Public/Dev/Games/FugaDoLeao --scene res://scenes/main/Main.tscn --quit-after 30
```

O comando `godot` do PATH pode apontar para a versao nao-Mono. Confira antes de assumir.

## Anti-patterns

- Nao deixe TODOs soltos sem plano claro.
- Nao crie singleton novo sem necessidade forte.
- Nao acople HUD, player, leao e spawner por referencias diretas quando signal/group resolve.
- Nao troque object pool por `instantiate()`/`queue_free()` continuo em gameplay.
- Nao faca refactor amplo junto com mudanca de gameplay pequena.
- Nao misture mudancas de arte, balanceamento e arquitetura no mesmo commit sem motivo.
