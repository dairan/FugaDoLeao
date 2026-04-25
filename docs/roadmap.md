# Roadmap

## Objetivo Atual

Transformar o prototipo em uma experiencia curta, legivel e repetivel, mantendo a arquitetura simples.

## Fase 0 - Export Baseline

- Criar preset Web.
- Validar demo Web em navegador.
- Criar preset Android debug.
- Validar Android em aparelho real.
- Criar preset iOS e validar caminho Xcode cedo.

## Fase 1 - Polimento do Loop

- Melhorar feedback visual de coleta boa.
- Melhorar feedback visual de coleta ruim.
- Destacar estado de perigo quando o leao esta perto.
- Tornar combo mais visivel no HUD.
- Ajustar balanceamento inicial de distancia, drain e penalidades.

## Fase 2 - Spawn Mais Justo

- Evitar repeticoes longas de itens ruins.
- Evitar spawn em padrao impossivel de reagir.
- Criar pequenas sequencias com intencao, como risco alto seguido de chance de recuperacao.
- Manter object pool atual.

## Fase 3 - Mobile

- Adicionar swipe vertical para trocar de faixa.
- Revisar HUD para telas estreitas.
- Confirmar area segura em iOS.
- Adicionar botao discreto de pausa se necessario.

## Fase 4 - Identidade

- Expandir lista de itens fiscais bons e ruins.
- Adicionar frases curtas de game over.
- Melhorar menu inicial com identidade visual do jogo.
- Revisar assets SVG para leitura em mobile.

## Fase 5 - Distribuicao

- Criar `export_presets.cfg`.
- Validar export web para smoke test rapido.
- Validar export iOS quando a configuracao Apple estiver pronta.
- Documentar pipeline de build.

## Nao Objetivos Agora

- Sistema complexo de fases.
- Economia persistente.
- Loja.
- Multiplayer.
- Framework proprio de ECS ou state machine.
