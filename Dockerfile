



FROM archlinux:latest

RUN pacman -Syu --noconfirm \
        base-devel \
        git \
        shellcheck \
        jq \
        lua \
        qt6-declarative \
        python-dbusmock \
    && pacman -Scc --noconfirm \
    && rm -rf /var/cache/pacman/pkg/*

WORKDIR /work