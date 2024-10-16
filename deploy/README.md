# k8s-observability demo


## kind cluster 관리

생성    
`kind create cluster --config deploy/kind.yaml --name nasir-k8s --image kindest/node:v1.30.0`

제거
`kind delete nasir-k8s`

## 클러스터 환경 구성

1. ArgoCD setup
    - kaf deploy/addons/site/local-win/init/1-repo-secret.yaml


## directory 구조
```
/deploy       
├── README.md       
├── addons      
│   ├── README.md       
│   ├── base: cluster 공통 부분에 대한 helm chart       
│   └── overlay: 각 클러스터 환경별로 변경값을 values.yaml로 정의 후 동기화     
└── apps        
    ├── README.md       
    ├── canary-demo: argoproj/rollouts-demo 이미지 기반 canary 배포 데모 및 테스트      
    ├── sphinx: sphinx repository에 대한 manifests
    ├── mci: mci repository에 대한 manifests
    ...    
    └── 배포가 필요한 프로젝트 각 디렉토리에 정리     
```
