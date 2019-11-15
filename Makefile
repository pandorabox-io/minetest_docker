TAG=registry.rudin.io/x86/minetest:pandorabox


build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

