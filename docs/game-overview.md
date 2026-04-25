# Foge Leao - Visao do Jogo

## Conceito

Foge Leao e um runner horizontal em 3 faixas com tematica fiscal. O jogador foge do leao do imposto de renda enquanto coleta itens fiscais bons e evita itens ruins.

A fantasia central e simples: ficar em dia com o fisco afasta o leao; cair na malha fina aproxima o perigo.

## Pilares

- Runner simples: trocar de faixa deve ser a principal decisao do jogador.
- Humor fiscal: textos e itens devem reforcar a metafora tributaria.
- Leitura rapida: risco, divida, combo e proximidade do leao precisam ser claros durante a corrida.
- Sessao curta: o jogo deve funcionar bem em partidas rapidas, especialmente em mobile.

## Loop Principal

1. O jogador corre automaticamente em uma das 3 faixas.
2. Itens aparecem da direita e atravessam a tela.
3. O jogador troca de faixa para coletar itens bons e evitar ruins.
4. Itens bons aumentam pontuacao, reduzem divida, afastam o leao e mantem combo.
5. Itens ruins reduzem pontuacao, aumentam divida, aproximam o leao e quebram combo.
6. O leao drena distancia passivamente com o tempo.
7. Quando `lion_distance` chega a zero, ocorre game over.

## Mecanicas Atuais

- 3 faixas horizontais.
- Itens bons: `dinheiro`, `DARF`, `regularizacao`, `nota em dia`.
- Itens ruins: `caixa dois`, `offshore suspeita`, `recibo frio`, `malha fina`.
- Combo com janela de 2.2 segundos.
- Multiplicador de combo ate 3x.
- Risco fiscal `Baixo`, `Medio` ou `Alto`, calculado por distancia do leao e divida.
- Dificuldade progressiva reduzindo intervalo de spawn.
- Pausa com `Esc` e restart com `R`.

## Direcao de Produto

O jogo deve primeiro ficar legivel e responsivo antes de ganhar novas mecanicas. Melhorias prioritarias:

- Feedback visual para coleta boa/ruim.
- Indicador mais forte de perigo quando o leao esta perto.
- Spawn mais justo e menos puramente aleatorio.
- Controle por toque para mobile.
- HUD responsivo para telas pequenas.
