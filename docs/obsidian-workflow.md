---
doc_type: workflow
status: active
canonical: true
last_reviewed: 2026-04-25
related:
  - README.md
  - refactor-plan.md
  - public-release-checklist.md
tags:
  - docs
  - obsidian
---

# Obsidian Workflow

## Objetivo

Reduzir drift, duplicacao e notas soltas no vault de documentacao do jogo.

## Configuracao Ativa

- [x] Core plugin `properties` habilitado.
- [x] Core plugin `templates` habilitado.
- [x] Core plugin `backlink` habilitado.
- [x] Core plugin `outgoing-link` habilitado.
- [x] Core plugin `graph` habilitado.
- [x] Tipos de propriedades definidos em `.obsidian/types.json`.
- [x] Template base definido em `templates/doc-note.md`.

## Documentacao Semantica

Vale a pena usar, mas de forma leve. Aqui existem dois niveis:

- Metadata nos documentos para evitar duplicacao no Obsidian.
- Contratos curtos no codigo para evitar drift de padrao e dependencia implicita.

Padrao adotado:

- `doc_type`: tipo do documento.
- `status`: `active`, `draft`, `deprecated` ou `archived`.
- `canonical`: `true` quando o documento e fonte de verdade.
- `last_reviewed`: data da ultima revisao.
- `related`: documentos relacionados.
- `tags`: tags de navegacao.

Use `canonical: true` apenas para documentos que devem ser fonte de verdade. Isso reduz duplicacao porque uma IA pode procurar o documento canonico antes de criar outro.

## Semantica no Codigo

Nao use comentarios longos para explicar implementacao obvia. Para este jogo, documentacao semantica no codigo deve marcar contratos que outra IA ou outro dev pode quebrar sem perceber:

- [ ] groups obrigatorios, como `player`.
- [ ] signals que conectam sistemas.
- [ ] invariantes de pool, como item inativo sem `monitoring`.
- [ ] exports de balanceamento.
- [ ] dependencia de node path em cena.

Se a regra puder ser validada por headless, CI ou checklist, prefira essa validacao. Comentario sem validacao deve ser curto e ficar colado na linha ou funcao que depende dele.

## Plugins Comunitarios Recomendados

Instale pelo Obsidian quando quiser reforcar o workflow:

- [ ] Dataview: consultar docs por metadata, status e tarefas abertas.
- [ ] Linter: padronizar Markdown e frontmatter.
- [ ] Find orphaned files and broken links: achar notas soltas e links quebrados.
- [ ] Omnisearch: busca melhor para evitar criar documento duplicado.
- [ ] Tag Wrangler: renomear tags sem deixar lixo.

Nao instale plugin so por instalar. Cada plugin precisa ajudar a reduzir drift, duplicacao ou friccao real.

## Rotina Antes de Criar Documento Novo

1. [ ] Buscar no vault por titulo e sinonimos.
2. [ ] Verificar `README.md` e documentos com `canonical: true`.
3. [ ] Se o assunto ja existir, atualizar o documento existente.
4. [ ] Se criar novo documento, usar `templates/doc-note.md`.
5. [ ] Preencher `related`.
6. [ ] Linkar o novo documento no `README.md` quando for parte do fluxo principal.

## Consultas Dataview Uteis

Documentos canonicos:

```dataview
TABLE doc_type, status, last_reviewed
FROM "docs"
WHERE canonical = true
SORT doc_type ASC
```

Documentos que precisam revisao:

```dataview
TABLE doc_type, status, last_reviewed
FROM "docs"
WHERE last_reviewed < date(today) - dur(30 days)
SORT last_reviewed ASC
```

Tarefas abertas:

```dataview
TASK
FROM "docs"
WHERE !completed
```
