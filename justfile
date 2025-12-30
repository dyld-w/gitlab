# Default recipe: list available commands
default:
    @just --list

# Build and upload plugin with optional suffix
upload suffix="" version_suffix="":
    #!/usr/bin/env bash
    set -euo pipefail

    # Generate maubot.yaml from template
    sed 's/{{{{SUFFIX}}/{{suffix}}/g; s/{{{{VERSION_SUFFIX}}/{{version_suffix}}/g' \
        maubot.yaml.template > maubot.yaml

    # Create module symlink if suffix provided
    if [[ -n "{{suffix}}" ]] && [[ ! -e "gitlab_matrix{{suffix}}" ]]; then
        ln -s gitlab_matrix "gitlab_matrix{{suffix}}"
    fi

    # Build and upload
    mbc build -u

    # Cleanup symlink
    if [[ -n "{{suffix}}" ]] && [[ -L "gitlab_matrix{{suffix}}" ]]; then
        rm "gitlab_matrix{{suffix}}"
    fi

# Upload production build (no suffix)
upload-prod: (upload "" "")

# Upload dev/testing build (with _testing suffix)
upload-dev: (upload "_testing" "-dev")

# Remove generated files
clean:
    rm -f maubot.yaml *.mbp gitlab_matrix_testing
