# gitops-flux-arc

```mermaid
graph LR
    subgraph Azure
        ArcManagement[Azure Arc Management]
    end

    subgraph Namespace
        customer-01-prod -->|Arc GitOps Configuration| ArcManagement
        customer-01-staging -->|Arc GitOps Configuration| ArcManagement
        customer-02-prod -->|Arc GitOps Configuration| ArcManagement
    end

    subgraph apps-state-clusters
        apps-state-customer-01-prod
        apps-state-customer-01-staging
        apps-state-customer-02-prod
    end

    subgraph infra-state-clusters
        infra-state-customer-01-prod
        infra-state-customer-01-staging
        infra-state-customer-02-prod
    end        

    subgraph apps-rings
        apps-ring0-internal
        apps-ring1-staging
        apps-ring2-earlyadopters
        apps-ring3-mainstream
        apps-ring4-conservative
    end

    subgraph infra
        subgraph ingress
            ingress-prod -->|patches| ingress-base
            ingress-staging -->|patches| ingress-base
            ingress-base -->|loads Helm Chart| nginx-ingress-chart
        end 
        subgraph cert-manager
            cert-manager-prod -->|patches| cert-manager-base
            cert-manager-staging -->|patches| cert-manager-base
            cert-manager-base -->|loads Helm Chart| cert-manager-chart
        end
    end

    subgraph apps
        subgraph app1
            app1-staging -->|patches| app1-base
            app1-production -->|patches| app1-base
            app1-base -->|loads Helm Chart| app1-chart
        end
        subgraph app2
            app2-staging -->|patches| app2-base
            app2-production -->|patches| app2-base
            app2-base -->|loads Helm Chart| app2-chart
        end
    end

    customer-01-prod -->|pull| apps-state-customer-01-prod
    customer-01-staging -->|pull| apps-state-customer-01-staging
    customer-02-prod -->|pull| apps-state-customer-02-prod

    customer-01-prod -->|pull| infra-state-customer-01-prod
    customer-01-staging -->|pull| infra-state-customer-01-staging
    customer-02-prod -->|pull| infra-state-customer-02-prod

    apps-state-customer-01-prod -->|patches| apps-ring3-mainstream
    apps-state-customer-01-staging -->|patches| apps-ring1-staging
    apps-state-customer-02-prod -->|patches| apps-ring2-earlyadopters

    infra-state-customer-01-prod -->|patches| ingress-prod
    infra-state-customer-01-prod -->|patches| cert-manager-prod
    infra-state-customer-01-staging -->|patches| ingress-staging
    infra-state-customer-01-staging -->|patches| cert-manager-staging
    infra-state-customer-02-prod -->|patches| ingress-prod
    infra-state-customer-02-prod -->|patches| cert-manager-prod

    apps-ring0-internal -->|patches| app1-staging
    apps-ring1-staging -->|patches| app1-staging
    apps-ring2-earlyadopters -->|patches| app1-production
    apps-ring3-mainstream -->|patches| app1-production
    apps-ring4-conservative -->|patches| app1-production

    apps-ring0-internal -->|patches| app2-staging
    apps-ring1-staging -->|patches| app2-staging
    apps-ring2-earlyadopters -->|patches| app2-production
    apps-ring3-mainstream -->|patches| app2-production
    apps-ring4-conservative -->|patches| app2-production

```