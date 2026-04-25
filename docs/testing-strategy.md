---
doc_type: strategy
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - refactor-plan.md
  - architecture.md
  - runbook.md
tags:
  - docs
  - testing
  - ai-guardrails
---

# Testing Strategy

## Objetivo

Criar uma rede pequena de seguranca para refatoracao assistida por IA, sem transformar o prototipo em um projeto pesado de QA.

## Decisao

Usar uma piramide simples:

- [x] Smoke tests headless para cenas principais no CI.
- [ ] Unit tests em GDScript para regras centrais.
- [ ] Characterization tests antes de refactors em scripts criticos.
- [ ] Scene/component tests para contratos de item, player e leao.
- [ ] E2E completo apenas depois que input mobile e HUD estiverem estaveis.

Ferramenta inicial recomendada: GUT 9.x para Godot 4.6. `gdUnit4` continua sendo alternativa se o projeto precisar de scene testing mais completo, mocking mais forte ou relatorios JUnit mais ricos.

## Alvos Prioritarios

1. [ ] `scripts/globals/game_state.gd`
   - item bom altera score, divida, distancia do leao e combo;
   - item ruim altera score, divida, distancia do leao e quebra combo;
   - risco fiscal muda conforme `lion_distance` e `debt`;
   - game over dispara no limite correto.

2. [ ] `scripts/items/tax_item.gd`
   - `reset_state(start_pos)` ativa, mostra e liga colisao;
   - `deactivate()` esconde e desliga `monitoring`;
   - colisao so aplica efeito quando o corpo esta no group `player`.

3. [ ] `scripts/player/player.gd`
   - jogador permanece dentro das 3 faixas;
   - input de teclado nao quebra com futura entrada touch.

4. [ ] `scripts/lion/lion.gd`
   - posicao do leao responde a `GameState.lion_distance`;
   - leao encontra jogador pelo group `player`.

## Guardrails para IA

- [ ] Antes de refatorar `GameState`, `Main`, `Player`, `Lion` ou `TaxItem`, criar ou atualizar characterization tests em commit separado.
- [ ] Assertions de teste nao devem mudar no mesmo commit da implementacao.
- [ ] Mudancas de teste, gameplay, arte, balanceamento e CI devem ficar em commits separados quando possivel.
- [ ] Diff simples que mexe em mais de 10 arquivos precisa de justificativa no resumo do commit ou PR.
- [ ] Toda task deve terminar com `git status --short` e validacao descrita no runbook.

## O que Nao Fazer Agora

- [ ] Nao criar harness proprio.
- [ ] Nao criar MCP de arquitetura.
- [ ] Nao adicionar E2E visual fragil antes do HUD/input mobile estabilizarem.
- [ ] Nao bloquear refactor pequeno exigindo cobertura total.

