# Data Storage and User Authentication

Sensitive data (e.g. user tokens) is not API-accessible.

Currently Open Banking Connector only supports development mode (all data including sensitive data is stored in plain-text in a local SQLite database to enable easy debugging).

So Open Banking Connector is not yet suitable for production deployments especially relating to payments. It is still probably fine for things like e.g. automated testing with bank sandboxes to check compatibility and "live-ness".

We are about to start work on cloud-agnostic storage and authentication options (e.g. Vault on Kubernetes) for production mode and welcome input on this.
