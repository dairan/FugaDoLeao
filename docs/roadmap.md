---
doc_type: roadmap
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - refactor-plan.md
  - publishing-plan.md
  - public-release-checklist.md
tags:
  - docs
  - roadmap
---

# Roadmap

## Objetivo Atual

Transformar o prototipo em uma experiencia curta, legivel e repetivel, mantendo a arquitetura simples.

## Como Continuar

- Use este arquivo como resumo executivo.
- Use `refactor-plan.md` e `publishing-plan.md` para detalhes.
- Atualize checkboxes aqui quando uma milestone for concluida nos planos detalhados.
- Proximo foco recomendado: `Fase 4 - Identidade` (revisar SVGs para leitura em mobile) e `Fase 6 - Pre-Release`.

## Fase 0 - Export Baseline

- [x] Criar preset Web.
- [x] Validar demo Web em navegador.
- [ ] Criar preset Android debug.
- [ ] Validar Android em aparelho real.
- [ ] Criar preset iOS e validar caminho Xcode cedo.

## Fase 1 - Polimento do Loop

- [x] Melhorar feedback visual de coleta boa.
- [x] Melhorar feedback visual de coleta ruim.
- [x] Destacar estado de perigo quando o leao esta perto.
- [x] Tornar combo mais visivel no HUD.
- [x] Ajustar balanceamento inicial de distancia, drain e penalidades.

## Fase 2 - Spawn Mais Justo

- [x] Evitar repeticoes longas de itens ruins.
- [x] Evitar spawn em padrao impossivel de reagir.
- [x] Criar pequenas sequencias com intencao, como risco alto seguido de chance de recuperacao.
- [x] Manter object pool atual.

## Fase 3 - Mobile

- [x] Adicionar swipe vertical para trocar de faixa.
- [x] Revisar HUD para telas estreitas.
- [x] Confirmar area segura em iOS.
- [x] Adicionar botao discreto de pausa se necessario.

## Fase 4 - Identidade

- [x] Expandir lista de itens fiscais bons e ruins.
- [x] Adicionar frases curtas de game over.
- [x] Melhorar menu inicial com identidade visual do jogo.
- [ ] Revisar assets SVG para leitura em mobile.
- [x] Atualizar hint de controles para mencionar swipe touch.

## Fase 5 - Distribuicao

- [x] Criar `export_presets.cfg`.
- [x] Validar export web para smoke test rapido.
- [ ] Validar export iOS quando a configuracao Apple estiver pronta.
- [x] Documentar pipeline de build.
- [x] Deploy automatico para itch.io via GitHub Actions.

## Fase 6 - Pre-Release

- [ ] README publico com status de prototipo e licenca.
- [ ] Ativar Secret Scanning e Push Protection no GitHub.
- [x] Remover `docs/.obsidian/workspace.json` do historico e ignorar localmente.

## Nao Objetivos Agora

- Android e iOS (decidido adiar — foco no web primeiro).
- Sistema complexo de fases.
- Economia persistente.
- Loja.
- Multiplayer.
- Framework proprio de ECS ou state machine.
