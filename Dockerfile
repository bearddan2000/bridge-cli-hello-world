FROM ubuntu:22.04 AS builder

WORKDIR /workspace

RUN apt update && apt install -y git

RUN git clone https://github.com/owainlewis/bridge.git

FROM ocaml/opam

ENV PATH /workspace/bridge/_build/default/bin:$PATH

WORKDIR /workspace/bridge

COPY --from=builder /workspace/bridge /workspace/bridge
 
RUN opam install dune menhir utop oUnit && \
    eval $(opam env) && \
    make clean && \
    make build

WORKDIR /code

COPY bin .
 
CMD "./run.sh"