DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_YML := --file docker-compose.yml
ifneq ("$(wildcard docker-compose.local.yml)","")
DOCKER_COMPOSE_YML += --file docker-compose.local.yml
endif

language := node
SUCCESS_MESSAGE := "✅ $(language) quickstart is running on http://localhost:3000"

.PHONY: up
up:
	REACT_APP_API_HOST=http://$(language):8000 \
	$(DOCKER_COMPOSE) \
		$(DOCKER_COMPOSE_YML) \
		$@ --build --detach --remove-orphans \
		$(language)
	@echo $(SUCCESS_MESSAGE)

.PHONY: logs
logs:
	$(DOCKER_COMPOSE) \
		$@ --follow \
		$(language) frontend

.PHONY: stop build
stop build:
	$(DOCKER_COMPOSE) \
		$(DOCKER_COMPOSE_YML) \
		$@ \
		$(language) frontend


.PHONY: build-heroku-api
build-heroku-api:
	heroku git:remote -a upward-inv-api
	docker buildx build --load --platform linux/amd64 -t registry.heroku.com/upward-inv-api/web -f Dockerfile.api .

.PHONY: push-heroku-api
push-heroku-api:
	heroku git:remote -a upward-inv-api
	docker push registry.heroku.com/upward-inv-api/web:latest

.PHONY: build-heroku-frontend
build-heroku-frontend:
	heroku git:remote -a upward-inv
	docker buildx build --load --platform linux/amd64 -t registry.heroku.com/upward-inv/web -f Dockerfile.web .

.PHONY: push-heroku-frontend
push-heroku-frontend:
	heroku git:remote -a upward-inv
	docker push registry.heroku.com/upward-inv/web:latest
