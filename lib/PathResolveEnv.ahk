; Resolve first environment variables in a input string
PathResolveEnv(path){   
    ; get env name
    env_name := RegExReplace(path, "\${?env:([^\\}]+)}?\\.*", "$1")
    EnvGet, env_var, %env_name%
    ; substitute env
    Return RegExReplace(path, "\${?env:([^\\}]+)}?", env_var)
}
