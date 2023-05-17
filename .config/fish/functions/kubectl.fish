function spod
  kubectl get pods --no-headers --field-selector=status.phase==Running\
    | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end)\
    | awk '{print $1}'\
    | xargs -o -I {} kubectl exec -t -i {} -- bash
end
function kcc
  kubectl config get-contexts --output name\
    | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end)\
    | awk '{print $1}'\
    | xargs -o -I % kubectl config use-context %
end
function kcn
  kubectl get namespaces --no-headers\
    | fzf -0 -1 (if set -q argv[1]; echo -q $argv[1]; end)\
    | awk '{print $1}'\
    | xargs -o -I % kubectl config set-context --current --namespace %
end
