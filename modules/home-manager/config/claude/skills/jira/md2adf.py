"""Core converter: Markdown → Atlassian Document Format (ADF).

Uses mistune's AST mode to parse markdown, then walks the token tree
to produce ADF. The key insight is that ADF uses flat marks on text nodes
while markdown uses nested structure — so we recursively accumulate marks
and flatten them onto leaf text nodes.
"""

import sys
from typing import Any, Dict, List, Optional

import mistune


_md = mistune.create_markdown(renderer=None, plugins=["table", "strikethrough"])


def convert(markdown: str) -> Dict[str, Any]:
    """Convert a markdown string to an ADF document."""
    if not markdown or not markdown.strip():
        return {"version": 1, "type": "doc", "content": []}

    tokens = _md(markdown)
    content = _convert_blocks(tokens)

    return {"version": 1, "type": "doc", "content": content}


# Languages Jira's ADF codeBlock accepts. Anything not in this set (or a known
# alias for one of them) is omitted so Jira doesn't reject the whole comment.
_JIRA_LANGUAGES = {
    "abap", "actionscript", "ada", "applescript", "arduino", "autoit",
    "bash", "c", "clojure", "coffeescript", "coldfusion", "cpp", "css",
    "delphi", "diff", "elixir", "erlang", "fortran", "foxpro", "go",
    "graphql", "groovy", "haskell", "html", "java", "javascript",
    "jsx", "kotlin", "latex", "lisp", "livescript", "lua", "mathematica",
    "matlab", "mermaid", "nasm", "nginx", "objective-c", "objectivec",
    "perl", "php", "powershell", "prolog", "puppet", "python", "qml", "r",
    "racket", "rst", "ruby", "rust", "scala", "shell", "sh", "smalltalk",
    "sql", "swift", "tcl", "terraform", "toml", "tsx", "typescript", "vb",
    "vbnet", "verilog", "vhdl", "vim", "visualbasic", "xml", "xquery",
    "yaml", "zsh",
}

_LANGUAGE_ALIASES: Dict[str, str] = {
    "js": "javascript",
    "ts": "typescript",
    "py": "python",
    "rb": "ruby",
    "rs": "rust",
    "kt": "kotlin",
    "yml": "yaml",
    "sh": "shell",
    "zsh": "shell",
    "bash": "shell",
    "json": "javascript",   # Jira doesn't support json — javascript is close enough
    "jsonc": "javascript",
}


def _normalise_language(info: str) -> str:
    """Map a fenced-code info string to a Jira-accepted language, or return '' to omit."""
    lang = info.strip().lower()
    lang = _LANGUAGE_ALIASES.get(lang, lang)
    return lang if lang in _JIRA_LANGUAGES else ""


def _convert_blocks(tokens: List[Dict]) -> List[Dict]:
    result = []
    for token in tokens:
        node = _convert_block(token)
        if node is not None:
            if isinstance(node, list):
                result.extend(node)
            else:
                result.append(node)
    return result


def _convert_block(token: Dict) -> Optional[Any]:
    t = token["type"]

    if t == "paragraph":
        content = _convert_inlines(token["children"])
        if content:
            return {"type": "paragraph", "content": content}
        return None

    if t == "heading":
        level = token["attrs"]["level"]
        content = _convert_inlines(token["children"])
        node = {"type": "heading", "attrs": {"level": level}}
        if content:
            node["content"] = content
        return node

    if t == "block_code":
        raw = token.get("raw", "")
        info = token.get("attrs", {}).get("info")
        node = {"type": "codeBlock"}
        if info:
            lang = _normalise_language(info)
            if lang:
                node["attrs"] = {"language": lang}
        node["content"] = [{"type": "text", "text": raw}]
        return node

    if t == "block_quote":
        content = _convert_blocks(token["children"])
        if content:
            return {"type": "blockquote", "content": content}
        return None

    if t == "list":
        ordered = token["attrs"].get("ordered", False)
        list_type = "orderedList" if ordered else "bulletList"
        items = []
        for child in token["children"]:
            if child["type"] == "list_item":
                item_content = _convert_list_item(child)
                items.append({"type": "listItem", "content": item_content})
        return {"type": list_type, "content": items}

    if t == "thematic_break":
        return {"type": "rule"}

    if t == "table":
        return _convert_table(token)

    return None


def _convert_list_item(token: Dict) -> List[Dict]:
    result = []
    for child in token["children"]:
        if child["type"] == "block_text":
            content = _convert_inlines(child["children"])
            if content:
                result.append({"type": "paragraph", "content": content})
        elif child["type"] == "paragraph":
            content = _convert_inlines(child["children"])
            if content:
                result.append({"type": "paragraph", "content": content})
        elif child["type"] == "list":
            result.append(_convert_block(child))
        else:
            block = _convert_block(child)
            if block is not None:
                if isinstance(block, list):
                    result.extend(block)
                else:
                    result.append(block)
    return result


def _convert_table(token: Dict) -> Dict:
    rows = []
    for child in token["children"]:
        if child["type"] == "table_head":
            cells = []
            for cell_token in child["children"]:
                cell_content = _convert_inlines(cell_token["children"])
                cells.append({
                    "type": "tableHeader",
                    "content": [{"type": "paragraph", "content": cell_content or []}],
                })
            rows.append({"type": "tableRow", "content": cells})
        elif child["type"] == "table_body":
            for row_token in child["children"]:
                cells = []
                for cell_token in row_token["children"]:
                    cell_content = _convert_inlines(cell_token["children"])
                    cells.append({
                        "type": "tableCell",
                        "content": [{"type": "paragraph", "content": cell_content or []}],
                    })
                rows.append({"type": "tableRow", "content": cells})
    return {"type": "table", "content": rows}


def _convert_inlines(children: List[Dict], marks: Optional[List[Dict]] = None) -> List[Dict]:
    """Recursively convert inline tokens to ADF text nodes, accumulating marks."""
    marks = marks or []
    result = []

    for token in children:
        t = token["type"]

        if t == "text":
            node = {"type": "text", "text": token["raw"]}
            if marks:
                node["marks"] = list(marks)
            result.append(node)

        elif t == "strong":
            result.extend(
                _convert_inlines(token["children"], marks + [{"type": "strong"}])
            )

        elif t == "emphasis":
            result.extend(
                _convert_inlines(token["children"], marks + [{"type": "em"}])
            )

        elif t == "strikethrough":
            result.extend(
                _convert_inlines(token["children"], marks + [{"type": "strike"}])
            )

        elif t == "link":
            link_mark = {"type": "link", "attrs": {"href": token["attrs"]["url"]}}
            result.extend(
                _convert_inlines(token["children"], marks + [link_mark])
            )

        elif t == "image":
            url = token["attrs"]["url"]
            alt_children = token.get("children", [])
            alt_text = alt_children[0]["raw"] if alt_children else url
            link_mark = {"type": "link", "attrs": {"href": url}}
            result.append({"type": "text", "text": alt_text, "marks": marks + [link_mark]})

        elif t == "codespan":
            node = {"type": "text", "text": token["raw"]}
            # Jira rejects combining "code" with other marks (e.g. strong+code).
            # Use code mark alone — surrounding formatting is lost but the text is preserved.
            node["marks"] = [{"type": "code"}]
            result.append(node)

        elif t == "softbreak":
            node = {"type": "text", "text": " "}
            if marks:
                node["marks"] = list(marks)
            result.append(node)

        elif t == "linebreak":
            result.append({"type": "hardBreak"})

    return result


if __name__ == "__main__":
    import json
    if len(sys.argv) >= 2:
        with open(sys.argv[1]) as f:
            md = f.read()
    else:
        md = sys.stdin.read()
    if not md.strip():
        print("Error: No input provided", file=sys.stderr)
        sys.exit(1)
    print(json.dumps(convert(md)))
