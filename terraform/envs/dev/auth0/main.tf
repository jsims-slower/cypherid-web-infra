# NOTE: The following ENV Variables MUST be set, and must point to the machine-to-machine (m2m) Auth0 Application
#     AUTH0_CLIENT_ID
#     AUTH0_CLIENT_SECRET

# resource "auth0_client" "global" {
#   name                 = "All Applications"
#   custom_login_page    = file("${path.module}/pages/login.html")
#   custom_login_page_on = true
#
#   refresh_token {
#     rotation_type   = "non-rotating"
#     expiration_type = "non-expiring"
#   }
# }

resource "auth0_role" "admin" {
  name        = "Admin"
  description = "Administrator"
}

resource "auth0_client" "idseq_web" {
  name        = "idseq-web"
  description = "Seqtoid DEV Web Application"
  allowed_clients = [
    # var.auth0_m2m_client_id,
    "https://dev.seqtoid.org",
  ]
  allowed_logout_urls = [
    "http://localhost:3000/",
    "https://dev.seqtoid.org/",
    "http://dev.seqtoid.org/",
    "https://meta.dev.seqtoid.org/",
    "http://meta.dev.seqtoid.org/",
  ]
  allowed_origins = [
    "http://localhost:3000",
    "https://dev.seqtoid.org",
    "http://dev.seqtoid.org",
    "https://meta.dev.seqtoid.org/",
    "http://meta.dev.seqtoid.org/",
  ]
  app_type = "regular_web"
  callbacks = [
    # "http://localhost:3000/auth/auth0/callback",
    # "http://127.0.0.2:4000/auth/auth0/callback",
    "https://dev.seqtoid.org/auth/auth0/callback",
    # "https://meta.dev.seqtoid.org/auth/auth0/callback",
  ]
  logo_uri = "https://assets.prod.czid.org/assets/CZID_Favicon_Black.png"
  sso      = true
  web_origins = [
    "http://localhost:3000",
    "https://dev.seqtoid.org",
    "https://meta.dev.seqtoid.org/",
  ]

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = 36000
    secret_encoded      = false
  }
}

resource "auth0_client_grant" "idseq_web_grant" {
  client_id = auth0_client.idseq_web.id
  audience  = "https://${var.auth0_domain}/api/v2/" # "https://dev.seqtoid.org" ## TODO: Should be this?!!!
  scope     = []
}

resource "auth0_client" "idseq_web_management" {
  name     = "idseq-web-management"
  app_type = "non_interactive"
}

resource "auth0_client_grant" "idseq_web_management_grant" {
  client_id = auth0_client.idseq_web_management.id
  audience  = "https://${var.auth0_domain}/api/v2/" # "https://dev.seqtoid.org" ## TODO: Should be this?!!!
  scope = [
    "read:users",
    "update:users",
    "delete:users",
    "create:users",
    "create:user_tickets",
    "read:roles",
  ]
}

# resource "auth0_client" "idseq_cli_v2" {
#   name = "idseq-cli-v2"
#   allowed_clients = [
#     "JuxupFFHWAkv6g3IBYKe5fGBNTOAXNOV",
#     "https://sandbox.idseq.net",
#     or
#     var.auth0_m2m_client_id,
#     "https://dev.seqtoid.org",
#   ]
#   app_type = "native"
# }
#
# resource "auth0_branding" "brand" {
#   logo_url = "https://assets.prod.czid.org/assets/CZID_Logo_Black.png"
#
#   colors {
#     primary         = "#3867fa"
#     page_background = "#FFFFFF"
#   }
#
#   # font {}
#
#   universal_login {
#     body = "<!DOCTYPE html><code><html><head>{%- auth0:head -%}</head><body>{%- auth0:widget -%}</body></html></code>"
#   }
# }

# resource "auth0_connection" "idseq_legacy_users" {
#   name     = "idseq-legacy-users"
#   strategy = "auth0"
#   enabled_clients = [
#     auth0_client.idseq_web_management.id,
#     auth0_client.auth0_deploy_cli_extension.id,
#     or
#     auth0_m2m_client_id,
#   ]
#   is_domain_connection = false
#   realms = [
#     "idseq-legacy-users",
#   ]
#
#   options {
#     import_mode                    = false
#     disable_signup                 = true
#     password_policy                = "good"
#     strategy_version               = 2
#     requires_username              = true
#     brute_force_protection         = true
#     enabled_database_customization = false
#
#     mfa {
#       active                 = true
#       return_enroll_settings = true
#     }
#
#     validation {
#       username {
#         max = 15
#         min = 1
#       }
#     }
#
#     password_complexity_options {
#       min_length = 1
#     }
#   }
# }

resource "auth0_connection" "username_password_authentication" {
  name     = "Username-Password-Authentication"
  strategy = "auth0"
  enabled_clients = [
    # var.auth0_m2m_client_id,
    auth0_client.idseq_web.id,
    # auth0_client.auth0_deploy_cli_extension.id,
    # auth0_client.idseq_web_management.id,
    # auth0_client.idseq_cli_v2.id,
  ]
  is_domain_connection = false
  realms = [
    "Username-Password-Authentication",
  ]

  options {
    import_mode                    = false
    disable_signup                 = false
    password_policy                = "excellent"
    strategy_version               = 2
    requires_username              = false
    brute_force_protection         = true
    enabled_database_customization = false # TODO: true when we can use a custom user DB

    # custom_scripts = {
    #   login    = file("${path.module}/scripts/login.js")
    #   get_user = file("${path.module}/scripts/get_user.js")
    # }
    #
    # # NOTE: these are encrypted
    # configuration = {
    #   AUTH0_DOMAIN        = var.auth0_m2m_domain
    #   AUTH0_CLIENT_ID     = auth0_client.idseq_web.client_id
    #   AUTH0_CLIENT_SECRET = auth0_client.idseq_web.client_secret
    # }

    mfa {
      active                 = true
      return_enroll_settings = true
    }

    password_history {
      size   = 5
      enable = true
    }

    password_dictionary {
      enable     = true
      dictionary = []
    }

    password_no_personal_info {
      enable = true
    }

    password_complexity_options {
      min_length = 10
    }
  }
}

data "auth0_client" "idseq_web" {
  client_id = auth0_client.idseq_web.id
}

data "auth0_client" "idseq_web_management" {
  client_id = auth0_client.idseq_web_management.id
}

module "auth0-ssm-params" {
  source  = "github.com/chanzuckerberg/cztack//aws-ssm-params-writer?ref=v0.104.2"
  project = var.project
  env     = var.env
  service = "web" # var.component
  owner   = var.owner

  parameters = {
    AUTH0_CLIENT_ID                = auth0_client.idseq_web.client_id
    AUTH0_CLIENT_SECRET            = data.auth0_client.idseq_web.client_secret
    AUTH0_DOMAIN                   = var.auth0_domain
    AUTH0_MANAGEMENT_CLIENT_ID     = auth0_client.idseq_web_management.client_id
    AUTH0_MANAGEMENT_CLIENT_SECRET = data.auth0_client.idseq_web_management.client_secret
    AUTH0_MANAGEMENT_DOMAIN        = var.auth0_domain
  }
}
