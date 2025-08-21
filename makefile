.PHONY: check-requirements
check-requirements:
	bash ./commons/check-requirements.sh

.PHONY: deploy
deploy: check-requirements pki/
	bash ./commons/deploy.sh $(filter-out $@,$(MAKECMDGOALS))

.PHONY: destroy
destroy: check-requirements
	bash ./commons/destroy.sh

.PHONY: redeploy
redeploy: check-requirements
	bash ./commons/destroy.sh
	bash ./commons/deploy.sh $(filter-out $@,$(MAKECMDGOALS))

pki/:
	bash ./commons/generate-pki.sh

.PHONY: clear-storage
clear-storage:
	bash ./commons/clear-storage.sh

%:
	@: