# Ft_Server

Using docker to create containers.<br>
Install a full web server which will be able to run multiple services, such as Wordpress, PhpMyadmin.<br>

## Usage

- Clone Repository
```bash
git clone https://github.com/vvaucoul/Ft_Server && cd Ft_Server
```

- Launch Docker
```bash
sudo ./start.sh [Container Name]
```

- Delete All Containers
```bash
sudo docker system prune --all
```

## Services

- Nginx Server
- MySQL Database
- PhpMyAdmin
- Wordpress service

