#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["google-genai", "Pillow"]
# ///
"""
Gera imagens via Gemini API.

Uso:
  generate.py <output> "<prompt>" [--ref <img>] [--model <model>] [--size WxH]

Exemplos:
  generate.py assets/art/item_bad.png "Pixel art briefcase..."
  generate.py assets/art/player_0.png "Frame 1..." --ref assets/art/ref.png --size 88x96
"""
import argparse
import io
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


def _normalize(data: bytes, w: int, h: int) -> bytes:
    from PIL import Image
    img = Image.open(io.BytesIO(data)).convert("RGBA")

    # Chroma key: remove lime-green bg if present
    pixels = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = pixels[x, y]
            if g > 100 and g > r * 1.3 and g > b * 1.3:
                pixels[x, y] = (0, 0, 0, 0)

    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)

    canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    img.thumbnail((w, h), Image.LANCZOS)
    ox = (w - img.width) // 2
    oy = (h - img.height) // 2
    canvas.paste(img, (ox, oy), img)

    buf = io.BytesIO()
    canvas.save(buf, format="PNG")
    return buf.getvalue()


def generate(output: str, prompt: str, refs: list[str], model: str, size: str | None) -> None:
    client = genai.Client(api_key=get_api_key())

    parts: list = []
    for ref in refs:
        ref_path = Path(ref)
        if not ref_path.exists():
            sys.exit(f"Referência não encontrada: {ref}")
        parts.append(types.Part.from_bytes(data=ref_path.read_bytes(), mime_type="image/png"))
    parts.append(prompt)

    ref_info = f" (refs: {', '.join(refs)})" if refs else ""
    print(f"→ Gerando: {output}{ref_info}")

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
            data = part.inline_data.data
            if size:
                w, h = map(int, size.split("x"))
                data = _normalize(data, w, h)
            out_path.write_bytes(data)
            print(f"  Salvo em: {output}")
            return

    for part in response.candidates[0].content.parts:
        if part.text:
            print(f"  [AVISO] {part.text}")
    sys.exit("Nenhuma imagem retornada.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Gera imagens via Gemini")
    parser.add_argument("output", help="Caminho de saída")
    parser.add_argument("prompt", help="Prompt de geração")
    parser.add_argument("--ref", action="append", default=[], metavar="IMG",
                        help="Imagem de referência (pode repetir para múltiplas)")
    parser.add_argument("--size", help="Tamanho do canvas WxH (ex: 88x96). Faz crop e normalização.", default=None)
    parser.add_argument("--model", default="gemini-3.1-flash-image-preview")
    args = parser.parse_args()

    generate(args.output, args.prompt, args.ref, args.model, args.size)


if __name__ == "__main__":
    main()
