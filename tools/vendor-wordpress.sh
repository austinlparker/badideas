#!/usr/bin/env bash
set -euo pipefail

VERSION=${WORDPRESS_VERSION:-6.8.3}
BASE="https://wordpress.org/wordpress-${VERSION}.tar.gz"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -L --fail --silent --show-error "$BASE" -o "$TMP/wordpress.tar.gz"
tar -xzf "$TMP/wordpress.tar.gz" -C "$TMP"
rm -rf site/wordpress
mkdir -p site
mv "$TMP/wordpress" site/wordpress

python3 - <<'PY'
import json
from pathlib import Path, PurePosixPath
root = Path('site')
paths = []
for base in [root / 'wordpress', root / 'wp-content']:
    for path in sorted(base.rglob('*')):
        if not path.is_file():
            continue
        rel = path.relative_to(root).as_posix()
        if any(part.startswith('.') for part in PurePosixPath(rel).parts):
            continue
        virtual_path = PurePosixPath('/') / rel
        paths.append({
            'url': './' + rel,
            'parent': virtual_path.parent.as_posix(),
            'name': virtual_path.name,
        })
for rel in ['wp-config.php']:
    virtual_path = PurePosixPath('/') / rel
    paths.append({
        'url': './' + rel,
        'parent': virtual_path.parent.as_posix(),
        'name': virtual_path.name,
    })
(root / 'wordpress-manifest.json').write_text(json.dumps(paths, separators=(',', ':')))
print(f'wrote site/wordpress-manifest.json with {len(paths)} files')
PY

du -sh site/wordpress site/wp-content site/wordpress-manifest.json
