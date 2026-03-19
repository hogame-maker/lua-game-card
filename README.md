# Lua Game Card 🎮

Um jogo de cartas desenvolvido em **Lua** com **LÖVE 2D** framework.

## 📋 Descrição

Lua Game Card é um jogo de cartas estratégico onde os jogadores enfrentam monstros, coletam tesouros e gerenciam seus decks. O jogo oferece um sistema completo de saves, UI interativa e gameplay envolvente.

## 🎨 Recursos

- ✨ **Interface Polida**: Botões com animações suaves e efeitos de hover
- 💾 **Sistema de Saves**: Seleção de 3 save slots com histórico de tempo jogado
- 🃏 **Cartas Variadas**: Monstros, tesouros e eventos com efeitos únicos
- ⚔️ **Sistema de Combate**: Sistema de turno com regras equilibradas
- 🎯 **Gerenciador de Deck**: Organize e customize seus decks
- 📊 **Gerenciador de Banco de Dados**: Sistema persistente de dados

## 🗂️ Estrutura do Projeto

```
Lua game card/
├── conf.lua                 # Configuração do LÖVE
├── main.lua                 # Arquivo principal
├── json.lua                 # Biblioteca JSON
├── assets/                  # Recursos do jogo
│   └── cards/               # Imagens das cartas
├── data/                    # Dados persistentes
│   ├── cards_db.json        # Banco de dados de cartas
│   ├── cards_db.lua         # Cartas em formato Lua
│   └── db_manager.lua       # Gerenciador de banco de dados
├── game/                    # Lógica do jogo
│   ├── card.lua             # Classe Card
│   ├── combat_system.lua    # Sistema de combate
│   ├── deck_manager.lua     # Gerenciador de decks
│   ├── game_state.lua       # Estado do jogo
│   ├── player.lua           # Classe Player
│   ├── rule_engine.lua      # Motor de regras
│   ├── turn_manager.lua     # Gerenciador de turnos
│   └── cards/               # Tipos de cartas
│       ├── event_card.lua
│       ├── monster_card.lua
│       └── treasure_card.lua
├── ui/                      # Interface do usuário
│   ├── button.lua           # Componente Button
│   ├── modal.lua            # Modal de seleção de saves
│   ├── save_slot.lua        # Slot de save
│   └── ui_manager.lua       # Gerenciador de UI
├── imagecard/               # Imagens e backgrounds
├── screens/                 # Capturas de tela (preview)
└── .git/                    # Repositório Git
```

## 🚀 Como Começar

### Requisitos

- LÖVE 2D 11.4+ ([Download aqui](https://love2d.org/))
- Lua 5.1+

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/lua-game-card.git
cd lua-game-card
```

2. Execute o jogo:
```bash
love .
```

## 🎮 Como Jogar

1. Inicie o jogo e clique em "Iniciar Game"
2. Selecione ou crie um novo save (3 slots disponíveis)
3. Gerencie seu deck e participe de combates
4. Use botão "Voltar" para retornar ao menu

## 🛠️ Tecnologia

- **Linguagem**: Lua
- **Engine**: LÖVE 2D
- **Formato de Dados**: JSON/Lua
- **Controle de Versão**: Git

## 📝 Funcionalidades Principais

### Interface
- Splash screen inicial
- Tela de login com botões estilizados
- Modal de seleção de saves com animações

### Gameplay
- Sistema de cartas com múltiplos tipos
- Combate por turno
- Gerenciamento de deck
- Persistência de dados

### UI Components
- Botões interativos com hover effects
- Save slots com expansão ao hover
- Modal fullscreen com overlay
- Sistema de fade in/out

## 🔄 Histórico de Versões

Consulte o [histórico de commits](https://github.com/seu-usuario/lua-game-card) para detalhes de todas as mudanças.

## 📦 Commits Recentes

- `3735e0b` - Add screens folder for preview images
- `4198f9a` - Zerar horas de saves e adicionar botao voltar no modal
- `e747424` - Add save selection modal with expandable save slots
- `3d52942` - Make buttons black and stack them vertically centered

## 🤝 Contribuindo

Sinta-se livre para fazer fork, criar branches e enviar pull requests com melhorias!

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 👨‍💻 Autor

Desenvolvido com ❤️ em Lua

---

**Divirta-se jogando!** 🎮✨
