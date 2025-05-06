# Dockerfile for Ruby on Rails development with asdf

# Build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT=bullseye
ARG RUBY_VERSION=3.3.0
ARG NODE_JS_VERSION=20.12.2
ARG BUNDLE_VERSION=2.5.6
ARG PORT=3000
ARG WM_VERSION=v2022.01.03.00
ARG ASDF_VERSION=v0.16.7

# Base image
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# Re-declare build arguments inside image
ARG RUBY_VERSION
ARG NODE_JS_VERSION
ARG BUNDLE_VERSION
ARG WM_VERSION
ARG ASDF_VERSION

# Environment variables
ENV APP_PATH=/app \
  PATH=/opt:/opt/asdf/shims:/opt/asdf/bin:/home/vscode/.gems/bin:$PATH \
  BUNDLE_PATH=/var/lib/gems/${RUBY_VERSION}/gems

# Install dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  unzip python-dev automake autoconf libtool build-essential gnupg2 \
  dirmngr tar git libssl-dev zlib1g-dev libyaml-dev curl libreadline-dev \
  cron imagemagick libjpeg-dev libpng-dev libtiff-dev libwebp-dev libvips \
  postgresql-client libpq-dev openssh-server openssh-client tzdata gifsicle \
  tmux vim ca-certificates && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR ${APP_PATH}

# Use bash login shell
SHELL ["/bin/bash", "-lc"]

# Install asdf
RUN curl -fsSL https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-386.tar.gz | tar -xz -C /opt && \
  echo -e "\nexport PATH=\"/opt:/opt/asdf/shims:/opt/asdf/bin:/home/vscode/.gems/bin:\$PATH\"" >> /home/vscode/.bashrc && \
  echo -e "\nexport PATH=\"/opt:\$HOME/.asdf/shims:\$HOME/.asdf/bin:/home/vscode/.gems/bin:\$PATH\"" >> ~/.bashrc


# # Install asdf plugins and versions
RUN asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && \
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
  asdf plugin add java https://github.com/halcyon/asdf-java.git && \
  asdf install ruby ${RUBY_VERSION} && \
  asdf install nodejs ${NODE_JS_VERSION} && \
  asdf install java temurin-17.0.6+10 && \
  asdf set -u ruby ${RUBY_VERSION} && \
  asdf set -u nodejs ${NODE_JS_VERSION} && \
  asdf set -u java temurin-17.0.6+10

# Copy .tool-versions early to use build cache
COPY --chown=vscode:vscode .tool-versions ./

# Install and configure watchman
RUN curl -fsSL https://github.com/facebook/watchman/releases/download/${WM_VERSION}/watchman-${WM_VERSION}-linux.zip -o watchman.zip && \
  unzip watchman.zip && \
  mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman && \
  cp watchman-*/bin/* /usr/local/bin && \
  cp watchman-*/lib/* /usr/local/lib && \
  chmod 755 /usr/local/bin/watchman && \
  chmod 2777 /usr/local/var/run/watchman && \
  touch /usr/local/var/run/watchman/.not-empty && \
  rm -rf watchman.zip watchman-*

# Fix permissions
RUN chown -R vscode:vscode /opt/asdf /usr/local/bin/watchman /usr/local/var/run/watchman

# Switch to non-root user
USER vscode

# Copy Gemfile and install bundler
COPY --chown=vscode:vscode Gemfile Gemfile.lock ./

# Expose Rails default port
EXPOSE ${PORT}
