# iolb
![image](https://github.com/jsmin6330/iolb/assets/150888333/a312bf76-8d69-4e2f-85a4-3a16d3ad4568)

</br>

## 요구사항
- fly.io 에 blog A, blog B 배포
- lb 를 fly.io 1곳에 배포
- lb 를 통해 들어가면 fly.io blog A, B 가 순차 적으로 보임
- A, B 중 하나를 업데이트 하는 동안 서비스는 중단 되지 않음

</br>

## 로드 밸런서(LB) 설정
### Nginx 로드 밸런서 설정(default.conf)
참조: https://fly.io/docs/networking/private-networking/#fly-io-internal-addresses </br>
Fly.io는 내부적으로 애플리케이션 간 통신을 위해 내부 DNS를 사용합니다. 이를 통해 애플리케이션은 서로를 찾고 통신할 수 있습니다. 
각 애플리케이션은 .internal 도메인을 통해 액세스할 수 있으며, 이는 Fly.io 내부에서만 해석됩니다.
```
upstream myapp {
    server jsmin6330-hello-vue-github-io.internal:80;
    server jsmin6330-github-io.internal:80;
}

server {
    listen 80; 

    # 모든 요청을 업스트림으로 프록시
    location / {
        proxy_pass http://myapp; # 업스트림 그룹을 참조
    }
}
```

### Dockerfile 
```
FROM nginx:latest
COPY default.conf /etc/nginx/conf.d/
```

### fly.io 배포
```
# fly.toml app configuration file generated for iolb on 2024-02-17T23:33:57+09:00
#
# See https://fly.io/docs/reference/configuration/ for information about how to use this file.
#

app = 'iolb'
primary_region = 'nrt'

[build]

[http_service]
  internal_port = 80
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 3
  processes = ['app']

[[vm]]
  size = 'shared-cpu-1x'
```


## 정보
블로그A: https://jsmin6330-hello-vue-github-io.fly.dev/
블로그B: https://jsmin6330-github-io.fly.dev/
LB: https://iolb.fly.dev/
