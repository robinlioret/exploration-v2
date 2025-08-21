.PHONY: check-requirements
check-requirements:
	bash ./commons/check-requirements.sh

.PHONY: deploy
deploy: check-requirements
	bash ./commons/deploy.sh $(filter-out $@,$(MAKECMDGOALS))

.PHONY: destroy
destroy: check-requirements
	bash ./commons/destroy.sh

.PHONY: redeploy
redeploy: check-requirements
	bash ./commons/destroy.sh
	bash ./commons/deploy.sh $(filter-out $@,$(MAKECMDGOALS))

.PHONY: ca-cert
ca-cert:
	bash ./commons/generate-ca-cert.sh

.PHONY: clear-storage
clear-storage:
	bash ./commons/clear-storage.sh

%:
	@: