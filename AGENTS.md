# AGENTS.md — Guide for AI Agents

## 🥓 What is Baconshell?

**Baconshell** is a lightweight desktop shell written in **QML** using [Quickshell](https://quickshell.org/), specifically designed for the **niri** Wayland compositor (by YaLTeR).

### Project Architecture

```
baconshell/
├── shell.qml              # Main entry point (ShellRoot)
├── shell.nix              # Nix development environment
├── Commons/               # Shared components (colors, styles)
│   ├── Color.qml
│   └── Style.qml
├── Modules/               # Functional modules of the shell
│   ├── Bar/               # Main status bar
│   │   ├── Bar.qml
│   │   ├── Extras/        # Decorative components (pill, workspace item...)
│   │   └── Widgets/       # Bar widgets (battery, clock, network...)
│   ├── Background.qml     # Wallpaper (loads from ~/.config/background)
│   ├── IdleManager.qml    # Idle manager with caffeine mode
│   ├── OSD.qml            # OSD popup — handles volume + brightness, icon + progress bar + label
│   ├── Polkit.qml         # Polkit authentication agent
│   └── Notifications/     # Notification daemon
├── Services/              # Background services
│   └── Brightness.qml     # Brightness control (upower/brightnessctl)
└── Widgets/               # Reusable widgets
    ├── StyledButton.qml
    └── StyledText.qml
```

### Main Features

- Status bar with system widgets (battery, brightness, clock, network, sound, player, window title, workspaces, system tray)
- Automatic wallpaper change from `~/.config/background`
- Idle manager with caffeine mode
- Polkit agent for authentication
- Notification daemon
- Volume OSD
- Brightness OSD
- Lock screen (work in progress)

### Requirements

- Quickshell ≥ 0.3.0
- niri
- `upower` and `brightnessctl` (laptop only)
- `libnotify` for internal notifications

---

## 📚 Quickshell Documentation

Quickshell is the framework powering this project. All official documentation can be found at:

| Resource | URL |
|----------|-----|
| **Official website** | https://quickshell.org/ |
| **Documentation** | https://quickshell.org/docs/ |
| **Repository** | https://github.com/dynobo/quickshell |
| **Quickshell Shell Components** | https://github.com/quickshell/quickshell-shell-components |

### Key APIs used by Baconshell

- **Quickshell API**: `Quickshell.screens`, `Quickshell.shell()` — runtime access
- **ShellRoot**: root shell component
- **ShellScreen**: represents an individual screen
- **Variants**: creates per-screen instances
- **Scope**: scoped context with inherited properties per screen

The QML types exposed by Quickshell (`ShellRoot`, `ShellScreen`, `Quickshell` namespace, etc.) are documented in the [official Quickshell documentation](https://quickshell.org/docs/).

---

## 🛠️ Project Conventions

- **Import namespace**: `import qs.Modules`, `import qs.Modules.Bar`, etc. (resolved via Nix)
- **Style**: QML with 4-space indentation
- **Pragma**: `//@ pragma UseQApplication` in `shell.qml`
- **Colors & styles**: centralized in `Commons/Color.qml` and `Commons/Style.qml`

---

## ⚠️ Important: Modifying the Codebase

**Any agent making changes to the code MUST keep the project architecture consistent.**

When adding, modifying, or removing functionality, consider:

1. **Where the new/changed code belongs** — `Modules/` for functional shell components, `Widgets/` for reusable UI components, `Services/` for background services, `Commons/` for shared assets (colors, styles, utilities).
2. **Update `shell.qml`** — any new module or service must be imported and instantiated in the main entry point.
3. **Maintain the import namespace** — all modules are imported under `qs.Modules.*`. Do not break this convention.
4. **Follow existing patterns** — match the coding style, component structure, and naming conventions of the existing codebase.
5. **Update this file** — if a new module, widget, or service is added, update the architecture diagram and descriptions in this `AGENTS.md` file so future agents have an accurate overview.

In short: **every change must be reflected in the project's architecture as a whole.** Never modify code in isolation — always consider how it fits into the overall structure.
