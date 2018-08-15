#!/bin/bash
# initialize parameters
# identify pull request and push
# prepare upload path, request url
SCANTIST_IMPORT_URL="https://api-staging.scantist.io/ci-scan/"


show_project_info() {
  echo "TRAVIS_EVENT_TYPE $TRAVIS_EVENT_TYPE"
  echo "TRAVIS_BRANCH $TRAVIS_BRANCH"
  echo "TRAVIS_REPO_SLUG $TRAVIS_REPO_SLUG"
  echo "TRAVIS_PULL_REQUEST_SLUG $TRAVIS_PULL_REQUEST_SLUG"
  echo "TRAVIS_PULL_REQUEST $TRAVIS_PULL_REQUEST"
  echo "TRAVIS_PULL_REQUEST_BRANCH $TRAVIS_PULL_REQUEST_BRANCH"
  echo "TRAVIS_PULL_REQUEST_SHA $TRAVIS_PULL_REQUEST_SHA"
  echo "TRAVIS_COMMIT $TRAVIS_COMMIT"
  echo "=================project info====================="

  echo "=================travis info======================="
  echo "travis_dart_version: $TRAVIS_DART_VERSION"
  echo "travis_go_version: $TRAVIS_GO_VERSION"
  echo "travis_haxe_version: $TRAVIS_HAXE_VERSION"
  echo "travis_jdk_version: $TRAVIS_JDK_VERSION"
  echo "travis_julia_version: $TRAVIS_JULIA_VERSION"
  echo "travis_node_version: $TRAVIS_NODE_VERSION"
  echo "travis_otp_release: $TRAVIS_OTP_RELEASE"
  echo "travis_perl_version: $TRAVIS_PERL_VERSION"
  echo "travis_php_version: $TRAVIS_PHP_VERSION"
  echo "travis_python_version: $TRAVIS_PYTHON_VERSION"
  echo "travis_r_version: $TRAVIS_R_VERSION"
  echo "travis_ruby_version: $TRAVIS_RUBY_VERSION"
  echo "travis_rust_version: $TRAVIS_RUST_VERSION"
  echo "travis_scala_version: $TRAVIS_SCALA_VERSION"

}
echo "=================show_project_info================="
show_project_info

repo_name=$TRAVIS_REPO_SLUG
commit_sha=$TRAVIS_COMMIT
branch=$TRAVIS_BRANCH
pull_request=$TRAVIS_PULL_REQUEST
build_time=$(date +"%s")
cwd=$(pwd)

echo $repo_name
echo $commit_sha
echo $branch
echo $pull_request
echo $build_time
echo $cwd

if [[ -z "${TRAVIS_PYTHON_VERSION}" ]]; then
  python_project="false"
else
  echo "this is a python project"
  pip freeze > requirements.txt
fi

pyenv global 3.6.3

eval "$(pyenv init -)"

python <(curl -s https://scripts.scantist.com/staging/TreeBuilder.py) $cwd $repo_name $commit_sha $branch $pull_request $build_time

#Log that the script download is complete and proceeding
echo "Uploading report at $SCANTIST_IMPORT_URL"

#Log the curl version used
curl --version

curl -g -v -f -X POST -d '@dependency-tree.json' -H 'Content-Type:application/json' -H 'Authorization:7851de4b-dfec-4344-aca0-2a033832cff5'' "$SCANTIST_IMPORT_URL"

#Exit with the curl command's output status
exit $?

