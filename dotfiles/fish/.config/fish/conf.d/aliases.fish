if status is-interactive
    # for builtins
    abbr -a cl clear
    abbr -a la ls -a
    abbr -a ll ls -lahF
    abbr -a ll ls -lahF
    abbr -a .. cd ..
    abbr -a ... cd ../..

    # for Kubernetes
    if command -q kubectl
        abbr -a k kubectl
        abbr -a kx kubectl ctx
        abbr -a kns kubectl ns
    end

    # for Podman
    if command -q podman
        abbr -a docker podman
        alias docker=podman # so copy-pasted commands still work (abbr doesn't trigger on copy-paste)
    end
end
