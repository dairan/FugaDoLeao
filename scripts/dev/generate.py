#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["google-genai"]
# ///
"""
Gera imagens via Gemini API.

Uso:
  generate.py <output> "<prompt>" [--ref <imagem>] [--model <model>]

Exemplos:
  generate.py assets/art/item_bad_new.png "Pixel art briefcase..."
  generate.py assets/art/player_sheet.png "4 frames..." --ref assets/art/pedro_reference.png
"""
import argparse
import subprocess
import sys
from pathlib import Path

from google import genai
from google.genai import types


def get_api_key() -> str:
    key = subprocess.run(
        ["security", "find-generic-password", "-s", "GEMINI_API_KEY", "-w"],
        capture_output=True, text=True
    ).stdout.strip()
    if not key:
        sys.exit("GEMINI_API_KEY não encontrado no keychain.")
    return key


def generate(output: str, prompt: str, ref: str | None, model: str) -> None:
    client = genai.Client(api_key=get_api_key())

    parts: list = []
    if ref:
        ref_path = Path(ref)
        if not ref_path.exists():
            sys.exit(f"Referência não encontrada: {ref}")
        parts.append(types.Part.from_bytes(data=ref_path.read_bytes(), mime_type="image/png"))
    parts.append(prompt)

    print(f"→ Gerando: {output}" + (f" (ref: {ref})" if ref else ""))

    response = client.models.generate_content(
        model=model,
        contents=parts,
        config=types.GenerateContentConfig(
            response_modalities=["IMAGE", "TEXT"]
        ),
    )

    for part in response.candidates[0].content.parts:
        if part.inline_data:
            out_path = Path(output)
            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.write_bytes(part.inline_data.data)
            print(f"  Salvo em: {output}")
            return

    # Sem imagem — exibe texto de resposta
    for part in response.candidates[0].content.parts:
        if part.text:
            print(f"  [AVISO] {part.text}")
    sys.exit("Nenhuma imagem retornada.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Gera imagens via Gemini")
    parser.add_argument("output", help="Caminho de saída (ex: assets/art/foo.png)")
    parser.add_argument("prompt", help="Prompt de geração")
    parser.add_argument("--ref", help="Imagem de referência para consistência", default=None)
    parser.add_argument("--model", default="gemini-3.1-flash-image-preview")
    args = parser.parse_args()

    generate(args.output, args.prompt, args.ref, args.model)


if __name__ == "__main__":
    main()
