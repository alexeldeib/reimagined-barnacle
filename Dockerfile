FROM ubuntu:22.04 as build

RUN apt update && apt install -y curl

WORKDIR /work
RUN curl -O https://get.gravitational.com/teleport-v10.3.9-linux-amd64-bin.tar.gz \
    && curl -O https://get.gravitational.com/teleport-v10.3.9-linux-amd64-bin.tar.gz.sha256 \
    && sha256sum --check teleport-v10.3.9-linux-amd64-bin.tar.gz.sha256 \
    && tar -xzf teleport-v10.3.9-linux-amd64-bin.tar.gz \
    && BINDIR=/usr/local/bin \
    && VARDIR=/var/lib/teleport \
    && mkdir -p $VARDIR $BINDIR

FROM ubuntu:22.04
RUN apt update && apt install -y ca-certificates
COPY --from=build /work/teleport/teleport /usr/local/bin/
COPY --from=build /work/teleport/tctl /usr/local/bin/
COPY --from=build /work/teleport/tsh /usr/local/bin/
COPY --from=build /work/teleport/tbot /usr/local/bin/
COPY post-deploy.sh /opt/teleport/post-deploy.sh
COPY sso-role.yaml /opt/teleport/sso-role.yaml
COPY github.yaml /opt/teleport/github.yaml
COPY cap.yaml /opt/teleport/cap.yaml

# not really necessary?
COPY --from=build /var/lib/teleport /var/lib/teleport 
RUN /usr/local/bin/teleport configure -o file --acme --cluster-name=port.alexeldeib.xyz --acme-email alexeldeib@gmail.com --roles node,auth,proxy 
RUN sed -i 's/nodename:.*$/nodename: proxyserver/g' /etc/teleport.yaml

ENTRYPOINT ["/usr/local/bin/teleport", "start"]
