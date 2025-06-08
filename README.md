
# dotfiles - Setup WezTerm + PowerShell + Neovim no Windows

Este repositório contém minha configuração pessoal para desenvolvimento no Windows utilizando WezTerm, PowerShell e Neovim.

---

## 🖥️ 1. Instalação do WezTerm

- Download: https://wezfurlong.org/wezterm/install/windows.html

---

## ⚙️ 2. Configuração do WezTerm

1. Execute o WezTerm uma vez para gerar a pasta de configuração:
   - C:\Users\SeuUsuario\AppData\Local\wezterm

2. Crie ou edite o arquivo wezterm.lua nessa pasta.

### Exemplo de configuração:

```lua
local wezterm = require 'wezterm'

return {
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 12.0,
  color_scheme = "Catppuccin Mocha",
  default_prog = {
    "pwsh.exe", "-NoLogo", "-NoExit",
    "-Command",
    "oh-my-posh init pwsh --config 'C:\\Users\\SeuUsuario\\oh-my-posh\\agnoster.omp.json' | Invoke-Expression"
  },
  enable_tab_bar = false,
  window_background_opacity = 0.95,
  window_padding = { left = 10, right = 10, top = 10, bottom = 10 },
}
```

3. Baixe e instale uma Nerd Font:
- https://www.nerdfonts.com/font-downloads (Ex.: FiraCode Nerd Font)

---

## 🔧 3. Instalação do PowerShell 7

- Download: https://github.com/PowerShell/PowerShell/releases

---

## 🎨 4. PowerShell + Oh My Posh

1. Instale o Oh My Posh:
```
winget install JanDeDobbeleer.OhMyPosh
```

2. Instale uma Nerd Font.

3. Configure o tema temporariamente:
```
oh-my-posh init pwsh --config "$(oh-my-posh get shell --shell pwsh --config)" | Invoke-Expression
```

4. Para tornar permanente, edite seu perfil do PowerShell:
```
notepad $PROFILE
```

Adicione no arquivo aberto:
```
oh-my-posh init pwsh --config "C:\Program Files\oh-my-posh\themes\catppuccin_mocha.omp.json" | Invoke-Expression
```

---

## 🔌 5. Winget

- Verifique se o App Installer está instalado pela Microsoft Store.
- Ou baixe diretamente: https://github.com/microsoft/winget-cli/releases

---

## 📝 6. Instalação do Neovim

1. Download (versão stable): https://github.com/neovim/neovim/releases

2. Instale ou extraia a versão portátil.

3. Se necessário, adicione o Neovim ao PATH:
   - Exemplo: C:\nvim\bin

---

## 📂 7. Configuração do Neovim

1. Crie a pasta de configuração:
   - C:\Users\SeuUsuario\AppData\Local\nvim\

2. Crie o arquivo init.lua dentro dessa pasta.

---

## 🚀 8. Configuração do Lazy.nvim + LSP para Python

1. Clone o gerenciador de plugins lazy.nvim:
```
git clone https://github.com/folke/lazy.nvim.git `
  "$env:LOCALAPPDATA\nvim-data\lazy\lazy.nvim"
```

2. Certifique-se de que seu init.lua referencia esse caminho:
```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
```

3. Adicione os plugins necessários ao lazy.setup({ ... }):
   - LSP: nvim-lspconfig
   - Autocompletar: nvim-cmp, cmp-nvim-lsp, LuaSnip, cmp_luasnip
   - Syntax highlight: nvim-treesitter

4. Instale e configure o servidor LSP para Python:
```
pip install 'python-lsp-server[all]'
```

5. Configure o LSP no seu init.lua:
```lua
local lspconfig = require("lspconfig")
lspconfig.pylsp.setup({})
```

6. Use Treesitter para destacar Python:
```lua
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", ... },
  highlight = { enable = true },
  indent = { enable = true },
})
```

---

## 🧪 9. Plugins adicionais recomendados para Python

- nvim-lint: para linting com flake8/pylint
- null-ls.nvim: para integração com formatadores (black, isort, etc.)

---

## ⌨️ 10. Atalhos no Windows (opcional)

- Crie um atalho do WezTerm na área de trabalho.
- Configure para iniciar no diretório de projetos.

---

## ✅ 11. Checklist Final

- [x] WezTerm instalado e configurado
- [x] Nerd Font aplicada
- [x] PowerShell 7 + Oh My Posh com tema funcionando
- [x] Neovim instalado com init.lua funcional
- [x] Plugins instalados via lazy.nvim
- [x] LSP Python funcionando com pylsp
- [x] Syntax Highlight e Indentação Python com Treesitter
- [x] Terminal embutido no Neovim funcionando (ToggleTerm)

---

## 🚀 Sobre este repositório

Este repositório existe para versionar e compartilhar minha configuração pessoal, mantendo consistência no ambiente de desenvolvimento e facilitando o setup em novos dispositivos.
