provider "unifi" {
  username = data.sops_file.secrets.data["unifi_username"]
  password = data.sops_file.secrets.data["unifi_password"]
  api_url  = data.sops_file.secrets.data["unifi_api_url"]

  allow_insecure = true
}
