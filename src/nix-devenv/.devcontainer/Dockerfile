FROM debian:bookworm-slim

ARG USER=vscode
ARG UID=1000
ARG GID=1000

ARG NIX_INSTALLER_VERSION=v0.24.0
ENV NIX_INSTALLER_VERSION=${NIX_INSTALLER_VERSION}

ARG GH_CLI_VERSION=2.55.0
ENV GH_CLI_VERSION=${GH_CLI_VERSION}

ARG FZF_VERSION=0.55.0
ENV FZF_VERSION=${FZF_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install nix using determined installation script
RUN apt update && apt install -y --no-install-recommends \
    curl ca-certificates git git-extras direnv zsh fd-find ripgrep vim sudo && \
    rm -rf /var/lib/apt/lists/* && \
    git config --global core.fileMode false

RUN  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/${NIX_INSTALLER_VERSION} | sh -s -- install linux --no-confirm --init none

# Installs starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Installs FZF
RUN curl -L https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz | tar -xzC /tmp && \
    mv /tmp/fzf /usr/local/bin/fzf && \
    chmod +x /usr/local/bin/fzf && \
    rm -rf /tmp/fzf

# Installs Github CLI
RUN curl -fsSL https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_amd64.tar.gz | tar -xzC /tmp && \
    mv /tmp/gh_${GH_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh && \
    chmod +x /usr/local/bin/gh && \
    rm -rf /tmp/${GH_CLI_VERSION}_linux_amd64 \
    gh --version

# create non-root user with specified UID and GID
RUN groupadd --gid $GID $USER && \
    useradd --uid $UID --gid $GID --shell /bin/zsh --create-home $USER && \
    usermod -aG sudo $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

USER $USER

# Copy dotfiles
WORKDIR /home/$USER

COPY --chown=$USER:$USER .zshrc .zshrc
COPY --chown=$USER:$USER .zsh_plugins.txt .zsh_plugins.txt
COPY --chown=$USER:$USER starship.toml .config/starship.toml

RUN git clone https://github.com/mattmc3/antidote.git ~/.antidote

CMD ["sleep", "infinity"]