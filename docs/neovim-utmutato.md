# Neovim útmutató – saját config

> Neovim 0.12 · lazy.nvim · config: `~/.config/nvim/`
> **Leader = `Space`.** Ha lenyomod és vársz egy pillanatot, a *which-key* felugró ablaka megmutatja, mi érhető el.

---

## 1. Alapfogalmak

| Fogalom | Mit jelent |
|---|---|
| **Buffer** | Egy megnyitott fájl a memóriában. Ezek látszanak fent a füleken. |
| **Ablak (window)** | Egy terület a képernyőn, ami éppen egy buffert mutat. Több ablak lehet egymás mellett/alatt. |
| **Leader** | Előtag-billentyű a saját parancsokhoz. Nálad a `Space`. A `<leader>ff` azt jelenti: `Space`, majd `f`, majd `f`. |

**Módok:** Normál (`Esc`) · Beszúrás (`i`, `a`, `o`) · Visual (`v`, `V` soronként) · Parancs (`:`)

---

## 2. Általános

| Billentyű | Funkció |
|---|---|
| `<leader>w` | Mentés |
| `<leader>q` | Kilépés (aktuális ablak) |
| `:qa` | Kilépés mindenből |
| `Esc` | Keresési kiemelés törlése (normál módban) |
| `u` / `Ctrl-r` | Visszavonás / újra |

A visszavonási előzmény a fájl bezárása után is megmarad (`undofile`).

---

## 3. Bufferek (fülek)

| Billentyű | Funkció |
|---|---|
| `Shift-H` / `Shift-L` | Előző / következő buffer (fülek sorrendjében) |
| `Ctrl-^` | Váltás az előző és az aktuális buffer között (két fájl közt ugráláshoz a leggyorsabb) |
| `<leader>bp` | Buffer választás: minden fülön megjelenik egy betű, azzal ugrasz |
| `<leader>fb` | Buffer-kereső: gépeléssel szűrsz a nyitott fájlok között |
| `<leader>bd` | Aktuális buffer bezárása |
| `<leader>bo` | Az összes többi buffer bezárása |

---

## 4. Ablakok

| Billentyű | Funkció |
|---|---|
| `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | Kurzor a bal / alsó / felső / jobb ablakba |
| `Ctrl-w v` | Függőleges felosztás (új ablak jobbra) |
| `Ctrl-w s` | Vízszintes felosztás (új ablak alul) |
| `Ctrl-w q` | Aktuális ablak bezárása |
| `Ctrl-w =` | Ablakok kiegyenlítése |

> `Shift-H/L` = **buffert** vált az aktuális ablakban.
> `Ctrl-h/l` = **ablakot** vált.

---

## 5. Fájlkezelő – oil.nvim

A mappát szerkeszthető szövegként mutatja, az aktuális ablakban.

| Billentyű | Funkció |
|---|---|
| `-` | Az aktuális fájl mappájának megnyitása / egy szinttel feljebb |
| `Enter` | Fájl vagy mappa megnyitása |
| `g?` | Az oil összes billentyűje |
| `g.` | Rejtett fájlok ki/be (alapból látszanak) |

**Fájlműveletek szövegszerkesztésként:**

- **Átnevezés:** írd át a fájl nevét a sorban.
- **Törlés:** töröld a sort (`dd`).
- **Új fájl:** írj egy új sort a névvel (mappához a név végére `/`).
- **Másolás/áthelyezés:** `dd` az egyik mappában, `p` a másikban.
- **Végrehajtás:** mentés (`<leader>w` vagy `:w`). Az oil megerősítést kér.

---

## 6. Keresés – fzf-lua

| Billentyű | Funkció |
|---|---|
| `<leader>ff` | Fájl keresése név alapján |
| `<leader>fg` | Szöveg keresése az összes fájlban (live grep) |
| `<leader>fb` | Nyitott bufferek |
| `<leader>fh` | Neovim súgó keresése |

**A keresőablakban:** gépelés = szűrés · `Ctrl-j` / `Ctrl-k` vagy nyilak = mozgás · `Enter` = megnyitás · `Ctrl-v` = megnyitás függőleges felosztásban · `Ctrl-s` = vízszintes felosztásban · `Esc` = bezárás

**Fájlon belüli keresés:** `/szöveg` + `Enter`, majd `n` / `N` a következő / előző találat. `*` a kurzor alatti szót keresi.

---

## 7. Kódolás – LSP (Java, Python, Lua)

Akkor működik, ha a fájlhoz csatlakozott language server (jdtls, pyright, lua_ls).

| Billentyű | Funkció |
|---|---|
| `gd` | Ugrás a definícióhoz |
| `gD` | Ugrás a deklarációhoz |
| `Ctrl-o` / `Ctrl-i` | Vissza / előre az ugrások között |
| `K` | Dokumentáció a kurzor alatti elemről |
| `grr` | Hivatkozások (references) |
| `gri` | Implementációk |
| `grt` | Típusdefiníció |
| `grn` vagy `<leader>rn` | Átnevezés (refactor) |
| `gra` vagy `<leader>ca` | Code action (import, gyorsjavítások) |
| `gO` | A fájl szimbólumai (metódusok, osztályok) |
| `Ctrl-s` (beszúrás módban) | Paraméter-súgó |

**Hibák, figyelmeztetések:**

| Billentyű | Funkció |
|---|---|
| `]d` / `[d` | Következő / előző diagnosztika |
| `Ctrl-w d` | Az aktuális sor hibaüzenetének megjelenítése |

---

## 8. Kódkiegészítés – blink.cmp (super-tab)

| Billentyű | Funkció |
|---|---|
| `Tab` | Javaslat elfogadása / snippetben a következő mező |
| `Shift-Tab` | Snippetben az előző mező |
| `Ctrl-n` / `Ctrl-p` vagy nyilak | Mozgás a javaslatok között |
| `Ctrl-Space` | Javaslatlista előhívása |
| `Ctrl-e` | Javaslatlista bezárása |
| `Ctrl-b` / `Ctrl-f` | Dokumentáció görgetése |

SQL fájlokban (DBUI-ból nyitva) a tábla- és oszlopneveket is ajánlja.

---

## 9. Szerkesztés

| Billentyű | Funkció |
|---|---|
| `<leader>cf` | Formázás *(ha átírtad; eredetileg `<leader>f`)* |
| Mentéskor | Automatikus formázás (Python: isort + black, Lua: stylua, egyébként LSP) |
| `Ctrl` + `r` + `+` (Insert módban) | Rendszer vágólap beillesztése |
| `J` / `K` (Visual módban) | Kijelölt sorok mozgatása le / fel |
| `>` / `<` (Visual módban) | Behúzás növelése / csökkentése |

**Hasznos Vim-alapok:** `ciw` szó cseréje · `dd` sor törlése · `yy` sor másolása · `p` beillesztés · `.` utolsó művelet ismétlése · `gg` / `G` fájl eleje / vége · `%` ugrás a párjára (zárójel)

A vágólap közös a rendszerrel (`clipboard = unnamedplus`), a `y` / `p` más programokkal is működik.

---

## 10. Adatbázis – vim-dadbod-ui

| Billentyű | Funkció |
|---|---|
| `<leader>dt` | Adatbázis-panel ki/be |
| `<leader>da` | Új kapcsolat hozzáadása |
| `<leader>df` | Az aktuális lekérdezés-buffer megkeresése a panelen |

**A panelen:** `Enter` = kapcsolat / tábla kinyitása · kapcsolat alatt *New query* = új lekérdezés-buffer · táblán `Enter` = kész lekérdezés-sablonok (pl. *List*, *Columns*)

**Lekérdezés futtatása:** a lekérdezés-bufferben `<leader>S` (normál módban az egész buffert, Visual módban a kijelölést futtatja). Mentésre nem fut le automatikusan.

---

## 11. Jupyter notebook – jupytext + Molten + NotebookNavigator

Az `.ipynb` fájl megnyitáskor automatikusan Python szövegként jelenik meg, a cellákat `# %%` sorok választják el. Mentéskor visszaíródik `.ipynb`-be.

**Első lépés minden munkamenetben:** `<leader>mi` (`:MoltenInit`), és válaszd ki a kernelt (pl. `python3`).

| Billentyű | Funkció |
|---|---|
| `<leader>mi` | Kernel indítása |
| `]h` / `[h` | Következő / előző cella |
| `<leader>x` | Aktuális cella futtatása |
| `<leader>X` | Cella futtatása és ugrás a következőre |
| `<leader>ml` | Aktuális sor futtatása |
| `<leader>me` | Futtatás operátorral (pl. `<leader>me` + `ip` = bekezdés) |
| `<leader>mc` | Cella újrafuttatása |

A kimenet nem nyílik meg magától. Megjelenítés: `:MoltenShowOutput`, elrejtés: `:MoltenHideOutput`. Új cella: írj egy `# %%` sort.

---

## 12. Git – gitsigns

Automatikus: a bal szélen jelölés a módosított sorokon, és az aktuális sor mögött halványan, ki és mikor módosította (blame).

| Parancs | Funkció |
|---|---|
| `:Gitsigns preview_hunk` | A módosítás megmutatása |
| `:Gitsigns reset_hunk` | A módosítás visszavonása |
| `:Gitsigns next_hunk` / `prev_hunk` | Ugrás a következő / előző módosításra |

---

## 13. Karbantartás

| Parancs | Funkció |
|---|---|
| `:Lazy` | Pluginkezelő (`U` frissítés, `S` szinkron, `X` felesleges pluginok törlése) |
| `:Mason` | Language serverek, formázók telepítése |
| `:checkhealth` | Teljes állapotellenőrzés |
| `:checkhealth nvim-treesitter` | Szintaxiskiemelés ellenőrzése |
| `:TSUpdate` | Treesitter parserek frissítése |
| `:LspInfo` vagy `:checkhealth vim.lsp` | Csatlakozott-e a language server |

---

## 14. Config-fájlok

```
~/.config/nvim/
├── init.lua                 ← csak 3 require, ne módosítsd
├── lua/config/
│   ├── options.lua          ← beállítások, leader
│   ├── keymaps.lua          ← saját billentyűk
│   └── lazy.lua             ← pluginkezelő indítása
└── lua/plugins/             ← pluginonként egy fájl
    ├── appearance.lua       (téma, statuszsor, fülek)
    ├── completion.lua       (kódkiegészítés)
    ├── dadbod.lua           (adatbázis)
    ├── editor.lua           (oil, fzf-lua, gitsigns, which-key)
    ├── format.lua           (formázás)
    ├── lsp.lua              (language serverek)
    ├── treesitter.lua       (szintaxiskiemelés)
    ├── molten.lua, jupytext.lua, notebook-navigator.lua
```

**Szabályok:**

- **Új billentyű:** a `keymaps.lua`-ba, vagy a plugin saját fájljában a `keys = { ... }` részbe.
- **Új plugin:** új fájl a `lua/plugins/` mappában, `return { { "szerző/plugin" } }` formában.
- **Módosítás után:** lépj ki és indítsd újra. A `:source` **nem** működik a lazy.nvim-mel.
- **Ha a config elromlik:** `nvim --clean <fájl>` config nélkül nyitja meg a fájlt, így javíthatod.

---

## 15. Hibaelhárítás

| Tünet | Megoldás |
|---|---|
| Egy billentyű nem működik | `:verbose nmap <billentyű>`: mi van rákötve, és honnan |
| „Re-sourcing your config is not supported” | Ne `:source`-olj, indítsd újra a Neovimot |
| Nincs szintaxiskiemelés | `:checkhealth nvim-treesitter`, majd `:TSUpdate` |
| Nincs `gd`, `K` stb. | `:checkhealth vim.lsp`: fut-e a language server? `:Mason`: telepítve van-e? |
| `<leader>x` nem futtat | Elindítottad a kernelt? `<leader>mi` |
| Beragadtál egy mappalistában | `Ctrl-^` vissza az előző bufferre |
