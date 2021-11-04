#!/usr/bin/env bash

check_apps()
{
    if ! type -p sysctl osascript 2>&1 > /dev/null; then
        return 1
    fi
}

trim()
{
    [[ "$*" ]] && {
        set -f
        set -- $*
        printf "%s" "$*"
        set +f
    }
}

notify()
{
    tiling=$(/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq -r 'if .type == "bsp" then "bsp" else "float" end')

    title="$(trim "${title_parts[*]}")"
    subtitle="$(trim "${subtitle_parts[*]}")"
    message="${title}"

    echo $tiling

    if [[ $tiling == "bsp" ]] ;
    then
        msg="Auto Tiling ON"
    else
        msg="Auto Tiling OFF"
    fi

    title="Yabai"
    message=${msg}
    # subtitle=${tiling}

    [[ "${title:0:1}" == "|" ]] && \
        title="${title##'| '}"

    [[ "${title:-1:1}" == "|" ]] && \
        title="${title%%' |'}"

    [[ "${subtitle:0:1}" == "|" ]] && \
        subtitle="${subtitle##'| '}"

    [[ "${subtitle:-1:1}" == "|" ]] && \
        subtitle="${subtitle%%' |'}"

    [[ "${message:0:1}" == "|" ]] && \
        message="${message##'| '}"

    [[ "${message:-1:1}" == "|" ]] && \
        message="${message%%' |'}"

    if [[ "${stdout}" ]]; then
        [[ "${title}" ]] && \
            display+=("${title}")
        [[ "${subtitle}" ]] && \
            display+=("${subtitle}")
        [[ "${message}" ]] && \
            display+=("${message}")
        printf "%s\\n" "${display[@]}"
    else
        osa_script="display notification \"${message}\" \
                    with title \"${title}\" \
                    subtitle \"${subtitle}\""

        /usr/bin/env osascript <<< "${osa_script}"
    fi
}


main()
{
    ! check_apps && exit 1

    notify
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && \
    main "$@"
