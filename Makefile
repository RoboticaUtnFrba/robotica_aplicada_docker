.PHONY: robotica_base
robotica_base:
	docker build \
		--build-arg USER_ID=$(shell id -u) \
		--build-arg GROUP_ID=$(shell id -g) \
		-f base.dockerfile \
		-t robotica:base \
		.

.PHONY: robotica_ros1
robotica_ros1: robotica_base
	docker build \
		-f ros1.dockerfile \
		-t robotica:ros1 \
		.

.PHONY: robotica_ros2
robotica_ros2: robotica_ros1
	docker build \
		-f ros2.dockerfile \
		-t robotica:ros2 \
		.

.PHONY: robotica_webots
robotica_webots: robotica_ros2
	docker build \
		-f webots.dockerfile \
		-t robotica:webots \
		.

.PHONY: robotica_amr
robotica_amr: robotica_webots
	docker build \
		-f amr.dockerfile \
		-t robotica:amr \
		.

.PHONY: robotica_manipulators
robotica_manipulators: robotica_amr
	docker build \
		-f manipulators.dockerfile \
		-t robotica:manipulators \
		.

.PHONY: robotica_drones
robotica_drones: robotica_manipulators
	docker build \
		-f drones.dockerfile \
		-t robotica:drones \
		.

.PHONY: robotica_mrs
robotica_mrs: robotica_drones
	docker build \
		-f mrs.dockerfile \
		-t robotica:mrs \
		.

.PHONY: robotica_legged
robotica_legged: robotica_mrs
	docker build \
		-f legged.dockerfile \
		-t robotica:legged \
		.

.PHONY: robotica_docker
robotica_docker: robotica_legged
	docker tag robotica:legged robotica:docker
