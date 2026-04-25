---
doc_type: adr
status: accepted
date: 2026-04-25
tags:
  - hosting
  - web
  - deploy
---

# ADR 001 — Hospedagem do demo web

## Contexto

O jogo precisa de uma URL pública para o demo web antes de publicar nas lojas. O
requisito principal é rodar Godot 4 no browser, o que exige os headers
`Cross-Origin-Opener-Policy: same-origin` e `Cross-Origin-Embedder-Policy: require-corp`
para SharedArrayBuffer funcionar.

O export web do Godot 4.6 gera um `index.wasm` de ~36 MiB.

## Alternativas avaliadas

### Cloudflare Pages

- Prós: já usamos Cloudflare para `dairan.dev`, deploy via `wrangler`.
- Contras: limite de 25 MiB por arquivo. O `index.wasm` (~36 MiB) excede esse limite.
- Tentativa de contorno: comprimir o WASM com gzip + rewrite via `_redirects` + header
  `Content-Encoding: gzip` em `_headers`. Não funcionou — Cloudflare Pages não permite
  setar `Content-Encoding` via `_headers`; o header é gerenciado internamente.

### GitHub Pages

- Prós: sem custo extra, repo já está no GitHub.
- Contras: não permite setar headers COOP/COEP para arquivos estáticos sem workaround
  de Service Worker. Mais frágil.

### itch.io

- Prós: feito para jogos, sem limite de tamanho de arquivo, suporte nativo a WASM/Godot,
  SharedArrayBuffer ativável por toggle nas configurações do jogo, deploy via `butler`,
  CI/CD simples com GitHub Actions, visibilidade para jogadores indie.
- Contras: URL padrão é `dairantf.itch.io/fuga-do-leao`, não `dairan.dev`. Mitigado
  com redirect `fugadoleao.dairan.dev` → itch.io via Cloudflare Redirect Rules.

## Decisão

**itch.io** como plataforma de hospedagem do demo web.

Deploy automático via `butler push` no GitHub Actions após CI passar.
Canal: `dairantf/fuga-do-leao:web`.

O subdomínio `fugadoleao.dairan.dev` aponta para `https://dairantf.itch.io/fuga-do-leao`
via Cloudflare Redirect Rule (301), mantendo a URL pessoal sem depender de infraestrutura
adicional.

## Consequências

- SharedArrayBuffer precisa estar habilitado nas configurações do jogo no itch.io
  (Edit game → Embed options → "SharedArrayBuffer support").
- Se o jogo crescer para distribuição nas lojas, itch.io continua como canal de demo
  web independente da distribuição mobile.
- Se no futuro quisermos sair do itch.io, a URL `fugadoleao.dairan.dev` pode ser
  redirecionada para outro host sem mudar o que foi divulgado.
