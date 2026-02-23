# Claude Code: Практики настройки для продуктивной работы

> Исследование проведено 2026-02-23. Источники: официальная документация Anthropic,
> анализ текущей конфигурации `~/.claude/`, репозиторий плагинов, community best practices.

---

## Оглавление

1. [Главный принцип: контекстное окно](#1-главный-принцип-контекстное-окно)
2. [CLAUDE.md — что реально работает](#2-claudemd--что-реально-работает)
3. [Hooks — автоматика без надежды на LLM](#3-hooks--автоматика-без-надежды-на-llm)
4. [Skills — доменные знания по требованию](#4-skills--доменные-знания-по-требованию)
5. [Subagents — изоляция контекста](#5-subagents--изоляция-контекста)
6. [MCP-серверы — расширение инструментария](#6-mcp-серверы--расширение-инструментария)
7. [Рабочие процессы по доменам](#7-рабочие-процессы-по-доменам)
8. [Антипаттерны — что вредит](#8-антипаттерны--что-вредит)
9. [Что внедрить сейчас](#9-что-внедрить-сейчас)
10. [Обновление claude-up.sh](#10-обновление-claude-upsh)

---

## 1. Главный принцип: контекстное окно

**Контекстное окно — единственный критический ресурс.** Всё остальное (CLAUDE.md, hooks, skills, memory) — это способы управлять тем, что попадает в контекст и когда.

Правила:
- `/clear` между несвязанными задачами — бесплатный сброс
- `/compact <фокус>` — управляемое сжатие с подсказкой, что сохранить
- Исследование в subagents — не засоряет основной контекст
- CLAUDE.md загружается в **каждое** сообщение — каждая лишняя строка стоит токенов

**Вывод:** всё, что можно убрать из CLAUDE.md без потери качества — убираем.

---

## 2. CLAUDE.md — что реально работает

### Иерархия (все уровни активны одновременно)

| Уровень | Файл | В git? | Назначение |
|---------|------|--------|------------|
| Глобальный | `~/.claude/CLAUDE.md` | Нет | Личные предпочтения, язык, экспертиза |
| Проектный | `<repo>/CLAUDE.md` | Да | Команды, конвенции, архитектура |
| Личный проектный | `~/.claude/projects/<path>/CLAUDE.md` | Нет | Секреты, локальные пути |
| Поддиректория | `<repo>/src/CLAUDE.md` | Да | Узкие правила для подсистемы |
| Memory | `~/.claude/projects/<path>/memory/MEMORY.md` | Нет | Оперативное состояние, накопленные факты |

Также поддерживается импорт: `@path/to/file.md` — подтягивает содержимое файла.

### Секции по убыванию влияния

**1. Commands (высший приоритет)**
Единственная секция, которую все эксперты ставят на первое место. Без неё Claude угадывает команды сборки.

```markdown
## Commands
- Build: `pio run`
- Test: `pytest tests/ -v`
- Lint: `ruff check . && mypy src/`
```

**2. Rules (негативные правила)**
"NEVER do X" — самые надёжно исполняемые инструкции. Эффективнее позитивных.

```markdown
## Rules
- NEVER modify migration files after commit
- NEVER create new files unless absolutely necessary
- Don't add dependencies without asking
```

**3. Conventions (отклонения от стандартов)**
Только то, что Claude не может вывести из кода. Не дублировать стандартные конвенции языка.

**4. Structure (только неочевидное)**
Claude умеет `ls` и `read`. Описывать нужно архитектурные решения, а не содержимое файлов.

**5. Description (1-3 предложения)**
Помогает Claude принимать контекстно-правильные решения.

### Что убрать / не добавлять

- "Write clean code" — Claude и так это делает
- Подробные описания файлов — Claude читает код
- API-документацию — лучше ссылка: "See @docs/api.md"
- Историю проекта — в MEMORY.md
- Секреты — в личный проектный override

---

## 3. Hooks — автоматика без надежды на LLM

Hooks — **детерминистические** действия. В отличие от CLAUDE.md (рекомендательные), hooks гарантируют выполнение.

### Ключевые события

| Event | Когда | Практика |
|-------|-------|----------|
| `PostToolUse` | После Edit/Write | Автоформат (ruff, prettier, gofmt) |
| `PreToolUse` | Перед Edit/Write | Блокировка изменений защищённых файлов |
| `Notification` | Claude ждёт ввода | Desktop-уведомление через `notify-send` |
| `SessionStart` | Начало/возобновление | Инъекция контекста после compaction |
| `Stop` | Claude закончил | Проверка: все ли задачи выполнены |

### Готовые конфиги для внедрения

**Уведомления (глобально, `~/.claude/settings.json`):**
```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [{"type": "command", "command": "notify-send 'Claude Code' 'Permission needed' --urgency=critical"}]
      },
      {
        "matcher": "idle_prompt",
        "hooks": [{"type": "command", "command": "notify-send 'Claude Code' 'Waiting for input'"}]
      }
    ]
  }
}
```

**Автоформат Python (проектный `.claude/settings.json`):**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs -I{} sh -c 'echo {} | grep -q \"\\.py$\" && ruff format {} && ruff check --fix {} || true'"
          }
        ]
      }
    ]
  }
}
```

**Защита файлов от изменений:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | grep -qE '\\.env$|credentials|secrets|\\.lock$' && echo 'BLOCKED: protected file' >&2 && exit 2 || exit 0"
          }
        ]
      }
    ]
  }
}
```

**Реинъекция контекста после compaction:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Reminder: check CLAUDE.md and MEMORY.md for project context.'"
          }
        ]
      }
    ]
  }
}
```

### Три типа hooks

| Тип | Как работает | Когда использовать |
|-----|-------------|-------------------|
| `command` | Запускает shell-команду | Форматирование, блокировки, уведомления |
| `prompt` | Одиночный LLM-вызов (Haiku) | Мягкая оценка: "все задачи выполнены?" |
| `agent` | Субагент с доступом к инструментам | Верификация: "тесты проходят?" |

---

## 4. Skills — доменные знания по требованию

Skills загружаются только когда нужны (в отличие от CLAUDE.md, который всегда в контексте). Это ключевое преимущество для доменных знаний.

### Структура

```
.claude/skills/<name>/SKILL.md
```

### Примеры для твоего профиля

**Workflow: создание PR (`.claude/skills/make-pr/SKILL.md`):**
```markdown
---
name: make-pr
description: Create a PR from current changes
disable-model-invocation: true
---
Create a PR for current changes: $ARGUMENTS

1. Run tests and ensure they pass
2. Create a descriptive commit
3. Push to remote
4. Create PR via `gh pr create`
```

**Доменное знание: Robonomics contracts:**
```markdown
---
name: robonomics-contracts
description: Robonomics v5 contract architecture and addresses
user-invocable: false
---
# Robonomics v5 Contracts
- Factory: 0x...
- Lighthouse: 0x...
- XRT: 0x...
[контрактная архитектура, ABI-специфика]
```

**Динамический контекст в skills:**
```markdown
## Current State
- Branch: !`git branch --show-current`
- Last commit: !`git log --oneline -1`
- Uncommitted: !`git status --short`
```

### `disable-model-invocation` vs `user-invocable`

| Настройка | Кто вызывает | Для чего |
|-----------|-------------|----------|
| По умолчанию | Ты + Claude | Общие знания/воркфлоу |
| `disable-model-invocation: true` | Только ты (`/name`) | Действия с побочными эффектами (deploy, commit) |
| `user-invocable: false` | Только Claude | Фоновые знания (Claude подтянет когда нужно) |

---

## 5. Subagents — изоляция контекста

Субагенты работают в отдельном контексте и возвращают сводку. Основное применение — **не засорять главный контекст исследованием**.

### Определение (`.claude/agents/<name>.md`):

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob, Bash
model: sonnet
---
You are a security engineer. Review for:
- Injection vulnerabilities
- Auth flaws
- Secrets in code
- Insecure data handling
```

### Выбор модели

| Модель | Для чего | Стоимость |
|--------|----------|-----------|
| `haiku` | Простые проверки, повторяющиеся задачи | Дёшево, быстро |
| `sonnet` | Ревью, анализ (рекомендуемый default) | Баланс |
| `opus` | Сложные миграции, архитектурные решения | Дорого, тщательно |

### Паттерн Writer/Reviewer

Сессия A (пишет код) → Сессия B (ревьюит с чистым контекстом). Чистый контекст = объективный ревью, без предвзятости к своему коду.

---

## 6. MCP-серверы — расширение инструментария

MCP подключают внешние сервисы. Конфиг: `.mcp.json` в корне проекта или через `claude mcp add`.

### Полезные серверы

| Сервер | Ценность | Конфиг |
|--------|---------|--------|
| **context7** | Актуальная документация библиотек | `{"command": "npx", "args": ["-y", "@upstash/context7-mcp"]}` |
| **GitHub MCP** | Issues, PRs (дополнение к `gh` CLI) | `{"type": "http", "url": "https://api.githubcopilot.com/mcp/"}` |
| **Puppeteer** | Скриншоты, PDF из HTML | `{"command": "npx", "args": ["-y", "@anthropic-ai/puppeteer-mcp"]}` |

### Рекомендация по MCP

Не злоупотреблять. Официальная позиция Anthropic: предпочтительнее CLI-инструменты (`gh`, `aws`, `gcloud`). MCP нужен как шлюз данных, а не зеркало API. Если задача решается через `gh pr list` — MCP не нужен.

---

## 7. Рабочие процессы по доменам

### Embedded / Hardware (PlatformIO, ESP-IDF, STM32)

**Что хорошо работает:**
- Итеративный цикл: `pio run` → ошибка → фикс → повтор
- Генерация и ревью C/C++ кода
- Парсинг линкер-ошибок
- Написание host-тестов (Unity, CMock)

**Что не работает:**
- Нет взаимодействия с железом (JTAG, serial monitor)
- Регистры нишевых MCU — галлюцинации без даташита
- Timing constraints для FPGA

**Ключевое правило:** положи даташит/reference manual как текстовый файл в `docs/` и укажи в CLAUDE.md:
```markdown
Reference: @docs/stm32f4_reference_spi.txt
```

### 3D-моделирование (OpenSCAD, KiCad)

**OpenSCAD — идеальный формат.** Текстовый, параметрический, проверяемый:
```markdown
## Commands
- Syntax check: `openscad -o /dev/null src/main.scad`
- Render STL: `openscad -o build/output.stl src/main.scad`
```

**KiCad** — файлы `.kicad_sch` и `.kicad_pcb` текстовые (S-expressions), Claude может их читать и редактировать. Но автороутинг и визуальная верификация — только руками.

**Принцип: текст побеждает.** OpenSCAD > Fusion360, KiCad > Altium, LaTeX > Word.

### Сети и IoT (MQTT, ESPHome, Home Assistant)

**ESPHome** — YAML-конфиги, валидация через `esphome config device.yaml`, компиляция через `esphome compile`.

**Home Assistant** — все YAML, Claude отлично пишет автоматизации и Jinja2.

**Валидация:** `nginx -t`, `iptables-restore --test`, `esphome config` — всё работает через Bash.

**Сетевую топологию описывай текстом в CLAUDE.md:**
```markdown
## Network
- VLAN 10: Management (10.0.10.0/24)
- VLAN 20: IoT (10.0.20.0/24, isolated)
- MQTT: mqtt://10.0.10.1:1883
```

### Документы и papers (LaTeX, ReportLab)

**Правило: одно предложение на строку в .tex.** Позволяет Claude точно редактировать через Edit tool и даёт чистые git-диффы.

**BibTeX из DOI (точнее чем из памяти):**
```bash
curl -sLH "Accept: application/x-bibtex" https://doi.org/10.1109/RED-UAS.2017.8101645
```

---

## 8. Антипаттерны — что вредит

### "Kitchen sink session"
Начал с одной задачи, перешёл на другую, вернулся. Контекст забит мусором.
→ **Лечение:** `/clear` между задачами.

### "Correction loop"
Поправил Claude, снова не так, снова поправил. Контекст отравлен неудачными попытками.
→ **Лечение:** после 2 неудачных коррекций — `/clear` + новый, улучшенный промпт.

### "Bloated CLAUDE.md"
CLAUDE.md на 300+ строк. Claude игнорирует часть инструкций — важные правила тонут в шуме.
→ **Лечение:** для каждой строки: "Если убрать — Claude ошибётся?" Нет → удалить.

### "Бесконечное исследование"
"Investigate this" без скоупа. Claude читает сотни файлов, заполняя контекст.
→ **Лечение:** узкий скоуп или subagents.

### "Cargo-culted CLAUDE.md"
Скопировал чужой CLAUDE.md целиком. Чужие конвенции, чужая структура.
→ **Лечение:** начни пустым, добавляй реактивно (когда Claude ошибается).

### ".claude/ полностью в .gitignore"
Текущее поведение `claude-up.sh`. Блокирует шаринг `settings.json` и `skills/` с командой.
→ **Лечение:** гранулярный .gitignore (см. раздел 10).

---

## 9. Что внедрить сейчас

### Приоритет 1 — Сразу (минуты)

- [ ] **Notification hooks** в `~/.claude/settings.json` — `notify-send` при ожидании ввода
- [ ] **Добавить Rules в шаблон** `claude-up.sh` — секция для негативных правил
- [ ] **Сократить глобальный CLAUDE.md** — убрать Research Background, Key Projects, Migration Note (→ экономия ~35 строк контекста на каждый запрос)

### Приоритет 2 — Эту неделю (часы)

- [ ] **Обновить claude-up.sh** — гранулярный .gitignore, создание `.claude/settings.json` (team-shared), шаблон skills
- [ ] **Создать skills** для частых воркфлоу: `/make-pr`, `/check-profit`, `/build-pdf`
- [ ] **Настроить hooks** по проектам: autoformat (ruff для Python, prettier для JS), защита .env

### Приоритет 3 — По мере работы (дни)

- [ ] **MCP context7** для hardware-проектов (PlatformIO, ESP-IDF документация)
- [ ] **Custom subagents** — security-reviewer, code-reviewer
- [ ] **Доменные CLAUDE.md шаблоны** — embedded, OpenSCAD, KiCad, LaTeX, IoT (детектировать в claude-up.sh)
- [ ] **SessionStart hook** для реинъекции контекста после compaction

---

## 10. Обновление claude-up.sh

Рекомендации по улучшению скрипта на основе исследования:

### Гранулярный .gitignore

```
# Claude Code (local only)
.claude/settings.local.json
.claude/hookify.*.local.md
# Shared: .claude/settings.json, .claude/skills/, .claude/agents/
```

### Добавить Rules в шаблон CLAUDE.md

```markdown
## Rules
TODO: Что Claude НИКОГДА не должен делать в этом проекте
```

### Создавать `.claude/settings.json` (team-shared)

Для команд, использующих общий код. Пустой `{}` как стартовая точка (аналогично `.local`).

### Создавать `.claude/skills/` директорию

Подготовить структуру для будущих skills.

### Детектирование типа проекта

По наличию `platformio.ini`, `*.scad`, `*.kicad_pro`, `main.tex`, `Cargo.toml` — генерировать соответствующий шаблон CLAUDE.md с правильными командами.

---

## Источники

- [Best Practices — Claude Code Docs](https://code.claude.com/docs/en/best-practices)
- [Automate workflows with hooks](https://code.claude.com/docs/en/hooks-guide)
- [How I Use Every Claude Code Feature — Shrivu Shankar](https://blog.sshh.io/p/how-i-use-every-claude-code-feature)
- [Claude Code Tips: 10 Real Productivity Workflows](https://www.f22labs.com/blogs/10-claude-code-productivity-tips-for-every-developer/)
- [GitHub: claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
- [50 Claude Code Tips — Geeky Gadgets](https://www.geeky-gadgets.com/claude-code-tips-2/)
- [SFEIR Institute — Claude Code Best Practices](https://institute.sfeir.com/en/claude-code/claude-code-resources/best-practices/)
- [Mastering the Vibe — Medium](https://dinanjana.medium.com/mastering-the-vibe-claude-code-best-practices-that-actually-work-823371daf64c)
- [Claude Code Hooks Examples — aiorg.dev](https://aiorg.dev/blog/claude-code-hooks)
- [How I use Claude Code — builder.io](https://www.builder.io/blog/claude-code)
- Локальный анализ: `~/.claude/`, plugins marketplace, существующие проекты
