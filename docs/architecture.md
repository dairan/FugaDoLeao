# Arquitetura

## Stack

- Godot 4.6.
- GDScript.
- Assets visuais em SVG.
- Audio em WAV.
- Estado global via autoload `GameState`.

## Cenas

- `scenes/menu/MainMenu.tscn`: entrada do jogo.
- `scenes/main/Main.tscn`: cena principal da partida.
- `scenes/player/Player.tscn`: jogador.
- `scenes/lion/Lion.tscn`: perseguidor.
- `scenes/items/GoodItem.tscn`: item positivo.
- `scenes/items/BadItem.tscn`: item negativo.
- `scenes/ui/HUD.tscn`: interface da partida.

## Scripts

- `scripts/globals/game_state.gd`: estado e regras centrais.
- `scripts/main/main.gd`: orquestracao da fase.
- `scripts/player/player.gd`: movimento do jogador.
- `scripts/lion/lion.gd`: movimento do leao.
- `scripts/items/tax_item.gd`: comportamento compartilhado de item fiscal.
- `scripts/items/good_item.gd`: especializacao de item bom.
- `scripts/items/bad_item.gd`: especializacao de item ruim.
- `scripts/ui/hud.gd`: leitura e exibicao do estado.
- `scripts/menu/main_menu.gd`: menu inicial.

## GameState

`GameState` e o contrato central do gameplay. Ele guarda:

- `score`
- `speed`
- `debt`
- `lion_distance`
- `risk_level`
- `combo_count`
- `combo_multiplier`
- `combo_timer`
- `is_paused`
- `is_game_over`

Ele tambem emite:

- `good_item_collected`
- `bad_item_collected`
- `game_over_triggered`

Regras de jogo como coleta boa, evento ruim, drain passivo e game over pertencem ao `GameState`.

## Fluxo de Gameplay

`Main` inicializa a partida, conecta sinais do `GameState`, cria pools de itens e controla o timer de spawn.

Itens inativos ficam escondidos e com `monitoring = false`. Quando o timer dispara, `Main` pega um item livre da pool, posiciona em uma faixa e reativa.

Quando um item colide com um corpo no group `player`, `tax_item.gd` chama o metodo adequado no `GameState` de acordo com `item_kind` e se desativa.

O HUD roda como leitor do estado global. Ele atualiza labels de pontuacao, velocidade, divida, distancia, risco, combo, pausa e game over.

## Contratos Importantes

- O jogador deve estar no group `player`.
- Itens devem expor `reset_state(start_pos: Vector2)` e `deactivate()`.
- Itens devem ter a propriedade `is_active`.
- `Main` espera encontrar `SpawnTimer`, sprites de parallax e players de audio pelos caminhos definidos na cena.
- `Lion` tenta localizar o jogador pelo group `player`.

## Regras de Evolucao

- Para novos eventos de jogo, prefira sinal no `GameState` quando mais de um sistema precisar reagir.
- Para novos tipos de item, prefira configurar ou estender `tax_item.gd` antes de duplicar scripts.
- Para mobile, adicione entrada touch no player sem quebrar input por teclado.
- Para feedback visual, prefira efeitos locais no item/player/HUD e mantenha regras numericas no `GameState`.
