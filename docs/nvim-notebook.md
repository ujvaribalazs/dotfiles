# Notebook munka Neovimben — kézikönyv

Molten (Jupyter kernel) + NotebookNavigator (cellák) + jupytext (.ipynb) + image.nvim (ábrák).

Konfig fájlok:
- `lua/plugins/molten.lua` — molten, image.nvim, megjelenés, output-billentyűk
- `lua/plugins/notebook-navigator.lua` — cellák futtatása, mozgás, szerkesztés
- `lua/plugins/jupytext.lua` — .ipynb megnyitása `# %%` formában
- `lua/config/options.lua` — `vim.g.python3_host_prog` (a Neovim saját venv-je)

---

## 1. Gyors kezdés

1. Nyiss meg egy `.py` vagy `.ipynb` fájlt.
2. `<leader>mi` → válaszd ki a kernelt (pl. a projekt venv-jét).
3. Írj cellákat `# %%` jelölőkkel.
4. `<leader>X` → futtatja a cellát, az output felugró ablakban látszik.
5. `ú` → következő cella, és így tovább.

## 2. Cellák

Egy cella a `# %%` sortól a következő `# %%`-ig tart. A fájl eleje is cellának számít.

```python
# %% [markdown]
# beszúrni a <leader>mM billentyűkombinációval lehet
# # Elemzés
# Ez markdown cella, nem fut le.

# %%
import pandas as pd
df = pd.read_csv("adat.csv")

# %%
df.describe()
```

## 3. Billentyűk

### Mozgás

| Billentyű | Mit csinál |
|---|---|
| `ú` / `ő` | következő / előző `# %%` cella (bármelyik, futtatott vagy nem) |
| `Ú` / `Ő` | következő / előző **lefuttatott** cella, outputtal a popupban |

(`ő`, `ú` = ahol angol billentyűzeten a `[` és `]` van.)
Ugrás után a cella a képernyő tetejére görgetődik (`zt`), így alatta látszik az output.
Kézi igazítás: `zt` tetejére, `zz` középre, `zb` aljára.

### Futtatás

| Billentyű | Mit csinál |
|---|---|
| `<leader>X` | cella futtatása + output popupban (a kurzor marad) |
| `<leader>x` | cella futtatása (csak virtuális output a cella alatt) |
| `<leader>mm` | futtatás és ugrás a következő cellára |
| `<leader>ma` | összes cella futtatása |
| `<leader>mj` | ez és az összes alatta lévő cella |
| `<leader>ml` | aktuális sor futtatása |
| `<leader><CR>` (vizuális mód) | kijelölés futtatása |
| `<leader>me` + mozgás | operátorral kijelölt rész futtatása (pl. `<leader>meip` = bekezdés) |
| `<leader>mc` | cella újrafuttatása (a molten-cella, az új kóddal) |

### Output

| Billentyű | Mit csinál |
|---|---|
| `<leader>o` | output megnyitása **és belépés** (görgetéshez) |
| `q` vagy `Esc` | kilépés / bezárás a popupban |
| `<leader>mh` | output popup elrejtése |
| `<leader>mb` | output böngészőben (pandas táblákhoz ideális) |
| `<leader>my` | output vágólapra |
| `<leader>md` | aktuális cella outputjának törlése |
| `<leader>mD` | a buffer **összes** outputjának törlése |

A popupban bent: `j/k`, `Ctrl-d/u`, `gg/G`, `/keresés`, vízszintesen `zh/zl`.

### Cellák szerkesztése

| Billentyű | Mit csinál |
|---|---|
| `<leader>mn` / `<leader>mN` | új cella alá / fölé |
| `<leader>mS` | cella kettévágása a kurzornál |
| `<leader>mM` | markdown cella beszúrása |
| `<leader>mk` / `<leader>mJ` | cella mozgatása fel / le |

### Kernel

| Billentyű | Mit csinál |
|---|---|
| `<leader>mi` | kernel indítása |
| `<leader>mx` | futás megszakítása (végtelen ciklus, lassú cella) |
| `<leader>mR` | kernel újraindítása, összes output törlése |

### Mentés, ipynb

| Billentyű | Mit csinál |
|---|---|
| `<leader>ms` / `<leader>mL` | outputok mentése / visszatöltése (JSON) |
| `<leader>mE` | outputok beírása a .ipynb fájlba |
| `<leader>mI` | outputok betöltése a .ipynb fájlból |

Ha which-key van telepítve: `<leader>m` után kilistázza a lehetőségeket.

## 4. Tipikus munkamenetek

**Egyszerű script cellákkal**
`<leader>mi` → `<leader>X` → `ú` → `<leader>X` → ...
Visszanézés: `Ő` / `Ú` lapoz a korábbi outputok között.

**Hosszú pandas tábla**
- `<leader>o` → belépsz és görgetsz, `q`-val ki.
- Kényelmesebb: `<leader>mb` → böngészőben rendes táblázatként.
- Vagy kevesebbet írass ki: `df.head(20)`, `pd.set_option("display.max_rows", 30)`.

**Meglévő .ipynb notebook**
1. Nyisd meg az `.ipynb`-t → a jupytext `# %%` formában mutatja.
2. `<leader>mi`, majd `<leader>mI` → a notebookban mentett outputok betöltése.
3. Dolgozol, mentés (`:w`) → a jupytext visszaírja ipynb-be.
4. `<leader>mE` → az új outputok is bekerülnek a notebookba.

**Lassú számítás nem áll le**
`<leader>mx` (megszakítás). Ha a kernel beragadt: `<leader>mR`.

## 5. Jó tudni

- Az outputok csak a futó sessionben élnek. Nvim bezárása vagy kernel restart után eltűnnek, kivéve ha mented (`<leader>ms` vagy `<leader>mE`).
- A popup csak addig látszik, amíg a kurzor a cellában van. Kilépsz a cellából → bezárul. A virtuális (cella alatti) output megmarad.
- A popup a futás közben élőben frissül, a keret zöld = siker, piros = hiba.
- Ábrák csak **kitty** terminálban jelennek meg (és kell az `imagemagick`). Más terminálban az ábrák nem látszanak, a szöveges output igen.

## 6. Hibaelhárítás

| Tünet | Megoldás |
|---|---|
| „Molten is not initialized” | `<leader>mi` |
| Konfig módosítás nem hat | a molten indításkor olvassa a beállításokat: nvim teljes újraindítása, majd új `<leader>mi` |
| Molten parancs nem létezik | `:UpdateRemotePlugins`, majd nvim újraindítás |
| Hiányzó python csomag | `:checkhealth molten` |
| Rossz kernel / nincs a listában | a projekt venv-jében: `pip install ipykernel` és `python -m ipykernel install --user --name projektnev` |
| Popup felvillan és eltűnik | csak `<leader>o`-val lépj be, ne kézi `:MoltenEnterOutput`-tal |
| Virtuális output rossz helyen / számozása nem egyezik a popuppal | `molten_virt_lines_off_by_1 = false` legyen (`# %%` celláknál kötelező), majd `<leader>mD` a régi outputok törlésére |
| Ugrás után nem látszik a cella | `ú`/`ő`/`Ú`/`Ő` görget; kézzel `zt` |
| Beállítások ellenőrzése | `:lua print(vim.g.molten_virt_text_output, vim.g.molten_image_provider)` → `true image.nvim` |

## 7. Telepítés (új gépen)

```bash
# Neovim saját python környezete
python3 -m venv ~/.virtualenvs/neovim
~/.virtualenvs/neovim/bin/pip install pynvim jupyter_client nbformat pillow

# jupytext parancs
pipx install jupytext

# ábrákhoz
sudo apt install kitty imagemagick

# projekt venv-ben
pip install ipykernel
python -m ipykernel install --user --name projektnev
```

Nvim-ben: `:Lazy sync` → `:UpdateRemotePlugins` → újraindítás → `:checkhealth molten`.
