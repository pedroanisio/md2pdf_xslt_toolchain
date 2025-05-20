FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    pandoc \
    openjdk-11-jre-headless \
    wget \
    unzip \
    curl \
    python3 \
    python3-pip \
    xmlstarlet \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Saxon-HE (XSLT processor)
RUN mkdir -p /opt/saxon && \
    wget -q https://sourceforge.net/projects/saxon/files/Saxon-HE/11/Java/SaxonHE11-4J.zip -O /tmp/saxon.zip && \
    unzip /tmp/saxon.zip -d /opt/saxon && \
    rm /tmp/saxon.zip

# Install Apache FOP (XSL-FO to PDF)
RUN mkdir -p /opt/fop && \
    wget -q https://downloads.apache.org/xmlgraphics/fop/binaries/fop-2.7-bin.zip -O /tmp/fop.zip && \
    unzip /tmp/fop.zip -d /opt/fop && \
    mv /opt/fop/fop-2.7/* /opt/fop/ && \
    rm -rf /opt/fop/fop-2.7 && \
    rm /tmp/fop.zip

# Set PATH to include our tools
ENV PATH="/opt/fop/fop:/opt/saxon:${PATH}"

# Install WeasyPrint as an alternative HTML to PDF converter
RUN pip3 install weasyprint

# Copy conversion script
COPY convert.sh /usr/local/bin/convert.sh
RUN chmod +x /usr/local/bin/convert.sh

# Set working directory
WORKDIR /data

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/convert.sh"]
