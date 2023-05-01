_f_edit() {
  echo "Running 'edit' command..."
}

_f_install() {
  echo "Running 'install' command..."
}

_f_uninstall() {
  echo "Running 'uninstall' command..."
}

_f_main() {
  echo "Running 'main' command..."
}

_f_show_usage() {
  echo "Usage: .f [edit|install|uninstall]"
}

.f() {
    local command="$1"

    case "$command" in
        edit)
            _f_edit
            ;;
        install)
            f_install
            ;;
        uninstall)
            f_uninstall
            ;;
        *)
            if [ -n "$1" ]; then
              _f_show_usage
            else
              _f_main
            fi
            ;;
    esac
}
