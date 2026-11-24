# Mandinga's Rotational Reminders

## English

A collection of class- and specialization-specific rotation reminders for World of Warcraft Retail.

Open **Options → AddOns → Mandinga's Rotational Reminders** or type `/mrr` to toggle reminders and pick their sounds from the Cooldown Manager sound list.

### Cooldown Manager setup

When Retail restricts direct aura lookups, add the following buffs to a visible **Tracked Buffs** or **Tracked Bars** section in the Cooldown Manager.

| Reminder | Buffs to track |
| --- | --- |
| Shadow Dance | Shadow Dance and Shadow Blades |
| Roll the Bones | Roll the Bones, plus Loaded Dice for the stage 2 recharge alert |
| Keep It Rolling | Roll the Bones |

### Available reminders

#### Subtlety Rogue

When Shadow Dance ends while Shadow Blades is still active, the addon plays the selected alert once. By default, WoW’s text-to-speech announces the localized spell name.

- Reads both buffs directly from the player whenever the game exposes them to addons. This works with the Cooldown Manager disabled.
- When the game restricts direct aura lookups, the reminder uses the Cooldown Manager entries listed above. It stays quiet if either buff’s state is still unavailable.

#### Assassination Rogue

Plays an alert once before the Improved Garrote buff expires. Set the lead time from 0.5 to 5 seconds in `/mrr`. The default is 1.5 seconds. If the game hides the aura timer, the reminder estimates the remaining time from the six-second window after leaving Stealth. By default, WoW’s text-to-speech announces the localized name of Garrote.

#### Outlaw Rogue

- **Roll the Bones** alerts with 2 seconds left on the buff. If Retail hides the timer, the addon estimates it from your Roll the Bones and Keep It Rolling casts. It also alerts when the spell finishes recharging at stage 1, or at stage 2 with Loaded Dice active.
- **Keep It Rolling** alerts when it finishes recharging with a stage 3 or 4 roll, or when a new roll of stage 3 or 4 is applied while it is ready.
- **Preparation** checks after you cast Adrenaline Rush, Killing Spree, or Blade Rush. It alerts if Preparation is ready and all three spells are on cooldown.

Each reminder has its own toggle and sound. By default, text-to-speech announces the localized spell name. A stage-based alert can play later in the same roll if Retail exposes the stage after the trigger.

## Português

Uma coleção de lembretes de rotação por classe e especialização para World of Warcraft Retail.

Abra **Opções → AddOns → Mandinga's Rotational Reminders** ou digite `/mrr` para ativar ou desativar os lembretes e escolher seus sons na lista do Gerenciador de Recarga.

### Configuração do Gerenciador de Recarga

Quando o Retail restringir a consulta direta aos efeitos, adicione os bônus abaixo a uma seção visível de ícones ou barras de bônus no Gerenciador de Recarga.

| Lembrete | Bônus a acompanhar |
| --- | --- |
| Dança das Sombras | Dança das Sombras e Lâminas Sombrias |
| Rolar os Dados | Rolar os Dados, além de Dados Viciados para o aviso de recarga no estágio 2 |
| Keep It Rolling | Rolar os Dados |

### Lembretes disponíveis

#### Ladino de Subterfúgio

Quando Dança das Sombras termina e o efeito de Lâminas Sombrias permanece ativo, o addon toca o aviso escolhido uma vez. Por padrão, a síntese de voz do WoW anuncia o nome localizado da habilidade.

- Consulta os dois efeitos diretamente no personagem quando o jogo disponibiliza esses dados aos addons. Isso funciona com o Gerenciador de Recarga desativado.
- Quando o jogo restringe a consulta direta, o lembrete usa as entradas do Gerenciador de Recarga listadas acima. O aviso fica em silêncio se o estado de algum dos efeitos continuar indisponível.

#### Ladino de Assassinato

Toca um aviso uma vez antes de terminar o efeito de Garrote Aprimorado. Ajuste a antecedência de 0,5 a 5 segundos em `/mrr`. O padrão é 1,5 segundo. Se o jogo ocultar o temporizador do efeito, o lembrete estima o tempo restante usando a janela de seis segundos após sair de Furtividade. Por padrão, a síntese de voz do WoW anuncia o nome localizado de Garrote.

#### Ladino Fora da Lei

- **Rolar os Dados** avisa quando faltam 2 segundos para o efeito terminar. Se o Retail ocultar o temporizador, o addon estima o tempo com base nos seus usos de Rolar os Dados e Keep It Rolling. Também avisa quando a recarga acaba com um resultado no estágio 1 ou no estágio 2 com Dados Viciados ativo.
- **Keep It Rolling** avisa quando a recarga acaba com um resultado no estágio 3 ou 4, ou quando um novo resultado nesses estágios é aplicado com a habilidade pronta.
- **Preparação** verifica após usar Adrenaline Rush, Killing Spree ou Blade Rush. Avisa se Preparação estiver pronta e as três habilidades estiverem em recarga.

Cada lembrete pode ser ativado separadamente e tem seu próprio som. Por padrão, a síntese de voz anuncia o nome localizado da habilidade. Se o Retail revelar o estágio com atraso, o aviso ainda pode tocar durante a mesma rolagem.
