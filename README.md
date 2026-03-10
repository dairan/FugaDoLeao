# Foge Leao

Protótipo Godot 4 de runner horizontal com 3 faixas.

## Como abrir

1. Instale o Godot 4.
2. Abra o editor.
3. Importe esta pasta.
4. Rode o projeto (a cena inicial é `scenes/menu/MainMenu.tscn`).

## Controles

- `W` / `Seta para cima`: subir faixa
- `S` / `Seta para baixo`: descer faixa
- `Esc`: pausar/retomar
- `R`: reiniciar após game over
- `Enter` ou `Espaço`: iniciar pelo menu

## Estrutura

- `scenes/main/Main.tscn`: fase principal
- `scenes/menu/MainMenu.tscn`: menu inicial
- `scenes/player/Player.tscn`: jogador
- `scenes/lion/Lion.tscn`: leão
- `scenes/items/*.tscn`: itens bons e ruins
- `scenes/ui/HUD.tscn`: interface
- `scripts/globals/game_state.gd`: estado global do jogo

## Observações

O loop de gameplay inclui combo, pressão passiva do leão, risco fiscal, pausa e dificuldade progressiva por tempo.
