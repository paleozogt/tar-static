PREFIX=

all: amd64 arm64v8 arm32v7
	docker push $(PREFIX)/tar-static:amd64
	docker push $(PREFIX)/tar-static:arm64v8
	docker push $(PREFIX)/tar-static:arm32v7
	docker manifest create $(PREFIX)/tar-static \
		$(PREFIX)/tar-static:amd64 \
		$(PREFIX)/tar-static:arm64v8 \
		$(PREFIX)/tar-static:arm32v7
	docker manifest push $(PREFIX)/tar-static

amd64: Dockerfile
	docker build --build-arg TRIPLET=x86_64-linux-gnu  -t $(PREFIX)/tar-static:amd64 .
	docker-copyedit.py \
		FROM $(PREFIX)/tar-static:amd64 \
		INTO $(PREFIX)/tar-static:amd64 \
		set arch amd64

arm64v8: Dockerfile
	docker build --build-arg TRIPLET=aarch64-linux-gnu -t $(PREFIX)/tar-static:arm64v8 .
	docker-copyedit.py \
		FROM $(PREFIX)/tar-static:arm64v8 \
		INTO $(PREFIX)/tar-static:arm64v8 \
		set arch arm64

arm32v7: Dockerfile
	docker build --build-arg TRIPLET=arm-linux-gnueabi -t $(PREFIX)/tar-static:arm32v7 .
	docker-copyedit.py \
		FROM $(PREFIX)/tar-static:arm32v7 \
		INTO $(PREFIX)/tar-static:arm32v7 \
		set arch arm
