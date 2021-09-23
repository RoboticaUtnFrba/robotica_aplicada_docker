# Base images

.PHONY: ubuntu_18
ubuntu_18:
	docker build \
		--build-arg USER_ID=$(shell id -u) \
		--build-arg GROUP_ID=$(shell id -g) \
		--build-arg UBUNTU=18 \
		-f ubuntu.dockerfile \
		-t robotica:ubuntu_18 \
		.

.PHONY: ubuntu_20
ubuntu_20:
	docker build \
		--build-arg USER_ID=$(shell id -u) \
		--build-arg GROUP_ID=$(shell id -g) \
		--build-arg UBUNTU=20 \
		-f ubuntu.dockerfile \
		-t robotica:ubuntu_20 \
		.

# ROS 1 images

.PHONY: ros1_melodic
ros1_melodic: ubuntu_18
	docker build \
		--build-arg UBUNTU=18 \
		--build-arg ROS=melodic \
		-f ros1.dockerfile \
		-t robotica:ros1_melodic \
		.

.PHONY: ros1_noetic
ros1_noetic: ubuntu_20
	docker build \
		--build-arg UBUNTU=20 \
		--build-arg ROS=noetic \
		-f ros1.dockerfile \
		-t robotica:ros1_noetic \
		.

# ROS 2 images

.PHONY: ros2_foxy
ros2_foxy: ubuntu_20
	docker build \
		--build-arg UBUNTU=20 \
		--build-arg ROS=foxy \
		-f ros2.dockerfile \
		-t robotica:ros2_foxy \
		.

# Webots images

.PHONY: webots_ros1_melodic
webots_ros1_melodic: ros1_melodic
	docker build \
		--build-arg PARENT=ros1_melodic \
		-f webots.dockerfile \
		-t robotica:webots_ros1_melodic \
		.

.PHONY: webots_ros1_noetic
webots_ros1_noetic: ros1_noetic
	docker build \
		--build-arg PARENT=ros1_noetic \
		-f webots.dockerfile \
		-t robotica:webots_ros1_noetic \
		.

.PHONY: webots_ros2_foxy
webots_ros2_foxy: ros2_foxy
	docker build \
		--build-arg PARENT=ros2_foxy \
		-f webots.dockerfile \
		-t robotica:webots_ros2_foxy \
		.

# Robotics images

# .PHONY: robotica_amr
# robotica_amr: ros2_foxy
# 	docker build \
# 		-f amr.dockerfile \
# 		-t robotica:amr \
# 		.

.PHONY: robotica_manipulators
robotica_manipulators: webots_ros1_melodic
	docker build \
		-f manipulators.dockerfile \
		-t robotica:manipulators \
		.

# .PHONY: robotica_drones
# robotica_drones: robotica_manipulators
# 	docker build \
# 		-f drones.dockerfile \
# 		-t robotica:drones \
# 		.

# .PHONY: robotica_mrs
# robotica_mrs: robotica_drones
# 	docker build \
# 		-f mrs.dockerfile \
# 		-t robotica:mrs \
# 		.

.PHONY: robotica_legged
robotica_legged: webots_ros1_noetic
	docker build \
		-f legged.dockerfile \
		-t robotica:legged \
		.
