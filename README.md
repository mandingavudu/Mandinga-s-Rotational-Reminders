# Mandinga's Rotational Reminders

## English

A collection of class- and specialization-specific rotation reminders for World of Warcraft Retail.

Settings, tooltips, and custom text-to-speech phrases follow your Retail client language.

Open **Options → AddOns → Mandinga's Rotational Reminders** or type `/mrr` to open the main settings page. Open the **Rogue** subpage to toggle reminders and choose their sounds. By default, every reminder uses text-to-speech (TTS) to announce its localized spell name. The sound picker includes the Cooldown Manager catalog when available. Sound effects play through **Gameplay SFX**.

Under **Audio**, **Duplicate non-TTS sounds** plays two simultaneous copies of each alert sound effect for extra volume. It is enabled by default. Text-to-speech plays once per alert.

### Cooldown Manager setup

When Retail restricts direct aura lookups, add the following buffs to a visible **Tracked Buffs** or **Tracked Bars** section in the Cooldown Manager.

| Reminder | Buffs to track |
| --- | --- |
| `Shadow Dance` | `Shadow Dance` and `Shadow Blades` |
| `Roll the Bones` | `Roll the Bones`, plus `Loaded Dice` for the stage 2 alert on combat entry or recharge |
| `Keep It Rolling` | `Roll the Bones` |

Roll stage detection can use the tracked bar’s exact localized result name or an original icon unique to that stage. If you customize the bar, use the localized result name as the entire label to keep the text fallback working.

### Available reminders

#### Subtlety Rogue

When `Shadow Dance` ends while `Shadow Blades` is still active, the addon plays the selected alert once.

- Reads both buffs directly from the player whenever the game exposes them to addons. This works with the Cooldown Manager disabled.
- When the game restricts direct aura lookups, the reminder uses the Cooldown Manager entries listed above. It stays quiet if either buff’s state is still unavailable.

#### Assassination Rogue

Plays an alert once before the `Improved Garrote` buff expires. Set the lead time from 0.5 to 5 seconds on the **Rogue** subpage. The slider shows seconds, with a default of `1.5 s`. If the game hides the aura timer, the reminder estimates the remaining time from the six-second window after leaving `Stealth`. The text-to-speech choices use the localized spell names `Improved Garrote` (default) and `Garrote`.

#### Outlaw Rogue

- `Roll the Bones` alerts with 2 seconds left on the buff while the spell is ready. If Retail hides the timer, the addon estimates it from your `Roll the Bones` and `Keep It Rolling` casts. On combat entry or recharge, it alerts if the spell is ready and you have no active roll, a stage 1 roll, or a stage 2 roll with `Loaded Dice` active. The sound picker also offers the spell’s cast sound at boosted volume.
- `Keep It Rolling` alerts when it finishes recharging with a stage 3 or 4 roll, or when a new roll of stage 3 or 4 is applied while it is ready. The sound picker also offers the Jackpot sound from the Liberation of Undermine tier sets.
- `Preparation` checks after you cast `Adrenaline Rush`, `Killing Spree`, or `Blade Rush`. It alerts if `Preparation` is ready and all three spells are on cooldown.

In English, `Roll the Bones` and `Keep It Rolling` offer the short text-to-speech phrases “Roll” and “Jackpot” in their sound pickers. A stage-based alert can play later in the same roll if Retail exposes the stage after the trigger.

### Tips

If several TTS reminders from this addon, other addons, or the Cooldown Manager trigger together, announcements may overlap or be cut off. Use sound effects for some reminders to reduce simultaneous speech.

## Português (Brasil)

Uma coleção de lembretes de rotação por classe e especialização para World of Warcraft Retail.

As configurações, as dicas de interface e as frases personalizadas de texto em fala seguem o idioma do seu cliente Retail.

Abra **Opções → AddOns → Mandinga's Rotational Reminders** ou digite `/mrr` para abrir a página principal de configurações. Na subpágina **Ladino**, você pode ativar ou desativar os lembretes e escolher seus sons. Por padrão, todos os lembretes anunciam o nome localizado da habilidade por texto em fala (TTS). O seletor inclui o catálogo do Gerenciador de Recarga quando disponível. Os efeitos sonoros usam a categoria **Gameplay SFX**.

Em **Áudio**, a opção **Duplicar sons sem TTS** toca duas cópias simultâneas do efeito sonoro de cada aviso para aumentar o volume. A opção vem ativada por padrão. O texto em fala toca uma vez por aviso.

### Configuração do Gerenciador de Recarga

Quando o Retail restringir a consulta direta aos efeitos, adicione os bônus abaixo a uma seção visível de **Bônus Rastreados** ou **Barras Rastreadas** no Gerenciador de Recarga.

| Lembrete | Bônus a acompanhar |
| --- | --- |
| `Dança das Sombras` | `Dança das Sombras` e `Lâminas Sombrias` |
| `Golpe de Sorte` | `Golpe de Sorte`, além de `Dados Viciados` para o aviso no estágio 2 ao entrar em combate ou ao terminar a recarga |
| `Sorte Grande` | `Golpe de Sorte` |

Para identificar o estágio da rolagem, o addon pode usar o nome localizado exato do resultado na barra rastreada ou um ícone original exclusivo daquele estágio. Se personalizar a barra, use apenas o nome localizado do resultado no texto para manter essa forma de identificação.

### Lembretes disponíveis

#### Ladino de Subterfúgio

Quando `Dança das Sombras` termina e o efeito de `Lâminas Sombrias` permanece ativo, o addon toca o aviso escolhido uma vez.

- Consulta os dois efeitos diretamente no personagem quando o jogo disponibiliza esses dados aos addons. Isso funciona com o Gerenciador de Recarga desativado.
- Quando o jogo restringe a consulta direta, o lembrete usa as entradas do Gerenciador de Recarga listadas acima. O aviso fica em silêncio se o estado de algum dos efeitos continuar indisponível.

#### Ladino de Assassinato

Toca um aviso uma vez antes de terminar o efeito de `Garrote Aprimorado`. Ajuste a antecedência de 0,5 a 5 segundos na subpágina **Ladino**. O controle exibe o tempo em segundos, com valor padrão de `1,5 s`. Se o jogo ocultar o temporizador do efeito, o lembrete estima o tempo restante usando a janela de seis segundos após sair de `Furtividade`. As opções de texto em fala usam os nomes localizados de `Garrote Aprimorado` (padrão) e `Garrote`.

#### Ladino Fora da Lei

- `Golpe de Sorte` avisa quando a habilidade está pronta e faltam 2 segundos para o efeito terminar. Se o Retail ocultar o temporizador, o addon estima o tempo a partir das ativações de `Golpe de Sorte` e `Sorte Grande`. Ao entrar em combate ou ao terminar a recarga, avisa se a habilidade estiver pronta e você estiver sem efeito ativo, no estágio 1 ou no estágio 2 com o bônus de `Dados Viciados` ativo. O seletor também oferece o som da habilidade com volume reforçado.
- `Sorte Grande` avisa quando a recarga acaba com um resultado de `Golpe de Sorte` no estágio 3 ou 4, ou quando você obtém um resultado nesses estágios com `Sorte Grande` pronta. O seletor também oferece o som de jackpot dos conjuntos de classe da Libertação da Inframina.
- `Preparação` verifica as recargas após você usar `Adrenalina`, `Matança` ou `Ímpeto da Lâmina`. Avisa se `Preparação` estiver pronta e as três habilidades estiverem em recarga.

Em português do Brasil, `Golpe de Sorte` e `Sorte Grande` oferecem as frases curtas “Role” e “Jackpot” no seletor de sons. Se o Retail revelar o estágio com atraso, o aviso ainda pode tocar durante a mesma rolagem.

### Dicas

Quando vários lembretes com TTS deste addon, de outros addons ou do Gerenciador de Recarga disparam juntos, as falas podem se sobrepor ou ser interrompidas. Use efeitos sonoros em alguns lembretes para reduzir a sobreposição.
