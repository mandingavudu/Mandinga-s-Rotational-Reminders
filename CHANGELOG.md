# Changelog

## 1.2.0

- **Roll the Bones** also alerts when you enter combat with the spell ready and either no active roll, a stage 1 roll, or a stage 2 roll with Loaded Dice active. Choose the spell’s cast sound or short text-to-speech (TTS) that speaks “Roll” in English and “Role” in Brazilian Portuguese.
- **Keep It Rolling** offers the original Jackpot sound effect from the Liberation of Undermine tier sets and a TTS option that speaks “Jackpot.”
- **Improved Garrote** uses its own localized spell name for standard TTS and offers **Garrote** as an alternate.
- Default every reminder to TTS with its full localized spell name. Existing sound selections carry over.
- Add **Duplicate non-TTS sounds** under **General** in `/mrr`. Enabled by default, it plays two simultaneous copies of each alert sound effect for extra volume. TTS plays once per alert.
- Update the bilingual README to cover combat-entry checks, their tracked buffs, and overlapping TTS alerts from the addon, other addons, and the Cooldown Manager. Format spell names as inline code.

## 1.1.1

- Use Retail’s Brazilian Portuguese spell and menu names in the settings and README, and localize the addon-list description.
- Clarify Cooldown Manager bar-label matching, sound selection and playback, and Improved Garrote’s text-to-speech preview and timer display.

## 1.1.0

- Add an **Assassination Rogue** reminder before **Improved Garrote** expires, with a configurable lead time of 0.5–5 seconds (default 1.5). Text-to-speech uses the localized name of **Garrote**.
- Add an **Outlaw Rogue** reminder for **Roll the Bones** when the spell is ready and the buff has 2 seconds left, accounting for Keep It Rolling extensions. It also alerts on recharge with no active buff, at stage 1, or at stage 2 with Loaded Dice active.
- Add an **Outlaw Rogue** reminder for **Keep It Rolling** when it finishes recharging with a stage 3 or 4 roll, or when a fresh roll of either stage is applied while it is ready.
- Add an **Outlaw Rogue** reminder for **Preparation** after casting Adrenaline Rush, Killing Spree, or Blade Rush if Preparation is ready and all three spells are on cooldown.
- Share audio and settings code across reminders. Each new reminder has its own toggle and sound in `/mrr` and defaults to localized text-to-speech.
- Document which buffs to track in the Cooldown Manager when Retail restricts direct aura access.

## 1.0.0

Initial release of Mandinga’s Rotational Reminders for World of Warcraft Retail.

- Add a **Subtlety Rogue** reminder that triggers once when Shadow Dance ends while Shadow Blades is still active. It reads both buffs directly when possible and falls back to visible Cooldown Manager trackers when aura access is restricted. By default, WoW’s text-to-speech (TTS) announces the localized spell name.
- Add account-wide settings under **Options → AddOns** and the `/mrr` shortcut. Enable or disable the reminder and choose or preview a sound from Blizzard’s Cooldown Manager list. Alert sound effects play through Gameplay SFX.
- Document the addon and its settings in English and Brazilian Portuguese.
- Set up tag-based GitHub and CurseForge publishing, with the release tag supplying the packaged addon version.
