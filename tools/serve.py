#!/usr/bin/env python3
"""Serve the site with the isolation headers required by Wasm pthreads."""

from argparse import ArgumentParser
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class IsolatedHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        super().end_headers()


def main():
    parser = ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()

    site = Path(__file__).resolve().parents[1] / "site"
    handler = partial(IsolatedHandler, directory=site)
    server = ThreadingHTTPServer((args.host, args.port), handler)
    print(f"Serving {site} at http://{args.host}:{args.port}")
    server.serve_forever()


if __name__ == "__main__":
    main()
