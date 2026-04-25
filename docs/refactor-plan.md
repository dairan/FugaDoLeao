---
doc_type: plan
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - architecture.md
  - publishing-plan.md
  - roadmap.md
  - testing-strategy.md
tags:
  - docs
  - refactor
  - gameplay
---

# Refactor Plan

## Objetivo

Levar o prototipo para uma base simples, jogavel e publicavel, usando praticas canonicas de Godot 4 sem overengineering.

## Como Continuar

- Atualize os checkboxes no mesmo commit da mudanca.
- Marque `[x]` apenas quando a mudanca estiver implementada e validada.
- Mantenha uma fase pequena por vez.
- Antes de pegar novo trabalho, leia esta ordem: `refactor-plan.md`, `testing-strategy.md`, `publishing-plan.md`, `public-release-checklist.md`, `runbook.md`.
- Proximo foco recomendado: `Fase 6 - Export Baseline`, item "Criar preset Web".

## Principios

- [x] Cena pequena e reutilizavel.
- [x] `Main` orquestra; nao concentra regra demais.
- [x] `GameState` guarda estado compartilhado e regras numericas globais.
- [x] Nodes cuidam do comportamento local.
- [x] Signals para eventos.
- [x] Groups para papeis, como `player`.
- [x] Object pool para entidades recorrentes.
- [x] Valores de balanceamento devem ser faceis de ajustar.
- [x] Contratos semanticos no codigo devem ser curtos, verificaveis e perto da dependencia real.
- [ ] Scripts criticos devem ter characterization tests antes de refactors maiores.
- [x] Cada refactor deve preservar o jogo rodando.

## Fase 0 - Test Safety Baseline

Objetivo: criar protecao minima para IA refatorar sem mudar comportamento sem perceber.

- [x] Instalar/configurar GUT 9.x para Godot 4.6.
- [x] Adicionar comando de teste local no runbook.
- [x] Rodar testes no GitHub Actions.
- [x] Criar characterization tests de `GameState`.
- [x] Criar component tests de `tax_item.gd`.
- [x] Documentar regra anti-gaming: assertions nao mudam no mesmo commit da implementacao.

Critério de pronto:

- [x] CI roda importacao, smoke scenes e testes GUT.
- [x] `GameState` tem cobertura dos efeitos de item bom, item ruim, risco e game over.
- [x] `TaxItem` tem cobertura de ativacao/desativacao da pool.

## Fase 1 - Base de Gameplay

Objetivo: reduzir duplicacao e tornar o loop mais facil de ajustar.

- [x] Manter item fiscal compartilhado em `tax_item.gd`.
- [x] Revisar se `GoodItem` e `BadItem` precisam continuar como scripts separados ou se podem virar cenas configuradas.
- [x] Extrair configuracoes de spawn para exports claros.
- [x] Documentar constantes de balanceamento em `GameState`.
- [x] Adicionar comentarios de contrato apenas onde houver dependencia por group, signal, node path ou pool.
- [x] Evitar que `Main` cresca alem de orquestracao de fase.

Critério de pronto:

- [x] `Main.tscn` carrega em headless.
- [x] Itens bons e ruins continuam colidindo e aplicando efeito correto.
- [x] Pool continua sem `queue_free()` em gameplay.

## Fase 2 - Input Mobile-First

Objetivo: deixar o jogo jogavel em touch sem perder teclado para desenvolvimento.

- [x] Adicionar swipe vertical para trocar de faixa.
- [x] Manter `move_up` e `move_down` via keyboard.
- [x] Centralizar traducao de input em `Player`.
- [x] Evitar que UI capture swipe de gameplay indevidamente.

Critério de pronto:

- [x] Teclado funciona no desktop.
- [x] Touch funciona no mobile/web mobile.
- [x] Movimento continua limitado a 3 faixas.

## Fase 3 - HUD Responsivo

Objetivo: fazer a UI caber em desktop, web e mobile.

- [x] Revisar `HUD.tscn` para ancoragem responsiva.
- [x] Garantir legibilidade em telas estreitas.
- [ ] Destacar risco fiscal e combo sem poluir a tela.
- [ ] Preparar safe area para iOS.

Critério de pronto:

- [x] HUD nao corta em 16:9.
- [x] HUD nao corta em telas altas de celular.
- [x] Game over fica legivel.

## Fase 4 - Spawn e Dificuldade

Objetivo: tornar o runner justo e repetivel.

- [x] Evitar sequencias longas de itens ruins.
- [x] Evitar spawn que gere decisao impossivel.
- [x] Criar chance de recuperacao apos risco alto.
- [x] Ajustar intervalo de spawn por tempo.
- [x] Manter dificuldade progressiva simples.

Critério de pronto:

- [x] Jogador consegue reagir aos spawns.
- [x] Dificuldade aumenta sem parecer aleatoria demais.
- [x] O jogo gera partidas curtas com vontade de tentar de novo.

## Fase 5 - Feedback e Polimento

Objetivo: comunicar bem o que aconteceu.

- [x] Feedback visual para item bom.
- [x] Feedback visual para item ruim.
- [x] Feedback de perigo quando o leao se aproxima.
- [x] Pequeno feedback de combo.
- [x] Revisar audio de coleta e game over.

Critério de pronto:

- [x] Coleta boa e ruim sao distinguiveis sem olhar so para score.
- [x] Perigo do leao e claro antes do game over.

## Fase 6 - Export Baseline

Objetivo: garantir que a base refatorada exporta.

- [x] Criar preset Web.
- [x] Validar demo Web em navegador.
- [ ] Criar preset Android debug.
- [ ] Criar preset iOS inicial.
- [ ] Validar Desktop apenas como alvo opcional.
- [x] Manter credenciais e signing fora do Git.

Critério de pronto:

- [x] Web abre em navegador.
- [ ] Android debug instala em aparelho.
- [ ] iOS tem caminho de export para Xcode documentado.

## Ordem Recomendada de Trabalho

1. [ ] Test safety baseline.
2. [ ] Web export baseline.
3. [ ] Swipe/touch.
4. [ ] HUD responsivo.
5. [ ] Spawn justo.
6. [ ] Feedback visual.
7. [ ] Android debug.
8. [ ] iOS export/Xcode.

## Fora de Escopo Agora

- ECS.
- Multiplayer.
- Loja.
- Analytics.
- Ads.
- Save cloud.
- Sistema complexo de fases.
