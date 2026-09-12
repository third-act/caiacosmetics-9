#!/usr/bin/env bash
# design-bakeoff/gate-design.sh — kit/visual greps for a thin design-only pass.
# Run from the Flutter pitch repo root. Paste the full output into chat before claiming done.
# Exit 1 if any hard fail fires.
#
# Unlike ui/gate.sh this gate has NO haptic-vs-taps floor and NO animation-count
# floor. Shadows must be present (AppShadows / BoxShadow); app views must use
# depth widgets. AppSpace + TabPill/bottomNavigationBar required.
# Copied KIT under lib/ui/common + lib/ui/shared_widgets is excluded from bans
# that the kit itself implements (pill OutlineInputBorder, surface white).
set -euo pipefail

ROOT="${1:-.}"
LIB="$ROOT/lib"
fail=0

# App Dart only — not the copied KIT (BrandField / theme / comments).
APP_GLOBS=(--glob '*.dart' --glob '!**/ui/common/**' --glob '!**/ui/shared_widgets/**')

if [[ ! -d "$LIB" ]]; then
  echo "FAIL: no lib/ under $ROOT — run from the Flutter repo root"
  exit 1
fi

echo "== design-bakeoff/gate-design.sh =="
echo "root: $(cd "$ROOT" && pwd)"
echo

hit() {
  local label="$1" pattern="$2" path="$LIB"
  local -a extra=(--glob '*.dart')
  if [[ $# -ge 3 ]]; then
    path="$3"
    shift 3
    if [[ $# -gt 0 ]]; then
      extra=("$@")
    fi
  fi
  local out
  out=$(rg -n "${extra[@]}" "$pattern" "$path" 2>/dev/null || true)
  if [[ -n "$out" ]]; then
    echo "FAIL: $label"
    echo "$out"
    echo
    fail=1
  else
    echo "OK:   $label"
  fi
}

need() {
  local label="$1" pattern="$2" path="$LIB"
  local -a extra=(--glob '*.dart')
  if [[ $# -ge 3 ]]; then
    path="$3"
    shift 3
    if [[ $# -gt 0 ]]; then
      extra=("$@")
    fi
  fi
  local out
  out=$(rg -n "${extra[@]}" "$pattern" "$path" 2>/dev/null || true)
  if [[ -z "$out" ]]; then
    echo "FAIL: $label"
    echo
    fail=1
  else
    echo "OK:   $label"
  fi
}

# Hard bans in app code (KIT copy excluded where the kit is the allowed implementation)
hit "Icons.arrow_back (use chevron_left)" 'Icons\.arrow_back'
hit "OutlineInputBorder (Material notch fields)" 'OutlineInputBorder' "$LIB" "${APP_GLOBS[@]}"
hit "labelText: floating Material labels" 'labelText:' "$LIB" "${APP_GLOBS[@]}"
hit "Colors.grey\[ one-off palette rot" 'Colors\.grey\['
hit "pure white page bg Color(0xFFFFFFFF)" 'bg\s*=\s*Color\(0xFFFFFFFF\)'
hit "CircularProgressIndicator (use CupertinoActivityIndicator / AppAsync.spinner)" 'CircularProgressIndicator\s*\('
hit "Image.network (bundle seed photos as assets)" 'Image\.network'
hit "CachedNetworkImage (bundle assets; no live CMS)" 'CachedNetworkImage'
hit "await AppHaptics (never await before onTap — CAIA)" 'await AppHaptics\.'
hit "await HapticFeedback (never await before onTap — CAIA)" 'await HapticFeedback\.'

# Presence (not ratio floors)
shadows=$(rg -n --glob '*.dart' 'BoxShadow' "$LIB" 2>/dev/null | wc -l | tr -d ' ')
echo
echo "== counts =="
echo "BoxShadow:       $shadows"

if [[ "$shadows" -lt 1 ]]; then
  echo "FAIL: no BoxShadow — copy KIT AppShadows / give cards and the pill depth"
  fail=1
else
  echo "OK:   BoxShadow present"
fi

# App views (not copied KIT) must actually use depth — KIT BoxShadow alone is not enough
depth=$(rg -n "${APP_GLOBS[@]}" 'AppShadows\.|PressableCard\s*\(|SnapCarousel\s*\(' "$LIB" 2>/dev/null | wc -l | tr -d ' ')
echo "depth uses:      $depth (AppShadows/PressableCard/SnapCarousel in app views)"
if [[ "$depth" -lt 2 ]]; then
  echo "FAIL: depth usage $depth < 2 — cards / floating chrome / rails need AppShadows (flat = STOP)"
  fail=1
else
  echo "OK:   depth via AppShadows / PressableCard / SnapCarousel"
fi

# AppSpace / air
appspace_def=$(rg -n --glob '*.dart' 'class AppSpace|AppSpace\.screen' "$LIB" 2>/dev/null | wc -l | tr -d ' ')
appspace_use=$(rg -n --glob '*.dart' 'AppSpace\.(screen|section|lg|xl|md)' "$LIB" 2>/dev/null | wc -l | tr -d ' ')
echo "AppSpace refs: def/match=$appspace_def use=$appspace_use"
if [[ "$appspace_def" -lt 1 ]]; then
  echo "FAIL: AppSpace missing — copy ui/KIT and use AppSpace.screen / section (cramped = STOP)"
  fail=1
elif [[ "$appspace_use" -lt 5 ]]; then
  echo "FAIL: AppSpace barely used ($appspace_use) — first compose must pad with tokens"
  fail=1
else
  echo "OK:   AppSpace in use"
fi

# Chrome must be wired in the app shell, not only mentioned in KIT comments
need "TabPill used in app shell" 'TabPill\s*\(' "$LIB" "${APP_GLOBS[@]}"
need "bottomNavigationBar: (floating pill shell)" 'bottomNavigationBar:' "$LIB" "${APP_GLOBS[@]}"

# Theme kit presence
if [[ ! -f "$LIB/ui/common/app_theme.dart" ]] && [[ ! -f "$LIB/ui/common/app_colors.dart" ]]; then
  echo "FAIL: missing KIT theme under lib/ui/common/ (copy from thirdact-skills/ui/KIT/)"
  fail=1
else
  echo "OK:   KIT theme files present"
fi

# Bundled assets expectation when seed imagery exists
if rg -n --glob '*.dart' 'Image\.asset|AssetImage|ExactAssetImage' "$LIB" >/dev/null 2>&1; then
  echo "OK:   Image.asset / AssetImage present"
else
  echo "WARN: no Image.asset found — if harvest has photos, bundle them; if thin, use type/data/texture (no empty plates)"
fi

# Flutter default web chrome — fail if stock Flutter icons still present
if [[ -d "$ROOT/web" ]]; then
  if [[ -f "$ROOT/web/manifest.json" ]] && rg -q 'Flutter Demo|A new Flutter project' "$ROOT/web/manifest.json" 2>/dev/null; then
    echo "FAIL: web/manifest.json still Flutter default — brand name/colors in first pass"
    fail=1
  else
    echo "OK:   web/manifest.json not Flutter default (or absent text)"
  fi
  if [[ -f "$ROOT/web/index.html" ]] && rg -q 'Flutter Demo' "$ROOT/web/index.html" 2>/dev/null; then
    echo "FAIL: web/index.html title still Flutter Demo"
    fail=1
  elif [[ -f "$ROOT/web/index.html" ]]; then
    echo "OK:   web/index.html title branded"
  fi
fi

echo
if [[ "$fail" -ne 0 ]]; then
  echo "RESULT: FAIL — fix before claiming done"
  exit 1
fi
echo "RESULT: PASS"
exit 0
