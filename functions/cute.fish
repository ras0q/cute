function cute --description "Execute commands from Markdown files"
    set -l cute_dir (set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo $HOME/.local/share)/cute
    set -l cute_script "$cute_dir/cute"

    # Try to find the script from Fisher installation first
    set -l fisher_script (status --current-filename | xargs dirname)/../cute
    if test -f $fisher_script
        set cute_script $fisher_script
    else if not test -f $cute_script
        echo "cute: Downloading script..." >&2
        mkdir -p $cute_dir
        if not curl -fsSL https://raw.githubusercontent.com/ras0q/cute/main/cute -o $cute_script
            echo "cute: Failed to download script" >&2
            return 1
        end
    end

    sh -c ". $cute_script && cute \$@" -- $argv
end

function __fish_cute_tasks --description 'Get available cute tasks'
    cute -l 2>/dev/null || true
end

complete -c cute -f
complete -c cute -n "__fish_seen_subcommand_from" -s h -d "Show help message"
complete -c cute -n "__fish_seen_subcommand_from" -s l -d "List tasks"
complete -c cute -n "__fish_seen_subcommand_from" -s L -d "Limit search depth for Markdown files"
complete -c cute -n "__fish_seen_subcommand_from" -s v -d "Enable verbose mode"
complete -c cute -a "(__fish_cute_tasks)" -d "Task slug"
