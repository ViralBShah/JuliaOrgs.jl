module JuliaOrgs

using GitHub
using TOML
#using ProgressMeter

export get_orglist

ghauth = GitHub.authenticate(ENV["GITHUB_TOKEN"])

function get_orglist()
    orgnames = Dict{String, Any}()

    registrypath = ENV["HOME"] * "/.julia/registries/General"
    packages = TOML.parsefile(registrypath * "/Registry.toml")["packages"]

    for p in packages
        package_path = p[2]["path"]
        repo_url = TOML.parsefile(registrypath * "/" * package_path * "/Package.toml")["repo"]
        name = split(repo_url, "/")[4]
        orgnames[name] = nothing
    end

    function ghowner(x)
        try
            GitHub.owner(x, auth=myauth)
        catch
            x
        end
    end

    return asyncmap(x->ghowner(x), collect(keys(orgnames)))

end

end
