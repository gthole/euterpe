FROM golang:1.16-buster as builder

RUN apt-get update && apt-get install -y \
    libtagc0-dev upx-ucl libicu-dev

COPY . /src/euterpe
WORKDIR /src/euterpe

RUN make release
RUN mv euterpe /tmp/euterpe
RUN /tmp/euterpe -config-gen && sed -i 's/localhost:9996/0.0.0.0:9996/' /root/.euterpe/config.json

FROM debian:buster

RUN apt-get update && apt-get install -y libtagc0 libicu63

COPY --from=builder /tmp/euterpe /usr/local/bin/euterpe
COPY --from=builder /root/.euterpe/config.json /root/.euterpe/config.json

ENV HOME /root
WORKDIR /root
EXPOSE 9996
CMD ["euterpe"]
