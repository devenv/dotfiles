docker rm -f `docker ps --no-trunc -aq`

if [ "$(uname)" == "Darwin" ]; then
  XARGS_OPTS=
  &>/dev/null xargs -r && XARGS_OPTS+="-r"
  docker images --filter dangling=true -q | xargs ${XARGS_OPTS} docker rmi
  docker volume ls -qf dangling=true | xargs ${XARGS_OPTS} docker volume rm
else
  docker images --filter dangling=true -q | xargs -r docker rmi
  docker volume ls -qf dangling=true | xargs -r docker volume rm
fi

