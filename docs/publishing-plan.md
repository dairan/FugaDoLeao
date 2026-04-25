# Publishing Plan

## Prioridade

1. [ ] Web
2. [ ] Android
3. [ ] iOS
4. [ ] Desktop

## Como Continuar

- Trabalhe na ordem de prioridade.
- Marque `[x]` somente depois de exportar/testar o alvo.
- Mantenha credenciais fora do Git; consulte `public-release-checklist.md`.
- Proximo foco recomendado: `Fase 1 - Web Demo`, item "Criar preset de export Web".

## Por que Web Primeiro

Web e o caminho mais rapido para validar export, controles, audio e compartilhamento publico. Um build web tambem serve como demo jogavel para receber feedback antes de fechar loja mobile.

## Fase 1 - Web Demo

- [ ] Criar preset de export Web.
- [ ] Exportar build debug local.
- [ ] Testar no navegador com teclado e touch.
- [ ] Validar audio apos primeira interacao do usuario.
- [ ] Publicar demo em hospedagem simples, como itch.io, Cloudflare Pages ou site pessoal.

Critério de pronto:

- [ ] Build web abre em navegador moderno.
- [ ] Menu inicia partida.
- [ ] Cena principal roda sem erro.
- [ ] Jogador troca de faixa.
- [ ] Game over e restart funcionam.

## Fase 2 - Android

- [ ] Configurar Android SDK, JDK e export templates.
- [ ] Criar preset Android.
- [ ] Definir package name, por exemplo `com.dairan.fugadoleao`.
- [ ] Gerar APK debug.
- [ ] Instalar e testar em aparelho real.
- [ ] Ajustar controles touch e HUD para telas pequenas.
- [ ] Gerar keystore de release.
- [ ] Exportar AAB para Play Console.

Critério de pronto:

- [ ] APK debug instala e roda em aparelho real.
- [ ] Controles touch funcionam sem teclado.
- [ ] HUD nao fica cortado.
- [ ] AAB release e gerado com assinatura.

## Fase 3 - iOS

- [ ] Configurar preset iOS.
- [ ] Definir bundle identifier, por exemplo `com.dairan.fugadoleao`.
- [ ] Exportar projeto Xcode.
- [ ] Configurar signing/provisioning.
- [ ] Rodar em simulador quando fizer sentido e em aparelho real.
- [ ] Enviar build para TestFlight.
- [ ] Preparar metadata da App Store.

Critério de pronto:

- [ ] Build roda em aparelho iOS real.
- [ ] Safe area nao cobre controles/HUD.
- [ ] TestFlight aceita o build.

## Fase 4 - Desktop

- [ ] Criar presets para macOS, Windows e Linux apenas se houver objetivo de distribuicao.
- [ ] Validar teclado, janela, fullscreen e audio.
- [ ] Publicar zip no itch.io ou release GitHub.

Critério de pronto:

- [ ] Build desktop abre sem editor Godot.
- [x] Teclado funciona.
- [ ] Tela escala corretamente.

## Trabalho Comum Antes de Release

- [ ] Controles touch por swipe vertical.
- [ ] HUD responsivo.
- [ ] Spawn mais justo.
- [ ] Feedback visual de coleta boa e ruim.
- [ ] Feedback de perigo quando o leao esta perto.
- [ ] Icone e nome final.
- [ ] Versao do projeto.
- [ ] Descricao curta, screenshots e politica de privacidade se a loja exigir.

## Regra de Engenharia

Manter `main` sempre exportavel. Cada alvo pode ter preset proprio, mas gameplay e UI devem continuar compartilhados. Diferencas de plataforma devem ficar em input, export settings e pequenos ajustes de layout.
