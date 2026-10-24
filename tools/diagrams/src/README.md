# Diagram Source Files

Mermaid source files (`.mmd`) for all pipeline diagrams. These are the source of truth.
Generated PNGs live in `../output/` (gitignored) and are uploaded to Squarespace.

## Generate PNGs

```bash
# All diagrams
./tools/diagrams/generate.sh

# Single diagram
./tools/diagrams/generate.sh tools/diagrams/src/my-diagram.mmd
```

## Editing Labels

Open any `.mmd` file and edit the text on arrow lines or node labels. Then regenerate.

```
# Before
C->>A: POST /token with code + code_verifier (back channel)

# After
C->>A: POST /token (back channel)
```

## Changing Font Size and Family

Add an `%%{init}%%` block at the top of the `.mmd` file before the diagram type declaration.

```
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontSize": "16px",
    "fontFamily": "Arial"
  }
}}%%
sequenceDiagram
    ...
```

### Key theme variables for sequence diagrams

| Variable | What it controls |
|---|---|
| `fontSize` | Overall font size |
| `fontFamily` | Font (Arial, Helvetica, etc.) |
| `actorFontSize` | Participant box labels |
| `messageFontSize` | Arrow label text |
| `noteFontSize` | Note block text |

## Adding a New Diagram

1. Create a new `.mmd` file in this folder
2. Write the Mermaid source (see existing files as reference)
3. Run `./tools/diagrams/generate.sh` to generate the PNG
4. Reference the PNG filename in the Sage draft with: `*[Diagram: filename.png]*`

## Prerequisites

mermaid-cli must be installed:

```bash
npm install -g @mermaid-js/mermaid-cli
# verify: mmdc --version
```
