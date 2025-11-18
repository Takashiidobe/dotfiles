complete -c cargo -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c cargo -n "__fish_use_subcommand" -f -a "mutants" -d 'Inject bugs and see if your tests catch them'
complete -c cargo -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l baseline -d 'Baseline strategy: check that tests pass in an unmutated tree before testing mutants' -r -f -a "{run	Run tests in an unmutated tree before testing mutants,skip	Don\'t run tests in an unmutated tree: assume that they pass}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l cap-lints -d 'Turn off all rustc lints, so that denied warnings won\'t make mutants unviable' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l colors -d 'Draw colors in output' -r -f -a "{auto	,always	,never	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l copy-vcs -l copy_git -d 'Copy `.git` and other VCS directories to the build directory' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s d -l dir -d 'Rust crate directory to examine' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l completions -d 'Generate autocompletions for the given shell' -r -f -a "{bash	,elvish	,fish	,powershell	,zsh	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l error -d 'Return this error values from functions returning Result: for example, `::anyhow::anyhow!("mutated")`' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s F -l re -d 'Regex for mutations to examine, matched against the names shown by `--list`' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s e -l exclude -d 'Glob for files to exclude; with no glob, all files are included; globs containing slash match the entire path. If used together with `--file` argument, then the files to be examined are matched before the files to be excluded' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s E -l exclude-re -d 'Regex for mutations to exclude, matched against the names shown by `--list`' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s f -l file -d 'Glob for files to examine; with no glob, all files are examined; globs containing slash match the entire path. If used together with `--exclude` argument, then the files to be examined are matched before the files to be excluded' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l gitignore -d 'Don\'t copy files matching gitignore patterns' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s j -l jobs -d 'Run this many cargo build/test jobs in parallel' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l jobserver -d 'Use a GNU Jobserver to cap concurrency between child processes' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l jobserver-tasks -d 'Allow this many jobserver tasks in parallel, across all child processes' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s L -l level -d 'Log level for stdout (trace, debug, info, warn, error)' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l manifest-path -d 'Path to Cargo.toml for the package to mutate' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l line-col -d 'Include line & column numbers in the mutation list' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s o -l output -d 'Create mutants.out within this directory' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s D -l in-diff -d 'Include only mutants in code touched by this diff' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l minimum-test-timeout -d 'Minimum timeout for tests, in seconds, as a lower bound on the auto-set time' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s p -l package -d 'Only test mutants from these packages' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l profile -d 'Build with this cargo profile' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l shard -d 'Run only one shard of all generated mutants: specify as e.g. 1/4' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l skip-calls -d 'Skip calls to functions and methods named in this list' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l skip-calls-defaults -d 'Use built-in defaults for `skip_calls`, in addition to any explicit values' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l test-package -d 'Run tests from these packages for all mutants' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l test-tool -d 'Tool used to run test suites: cargo or nextest' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l test-workspace -d 'Run all tests in the workspace' -r -f -a "{true	,false	}"
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s t -l timeout -d 'Maximum run time for all cargo commands, in seconds' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l timeout-multiplier -d 'Test timeout multiplier (relative to base test time)' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l build-timeout -d 'Maximum run time for cargo build command, in seconds' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l build-timeout-multiplier -d 'Build timeout multiplier (relative to base build time)' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s C -l cargo-arg -d 'Additional args for all cargo invocations' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l features -d 'Space or comma separated list of features to activate' -r
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l all-logs -d 'Show cargo output for all invocations (very verbose)'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s v -l caught -d 'Print mutants that were caught by tests'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l check -d 'Cargo check generated mutants, but don\'t run tests'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l diff -d 'Show the mutation diffs'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l in-place -d 'Test mutations in the source tree, rather than in a copy'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l iterate -d 'Skip mutants that were caught in previous runs'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l json -d 'Output json (only for --list)'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l leak-dirs -d 'Don\'t delete the scratch directories, for debugging'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l list -d 'Just list possible mutants, don\'t run them'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l list-files -d 'List source files, don\'t run anything'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l no-config -d 'Don\'t read .cargo/mutants.toml'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l no-copy-target -d 'Don\'t copy the /target directory, and don\'t build the source tree first'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l no-times -d 'Don\'t print times or tree sizes, to make output deterministic'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l shuffle -d 'Run mutants in random order'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l no-shuffle -d 'Run mutants in the fixed order they occur in the source tree'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s V -l unviable -d 'Print mutations that failed to check or build'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l version -d 'Show version and quit'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l workspace -d 'Generate mutations in every package in the workspace'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l no-default-features -d 'Do not activate the `default` feature'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -l all-features -d 'Activate all features'
complete -c cargo -n "__fish_seen_subcommand_from mutants" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c cargo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from mutants; and not __fish_seen_subcommand_from help" -f -a "mutants" -d 'Inject bugs and see if your tests catch them'
complete -c cargo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from mutants; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
