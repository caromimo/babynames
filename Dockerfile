FROM alpine:3.14

WORKDIR /app

# Create a group and user
RUN addgroup -S shiny && adduser -S shiny -G shiny

# httpuv is extremely pickly about what is used during compilation.
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.11/main' >> /etc/apk/repositories
RUN set -ex; apk add --no-cache autoconf=2.69-r2 automake=1.16.1-r0

# Download R and system dependencies
RUN apk add -U --no-cache R R-dev \
    bash \
    m4 \
    file \
    curl-dev \
    python2 \
    g++ \
    gcc \
    cmake \
    libc6-compat \
    git \
    libffi \
    psmisc \
    rrdtool \
    cairo-dev \
    libxt-dev \
    libxml2-dev \
    linux-headers \
    wget

# copy necessary files
## app folder
COPY app.R .
## renv.lock file
COPY renv.lock ./renv.lock

# install renv & restore packages
RUN Rscript -e 'install.packages("renv", , repo="https://cran.rstudio.com/")'
RUN Rscript -e 'renv::restore()'

# Tell docker that all future commands should run as the shiny user
USER shiny

# expose port
EXPOSE 8080

# run app on container start
CMD ["Rscript", "-e", "shiny::runApp('/app/app.R', host = '0.0.0.0', port = 8080)"]
