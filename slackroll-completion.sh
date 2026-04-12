#!/bin/bash
# Bash autocompletion for slackroll
# Contributed in 2026 by Brent Spillner <spillner@acm.org>
# Released under the same license terms as the main slackroll script

_slackroll()
{
  COMPREPLY=()
  local invoke="${COMP_WORDS[0]}"
  local arg="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" = "1" ]; then
      local all_subcmds=$(${invoke} raw-list-cmds)
      COMPREPLY=( $(compgen -W "${all_subcmds}" ${arg}) )
      return 0
  else
      local subcmd="${COMP_WORDS[1]}"
      if [ "${subcmd}" = "batch" ]; then
          subcmd="${COMP_WORDS[2]}"
      fi

      for x in `${invoke} raw-cmds-expect-local`; do
          if [ "${subcmd}" = "${x}" ]; then
              local local_pkgs=$(${invoke} raw-list-local ${arg})
              COMPREPLY=( $(compgen -W "${local_pkgs}" ) )
              return 0
          fi
      done

      for x in `${invoke} raw-cmds-expect-remote`; do
          if [ "${subcmd}" = "${x}" ]; then
              local remote_pkgs=$(${invoke} raw-list-remote ${arg})
              COMPREPLY=( $(compgen -W "${remote_pkgs}" ) )
              return 0
          fi
        done

      for x in `${invoke} raw-cmds-expect-foreign`; do
          if [ "${subcmd}" = "${x}" ]; then
              local foreign_pkgs=$(${invoke} raw-list-foreign ${arg})
              COMPREPLY=( $(compgen -W "${foreign_pkgs}" ) )
              return 0
          fi
      done

      for x in `${invoke} raw-cmds-expect-frozen`; do
          if [ "${subcmd}" = "${x}" ]; then
              local frozen_pkgs=$(${invoke} raw-list-frozen ${arg})
              COMPREPLY=( $(compgen -W "${frozen_pkgs}" ) )
              return 0
          fi
      done

      for x in `${invoke} raw-cmds-expect-path`; do
          if [ "${subcmd}" = "${x}" ]; then
              _filedir
              return 0
          fi
      done

      if [[ ${subcmd} == *upgrade* ]]; then
          local upgrade_opts="--auto-select"
          COMPREPLY=($(compgen -W "${upgrade_opts}" -- ${arg}))
      fi
  fi

  return 0
}

complete -F _slackroll slackroll
