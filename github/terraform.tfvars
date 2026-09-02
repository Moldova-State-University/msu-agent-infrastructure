# Organization Variables
org_name = "Moldova-State-University"

# Users
users = {
  # Admins
  "mcroitor" = {
    org_role = "admin"
  },
  "devrdn" = {
    org_role = "admin"
  },
  "sharishi" = {
    org_role = "admin"
  },
  "TrEtLiz" = {
    org_role = "admin"
  }

  # Members
  "JUnknowL" = {
    org_role = "member"
  },
  "statova-nadejda" = {
    org_role = "member"
  },
  "AndreiKlinchev" = {
    org_role = "member"
  },
  "leopard-bf187" = {
    org_role = "member"
  },
  "Rengeka" = {
    org_role = "member"
  },
  "A1EXSO" = {
    org_role = "member"
  },
  "danutasemeniuc" = {
    org_role = "member"
  },
  "FaStiCkeR" = {
    org_role = "member"
  },
  "yorunikakeru4" = {
    org_role = "member"
  },
  "valccria" = {
    org_role = "member"
  }
}

# Teams
sub_team = {
  "ai-team" = {
    description = "AI Team with access to AI-related repositories"
    members     = ["mcroitor", "devrdn", "AndreiKlinchev", "statova-nadejda", "sharishi", "danutasemeniuc"]
  },
  "ar-team" = {
    description = "AR Team with access to AR-related repositories"
    members     = ["mcroitor", "devrdn", "leopard-bf187", "A1EXSO", "yorunikakeru4"]
  },
  "web-team" = {
    description = "Web Development Team"
    members     = ["mcroitor", "devrdn", "JUnknowL", "FaStiCkeR", "valccria"]
  },
  "devops-team" = {
    description = "DevOps Team managing infrastructure repositories"
    members     = ["devrdn", "mcroitor", "Rengeka", "yorunikakeru4"]
  },
  "qa-team" = {
    description = "Quality Assurance Team for testing and validation"
    members     = ["devrdn", "mcroitor", "TrEtLiz", "danutasemeniuc"]
  },
  "pm-team" = {
    description = "Project Management Team overseeing project progress"
    members     = ["devrdn", "mcroitor", "sharishi", "TrEtLiz"]
  }
}

# Repositories
repositories = {
  "msu-agent-knowledge-base" = {
    name        = "msu-agent-knowledge-base"
    visibility  = "public"
    description = "Knowledge base repository for MSU Agent project. Managed by Terraform."
    topics      = ["msu", "artificial-intelligence", "knowledge-base", "chatbot"]
    auto_init   = true

    team_access = {
      "ai-team"     = "maintain"
      "devops-team" = "admin"
    }

    # For this repo, require 2 approving reviews before merging
    required_approving_review_count = 2
  },

  "msu-agent-knowledge-data-parser" = {
    name        = "msu-agent-knowledge-data-parser"
    visibility  = "public"
    description = "Knowledge data parser repository for MSU Agent project. Managed by Terraform."
    topics      = ["msu", "artificial-intelligence", "knowledge-base", "chatbot"]
    auto_init   = true

    team_access = {
      "ai-team"     = "maintain"
      "devops-team" = "admin"
    }

    # For this repo, require 2 approving reviews before merging
    required_approving_review_count = 2
  },

  "msu-agent-ai-service" = {
    name        = "msu-agent-ai-service"
    visibility  = "public"
    description = "AI service repository for MSU Agent project. Managed by Terraform."
    topics      = ["msu", "artificial-intelligence", "ai-service", "chatbot"]
    auto_init   = true

    team_access = {
      "ai-team"     = "maintain"
      "devops-team" = "admin"
    }

    # For this repo, require 2 approving reviews before merging
    required_approving_review_count = 2
  },

  "msu-agent-krystallic" = {
    name        = "msu-agent-krystallic"
    description = "Special version of Krystallic Engine, developed by BytesForge, for MSU Agent program on Android and IOS. Managed by Terraform."
    visibility  = "public"
    topics      = ["augmented-reality", "mobile", "android", "ios", "3d-engine", "krystallic"]
    auto_init   = false

    team_access = {
      "ar-team"     = "maintain"
      "devops-team" = "admin"
    }

    required_approving_review_count = 0
  },

  "msu-agent-krystallic-runtime" = {
    name        = "msu-agent-krystallic-runtime"
    description = "Krystallic Runtime repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["augmented-reality", "mobile", "3d-engine", "krystallic", "runtime"]
    auto_init   = true

    team_access = {
      "ar-team"     = "admin"
      "devops-team" = "admin"
    }

    required_approving_review_count = 1
  },

  "msu-agent-krystallic-editor" = {
    name        = "msu-agent-krystallic-editor"
    description = "Krystallic Editor repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["augmented-reality", "3d-engine", "krystallic", "editor"]
    auto_init   = true

    team_access = {
      "ar-team"     = "admin"
      "devops-team" = "admin"
    }

    required_approving_review_count = 1
  },

  "msu-agent-mobile-client" = {
    name        = "msu-agent-mobile-client"
    description = "Mobile client repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["augmented-reality", "mobile", "android", "ios", "3d-engine", "krystallic"]
    auto_init   = true

    team_access = {
      "ar-team"     = "admin"
      "web-team"    = "maintain"
      "devops-team" = "admin"
    }

    required_approving_review_count = 1
  },

  "msu-agent-mobile-resources" = {
    name        = "msu-agent-mobile-resources"
    description = "Mobile resources repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["augmented-reality", "mobile", "android", "ios", "3d-engine", "krystallic"]
    auto_init   = true

    team_access = {
      "ar-team"     = "admin"
      "web-team"    = "maintain"
      "devops-team" = "admin"
    }

    required_approving_review_count = 1
  },

  "msu-agent-documentation" = {
    name        = "msu-agent-documentation"
    description = "Documentation repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["msu", "documentation", "project-management", "guides", "api-docs"]
    auto_init   = true

    team_access = {
      "web-team"    = "push"
      "ai-team"     = "push"
      "ar-team"     = "push"
      "devops-team" = "admin"
    }

    required_approving_review_count = 2
  },

  "msu-agent-infrastructure" = {
    name        = "msu-agent-infrastructure"
    description = "Infrastructure as Code (IaC) repository for MSU Agent project. Managed by Terraform."
    visibility  = "public"
    topics      = ["msu", "infrastructure-as-code", "terraform", "devops"]
    auto_init   = true

    team_access = {
      "devops-team" = "admin"
    }

    required_approving_review_count = 0
  },

  "msu-agent-backend" = {
    name        = "msu-agent-backend"
    description = "MSU Agend backend repository for managing backend services and APIs. Managed by Terraform."
    visibility  = "public"
    topics      = ["msu", "backend", "csharp", "web"]
    auto_init   = true

    team_access = {
      "web-team"    = "maintain"
      "devops-team" = "admin"
    }

    required_approving_review_count = 1
  }
}