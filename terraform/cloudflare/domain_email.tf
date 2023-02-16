data "cloudflare_zones" "email" {
  filter {
    name = data.sops_file.secrets.data["email.domain"]
  }
}

resource "cloudflare_record" "email_mx_main" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "aspmx.l.google.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 1
}

resource "cloudflare_record" "email_mx_secondary_1" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "alt1.aspmx.l.google.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 5
}

resource "cloudflare_record" "email_mx_secondary_2" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "alt2.aspmx.l.google.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 5
}

resource "cloudflare_record" "email_mx_tertiary_1" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "aspmx2.googlemail.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "email_mx_tertiary_2" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "aspmx3.googlemail.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "email_dmarc" {
  name     = "_dmarc"
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "v=DMARC1; p=none; rua=mailto:dmarc@${data.sops_file.secrets.data["email.domain"]}"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "email_spf" {
  name     = data.sops_file.secrets.data["email.domain"]
  zone_id  = lookup(data.cloudflare_zones.email.zones[0], "id")
  value    = "v=spf1 include:_spf.google.com ~all"
  comment  = local.cf_comment
  type     = "TXT"
}
