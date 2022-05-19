#!/bin/bash

repl(){
  clj \
    -J-Dclojure.core.async.pool-size=1 \
    -X:Ripley Ripley.core/process \
    :main-ns Dr-Pershing.main
}


main(){
  clojure \
    -J-Dclojure.core.async.pool-size=1 \
    -M -m Dr-Pershing.main
}

tag(){
  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  TAG="$COMMIT_COUNT-$COMMIT_HASH"
  git tag $TAG $COMMIT_HASH
  echo $COMMIT_HASH
  echo $TAG
}

jar(){

  rm -rf out/*.jar
  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  clojure \
    -X:Genie Genie.core/process \
    :main-ns Dr-Pershing.main \
    :filename "\"out/Dr-Pershing-$COMMIT_COUNT-$COMMIT_HASH.jar\"" \
    :paths '["src" "out/ui" "out/corn"]'
}

Madison_install(){
  npm i --no-package-lock
  mkdir -p out/ui/
  cp src/Dr_Pershing/index.html out/ui/index.html
  cp src/Dr_Pershing/style.css out/ui/style.css
  mkdir -p out/corn/
  cp package.json out/corn/package.json
}

Moana(){
  clj -A:Moana:ui:corn -M -m shadow.cljs.devtools.cli "$@"
}

Madison_repl(){
  Madison_install
  Moana clj-repl
  # (shadow/watch :main)
  # (shadow/watch :ui)
  # (shadow/repl :main)
  # :repl/quit
}

release(){
  rm -rf out
  Madison_install
  Moana release :ui :corn
  jar
}

"$@"