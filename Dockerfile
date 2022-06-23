FROM ubuntu
RUN apt-get update && apt-get install -y \
  jq \
  git \
  curl \ 
  sudo \ 
  python3 \
  python3-pip \
  python-is-python3
RUN python -m pip install \
  typer \
  pyyaml \
  requests \
  gatorgrader \
  python-dotenv
RUN curl -fSSL https://raw.githubusercontent.com/term-world/world-container/main/gginstall.sh | sh
RUN curl -fsSL https://code-server.dev/install.sh | sh
ADD https://raw.githubusercontent.com/term-world/world-container/main/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT /entrypoint.sh
