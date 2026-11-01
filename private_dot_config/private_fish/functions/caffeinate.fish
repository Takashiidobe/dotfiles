function caffeinate --description 'Keep the computer and screen awake for a duration'
    if test (count $argv) -gt 1
        printf 'Usage: caffeinate [duration: 30m, 1h, 2d]\n' >&2
        return 2
    end

    set -l duration infinity
    if set -q argv[1]
        set duration $argv[1]
    end

    kde-inhibit --power --screenSaver sleep -- $duration
end
