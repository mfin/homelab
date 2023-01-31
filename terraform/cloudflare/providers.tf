provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cf_api_token"]
}
