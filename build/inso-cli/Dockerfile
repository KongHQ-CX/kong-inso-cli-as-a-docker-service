FROM node:alpine
ENV TERM=dumb
RUN apk --no-cache add g++ make curl-dev bash python3 jq && npm install -g insomnia-inso

# Set working directory to the root of the project.
RUN mkdir /workdir && chmod 755 /workdir
WORKDIR /workdir

ADD inso-entrypoint.sh /usr/local/bin/inso-entrypoint.sh
RUN chmod a+x /usr/local/bin/inso-entrypoint.sh
ADD inso-lint.sh /usr/local/bin/.
RUN chmod a+x /usr/local/bin/inso-lint.sh

ENTRYPOINT ["inso-entrypoint.sh" ]
