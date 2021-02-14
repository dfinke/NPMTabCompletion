Import-Module TabExpansionPlusPlus

function NPMCompletion {
    param($wordToComplete, $commandAst)

    Set-Alias -Name nct -Value New-CommandTree

    $commandTree = & {
        nct access 'Set access level on published packages' {
            nct public 'Set a package to be publicly accessible'
            nct restricted 'Set a package to be restricted'
            nct grant 'Grant the ability of users and teams to have read-only or read-write access to a package' {
                nct 'read-only' 'tt'
                nct 'read-write' 'tt'
                nct 'scope:' 'tt'
            }
            nct revoke "Revoke the ability of users and teams" {
                nct "scope:team" "the team"
            }
            nct ls-packages "Show all of the packages a user or a team is able to access, along with the access level, except for read-only public packages"
            nct ls-collaborators "Show all of the access privileges for a package. Will only show permissions for packages to which you have at least read access"
            nct edit 'Set the access privileges for a package at once using $EDITOR'
        }

        nct adduser 'Add a registry user account' { }
        nct bin 'Display npm bin folder' { }
        nct bugs 'Bugs for a package in a web browser maybe' { }
        nct build 'Build a package' { }
        nct cache 'Manipulates packages cache' { }
        nct config 'Manage the npm configuration files' { }
        nct dedupe 'Reduce duplication' { }
        nct deprecate 'Deprecate a version of a package' { }
        nct dist-tag 'Modify package distribution tags' { }
        nct docs 'Docs for a package in a web browser maybe' { }
        nct edit 'Edit an installed package' { }
        nct explore 'Browse an installed package' { }
        nct help 'Get help on npm' { }
        nct help-search 'Search npm help documentation' { }
        nct init 'Interactively create a package.json file' { }
        nct link 'Symlink a package folder' { }
        nct logout 'Log out of the registry' { }
        nct ls 'List installed packages' { }
        nct npm 'javascript package manager' { }
        nct outdated 'Check for outdated packages' { }
        nct owner 'Manage package owners' { }
        nct pack 'Create a tarball from a package' { }
        nct ping 'Ping npm registry' { }
        nct prefix 'Display prefix' { }
        nct prune 'Remove extraneous packages' { }
        nct publish 'Publish a package' { }
        nct rebuild 'Rebuild a package' { }
        nct repo 'Open package repository page in the browser' { }
        nct restart 'Restart a package' { }
        nct root 'Display npm root' { }
        nct search 'Search for packages' { }
        nct shrinkwrap 'Lock down dependency versions' { }
        nct star 'Mark your favorite packages' { }
        nct stars 'View packages marked as favorites' { }
        nct start 'Start a package' { }
        nct stop 'Stop a package' { }
        nct tag 'Tag a published version' { }
        nct team 'Manage organization teams and team memberships' { }
        nct test 'Test a package' { }
        # nct uninstall 'Remove a package' { }
        nct unpublish 'Remove a package from the registry' { }
        nct update 'Update a package' { }
        nct version 'Bump a package version' { }
        nct view 'View registry info' { }
        nct whoami 'Display npm username' { }

        nct install 'install in package directory' {
            nct -Argument "--save" "Package will appear in your dependencies"
            nct -Argument "--save-dev" "Package will appear in your devDependencies"
            nct -Argument "--save-optional" "Package will appear in your optionalDependencies"
        }

        nct run 'Run arbitrary package scripts' {
            nct {
                param($wordToComplete, $commandAst)

                $scripts = (Get-Content .\package.json | ConvertFrom-Json).scripts
                $scripts |
                    Get-Member -MemberType NoteProperty |
                    Where-Object { $_.Name -like "${wordToComplete}*" } |
                    ForEach-Object {
                        $target = $scripts.($_.Name)
                        New-CompletionResult $_.Name "$($target)"
                    }
            }
        }

        nct uninstall 'Run arbitrary package scripts' {
            nct {
                param($wordToComplete, $commandAst)

                $scripts = (Get-Content .\package.json | ConvertFrom-Json).dependencies
                $scripts |
                    Get-Member -MemberType NoteProperty |
                    Where-Object { $_.Name -like "${wordToComplete}*" } |
                    ForEach-Object {
                        $target = $scripts.($_.Name)
                        New-CompletionResult $_.Name "$($target)"
                    }
            }
        }
    }

    Get-CommandTreeCompletion $wordToComplete $commandAst $commandTree
}

NPMCompletion

Register-ArgumentCompleter -Command 'npm' -Native -ScriptBlock $function:NPMCompletion -Description 'Complete parameters and arguments to npm.cmd'
