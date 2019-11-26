# Installation and Use

Open Banking Connector runs on both Mac and Linux. It is provided as a Swift package containin an HTTP application and a library. The HTTP application presents an API which is a mirror of the functions supported by the library.

TLS (HTTPS) support is not provided out of the box to allow local running/testing and because it is expected that this will be implemented via some type of wrapper (e.g. reverse proxy on a server).

Note that bcause Open Banking redirects get sent to a TLS endpoint on a pre-registered domain, this must be available to test consent authorisation even when running locally or debugging. One way to configure this in non-production settings is via SSH port forwarding from a cloud server set up with the correct domain and an Apache front-end (see here).

## Installation Instructions

### Mac

Open Banking Connector can be installed on a Mac for local running and debugging. 

Note that bcause Open Banking redirects get sent to a TLS endpoint on a pre-registered domain, this must be available to test consent authorisation.

#### Requirements:
* Xcode 11.2 or greater

#### Step 1: Clone repo and run

Clone the repo locally and run/debug in Xcode on your Mac as a Swift Package using the default Scheme. Xcode will automatically download dependencies and build Open Banking Connector before running.

### Linux with HTTPS reverse proxy (Apache 2)

#### Requirements:
* Ubuntu 18.04

#### Step 1: install Swift 5.1.2 or greater

```bash
# Sample instructions
sudo apt-get -y install clang libicu-dev libpython2.7 # libpython2.7 required for REPL
wget https://swift.org/builds/swift-5.1.2-release/ubuntu1804/swift-5.1.2-RELEASE/swift-5.1.2-RELEASE-ubuntu18.04.tar.gz
tar xzf swift-5.1.2-RELEASE-ubuntu18.04.tar.gz
sudo mv swift-5.1.2-RELEASE-ubuntu18.04 /opt/swift-5.1.2
rm swift-5.1.2-RELEASE-ubuntu18.04.tar.gz
vim ~/.bashrc # Add this line then save: export PATH=/opt/swift-5.1.2/usr/bin:$PATH
```

#### Step 2: Install Apache 2

```bash
# Sample instructions
sudo apt-get -y install apache2
```

#### Step 3: Configure Apache 2 as reverse proxy

Configure Apache 2 to proxy TLS requests to HTTP on a specified unprivileged port (e.g. 3000) and ensure firewall is configured and enabled.

```bash
# Sample instructions
cd /etc/apache2/sites-enabled
sudo ln -s ../sites-available/default-ssl.conf
# Sample edit to default-ssl.conf near the bottom above </VirtualHost>
# Proxy all paths to HTTP, port 3000
ProxyRequests on
ProxyPass / http://localhost:3000/
```

```bash
# Sample instructions
# Turn on Apache proxy modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo service apache2 restart
# Configure and enable firewall (for illustrative purposes only)
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw enable
```

#### Step 4: Clone repo and run

Clone the repo locally and then build and run.

```bash
# Sample instructions
git clone https://github.com/finlabsuk/open-banking-connector.git
cd open-banking-connector/
sudo apt-get -y install libssl-dev # dependency from https://github.com/IBM-Swift/BlueRSA 
sudo apt-get install -y libsqlite3-dev # dependency from https://github.com/vapor/sqlite-nio
ulimit -n 65536 # may be necessary if linker reports "/usr/bin/ld.gold: fatal error: out of file descriptors and couldn't close any"
swift build
swift run
```

