# BRIEF — CAIA Cosmetics (caiacosmetics-9)

Draft for Demo QA port. Research date: **12 September 2026**. English (skills). App UI: **Swedish**.

**Build gate:** OPEN — Norway Scout **kjør** 12 Sep 2026 (bakeoff #3 / Composer Max).

**Track:** **design-bakeoff #3 / Cursor-only**. **Composer Max** default on all design steps (not High). Soft depth. Gold bar: **caiacosmetics-4**. Splash + 3–5 tab roots; functions need not work. No Opus. No Mail 1/2.

**New project.** Slug `caiacosmetics-9`, repo `third-act/caiacosmetics-9`. Do **not** reuse `-7`/`-8` or earlier code, seed, photos, or URLs. QA: https://www.thirdact.no/demo/caiacosmetics-9 (no `?v=` on Webflow). Customer: https://www.thirdact.se/caiacosmetics-9. Skills pin: `d0a6598` (PR #28 densitet STOP + Max; keep imagery-audit, TabPill bleed STOP, zero-gap STOP).

Never contact the brand. Never put `info@caiacosmetics.com` or `pal@` in UI.

---

## 0. HARD REQUIREMENT — onske (verbatim)

Confirmed character-for-character with Norway Scout **12 Sep 2026** (91 chars):

> **Man ska kunna scanna ansiktet och få rekommendationer på vilka produkter som passar min hud**

Visual ship: face scan → resultat → rekommendationer → produkt-detalj + favoritter/profil. Swedish UI. Never dump raw onske as labeled Hem section.

---

## 1. Client

| | |
|---|---|
| Name | Beauty Icons AB (CAIA Cosmetics) |
| Org | 559153-2493 |
| Site | https://caiacosmetics.se/ |
| Audience | KUNDE — ansiktsscan → produktanbefaling |
| Slug | caiacosmetics-9 |
| Market | **SE** |
| Form To | pal@thirdact.se — never in UI |
| Customer URL | https://www.thirdact.se/caiacosmetics-9 |
| QA | https://www.thirdact.no/demo/caiacosmetics-9 |

**Tokens:** blush `#E0CCC7`, cream `#FFFCF7`, ink `#333333`. Soft cream/blush photography.

---

## 2c. Art direction

Soft depth **LOCKED**. Soft depth ≠ sparse.

---

## 6. Features (design-bakeoff — thin)

**Tabs (4):** Hem · Hudscan · För dig · Mina

**Must follow tip `d0a6598`:**
- **Densitet:** first fold = hero + primary CTA + ≥1 secondary row visible; no large empty stripe / “premium empty” breathing vs caiacosmetics-4
- **Imagery-audit:** face in Hudscan; lifestyle/editorial Hem hero (not sterile gradient+packshot); splash harvest photo; distinct För dig; image↔label match
- No accent panel under TabPill; no zero-gap stacked cards
- Compact fold STOPs + AppShadows (not chips); break-the-stack once per screen
- First paint: no black frame

**§6e:** Soft depth. One accent-owned surface on one screen. Bar: caiacosmetics-4.

---

## Screens

face scan · resultat · rekommendationer · produkt-detalj · favoritter · profil

Splash → logged-in. No login / Firebase / Azure / TestFlight.
