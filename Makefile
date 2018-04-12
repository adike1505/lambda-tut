PROJECT = unique_identifier
VIRTUAL_ENV = env
FUNCTION_NAME = unique_identifier
AWS_REGION = us-east-1
FUNCTION_HANDLER = lambda_handler
LAMBDA_ROLE = arn:aws:iam::820269386197:role/gna-lambda-role

# default commands
install: virtual
build: clean_package build_package_tmp copy_python remove_unused zip

clean-pyc:
	find -name '*.pyc' -delete

virtual:
	@echo "--> setup and activate virtualenv"
	if test ! -d "$(VIRTUAL_ENV)"; then \
		pip install virtualenv; \
		virtualenv $(VIRTUAL_ENV); \
	fi
	@echo ""

clean_package:
	rm -rf ./package/*

build_package_tmp:
	mkdir -p ./package/tmp/lib
	cp -a ./$(PROJECT)/. ./package/tmp/

copy_python:
	if test -d $(VIRTUAL_ENV)/lib; then \
		cp -a $(VIRTUAL_ENV)/lib/python2.7/site-packages/. ./package/tmp/; \
	fi

remove_unused:
	rm -rf package/tmp/wheel*
	rm -rf package/tmp/easy-install*
	rm -rf package/tmp/setuptools*
	clean-pyc

zip:
	cd package/tmp && zip -r ../$(PROJECT).zip .

lambda_delete:
	aws lambda delete-function --function-name $(FUNCTION_NAME)

lambda_create:
	aws lambda create-function \
		--region $(AWS_REGION) \
		--function-name $(FUNCTION_NAME) \
		--zip-file fileb://package/$(PROJECT).zip \
		--role $(LAMBDA_ROLE) \
		--handler $(PROJECT).$(FUNCTION_HANDLER) \
		--runtime python2.7 \
		--timeout 15 \
		--memory-size 128

