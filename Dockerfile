FROM mongo:4.2

RUN apt-get update && \
    apt-get install awscli -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["/backup.sh"]
